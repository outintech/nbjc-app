## MacOS 10.14.6 Mojave Users

There are many ways in which trying to install ruby 2.7.2 will go wrong within a modern MacOS environment, and the easiest way to get ruby-build to work with ruby environment managers like rubyenv and asdf is to use Homebrew to install another version of gcc.

Here is a quick outline of the steps that worked as of 10/13/21

- Do a clean install of XCode's Command Line Tools
  - run `rm -rf /Library/Developer/CommandLineTools/`
  - run `xcode-select --install` or download the installer for CLI tools 11.3.1 https://download.developer.apple.com/Developer_Tools/Command_Line_Tools_for_Xcode_11.3.1/Command_Line_Tools_for_Xcode_11.3.1.dmg
  - Point to command line tools by running `sudo xcode-select -s /Library/Developer/CommandLineTools`
- run `brew install gcc`
- add aliases in your `~/.bash_profile` or `~/.bashrc` file:
```
alias gcc='gcc-11'
alias cc='gcc-11'
alias g++='g++-11'
alias c++='c++-11'
```
- if using **asdf** package manager, add these lines to the relevant shell profile files mentioned above:
```
. /usr/local/opt/asdf/libexec/asdf.sh
. /usr/local/opt/asdf/asdf.sh
```
- Make sure brew is up to date with `brew update` and `brew upgrade`
- run `rbenv install 2.7.2` or `asdf install ruby 2.7.2` depending on which ruby version manager you are using
- Set 2.7.2 to global with `rbenv global 2.7.4` or `asdf global ruby 2.7.2`
- Verify by running `ruby -v` and should see 
```
ruby 2.7.2p137 (2020-10-01 revision 5445e04352) [x86_64-darwin18]
```
