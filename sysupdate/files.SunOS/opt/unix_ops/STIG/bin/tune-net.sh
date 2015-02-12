#!/bin/sh

# These network tuneables are required by disa for supposed security reasons.

/usr/sbin/ndd -set /dev/ip ip_forward_src_routed 0  #GEN003600
/usr/sbin/ndd -set /dev/ip ip_respond_to_timestamp_broadcast 0
/usr/sbin/ndd -set /dev/ip ip_respond_to_timestamp 0  #GEN003602
/usr/sbin/ndd -set /dev/ip ip_respond_to_echo_broadcast 0  #GEN003603
/usr/sbin/ndd -set /dev/ip ip_respond_to_echo_multicast 0  #GEN003604
/usr/sbin/ndd -set /dev/tcp tcp_rev_src_routes 0  #GEN003605
/usr/sbin/ndd -set /dev/ip ip_ignore_redirect 1  #GEN003609
/usr/sbin/ndd -set /dev/ip ip_send_redirects 0  #GEN003610
/usr/sbin/ndd -set /dev/ip6 ip6_forwarding 0  #GEN005610
/usr/sbin/ndd -set /dev/ip6 ip6_ignore_redirect 1  #GEN007860
/usr/sbin/ndd -set /dev/ip6 ip6_send_redirects 0  #GEN007880
/usr/sbin/ndd -set /dev/ip6 ip6_forward_src_routed 0  #GEN007920
/usr/sbin/ndd -set /dev/ip6 ip6_forward_src_routed 0  #GEN007940
/usr/sbin/ndd -set /dev/tcp tcp_conn_req_max_q 1024  #GEN003601
/usr/sbin/ndd -set /dev/ip ip6_respond_to_echo_multicast 0  #GEN007950
 

if [ `/usr/sbin/ndd /dev/tcp tcp_conn_req_max_q0` -lt 2048 ] ; then
  /usr/sbin/ndd -set /dev/tcp tcp_conn_req_max_q0 2048
fi



exit 0

