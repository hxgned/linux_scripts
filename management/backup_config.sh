#!/bin/bash

v_time=`date "+%Y-%m-%d"`;

backup_dir=./backup_${v_time};
shadowsocks_backup_dir=$backup_dir/shadowsocks_conf;
nginx_backup_dir=$backup_dir/nginx_conf;
v2ray_backup_dir=$backup_dir/v2ray_conf;
certificate_backup_dir=$backup_dir/ssl_bak;
www_backup_dir=$backup_dir/wwww;

echo 'my personal server backup script for ubuntu 18.04';

function privilege_check()
{
	if [ `whoami` == 'root' ]; then
		echo 'you are root!';
	else 
		echo 'run this scrupt as root!';
		exit;
	fi
}

function backup_directory_check()
{
	if test -d $backup_dir; then
		echo 'a bckup floder already exist!';
		echo 'delete it before run this script!'

		while true
		do
			read -p 'do you want to remove it(y/n):' opt;

			if [ "$opt" == "y" ]; then
				rm -rf ./$backup_dir;
				break;
			elif [ "$opt" == "n" ]; then
				echo 'will quit!'
				exit 1;
			else 
				echo "invalid input! try again!";
				continue;
			fi
		done
	fi

	mkdir ./backup_${v_time};
}

function backup_shadowsocks()
{
	if test -d /etc/shadowsocks-libev; then
		echo 'shadowsocks-libev configuration detected!';

		mkdir -p ${shadowsocks_backup_dir};

		mkdir -p ${shadowsocks_backup_dir}/main_config;
		mkdir -p ${shadowsocks_backup_dir}/default;
		mkdir -p ${shadowsocks_backup_dir}/systemd;

		echo 'backuping shadowsoks main configuration files';
		cp -rf /etc/shadowsocks-libev ${shadowsocks_backup_dir}/main_config/;
		echo 'backuping shadowsoks systemd configuration files';
		cp -rf /lib/systemd/system/shadowsocks*.service ${shadowsocks_backup_dir}/systemd/;
		echo 'backuping shadowsoks default configuration files (/etc/default)';
		cp -rf /etc/default/shadowsocks-libev ${shadowsocks_backup_dir}/default/;
	fi
}

function backup_nginx()
{
	if test -d /etc/nginx; then
		echo 'nginx configuration detected!';

		mkdir -p ${nginx_backup_dir};

		mkdir -p ${nginx_backup_dir}/sites-available;

        	echo 'backuping nginx sites configuration files';
        	cp -rf /etc/nginx/sites-available/* ${nginx_backup_dir}/sites-available/;
	fi
}

function backup_v2ray()
{
	if test -d /etc/v2ray; then
		echo 'v2ray configuration detected!';

		mkdir -p ${v2ray_backup_dir};
		
		mkdir -p ${v2ray_backup_dir}/main_config;
		mkdir -p ${v2ray_backup_dir}/systemd;

		echo 'backuping v2ray main configuration files';
		cp -rf /etc/v2ray ${v2ray_backup_dir}/main_config/;
		echo 'backuping v2ray systemd configuration files';
		cp -rf /lib/systemd/system/v2ray.service ${v2ray_backup_dir}/systemd/;
	fi
}

function backup_certificates()
{
	if test -d /root/ssl; then
		echo 'user certificate detected!';

		mkdir -p ${certificate_backup_dir};

		echo 'backuping ca private key && public key files';
		cp -rf /root/ssl ${certificate_backup_dir}/;
	fi
}

function backup_www()
{
	if test -d /var/www; then
		echo 'websites detected!';

		mkdir -p ${www_backup_dir};

		echo 'backuping websites files';
		cp -rf /var/www/* ${www_backup_dir}/;
	fi
}

function create_tar()
{
	echo 'creating a tar  package.....'
	tar -cvf ./backup_${v_time}.tar $backup_dir;
}

privilege_check;
backup_directory_check;
backup_shadowsocks;
backup_nginx;
backup_v2ray;
backup_certificates;
backup_www；
create_tar;
