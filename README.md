## Basic Hadoop image

#### Overview

Installs Hadoop and it's dependencies.
Can run a number of hadoop client commands outlined below. Serves as a baseline to all the other hadoop/cassandra related images under the `andlaz` repo -- `hadoop-cassandra`, `hadoop-hdfs-nn`, `hadoop-yarn-rm`

#### Usage

There is nothing in this image to help you configure or start any of the Hadoop deamons. Those you will find in 
 - `andlaz/hadoop-cassandra` ( data node, node manager )
 - `andlaz/hadoop-hdfs-nn` ( name node )
 - `andlaz/hadoop-yarn-rm` ( resource manager )

Nevertheless, you can ( and should ) use this image to run hdfs/yarn/mapred client commands.

##### Install Locations

 - /opt/hadoop-2.7.0
 - /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.45-30.b13.el7_1.x86_64/

`JAVA_HOME` is set and the hadoop bin folder added to `PATH`

##### Client command example

n.b. `resourcemanager` is the host ( also docker container name ) of the resource manager

    docker run \
    	-e "YARN_CLIENT_OPTS=-Dyarn.resourcemanager.hostname=resourcemanager" \
        -ti --rm \
        andlaz/hadoop-base \
        yarn node -list