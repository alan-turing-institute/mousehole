# Mousehole 🐭

Quickly deploy a flexible, collaborative environment for working with private
data.

## 🤔 What is Mousehole

Mousehole
([/ˈmaʊzəl/](http://ipa-reader.xyz/?text=%CB%88ma%CA%8Az%C9%99l&voice=Brian))
takes its name from a harbour village in Cornwall, UK.  It is inspired by, and
draws on, the [Data safe havens in the
cloud](https://www.turing.ac.uk/research/research-projects/data-safe-havens-cloud)
project. That project has developed policy and processes to deploy research
environments on the cloud that are secure enough to handle sensitive data yet
flexible enough to host productive data-science projects.

The Data Safe Havens project has devised  a series of data security tiers
numbered 0–4. Tiers 2 and above cover sensitive data, and tier 0 covers public,
non-sensitive data. That leaves tier 1 data which is not sensitive, but we may
still wish to keep private. For example, we might not be ready to share the data
or might want to keep it secret for a competitive advantage.

Tier 1 (and tier 0) data therefore do not require a safe haven and the
associated restrictions might become frustrating. However, there is still value
in having a reasonably secure, collaborative, flexible environment when working
with tier 1 or 0 data. The aim of Mousehole is therefore to take the positive
features of the safe haven and include them in a light-weight, stand-alone and
more permissive environment suitable for non-sensitive data.

## 🔓 Data that is private but not sensitive or personal

> ⚠️ Important
>
> **This environment is not suitable for work involving sensitive or personal
> data**. It is completely possible for someone to extract the private data from
> the environment, whether intentionally, accidentally or through coercion. In
> particular, users can copy/paste to and from the remote machine and make
> outbound internet connections.

> ⚠️ Important
>
> This environment relies on trust in both the administrators and users and
> should not be used in a situation where you do not have reasonable confidence
> that either the administrators or users will not misuse the data.
>
> Administrators have a very high level of access and control including, but not
> limited to, reading private data, extracting data and imitating other users.
> Normal users may release data from the environment to the internet or copy it
> from the environment to their local machines.

## 🚀 Features

- 🚅 Quick and easy to deploy (leveraging [Terraform](https://www.terraform.io/)
  and [Ansible](https://www.ansible.com/))
- 🥑 [Guacamole](https://guacamole.apache.org/) for remote desktop in a browser
- 🔐 Two factor authentication
- 🤖 Automated account creation and deletion
- 🖥️ Configurable Ubuntu VM pre-loaded with programming/data-science packages
- ⛰️ Read-only filesystem for input data
- 🚪 Read/write filesystem to easily extract outputs
- 🤝 Shared working directory backed (optionally) by SSD storage for
  collaborative work
- 🌐 Bring your own domain
- 🔑 Automatic SSL/TLS configuration using [Let's
  Encrypt](https://letsencrypt.org/) and [Traefik](https://traefik.io/)
- 🤝 Permissively licensed (you are free to copy, use and modify this code as
  well as to merge it with your own)
