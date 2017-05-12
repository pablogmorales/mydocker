use mysql;
update user set authentication_string=password('password') where user='root';
flush privileges;

