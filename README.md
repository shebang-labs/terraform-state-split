# Terraform Resource Mover

This is a Ruby script that allows you to move resources in Terraform state files based on user input. It uses the tty-prompt gem to create an interactive command-line interface, this ruby CLI tool helps you organise large terraform state files into smaller ones by moving chosen resources from a provided state file into another destination state file.

## Installation

To use this script, you need to have Ruby installed on your system. You also need to install the tty-prompt gem and other dependencies by running:

```bash
bundle install
```

You also need to have [Terraform installed](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) and [initialized](https://developer.hashicorp.com/terraform/cli/commands/init) in your working directory.

## Usage

### Natively (without Docker)

To run the script, simply execute it with Ruby:

```bash
terraform state pull > tf.state # pull the state file from your Terraform workspace/remote state storage
ruby resource_mover.rb # run the script and follow the prompts to choose the resources you want to move
```

The script will ask you for the absolute input state file path and the absolute output state file path. These are the paths to the state files where you want to move resources from and to.

Then, the script will list all the resources in the input state file and prompt you to select the ones you want to move. You can use the arrow keys, space bar, and enter key to make your selection.

The script will then use the `terraform state mv` command to move the selected resources from the input state file to the output state file.

### With Docker (recommended)

To run the script with Docker, you can use the following command:

```bash
terraform state pull > tn.state # pull the state file from your Terraform workspace/remote state storage
# Change TF_VERSION to the version of Terraform you are using in the Dockerfile
docker build . -t terraform-state-split # build the Docker image
# ~/my-terraform-project is the path to your Terraform project directory, it should contain an initialised Terraform project (with plugins/providers downloaded)
docker run -it --rm --env TF_IN_STATE_PATH=./in.state --env TF_OUT_STATE_PATH=./out.state -v ~/my-terraform-project:/terraform terraform-state-split # run the Docker container and follow the prompts to choose the resources you want to move
```
