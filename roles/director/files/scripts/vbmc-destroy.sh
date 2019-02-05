for domain in $(vbmc list | grep -v 'Domain name' | awk '{print $2}');  do   vbmc delete $domain; done
