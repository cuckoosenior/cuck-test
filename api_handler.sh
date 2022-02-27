cd ~/cuckoo/malware;
git fetch origin > /dev/null 2>&1;
if [ $(git rev-parse HEAD) != $(git rev-parse @{u}) ]
then
	git pull > /dev/null 2>&1;
	# Do our stuff with the file
	echo $(file hello.bat) > ~/cuckoo/logs/logs.log;
	# Clean
	ls | grep -v malware.txt | xargs rm > /dev/null 2>&1;
	git add . > /dev/null 2>&1;
	git add ~/cuckoo/logs .
	git commit -m "Added Logs and removed malware" > /dev/null 2>&1;
	git push > /dev/null 2>&1;
	sleep 5;
	git pull > /dev/null 2>&1;
fi

