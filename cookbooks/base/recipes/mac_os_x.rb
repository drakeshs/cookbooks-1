raise "running as root is not supported on mac os" if root?

include_recipe "mac"
include_recipe "homebrew"
include_recipe "iterm"

# need to upgrade this one as early as possible or dircolors will break
package "xz"
package "coreutils" do
  action :upgrade
end
