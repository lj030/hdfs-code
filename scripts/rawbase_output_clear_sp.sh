#!/bin/bash
##########################################################
##对hdfs指定目录进行文件的清理
###########################################################

HADOOP_HOME=""
HADOOP_BIN="${HADOOP_HOME}/bin/hadoop"
D_DAYS=1
D_DIRS=("",
""
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
