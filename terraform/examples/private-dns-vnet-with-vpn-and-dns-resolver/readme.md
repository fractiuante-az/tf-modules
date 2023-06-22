


Add custom DNS entries in `AzureVPN/azurevpnconfig.xml`, take IPs from DNS private resolver inbound endpoints:
 
```xml
<AzVpnProfile ...>
  <serverlist>
  ...
  </serverlist>

  <clientconfig>
    <dnsservers>
      <dnsserver>10.1.XXX.Y</dnsserver>
      <dnsserver>10.1.XXX.Z</dnsserver>
    </dnsservers>
  </clientconfig>
</AzVpnProfile>
```
