require 'tty'

cmd = TTY::Command.new

# install homebrew (also installs Xcode CLTools)
cmd.run '/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install < /dev/null)"'

cmd.run <<EOS
brew analytics off && \
brew doctor && \
brew update && \
brew tap caskroom/cask && \
brew cask doctor
EOS

cmd.run 'brew bundle'
cmd.run 'brew cleanup -s && brew cask cleanup'
