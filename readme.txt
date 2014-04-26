INSTALLATION!

0) Prerequisites
apt-get install ruby 
gem install rake
gem install bundler
apt-get install mysql-server mysql-client libmysqlclient-dev nodejs
0.1) MySQL
CREATE DATABASE ricer;
GRANT ALL ON ricer.* to ricer@localhost identified by 'ricer';


1) bundle install --path vendor/bundle
2) bundle update
3) rake db:migrate
4) rake db:seed (see db/seed.rb to add a server)
5) rake ricer:start
6) rake ricer:start again, because it will install some plugins on first run and then it needs a restart


FEATURES
+ Multi Network support
+ Great flood control
+ Reload Code on runtime
+ Almost Thread safe in theory
+ Bug Free?
+ Rails style


TODO
+ Invent interactive walkthrough system
+ Jabber + ICQ + Websocket Binding


THANKS
+ All #wechall people for making my day every day!
+ dloser for support and aid to raise free time
+ livinskull for the best greeting card ever!
+ jjk for ruby lessons
+ spaceone for making me proud
+ Hirsch for motivation
+ noother for great Nimda3 code
