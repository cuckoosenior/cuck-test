param(
[string]$a,
[string]$b
)

connect-viserver vcenter.cise.ufl.edu -user $a -Password $b;

start-vm -VM "Proxy Host" -Confirm:$False;
