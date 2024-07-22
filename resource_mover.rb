require 'tty-prompt'
require 'tty-progressbar'
require 'json'

def extract_resource_names(resources, add_module = false)
  result = []

  resources.each do |resource|
    next if resource['mode'] == "data"
    choice = ""

    unless resource['module'].nil?
      result << resource['module'] if (result.none? { |c| c == resource['module'] } && add_module)
      choice += resource['module'] + '.'
    end
    choice += resource['type'] + '.'
    choice += resource['name']
    result << choice
  end
  result
end

def move_resource(resources, resource_name, move_to_module, new_path, in_state_path, out_state_path)
  affected_resources = []
  if resource_name.include?('module.') && resource_name.count('.') == 1
    affected_resources = resources.select { |r| r['module'] == resource_name }
  else
    affected_resources = resource_name.include?('module.') ? resources.select { |r| r['module'].to_s + '.' + r['type'] + '.' + r['name'] == resource_name } : resources.select { |r| r['type'] + '.' + r['name'] == resource_name }
  end
  resources_names = extract_resource_names(affected_resources)
  bar = TTY::ProgressBar.new("Moving #{resources_names.length} resource(s) [:bar] :percent", total: resources_names.length)
  resources_names.each do |resource|
    new_resource_name = resource
    if move_to_module
      new_resource_name = resource.include?('module.') ? resource.split('.').drop(2).join('.') : resource
      new_resource_name = new_path == '' ? new_resource_name : 'module.' + new_path + ( new_resource_name == '' ? '' : '.' + new_resource_name)
    end
    system("cd '#{File.dirname(in_state_path)}' && terraform state mv -state='#{in_state_path}' -state-out='#{out_state_path}' '#{resource}' '#{new_resource_name}' > /dev/null 2>&1")
    bar.advance(1)
  end
end

prompt = TTY::Prompt.new

in_state_path = ENV['TF_IN_STATE_PATH'] || prompt.ask('Please enter the absolute input state file path.', convert: :filepath, default: '/terraform/in-terraform.tfstate')
out_state_path = ENV['TF_OUT_STATE_PATH'] || prompt.ask('Please enter the absolute output state file path.', convert: :filepath, default: '/terraform//out-terraform.tfstate')

new_path = ""
move_to_module = prompt.yes?('Do you want to move resources from one module to another module?')
  
if move_to_module
  new_path = prompt.ask('Please enter the module name (Leave empty for root module)', default: '')
end

in_state_file = File.read(in_state_path)
in_state = JSON.parse(in_state_file)
resources = in_state['resources']
choices = extract_resource_names(resources, true)

choices = choices.sort_by { |c| (c.include?('module.') && c.count('.') == 1) ? 0 : 1 }

if(choices.length == 0)
  puts "No resources found in the state file."
  exit
end

result =  prompt.multi_select("Resources to be moved? (Use ↑/↓ arrow keys, press Space to select and Enter to finish)", choices, filter: true, symbols: { marker: ">" })
result.each do |resource_name|
  move_resource(resources, resource_name, move_to_module, new_path, in_state_path, out_state_path)
end

