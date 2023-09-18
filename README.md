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
或者使用编译好的镜像 **honmaple/ztncui:latest**

## 使用

先部署zerotier的客户端(部署过的可以忽略)
```
docker run -d --name zerotier --restart always --net=host --cap-add NET_ADMIN --device /dev/net/tun -v `pwd`/zerotier:/var/lib/zerotier-one zerotier/zerotier:latest
```

然后部署UI
```
docker run -d --name ztncui --restart always \
-e MYADDR={服务器IP} \
-e HTTP_PORT=4000 \
-e HTTP_ALL_INTERFACES=yes \
-e ZT_ADDR={zerotier地址, 比如Docker网关:9993} \
-e ZT_TOKEN={可以为空，但需要挂载zerotier-one的配置路径} \
-v `pwd`/ztncui:/opt/ztncui/etc
-v `pwd`/zerotier:/var/lib/zerotier-one \
-p 4000:4000
```

**ZT_ADDR**: 由于zerotier和UI没有部署在一个容器, 所以需要从UI内部访问宿主机的 **9993** 端口, 这里可以使用UI容器的网关访问, 比如UI容器的IP是 **172.17.0.12**, 则访问 **172.17.0.1**

另外，zerotier默认的API接口只允许 **127.0.0.1** 访问, 所以需要在挂载目录 `xxx/zerotier` 下新建一个 **local.conf**
```
{
    "settings": {
        "allowManagementFrom": ["127.0.0.1/24", "::1", "172.17.0.1/24"]
    }
}
```

并且修改归属的用户和用户组
```
docker exec -it zerotier bash
cd /var/lib/zerotier-one
chown zerotier-one:zerotier-one local.conf
exit
```
然后重启

## 私有Planet
上述部署使用的仍然是官方的Planet，如果需要改为私有Planet:
```
docker cp script/mkmoonworld-x86_64 zerotier:/tmp
docker cp script/patch.sh zerotier:/tmp
docker exec -it zerotier bash /tmp/patch.sh {服务器IP}
docker restart zerotier
```

然后把 zerotier 目录下的 **planet** 下载下来，并替换到各个客户端

