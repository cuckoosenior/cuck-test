cd ~/cuckoo/malware;
git fetch origin > /dev/null 2>&1;
if [ $(git rev-parse HEAD) != $(git rev-parse @{u}) ]
then
	git pull > /dev/null 2>&1;
	
	 #while there are x files not malware.txt in array 
	array = ($(ls -I "malware.txt"))
	
	while [ ${#array[@]} -ne 0 ]
	do
		fl=${array[0]}
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
		
		export hash=($(md5sum $fl))
		
		cat ~/r.json | python -m json.tool | cat > ~/cuckoo/logs/"$hash".json;
		
		rm ~/r.json;

		curl -sS -H "Authorization: Bearer NLU_hGQ3UdSFsthvnL7f5g" 192.168.1.116:8090/tasks/delete/$id > /dev/null 2>&1;
			
		# Clean
		# ls | grep -v malware.txt | xargs rm > /de v/null 2>&1;
		rm $fl > /dev/null 2>&1;
		
		#Turn proxy back on 
		
		pwsh ~/poweron.ps1 $1 $2 > /dev/null 2>&1
		
		while true;
		do
			ping -c 1 -w 1 "192.168.1.2" > /dev/null && break;
		done
		
		sleep 2;
		
		export http_proxy='http://192.168.1.2:8080/';
		
		git pull > dev/null 2>&1;
		git add . > /dev/null 2>&1;
		git add ~/cuckoo/logs .
		git commit -m "Added Logs and removed malware" > /dev/null 2>&1;
		git push > /dev/null 2>&1;
		
		array = ($(ls -I "malware.txt"))s
		
	done

else
	echo "Not new malware";
fi

