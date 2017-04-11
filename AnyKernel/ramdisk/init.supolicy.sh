#!/system/bin/sh

SUPOLICY=`which supolicy`

$SUPOLICY --live \
	"allow priv_app { cache_private_backup_file unlabeled } dir getattr" \
	"allow untrusted_app sysfs_kgsl file { read write getattr open }" \
	"allow untrusted_app sysfs_kgsl dir { read write getattr open }" \
	"allow untrusted_app sysfs file { read write getattr open }" \
	"allow untrusted_app sysfs dir { read write getattr open }" \
	"allow { audioserver system_server location sensors } diag_device chr_file { read write }" \
	"allow vold logd dir read" \
	"allow vold logd lnk_file getattr" \
	"allow dumpstate theme_data_file file getattr" \
	"allow mediaserver mediaserver_tmpfs file { read write execute }" \
	"allow untrusted_app sysfs_zram dir search" \
	"allow untrusted_app sysfs_zram file { read open getattr }" \
	"allow shell dalvikcache_data_file dir write"
