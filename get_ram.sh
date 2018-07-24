#!/bin/bash
echo "["
for ((i=0; i<$1; i+=5));
do
	sleep 3;
  echo "{\"date\": \"`date`\", \"mem\": \"`free --mega | grep Mem | awk '{print $3}'`\",\"docker\":`docker stats --format '{ \"{{.Name}}\":{ \"mem\" : \"{{.MemUsage}}\", \"cpu\" : \"{{.CPUPerc}}\" }}' --no-stream `}";
done
echo "]"
