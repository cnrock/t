#!/usr/bin/env sh
################################################
# The DCE v4.x platform etcd data backup script
# Author: SanXian
################################################
[ -z $debug ] && debug=false || $debug == true && debug=true || debug=false
set -ue
`$debug` && set -x
echo -n "debug Mode: "
`$debug` && echo true || echo false
etcd_data_dir="${etcd_data_dir}"
backup_save_dir="${etcd_backup_save_dir}"
backup_temp_dir="${etcd_backup_temp_dir}/etcd_backup"

#export ETCDCTL_CACERT=/etc/ssl/private/ca.crt
#export ETCDCTL_CA_FILE=/etc/ssl/private/ca.crt
#export ETCDCTL_CERT_FILE=/etc/ssl/private/etcd/peer.crt
#export ETCDCTL_ENDPOINTS=https://localhost:12379
#export ETCDCTL_CERT=/etc/ssl/private/etcd/peer.crt
#export ETCDCTL_KEY_FILE=/etc/ssl/private/etcd/peer.key
#export ETCDCTL_KEY=/etc/ssl/private/etcd/peer.key

backup_etcd_apiv2_shell(){
  echo "[Info]backuping etcd v2 data by shell commmand"
  echo "#!/usr/bin/env sh" >> $1
  set +x
  for key in $(ETCDCTL_API=2 /usr/local/bin/etcdctl ls --recursive -p | grep -v "/$")
    do value=$(ETCDCTL_API=2 /usr/local/bin/etcdctl get $key);
    echo "etcdctl set $key '$value'" >> $1
  done
   `$debug` && set -x
  echo "[Info]etcd v2 data backup completed (script)"
  return;
}

backup_etcd_apiv2_command(){
  echo "[Info]backuping etcd v2 data by etcd commmand"
  echo "[Info]etcd v2 data backup completed (command)"
  `${debug}` && ETCDCTL_API=2 /usr/local/bin/etcdctl backup --data-dir=$etcd_data_dir --backup-dir="${backup_temp_dir}/etcd_v2_backup"
  `${debug}` || ETCDCTL_API=2 /usr/local/bin/etcdctl backup --data-dir=$etcd_data_dir --backup-dir="${backup_temp_dir}/etcd_v2_backup" 2>/dev/null
  if [ ! -d "etcd_v2_backup" ]
  then
    echo "[Fatal ERROR] can not find the backup file folder after etcdctl backup operaction"
    exit -1
  fi
  tar --force-local -czf $1 etcd_v2_backup
  echo "[Info]etcd v2 data backup completed (command)"
  return;
}

backup_etcd_apiv3(){
  echo "[Info]backuping etcd v3 data"
  `$debug` && ETCDCTL_API=3 /usr/local/bin/etcdctl snapshot save $1
  `$debug` || ETCDCTL_API=3 /usr/local/bin/etcdctl snapshot save $1 2>/dev/null
  # check snapshot file status
  ETCDCTL_API=3 /usr/local/bin/etcdctl --write-out=table snapshot status $1
  echo "[Info]etcd v3 data backup completed"
  return;
}



if [ ! -d "$backup_save_dir" ]
then
  echo "[Fatal ERROR] can not find save folder for the backup files"
  exit -1
fi

hostnameStr=`hostname`
dateStr=`date "+%y-%m-%dT%H:%M:%S"`
v2_backup_file_sh="etcd_v2_bakckup.sh"
v2_backup_file_file="etcd_v2_files.tar.gz"
v3_snapshot_file="etcd_v3_snapshot.db"
tar_backup_file="${hostnameStr}-D${dateStr}.tar.gz"

mkdir -p ${backup_temp_dir}
cd ${backup_temp_dir}

backup_etcd_apiv2_shell $v2_backup_file_sh
backup_etcd_apiv2_command $v2_backup_file_file
backup_etcd_apiv3 $v3_snapshot_file

if ! [ -f $v2_backup_file_sh -a -f $v2_backup_file_file -a -f $v3_snapshot_file ]
then
  echo "[Fatal ERROR] can not find the etcd backup files"
  exit -1
fi

cd ${etcd_backup_temp_dir}

tar --force-local -czf ${tar_backup_file} etcd_backup

if [ ! -f ${tar_backup_file} ]
then
  echo "[Fatal ERROR] can not find the tar files"
  exit -1
fi

cp ${tar_backup_file} ${backup_save_dir}

echo "[Info]etcd data backup success"
