namespace :faker do
  desc "TODO"
  task init: :environment do
    Rake::Task['db:purge'].invoke
    Rake::Task['db:migrate'].invoke
    User.create(:email => "local@host.com", :password => 'password', :password_confirmation => 'password')
    User.create(:email => "user2@host.com", :password => 'password', :password_confirmation => 'password')

    # associate machines with users
    ip = IPAddr.new("192.168.0.50")
    (1..10).each do |n|
      puts ip.succ.to_s.inspect
      Machine.create(title: "#{Faker::Hacker.verb}_#{Faker::Hacker.verb}_#{Faker::Hacker.verb}", user_id:1, ip: ip.succ.to_s, deployed: true)
      ip = IPAddr.new(ip.succ.to_s)
    end
  end

end
