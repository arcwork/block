#!/bin/bash
##########################################
#	Block ip's From Error Log of Apache  #
    folder="/www/logs"   //folder of apache logs
    tmpfile1=x1.tmp
    tmpfile2=x2.tmp
    exe=/usr/sbin/iptables   // whereis iptables
    out=outfile              // executable script
    wanInterface=eth1
    options=" -p tcp --dport 80 "
#				                         #
##########################################
cat $folder/error_log | grep error | cut -b44-60 | tr "]cFilernIqsu" " " | sed 's/ //g' > $tmpfile1
sort $tmpfile1 | uniq > $tmpfile2

#create out file 
echo "#!/bin/bash" > $out
echo "# " >> $out

echo $exe -N dropip >> $out

egrep -v "^#|^$" $tmpfile2 | while IFS= read -r ip
do
echo "$exe -A dropip -i $wanInterface -s $ip $options -j LOG --log-prefix  IP BlockList  " >> $out
echo "$exe -A dropip -i $wanInterface -s $ip $options -j DROP" >> $out
done < "$tmpfile2"

echo "$exe -I INPUT -j dropip" >> $out

chmod +x $out

#run the script 
./$out

#erase temp files
rm -rf $tmpfile1
rm -rf $tmpfile2
