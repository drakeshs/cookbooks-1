if vbox_guest?
  include_recipe "virtualbox::guest"
else
  include_recipe "virtualbox::host"
end
