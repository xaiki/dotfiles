#!/usr/bin/env fish
function wttr --description 'get weather from wttr.in'
    set request "wttr.in/$argv?q"
    test "$COLUMNS" -lt 125; and set request "$request?n"
    curl -H "Accept-Language: $LANG%_*" --compressed "$request"
end
