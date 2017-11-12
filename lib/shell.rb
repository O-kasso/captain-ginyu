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

# dotfiles
cmd.run 'cp "$(brew --prefix git)/etc/bash_completion.d"/* "$HOME"'
cmd.run 'cp -R ./dotfiles/ "$HOME"'

# node
cmd.run 'cd && npm install'

# setup and launch iTerm
# custom profile currently only becomes default if unix username is 'O-kasso'
# TODO: dynamically set username
cmd.run 'open -a iTerm'
cmd.run 'mv -f ~/okasso-iterm-profile ~/Library/Application\ Support/iTerm2/DynamicProfiles/'
cmd.run 'pkill iTerm'
cmd.run 'defaults read -app iTerm'
cmd.run 'open -a iTerm'
