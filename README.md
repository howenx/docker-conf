# docker-conf

- **创建容器**

            sudo docker run --name pg-b -d -p 5432:5432 postgres-search

- **连接到启动的容器**
	
	        sudo docker run -it --rm --link pg-b:postgres-search-test postgres-search bash

- **进入docker**
	
	        sudo docker inspect --format "{{ .State.Pid }}" f41a1a163ae1
	        sudo nsenter --target 52825 --mount --uts --ipc --net --pid

- **建立一个相互连接的docker**
	
	        sudo docker run -d -p 80:80 --name ng-2 --link pg-b:pg-b nginx-pgad

- **ubuntu批量删除docker无用镜像**
	
	        docker ps -a | grep "Exited" | awk '{print $1 }'|xargs docker stop
			docker ps -a | grep "Exited" | awk '{print $1 }'|xargs docker rm
			docker images|grep none|awk '{print $3 }'|xargs docker rmi


- **docker phgpgadmin导出sql出现空白问题解决**
	
	        you need to modify your dbexport.php in /usr/share/phppgadmin (on Ubuntu) modify line from passthru($cmd); to echo passthru($cmd); modify line $cmd = $exe . " -i"; to $cmd = $exe;
			it will be enough. Cause parameter -i seems to be deprecated in postgres 9.5 , he gave error for me.