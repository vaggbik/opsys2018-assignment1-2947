#!/bin/bash

if [[ ! -d ./sites/ ]]
then
        mkdir sites
fi

file="../File.txt"

cd sites
if [ -f $file ]
then
        while IFS='' read -r site || [[ -n "$site" ]]
                do
                        if [[ $site != "#"* ]];
                                then
                                filesite="$(echo "${site#*//}" | tr -d /)";
                                if [[ ! -f $filesite ]]
                                then
                                        touch $filesite
                                        echo "$site INIT"
                                        wget "$site" -q -O $filesite;
                                        if [[ ! -s $filesite ]];
                                        then
                                                >&2 echo "$site FAILED";
                                        fi
                                else
                                        wget "$site" -q -O temp.txt
                                        if [[ ! -s temp.txt ]]
                                        then
                                                >&2 echo "$site FAILED";
                                        else
                                                if ! diff $filesite temp.txt >/dev/null ;
                                                then
                                                        echo "$site"
                                                        wget "$site" -q -O $filesite;

                                                fi
                                        fi
                                fi
                        fi
                done <"$file"
                
else
        echo "Error 404: File.txt with websites not found"
        echo "Do you want to create File.txt? (y/n)"    
                read a;
                if [[ $a == "y" ]]
                then
                        touch ../File.txt;
                fi
        while [ $a != "y" ] && [ $a != "n" ]
        do
                echo "you must answer with y for yes or n for no."
                read a;
                if [[ $a == "y" ]]
                then
                        touch ../File.txt;
                fi
        done;
fi

