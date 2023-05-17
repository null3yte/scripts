host=$(echo $1 | unfurl format %d)
gospider --site $1 -a -r -d 6 -u "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36" -q --robots --sitemap --js --json | jq -r ".output" | grep -Eiv '\.(css|jpg|jpeg|png|svg|img|gif|mp4|pdf|doc|ogv|wmv|webm|webp|mov|mp3|m4a|ppt|pptx|scss|tof|ttf|otf|woff|woff2|ico|bmp|htc|image|rtf)' | grep $host | sort -u
