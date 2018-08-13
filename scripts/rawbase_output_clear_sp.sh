#!/bin/bash
##########################################################
##ya-global对制定目录进行rawbase出库删除，保留1~2天的数据
###########################################################

HADOOP_HOME="/home/disk0/wujian11/hadoop_client/hadoop-yq/hadoop"
HADOOP_BIN="${HADOOP_HOME}/bin/hadoop"
D_DAYS=1
D_DIRS=("/user/kg/rawbase_output/newfangled_music",
"/user/kg/rawbase_output/online_kg_publish_core",
"/user/kg/rawbase_output/SPO_data_all",
"/user/kg/rawbase_output/bdbk_rawbase_jsonld",
"/user/kg/rawbase_output/music_after_merge"
)

function clear_dir(){
	local hdfs_dir=$1
	local subdir_list=`${HADOOP_BIN} dfs -ls $1 | awk -v X_DAY=${D_DAYS}  'BEGIN{ x_days_ago=strftime("%F", systime()-X_DAY*24*3600) }{ if($6<x_days_ago){printf "%s\n", $8} }'`
	for dir in $subdir_list
	do
		echo "removing $dir"
		$HADOOP_BIN fs -rmr -skipTrash $dir
		if [ $? -ne 0 ]
		then
			echo "removing failed: $dir" >&2
		fi
	done
}

for d_dir in ${D_DIRS[@]}
do
       echo $d_dir
       clear_dir $d_dir
done
