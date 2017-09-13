require 'tty'
require 'yaml'

cmd = TTY::Command.new

cmd.run 'mkdir -p ~/.vim/{autoload,bundle,_swap}'
cmd.run 'curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim'

plugins = YAML.load_file('vim-plugins.yml')

plugins.each do |plugin|
  cmd.run("git clone https://github.com/#{plugin}", chdir: '~/.vim/bundle')
end
