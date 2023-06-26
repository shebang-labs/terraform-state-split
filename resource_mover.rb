require 'tty-prompt'
require 'json'

prompt = TTY::Prompt.new

in_state_path = ENV['TF_IN_STATE_PATH'] || prompt.ask('Please enter the input state file path.', convert: :filepath, default: './in-terraform.tfstate')
out_state_path = ENV['TF_OUT_STATE_PATH'] || prompt.ask('Please enter the output state file path.', convert: :filepath, default: './out-terraform.tfstate')

in_state_file = File.read(in_state_path)
in_state = JSON.parse(in_state_file)
resources = in_state['resources']
choices = []

resources.each do |resource|
  choice = ""
  choice += resource['module'] + '.' unless resource['module'].nil?
  choice += resource['type'] + '.'
  choice += resource['name']
  choices << choice
end

result =  prompt.multi_select("Resources to be moved? (Use ↑/↓ arrow keys, press Space to select and Enter to finish)", choices, symbols: { marker: ">" })
result.each do |resource_name|
  system("cd '#{File.dirname(in_state_path)}' && terraform state mv -state-out='#{out_state_path}' #{resource_name} #{resource_name}")
end

