# 3cx-docker
3cx installation container


docker run -d \
    --name=3cxpbx \
    -p 5000-5001:5000-5001 \
    -p 5060:5060 \
    -p 5065:5065\
    -p 5090:5090 \
    -p 9000:10999 \
    --cap-add SYS_ADMIN 
    -v /sys/fs/cgroup:/sys/fs/cgroup:ro
    -e DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/0/bus \
fbarbier01/3cx:latest
