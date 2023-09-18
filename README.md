# ztncui-aio
ztncui的Docker镜像, 使Planet节点和Leaf节点共存

## 下载
```
git clone --depth=1 https://github.com/honmaple/ztncui-aio
cd ztncui-aio
```

## 编译
```
git submodule update --init
docker build -t ztncui .
```

## 使用

先部署zerotier的客户端(部署过的可以忽略)
```
docker run -d --name zerotier --restart always --net=host --cap-add NET_ADMIN --device /dev/net/tun -v `pwd`/zerotier:/var/lib/zerotier-one zerotier/zerotier:latest
```

然后部署UI
```
docker run -d --name ztncui --restart always \
           -e MYADDR={服务器IP}
           -e HTTP_PORT={监听端口}
           -e HTTP_ALL_INTERFACES=true
           -e ZT_ADDR={zerotier地址, 比如服务器IP:9993或者Docker网关:9993}
           -e ZT_TOKEN={可以为空，但需要挂载zerotier-one的配置路径}
           -v `pwd`/zerotier:/var/lib/zerotier-one -v `pwd`/ztncui:/opt/ztncui/etc
```

## 私有Planet
上述部署使用的仍然是官方的Planet，需要改为私有Planet的步骤:
```
docker cp ztncui:/opt/ztncui/script/mkmoonworld-x86_64 zerotier:/tmp
docker cp ztncui:/opt/ztncui/script/patch.sh zerotier:/tmp
docker exec -it zerotier bash /tmp/patch.sh
docker restart zerotier
```

