# 💼 Administrator guide

## 🏗️ How to deploy

### 📦 Required software and other prerequisites

Before you start, you will need to install some dependencies,

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

You will also need,

- A domain where you are able to modify or create new DNS records

And ideally

- An email address to receive [Let's Encrypt](https://letsencrypt.org/)
  certificate expiry alerts
- An email account with SMTP access to send users their initial login
  credentials

### 🤖 Deploy the infrastructure with Terraform

Make sure you are authenticated with Azure CLI

```bash
az login
```

Change to the terraform directory

```bash
cd terraform
```

Initialise terraform

```bash
terraform init
```

Make a copy of the example Terraform variables file `terraform.tfvars.example`.

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit your copy using your text editor, completing the appropriate variables.
These should be fairly self-explanatory. If you do not complete any required
variables you will be prompted to enter them in the command line when running
Terraform.

Plan your deployment

```bash
terraform plan -out myplan
```

Check the output to ensure the changes make sense. If all is well you can now
apply the plan with

```bash
terraform apply myplan
```

Terraform will print a message giving the address of the name servers of the
Azure DNS Zone for your deployment (you can print this again at any time using
`terraform output`). You will need to add these addresses as NS records to your
domain (the same domain that your specified in `terraform.tfvars`). This way
requests to your domain will be forwarded to the DNS managed by terraform.

### ⚙️ Configure the virtual machines with Ansible

Change to the Ansible directory

```bash
cd ../ansible
```

Terraform will have written some files needed by Ansible,

- `inventory.yaml` - The Ansible inventory, which tells Ansible how to connect
  to the virtual machines
- `vars/terraform_vars.yaml` - Some variables exported for Terraform that will
  be used by Ansible
- `../keys/{dsvm,guacamole}_admin_id_rsa.pem` - The private SSH keys for the
  DSVM and Guacamole machines respectively

Ensure the required Ansible roles and collections are installed

```bash
ansible-galaxy install -r requirements.yaml
```

Make a copy of the example variables file

```bash
cp vars/ansible_vars.yaml.example vars/ansible_vars.yaml
```

Open your copy with your text editor and ensure the values are correct and
complete any undefined variables.

If you want to use [Let's Encrypt](https://letsencrypt.org/) to generate SSL
certificates automatically (highly recommended!) change `lets_encrypt` to `true`
and `lets_encrypt_email` to a suitable email address.  This address will receive
warnings if your certificates are due to expire and have not been updated (which
should happen automatically).

Enter a password for the Postgres database as the value of the key
`guac_db_password`.

Enter a password for the guacamole admin account as the value of the key
`guac_admin_password`.

You can also define additional apt and snap packages here. See [Adding
software](#-adding-software) for details.

Configure the Guacamole and DSVM machines

```bash
ansible-playbook -i inventory.yaml main.yaml
```

## 👥 Manage users with Ansible

Make a copy of the users variables file

```bash
cp vars/user_vars.yaml.example vars/user_vars.yaml
```

Open your copy with your editor.  If you want the user management role to
automatically email users their initial login credentials, complete enter your
email's SMTP settings into the `email` dict.

If you also want to write the initial passwords to a file on your local machine,
change `force_write_initial_passwords` to `yes`.

To declare users that should exist (this can be both existing and new users),
add their name, username and email address to the `users` dict following the
example.

To declare users that should not exist, add their username to the
`users_deleted` dict.

To create or remove users run

```bash
ansible-playbook -i inventory.yaml manage_users.yaml
```

If you have configured SMTP settings, newly created users will be send their
initial credentials from that email address. If the Guacamole and Linux
credentials are written to file they can be found in `guac_new_users.yaml` and
`new_users.yaml` respectively.

## ↕️ Resizing

To change the size of either of the virtual machines, for example to handle an
increased number of users or support GPU computing, you can simply update the
Terraform configuration.

Open `terraform/terraform.tfvars` and edit the dict `vm_sizes`. `guacamole`
defines the size of the Guacamole VM and `dsvm` defines the size of the DSVM.
See the [Azure
documentation](https://docs.microsoft.com/en-us/azure/virtual-machines/sizes)
for a list of possible values. Ensure that your selected VM size is available in
your selected location (`location` in `terraform/terraform.tfvars`. You can
check the available VM sizes for a location by running

```bash
az vm list-sizes --location "<location>"
```

You can apply the new VM sizes using the plan/apply workflow
[above](#-deploy-the-infrastructure-with-terraform). Plan your changes using

```bash
terraform plan -out resizeplan
```

and ensure that the changes printed to your
console are what you expect. You can then apply the changes with 

```
terraform apply resizeplan
```

## 🚚 Ingress and egress

Both input and output data are held on [Azure file
shares](https://docs.microsoft.com/en-us/azure/storage/files/storage-files-introduction)
configured as SMB shares. Both shares will be belong to the same storage
account, which you will be able to see in the resource group you choose when
deploying the infrastructure using Terraform.

You may use whatever methods you think are best, including using the azure
portal. However, from past experience we have found [Azure Storage
Explorer](https://azure.microsoft.com/en-us/features/storage-explorer/) to be a
convenient and secure for both data ingress and egress.

## 🎁 Adding software

The Ansible variables file `host_vars/dsvm.yaml` has a number of DSVM packages
predefined. You can also install additional apt packages (from the default
repositories) or [snaps](https://snapcraft.io/) by editing your
`ansible_vars.yaml` file.

To install additional packages using `apt` (Ubuntu's package manager), add the
names of the packages to the list `apt_packages_extra` in `ansible_vars.yaml`.
You can find the names of packages for the default Ubuntu 20.04 LTS image on the
[the Ubuntu packages website](https://packages.ubuntu.com/focal/).

To add new snap packages add them to the list `snap_packages_extra` in
`ansible_vars.yaml`. Each item on this list must have the key `name` which is
the name of the snap as you would use to install on the command line. You can
find the names of snaps on the [snap store](https://snapcraft.io/store) by
selecting a snap and clicking the green install button. If the snap should be
installed with classic confinement (this is also made apparent when clicking
'install' in the snap store) you should also add the key `classic` with value
`yes`. Look at `host_vars/dsvm.yaml` for examples of both classic and standard
snaps in the list `snap_packages_default`.

After making changes you can ensure the packages are installed with

```bash
ansible-playbook -i inventory.yaml main.yaml --tags dsvm
```

## 💣 Tear down the environment

To tear down all of the resources you have deployed, ensure you are in the
terraform directory and run

```bash
terraform destroy
```
