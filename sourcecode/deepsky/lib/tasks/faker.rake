namespace :faker do
  desc "TODO"
  task init: :environment do
    Rake::Task['db:purge'].invoke
    Rake::Task['db:migrate'].invoke
    User.create(:email => "local@host.com", :password => 'password', :password_confirmation => 'password')
    User.create(:email => "user2@host.com", :password => 'password', :password_confirmation => 'password')

    # associate machines with users
    ip = IPAddr.new("192.168.0.50")
    (1..2).each do |n|
      title = "#{Faker::Hacker.verb}_#{Faker::Hacker.verb}_#{Faker::Hacker.verb}".parameterize
      Machine.create(title: "#{title}", user_id: rand(1..2), ip: ip.succ.to_s, deployed: false)
      ip = IPAddr.new(ip.succ.to_s)
    end

    u = User.where(email: 'local@host.com').take
    u.token = 'securetoken'
    u.save
  end

end
