#!/bin/bash
##########################################################
##hdfs文件删除脚本，以文件的时间戳
##进行时间的比较，可以精确删除指定时间外的文件
###########################################################

HADOOP_HOME=""
HADOOP_BIN=""
D_DAYS=1
C_TIME=`date +%s`
D_TIME=`echo "$C_TIME-$D_DAYS*3600*24" | bc | awk '{print int($0)}'`
D_DIRS=("") 

function clear_dir(){
	local hdfs_dir=$1
	local subdir_list=`${HADOOP_BIN} dfs -ls $1|awk '{printf "%s&%s&%s\n", $6, $7, $8}'`
	for dir in $subdir_list
	do
        str=${dir//&/ }
        arr=($str)
        if [ ${#arr[@]} -lt 3 ] 
        then 
            continue
        else
            ct=`date -d "${arr[0]} ${arr[1]}" +%s`
            if [ $ct -lt $D_TIME ]
            then 
                echo "removing ${arr[0]} ${arr[1]} ${arr[2]}"
                $HADOOP_BIN fs -rmr -skipTrash ${arr[2]}
                if [ $? -ne 0 ]
                then
                    echo "removing faild: $dir" >&2
                fi
            fi
        fi
	done
}


for d_dir in ${D_DIRS[@]}
do
       echo $d_dir
       clear_dir $d_dir
done
