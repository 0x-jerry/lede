
# source ./prepare.zsh

export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/make/libexec/gnubin:$PATH"

# clean some path
export PATH=$(echo $PATH | tr ':' '\n' | grep -v 'Fusion.app/Contents/Public' | tr '\n' ':')
export PATH=$(echo $PATH | tr ':' '\n' | grep -v '~/.dotnet/tools' | tr '\n' ':')

# set proxy
export HTTP_PROXY=http://127.0.0.1:10010;
export HTTPS_PROXY=http://127.0.0.1:10010;