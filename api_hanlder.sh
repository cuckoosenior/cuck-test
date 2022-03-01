cd ~/cuckoo/malware;
git fetch origin > /dev/null 2>&1;
if [ $(git rev-parse HEAD) != $(git rev-parse @{u}) ]
then
	git pull > /dev/null 2>&1;
	# Do our stuff with the file
	fl=$(ls -I "malware.txt");
	
	# Turn off the proxy
	pwsh ~/poweroff.ps1 $1 $2 > /dev/null 2>&1;
		
	while true;
	do
		!(ping -c 1 -w 1 "192.168.1.2" > /dev/null) && break;
	done
	
	export http_proxy='';
	
	# Put the file for cuckoo to use and get the task id
	id=$(curl -sS -H "Authorization: Bearer NLU_hGQ3UdSFsthvnL7f5g" -F file=@"$fl" 192.168.1.116:8090/tasks/create/file | jq -r '.task_id');
	
	#This returns 'Report not found' if there is no report
	mssg=$(curl -sS -H "Authorization: Bearer NLU_hGQ3UdSFsthvnL7f5g" 192.168.1.116:8090/tasks/summary/$id | jq -r '.message');
	
	while [ "$mssg" == "Report not found" ] 
	do
		sleep 2;
		mssg=$(curl -sS -H "Authorization: Bearer NLU_hGQ3UdSFsthvnL7f5g" 192.168.1.116:8090/tasks/summary/$id | jq -r '.message');
	done
	
	curl -sS -H "Authorization: Bearer NLU_hGQ3UdSFsthvnL7f5g" 192.168.1.116:8090/tasks/summary/$id > ~/r.json;
	
	cat ~/r.json | python -m json.tool | cat > ~/cuckoo/logs/report.json;
	
	rm ~/r.json;

	curl -sS -H "Authorization: Bearer NLU_hGQ3UdSFsthvnL7f5g" 192.168.1.116:8090/tasks/delete/$id > /dev/null 2>&1;
		
	# Clean
	ls | grep -v malware.txt | xargs rm > /dev/null 2>&1;
	
	#Turn proxy back on 
	
	pwsh ~/poweron.ps1 $1 $2 > /dev/null 2>&1
	
	while true;
	do
		ping -c 1 -w 1 "192.168.1.2" > /dev/null && break;
	done
	
	sleep 2;
	
	export http_proxy='http://192.168.1.2:8080/';
	
	git add . > /dev/null 2>&1;
	git add ~/cuckoo/logs .
	git commit -m "Added Logs and removed malware" > /dev/null 2>&1;
	git push > /dev/null 2>&1;
	sleep 5;
	git pull > /dev/null 2>&1;

else
	echo "Not new malware";
fi

