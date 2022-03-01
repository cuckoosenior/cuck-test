param(
[string]$a,
[string]$b
)

connect-viserver vcenter.cise.ufl.edu -user $a -Password $b;

shutdown-vmguest -VM "Proxy Host" -Confirm:$False;

