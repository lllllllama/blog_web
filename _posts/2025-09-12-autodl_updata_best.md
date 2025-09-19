---
layout: post
title: AutoDL 大文件上传最快方式
date: 2025-09-12 10:00:00 +0800
categories: [教程]
tags: [AutoDL, 上传, MobaXterm, Google Drive, 网盘]
cover: /assets/img/cover.svg
summary: 快速比较在 AutoDL 实例上上传大文件的几种方法，覆盖 MobaXterm、公网网盘、Google Drive 以及容器内直接上传。
toc: true
---

AutoDL 默认的控制台上传通道较慢，特别是面对数十 GB 的模型或数据集时会拖慢工作节奏。下面整理四种常见方案，并结合实际体验说明适用场景与注意事项。

## 方法一：使用 MobaXterm（最快且免费）

1. 从 MobaXterm 官网下载安装包并完成安装。
2. 打开软件，点击 Session → SSH，填入面板提供的主机、用户名与端口，例如：
   - Remote host：connect.westb.seetacloud.com
   - Specify username：oot
   - Port：35545
3. 首次连接会提示保存会话与主机指纹，分别选择 OK 与 Accept。
4. 在密码输入框中右键选择 Paste 粘贴 AutoDL 后台提供的密码并回车。
5. 成功登录后，在左侧 SFTP 面板中即可拖拽文件上传，实测带宽可达到 10-100 MB/s。

![MobaXterm 主界面](/assets/img/posts/2025-09-12-autodl_updata_best/9c7fb1801a4f40fc906907359c33de45.png)
![新建 SSH 会话](/assets/img/posts/2025-09-12-autodl_updata_best/78ff8c18986549d0a018356c2e628eb1.png)
![会话配置示例](/assets/img/posts/2025-09-12-autodl_updata_best/3a422a506c8441ab8e1abf6016c90bb5.png)

### 优缺点

- 优点：速度快、图形界面易上手、支持断点续传。
- 缺点：需要在本地安装软件，部分公司环境可能限制可执行程序。

## 方法二：使用公网网盘（官方推荐）

以夸克网盘为例，上传速度稳定在 10 MB/s 左右，普通会员单次可上传约 100 GB。完成上传后，在 AutoDL 控制台中使用提供的同步功能即可将文件下载到实例中。

![夸克网盘上传速度示例](/assets/img/posts/2025-09-12-autodl_updata_best/a6bb92a3c0bc4195bd31dd30f523330e.png)
![官方文档指引](/assets/img/posts/2025-09-12-autodl_updata_best/ece24f3b791f44a491ea25bd378cc623.png)

### 优缺点

- 优点：流程简单，官方文档提供详细说明，新手易于上手。
- 缺点：需要先上传再下载，实际到实例的速度约为上传速度的一半；大容量与高速通常需要会员。

## 方法三：使用 Google Drive + gdown

1. 将文件上传至 Google Drive，并获取分享链接。
2. 在 AutoDL 容器终端中安装 gdown（若尚未安装）：

   `ash
   pip install gdown
   `

3. 使用共享链接中的文件 ID 执行 gdown --fuzzy <share-link> 下载即可。

### 优缺点

- 优点：无需额外费用，可编写脚本自动化；全球网络环境下速度较平均。
- 缺点：需要可访问 Google 服务的网络环境，对国内网络可能需要代理。

## 方法四：容器内浏览器直接上传

在 AutoDL Web 终端页面中直接拖拽文件上传，操作最简单，但速度通常在 1-3 MB/s，仅适合体积较小的补丁文件或配置。

![容器内上传界面](/assets/img/posts/2025-09-12-autodl_updata_best/e60370118fa3488c83e5be94ed9e1657.png)

---

### 选择建议

- 追求最快速度：优先使用 MobaXterm。
- 需要图形化且无需安装复杂工具：选择公网网盘方案。
- 希望脚本化自动化：使用 Google Drive + gdown。
- 小体积文件或临时补丁：直接使用容器内上传。

结合自身网络条件和团队协作方式选择合适方案，可显著缩短数据分发时间。