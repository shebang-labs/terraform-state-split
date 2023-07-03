# Terraform State Split

Terraform State Split is a Ruby-based CLI tool designed to help you organize and manage large Terraform state files. It leverages the tty-prompt gem to provide an interactive command-line interface for moving selected resources between Terraform state files.

## Demo

[![asciicast](https://asciinema.org/a/qqF2E5Uz2ybwzhJdMpuufzblu.svg)](https://asciinema.org/a/qqF2E5Uz2ybwzhJdMpuufzblu)

## Getting Started

### From Source

For utilizing this tool, ensure Ruby is installed on your machine. Also, tty-prompt gem along with other required dependencies must be installed using the following command:

```bash
bundle install
```

Terraform must also be [installed](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) and [initialized](https://developer.hashicorp.com/terraform/cli/commands/init) within your working directory.

To execute `terraform-state-split`, use the following commands:

```bash
terraform state pull > tf.state # Extract the state file from your Terraform workspace or remote state storage
ruby resource_mover.rb # Run the script and follow the prompts to select the resources to be moved
```

### Homebrew (For MacOS)

For MacOS users, the tool can be installed via Homebrew using the following commands:

```bash
brew tap shebang-labs/tap
brew install terraform-state-split
```

To run `terraform-state-split`, execute the following:

```bash
terraform state pull > tf.state # Extract the state file from your Terraform workspace or remote state storage
terraform-state-split # Run the script and follow the prompts to select the resources to be moved
```

## How to Use

The tool will prompt you to provide the absolute input state file path and the absolute output state file path. These are the paths of the state files from which and to which you wish to move resources.

Next, all resources present in the input state file will be displayed and you'll be prompted to select the ones to be moved. Make your selection using arrow keys, space bar, and enter key.

The tool will then utilize the `terraform state mv` command to transfer the selected resources from the input state file to the output state file.
