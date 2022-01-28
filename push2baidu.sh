#!/bin/bash
        
url_txt=urls.txt

doCommit() {
    echo ">>>>>>> build in mkdocs branch success"

    echo "push2baidu executing ..."

    rm -f $url_txt

    cmd=`grep loc site/sitemap.xml  | awk -F ">" '{print $2}' | awk -F "<" '{print $1}'`

    for line in $cmd; do
        echo $line >> $url_txt
    done

    echo "pushing urls to baidu"

    curl -H 'Content-Type:text/plain' --data-binary "@$url_txt" "http://data.zz.baidu.com/urls?site=https://wzasd.github.io&token=gv0ua2vUtIH0z7bt"

    echo "push completed."

    rm -f $url_txt
}

doCommit