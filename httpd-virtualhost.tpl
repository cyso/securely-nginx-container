<VirtualHost *:TEMPLATE_PORT>
    LuaScope                  thread
    LuaRoot                   /usr/local/bin/apache2
    LuaHookFixups             gcp-auth.lua authenticate

    ProxyTimeout              60
    ProxyMaxForwards          15

    ProxyPass                 /error   !
    ProxyPass                 /        TEMPLATE_LOCATION
    ProxyPassReverse          /        TEMPLATE_LOCATION

    ServerName                TEMPLATE_FQDN

    <Directory /var/www/html>

        AllowOverride None

        # The error page will be blocked by ModSecurity
        SecRuleEngine DetectionOnly

        Require all granted

        AddOutputFilter includes .html
        Options +IncludesNoExec

    </Directory>

</VirtualHost>

