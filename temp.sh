#!/usr/bin/env sh

log() {
    ubus call log write_ext "{
                \"event\": \"$2\",
                \"sender\": \"$1\",
                \"table\": 2,
                \"write_db\": 1
        }"
}

# Old format
# default via 123.209.73.224 dev qmimux0 proto static src 123.209.73.223 metric 1
# Current Format
# default dev qmimux0 proto static scope link src 123.209.87.114 metric 1
CHANGING=$(ip route show default | grep "metric 1")

if [ -z "${CHANGING}" ]; then
    log "Network Operator" "No default route available."
    #/usr/bin/eventslog -i -t network -n "Force Route" -e "No default route. Exiting."
    exit 0
fi

# GW_IP=$(echo ${CHANGING} | awk '{print $3}')
GW_IF=$(echo ${CHANGING} | awk '{print $3}')
SRC_IP=$(echo ${CHANGING} | awk '{print $9}')

# Old Format
# default via 192.168.0.1 dev wlan0 src 192.168.0.21
# Current Format
# default dev qmimux0 scope link src 123.209.87.114
CURRENT=$(ip route show table 2 default)

if [ ! -z "$CURRENT" ]; then

    # CURR_GW_IP=$(echo ${CURRENT} | awk '{print $3}')
    CURR_GW_IF=$(echo ${CURRENT} | awk '{print $3}')
    CURR_SRC_IP=$(echo ${CURRENT} | awk '{print $7}')

    # No longer works
    # if [ "$GW_IP" == "${CURR_GW_IP}" ] && [ "$GW_IF" == "${CURR_GW_IF}" ] && [ "$SRC_IP" == "${CURR_SRC_IP}" ] ; then
    if [ "$GW_IF" == "${CURR_GW_IF}" ] && [ "$SRC_IP" == "${CURR_SRC_IP}" ]; then
        log "Network Operator" "No change to default route. Ignoring."
        #/usr/bin/eventslog -i -t network -n "Force Route" -e "No change. Ignoring."
        exit 0
    fi

fi

/etc/init.d/openvpn stop SY3
ip route flush table 2
sleep 1
ip route add default dev ${GW_IF} src ${SRC_IP} table 2
# No longer works
# ip route add default via ${GW_IP} dev ${GW_IF} src ${SRC_IP} table 2
/etc/init.d/openvpn start SY3
#/usr/bin/eventslog -i -t network -n "Force Route" -e "Table 2 Updated ${GW_IF} via ${GW_IP} src ${SRC_IP}. From ${CURR_GW_IF}:${CURR_GW_IP}/${CURR_SRC_IP}. Debug ${CHANGING}."
log "Network Operator" "Table 2 Updated ${GW_IF} via ${GW_IP} src ${SRC_IP}. From ${CURR_GW_IF}:${CURR_GW_IP}/${CURR_SRC_IP}."

exit 0
