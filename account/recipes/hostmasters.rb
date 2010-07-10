hostmasters = search(:users, "groups:hostmaster")

hostmasters.each do |hostmaster|
  account hostmaster['id'] do
    password hostmaster['password']
    shell hostmaster['shell']
    comment hostmaster['comment']
    authorized_keys hostmaster['authorized_keys']
  end

  group "wheel" do
    members hostmaster['id']
    append true
  end
end
