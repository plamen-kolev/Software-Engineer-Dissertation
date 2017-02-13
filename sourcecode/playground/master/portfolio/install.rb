@build_path = '/home/vagrant/portfolio'
apt_package 'packages' do
    package_name ['php', 'php-mbstring', 'php-xml', 'php-gd', 'php-sqlite3', 'wkhtmltopdf', 'nginx', 'xvfb']
end

git "/home/vagrant/portfolio" do
    repository "https://github.com/plamen-k/portfolio.git"
    reference "master"
    action :sync
end

bash 'composer_install' do
    code 'cd /home/vagrant/portfolio && ./composer.phar install'
end

bash 'compile_website' do
    code 'cd /home/vagrant/portfolio && nohup php artisan serve & && php artisan page'
end

bash 'to_serve_man' do
    code <<-EOH
        cp -r /home/vagrant/portfolio/plamen-k.github.io /var/www/      
    EOH
end

