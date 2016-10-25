#!/usr/bin/env bash


BROKER="$KAFKA_ADVERTISED_HOST_NAME:$KAFKA_ADVERTISED_PORT"

if [[ -z "$START_TIMEOUT" ]]; then
    START_TIMEOUT=600
fi

start_timeout_exceeded=false
count=0
step=10
while netstat -lnt | awk '$4 ~ /:'$KAFKA_PORT'$/ {exit 1}'; do
    echo "waiting for kafka to be ready"
    sleep $step;
    count=$(expr $count + $step)
    if [ $count -gt $START_TIMEOUT ]; then
        start_timeout_exceeded=true
        break
    fi
done

if $start_timeout_exceeded; then
    echo "Kafka isn't ready (waited for $START_TIMEOUT sec)"
    exit 1
fi

$KAFKA_HOME/bin/kafka-run-class.sh kafka.admin.AutoExpandCommand --zookeeper=$KAFKA_ZOOKEEPER_CONNECT --broker=$KAFKA_BROKER_ID --mode=monitor
