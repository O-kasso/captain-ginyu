require 'tty'

cmd = TTY::Command.new

# upgrade shell to latest Bash version
cmd.run 'echo "/usr/local/bin/bash" | sudo tee -a /etc/shells > /dev/null'
cmd.run 'chsh -s /usr/local/bin/bash'

# install FZF extensions
cmd.run 'yes | /usr/local/opt/fzf/install & '

# ruby
latest_ruby =
  cmd.run('rbenv install -l | grep -v - | tail -1 | sed -e "s/^ *//"').out
cmd.run 'eval "$(rbenv init -)"'
cmd.run "rbenv install #{latest_ruby}"
cmd.run "rbenv global #{latest_ruby}"

# node
cmd.run 'npm install -g htmlhint stylelint jshint coffeelint jsonlint pug-lint'

# dotfiles
cmd.run 'cp "$(brew --prefix git)/etc/bash_completion.d"/* "$HOME"'
cmd.run 'cp -R ./dotfiles/ "$HOME"'

# reload shell
cmd.run 'source ~/.bash_profile'
