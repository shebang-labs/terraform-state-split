# Terraform Resource Mover

This is a Ruby script that allows you to move resources in Terraform state files based on user input. It uses the tty-prompt gem to create an interactive command-line interface, this ruby CLI tool helps you organise large terraform state files into smaller ones by moving chosen resources from a provided state file into another destination state file.

## Installation

To use this script, you need to have Ruby installed on your system. You also need to install the tty-prompt gem by running:

```bash
gem install tty-prompt
```

You also need to have Terraform installed and initialized in your working directory.

## Usage

To run the script, simply execute it with Ruby:

```bash
ruby resource_mover.rb
```

The script will ask you for the absolute input state file path and the absolute output state file path. These are the paths to the state files where you want to move resources from and to.

Then, the script will list all the resources in the input state file and prompt you to select the ones you want to move. You can use the arrow keys, space bar, and enter key to make your selection.

The script will then use the `terraform state mv` command to move the selected resources from the input state file to the output state file.
