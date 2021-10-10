# Scenario 2: Metrics To Monitor in a proxy server with SSL offloading

## Which metrics to monitor in an SSL Offloading Server and how to monitor ?

### 1. CPU Usage
 * Why to monitor ?
SSL Offloading is cpu sensitive process so its important to monitor CPU metrics.
 * How to monitor ?
**top** command can be used to monitor cpu load as well as CPU usage.
#### Bash Script to monitor CPU Usage
Bash script which makes use of the **top** command can be used as cronjob to monitor CPU usage and send alerts to a given email address. Warning and critical threshold can also be provided as required.   
Example:
```
cd home-test/scenario-2
./bin/check_server_metrics.sh -m cpu -w 75 -c 90

OK. CPU: 17%
```

### 2. Memory Usage
 * Why to monitor?
When server is out of RAM, this affects the server efficiency and performance.
 * How to monitor ?
**free** command can be used to monitor memory usage.
#### Bash Script to monitor Memory Usage
Bash script which makes use of the **free** command can be used as cronjob to monitor Memory usage and send alerts to a given email address. Warning and critical threshold can also be provided as required.   
Example:
```
cd home-test/scenario-2
./bin/check_server_metrics.sh -m mem -w 75 -c 90

 OK. RAM: 56% 
 ```

### 3. Disk Usage   
 * Why to monitor?
When server is out of Disk space, the application fails as it cannot write files or logs, hence affecting the end users.
 * How to monitor ?
**df -h** command can be used to monitor disk usage.
#### Bash Script to monitor Disk Usage
Bash script which makes use of the **df** command can be used as cronjob to monitor Disk usage and send alerts to a given email address. Warning and critical threshold can also be provided as required.   
Example:
```
cd home-test/scenario-2
 ./bin/check_server_metrics.sh -m disk -w 75 -c 90

 Critical! DISK: 93%
 ```

### 4. Increase in file descriptor 
 * Why to monitor ?
Slower responses and higher wait time will cause high File descriptors on server
 * How to monitor ?
**lsof** can be used to find the open file descriptor for all the process in the server
```
lsof | wc -l
```
Find the open file descriptor for a single process
```
    lsof -a -p <process-id>
```
#### Bash Script to monitor Open files.
Bash script which makes use of the **lsof** command can be used as cronjob to monitor the open files usage and send alerts to a given email address. Warning and critical threshold can also be provided as required.   
Example:
```
cd home-test/scenario-2
 ./bin/check_server_metrics.sh -m open_files -w 100 -c 300

 Warning! OPEN_FILES: 185
 ```

### 5. TCP Open Connections
 * Why to monitor?
TCP Connections open (Internet<->Proxy<->Backend)
 * How to monitor ?
The following command can be used to find the open connections for tcp:
```
netstat -tn
```
#### Bash Script to monitor Open TCP Connections
Bash script which makes use of the **netstat** command can be used as cronjob to monitor the open files usage and send alerts to a given email address. Warning and critical threshold can also be provided as required.   
Example:
```
cd home-test/scenario-2
./bin/check_server_metrics.sh -m open_tcp_connections -w 100 -c 300

OK. OPEN_TCP_CONNECTIONS: 0
 ```

### 6. SSL Certificate Expiry on Proxy Server
 * Why to monitor?
SSL is crucial to monitor. If ssl certificate expires, the site will be unreachable.
 * How to monitor ?
The following command can be used to monitor ssl expiry time.
```
openssl s_client -servername google.com -connect google.com:443  2>/dev/null 
| openssl x509 -noout -dates
```
#### Bash Script to SSL expiry time.
Bash script which makes use of the **openssl** command can be used as cronjob to monitor the ssl expiry time and send alerts to a given email address. Warning and critical threshold can also be provided as required.   
Example:
```
cd home-test/scenario-2
./bin/check_ssl_cert_expiry.sh -s google.com -w 30 -c 15
Website is google.com
OK. google.com will expire in 40 days
 ```

### 7. SSL-Offloading Proxy Server Process Aliveness 
 * Why to monitor?
The process which deals with SSL offloading needs to be up and running. Hence its important to monitor 
 * How to monitor ?
pgrep or ps command can be used to check if a process is running.
```
pgrep <process name> || echo Not running 
OR
ps -ef | <process name> | grep -v grep || echo not running
```
#### Bash Script to monitor process aliveness.
Bash script which makes use of the **ps** command can be used as cronjob to monitor the process aliveness and send alerts to a given email address.  
Example:
```
cd home-test/scenario-2
./bin/check_process.sh nginx jeraldsabu@gmail.com
The process nginx is running.
 ```

### 8. Disk Stats   
* Why to monitor ?
Disk I/O metrics from /proc/diskstats. To measure DISK IO of the server while performing Encrytion / Decryption
* How to monitor ?
```
iostat -p sda
iostat -x 2 5
```
#### Bash Script to monitor Disk I/O.
Bash script which makes use of the **iostat**  can be used as cronjob to monitor the Disk IO and send disk IO reports to email.  
Example:
```
cd home-test/scenario-2
$ ./check_diskstat.sh 
 ```

### **Realtime Monitoring can also be done with various tools like nagios, prometheus with netdata or node exporters, zabbix etc.**

## Challenges of SSL-Offloading Proxy Server Monitoring :
1. Compatibility metrics for clients: Application is not compatible at all with SSL offloading in some cases. How to differentiate those clients ?
2. HTTPS -> HTTP decryption inspection : HTTP inspection (When encrypted request decrypted by SSL-Offloading server) is difficult to choose (for which http requests)?. Hackers are using the SSL/TLS protocols as a tool to obfuscate their attack payloads. A security device may be able to identify a cross-site scripting or SQL injection attack in plaintext, but if the same attack is encrypted using SSL/TLS, the attack will go through unless it has been decrypted first for inspection.
3. Key Sizes of Requests : SSL processing will be CPU intensive when the key size increases. How to measure Key sizes ?
4. Internet Facing Firewall Monitoring : Catch Security Threats, DDoS attacks , Spoofing
5. Monitoring of Monitoring and HA of monitoring itself : Its always challenge.
6. Metrics monitoring tools should not affect server performance.