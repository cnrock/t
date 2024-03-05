# docker-rockylinux9-systemd
This repository show you how to use systemd on RockyLinux 9

You can see it in the Dockerfile

# Usage
```
$> git clone
$> docker build -t rockylinux9-systemd-image . --no-cache
$> docker run -itd --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:rw --name rockylinux9-systemd rockylinux9-systemd-image
```

Check systemd status in Docker
```
$> docker exec -it rockylinux9-systemd bash
$> systemctl
```

# More compatibility of systemd
In Addition if you need to have more compatibility of systemd in docker (for timedatectl, loginctl etc...)

```$> systemctl start systemd-logind```

And to add "service" command

  ```$> dnf install initscripts```

