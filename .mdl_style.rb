# Import all default rules
all

# Only allow atx style headings (e.g. # H1 ## H2)
rule 'MD003', :style => :atx

# Only allow dashes in unordered lists
rule 'MD004', :style => :dash

# Enfore line length of 80 characters except in code blocks and tables
rule 'MD013', :code_blocks => false, :tables => false

# Allow bare URLs (i.e. without angle brackets)
exclude_rule 'MD034'
