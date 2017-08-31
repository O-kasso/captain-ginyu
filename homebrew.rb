require 'tty'

cmd = TTY::Command.new

if cmd.run('xcode-select -p').failure?
  # trick macOS updater into thinking XCODE COMMAND LINE TOOLS are available
  cmd.run('touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress')
  # install XCODE COMMAND LINE TOOLS and other pending updates
  cmd.run('softwareupdate -i -a')
end

# install homebrew
cmd.run('/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install < /dev/null)"')

# this may no longer be necessary
# cmd.run('chown -R "$(whoami)" /usr/local') # fixes occasional permissions issue

cmd.run('brew analytics off')
cmd.run('brew doctor')
cmd.run('brew update')
cmd.run('brew tap caskroom/cask ')
cmd.run('brew cask doctor')
cmd.run('brew bundle')
cmd.run('brew cleanup -s')
cmd.run('brew cask cleanup')
