node 'pserver' {
include nginx
include httpd
include git
}
node 'pclient' {
include nginx
include httpd
}
