# Scenario 1: Numbers in random order
This repository basically helps you to print numbers from 1 to 10 in random order.
## Overview
* The program which is written in bash will print numbers in random order from 1 to 10 or from any specific range provided in the script. 
* The program make use of the predefined unix variable called "RANDOM" to print the numbers in random order.
## Technologies
* GNU bash, version 5.0.16(1)-release (x86_64-pc-linux-gnu)
## Prerequisites
Make sure that bash is installed. (Bash is available on linux and Mac OS by default)
```sh
bash --version
```
If bash is not installed by default. The following command can be used to install bash in different OS.
* Mac OS
 ```sh
 brew install bash
 ```
* Debian OS
 ```sh
  sudo apt-get install bash
 ```
* Centos/Redhat OS
 ```sh
  sudo yum install bash
 ```

# How to run
1. Open the terminal and run the below command to clone the repository to the local machine. 
```
git clone https://github.com/jeraldsm/home-test.git
```
2. Provide execute permission for the script.
```
cd home-test/scenario-1
chmod +x bin/printRandomNum.sh 
```
3. Execute the script.
```
./bin/printRandomNum.sh
```
4. You can also sepcify a range in the script arguments.
```
./bin/printRandomNum.sh 1 10
```

## Sample Output
```
./bin/printRandomNum.sh 
3
7
6
2
5
4
1
9
10
8
```
