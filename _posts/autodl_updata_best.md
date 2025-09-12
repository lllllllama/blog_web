#  AutoDl-较大文件上传最快方法

##  方法一.使用MobaXterm（最快，同时免费）上传速度（20mb/s - 100mb/s）
#### 直接使用**MobaXterm**(官网：https://mobaxterm.mobatek.net/)
#### 直接点击下载




![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/9c7fb1801a4f40fc906907359c33de45.png)
#### 然后打开，选择Session
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/78ff8c18986549d0a018356c2e628eb1.png)
#### 选ssh
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/3dcde5fd774a48f5a9c782d2b6759527.png)
#### 然后进入autodl，打开你租用的实例（建议上传时用无卡），然后复制ssh
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/caf50e4ac1ab42fa9bf90663b6e971bc.png)
#### 随便找个地方粘贴一下，比如我这个，ssh -p 35545 root@connect.westb.seetacloud.com
Remote host 就是 connect.westb.seetacloud.com
Specify username 就是 root
Port 就是 35545
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/3a422a506c8441ab8e1abf6016c90bb5.png)
#### 然后点ok，再点accept，进入输入密码页面
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/a3bcb07c65614bdc87c6cd49808e3507.png)

#### 从这复制，然后到密码页面粘贴即可
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/4ac452aa0cc3467a952124d417c0212f.png)
#### 注意，直接ctrl + v可能用不了，要一直长按ctrl的同时点鼠标右键然后选paste，然后回车即可。![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/6f0e7f0b5a8e460cbe54b30bccfbfb47.png)
#### 然后选yes![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/562feb05cbd3483c9c491be024e20344.png)
#### 出现这个页面选Cancel
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/1d08793803c3418cba68348440a07be4.png)
#### 然后进去到对应目录，选上传即可
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/5bf8a474b8564c3faa15d772434a254a.png)
##  方法二.使用公网网盘（官网推荐，不免费，方便管理）
###  速度（上传之后还需要下载，实际到实例里面的速度只有一半左右）
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/a6bb92a3c0bc4195bd31dd30f523330e.png)
#### 夸克网盘笔者实测上传大概10mb/s，普通会员最多一次上传100g的

#### 详细方法见AutoDl帮助文档
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/ece24f3b791f44a491ea25bd378cc623.png)


##  方法三.使用Google drive(笔者推荐)
在google drive上面上传文件，然后在容器终端用gdown 下载就行，速度还行，不需要花冤枉钱去买网盘。

##  方法四.直接在容器内上传（比较慢但方便，适合小文件）
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/e60370118fa3488c83e5be94ed9e1657.png)




