#!/usr/bin/fish
set CONF ~/.config/fish/conf.d/21_flapak_aliases.fish
set BLACKLIST not autolad flatpak

echo "#!/usr/bin/fish" > $CONF
echo -n "adding:"
flatpak list --columns=application --app | while read a;
    echo ""
    echo -n "$a: "
    flatpak run --command=sh $a -c 'ls /app/bin' 2>/dev/null | grep -ve \((echo $BLACKLIST | sed s/' '/'|'/g)\) | while read c;
        command -v $c > /dev/null
        or echo "alias $c \"flatpak run --command=$c $a\"" >> $CONF && echo -n " $c"
    end
end
echo "\n... all done."
