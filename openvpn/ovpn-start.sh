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

#Create namespaces
ip netns add west
ip netns add east
ip netns add internet


#Create veth interfaces to link namespaces
ip link add west0 type veth peer name pub0
ip link add east0 type veth peer name pub1


#Move west0 to 'west' namespace
ip link set west0 netns west

#Move east0 to 'east' namespace
ip link set east0 netns east

#Move pub0 and pub1 to 'internet' namespace
ip link set pub0 netns internet
ip link set pub1 netns internet

#create tun interfaces
ip netns exec east openvpn --mktun --dev tun0
ip netns exec west openvpn --mktun --dev tun1

#configure ip address on all the interfaces
ip netns exec internet ip addr add 172.16.1.1/24 dev pub0
ip netns exec internet ip addr add 172.16.2.1/24 dev pub1
ip netns exec west ip addr add 172.16.1.2/24 dev west0
ip netns exec east ip addr add 172.16.2.2/24 dev east0
ip netns exec west ip addr add 10.0.1.2/24 dev tun1
ip netns exec east ip addr add 10.0.1.1/24 dev tun0

#set all interfaces up
ip netns exec internet ip link set pub0 up
ip netns exec internet ip link set pub1 up
ip netns exec west ip link set west0 up
ip netns exec east ip link set east0 up
ip netns exec east ip link set tun0 up
ip netns exec west ip link set tun1 up

#setup route
ip netns exec west ip route add default via 172.16.1.1
ip netns exec east ip route add default via 172.16.2.1

#start openvpn
ip netns exec east openvpn --tls-server --config config/east-server.config
ip netns exec west openvpn --tls-client --config config/west-user.config

