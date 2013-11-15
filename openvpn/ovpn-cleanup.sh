#[west user side] ---- [internet] ----- [east server side]
#
#
#[west user side]
#    • Namespace: west
#    • Interface west0 (IP Addr: 172.16.1.2/24)
#        ○ Veth remote: pub0 (IP Addr: 172.16.1.1/24)
#    • Interface tun1 (IP Addr: 10.0.1.2/24)
#
#[internet]
#    • Namespace: internet
#    • Interface pub0  (IP Addr: 172.16.1.1/24)
#        ○ Veth remote: west0 (IP Addr: 172.16.1.2/24)
#    • Interface pub1 (IP Addr: 172.16.2.1/24)
#        ○ Veth remote: east0 (IP Addr: 172.16.2.2/24)
#        
#[east server side]
#    • Namespace: east
#    • Interface east0 (IP Addr: 172.16.2.2/24)
#        ○ Veth remote pub1 (IP Addr: 172.16.2.1/24)
#    • Interface tun0 (IP Addr: 10.0.1.1/24)
#
#

# kill openvpn
killall -9 openvpn

#Create namespaces
ip netns del west
ip netns del east
ip netns del internet

#not perfect but will work if the box is rebooted
#TODO: Delete all resources and then delete namespace


