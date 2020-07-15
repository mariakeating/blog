#!/bin/bash

AppendIndex()
{
    echo "$1" >> index.html
}

AppendArchive()
{
    echo "$1" >> archive.html
}

GetPostFile()
{
    FilePath="$1"
    OutputFileName="$(basename "$FilePath" .md).html"
    OutputFileName=${OutputFileName:9}

    echo "$OutputFileName"
}

MakePost()
{
    FilePath="$1"
    OutputFileName=$(GetPostFile "$FilePath")
    OutputFilePath="archive/$OutputFileName"
    lowdown -Thtml --html-no-head-ids -o "$OutputFilePath" "$FilePath"
    echo "<h4>~Maria Keating</h4>" >> "$OutputFilePath"
    PostTitle="$(awk -vRS="</h1>" '/<h1>/{gsub(/.*<h1>|\n+/,"");print;exit}' "$OutputFilePath")"
    PostDate="$(echo "$FilePath" | grep -o '[0-9]\+')"
    AppendArchive "<li><a href=\"$OutputFilePath\">$PostDate / $PostTitle</a></li>"
}

rm -f index.html
rm -f archive.html
rm -rf archive/

mkdir -p archive/
touch index.html
touch archive.html
AppendArchive "<h1>Archive</h1>"
AppendArchive "<ul>"
ls -1 sources/*.md | sort -r | while read FileName; do MakePost "$FileName"; done
AppendArchive "</ul>"
AppendIndex "<h4>Latest Post</h4>"
AppendIndex "<hr>"
LatestPost=$(ls -1 sources/*.md | sort | tail -n1)
LatestPost="archive/$(GetPostFile "$LatestPost")"
cat "$LatestPost" >> index.html
