#!/bin/bash
sudo apt install figlet
figlet -f slant sub-miner
echo "A Recon Automation Tool by bi66y"

read -p "Enter company name: " company
read -p "Domain:" domain
echo "This will take sometime...have a look at recon folder created at home directory"
mkdir ~/recon
mkdir ~/recon/$company
mkdir ~/recon/$company/$domain

cd ~/recon/$company/$domain/
mkdir ~/recon/$company/$domain/subs

amass enum -passive -d $domain -o ./subs/amass-passive.txt
findomain -t $domain -u ./subs/findomain.txt
subfinder -d $domain -o ./subs/subf.txt
assetfinder $domain | tee -a ./subs/assf.txt
sublist3r -d $domain -o ./subs/subl.txt

cat ./subs/*.txt | anew ./allsubs.txt
httpx -l allsubs.txt --silent -o live.txt
httpx -l live.txt -mc 404 -cname -o cnames.txt
httpx -l live.txt --content-length -mc 200 -o content.txt
cat live.txt | dnsx -a --resp-only -o ip.txt
cat ip.txt | nrich - >> nrich.txt
httpx -l live.txt -p 80,443,8080,3000 -status-code -title -o titles.txt
httpx -l live.txt --silent -title -mc 403 -o forbidden.txt
