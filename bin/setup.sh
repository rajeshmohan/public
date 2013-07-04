#/bin/bash
mysql ovs_quantum -e "delete from firewalls"
mysql ovs_quantum -e "delete from firewall_rules"
mysql ovs_quantum -e "delete from firewall_policies"

export policy_id=`curl -X POST -H "X-Auth-Token: $auth_token" -H "Content-type: application/json" -d '{"firewall_policy": {"name": "fwasspolicy"} }' $q_url/firewall/firewall_policies|python ~/bin/policy_id.py`
export fw_id=`curl -X POST -H "X-Auth-Token: $auth_token" -H "Content-type: application/json" -d '{"firewall": {"name": "fwasstest", "firewall_policy_id": "'$policy_id'"} }' $q_url/firewalls|python ~/bin/fw_id.py`
export rule_id=`curl -X POST -H "X-Auth-Token: $auth_token" -H "Content-type: application/json" -d '{"firewall_rule": {"protocol": "tcp", "destination_port": "80", "action": "allow"}}' $q_url/firewall/firewall_rules|python ~/bin/rule_id.py`
curl -X PUT -H "X-Auth-Token: $auth_token" -H "Content-type: application/json" -d '{"firewall_policy": {"firewall_rules_list": ["'$rule_id'"]}}' $q_url/firewall/firewall_policies/$policy_id|python -m json.tool

echo "Polcy ID: " $policy_id
echo "Firewall ID: " $fw_id
echo "Rule ID: " $rule_id
