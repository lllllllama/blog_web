---
layout: post
title: AutoDL 大文件上传最快方式
date: 2025-09-12 10:00:00 +0800
categories: [教程]
tags: [AutoDL, 上传, MobaXterm, Google Drive, 网盘]
cover: /assets/img/cover.svg
summary: 比较几种在 AutoDL 实例上上传大文件的方案，涵盖 MobaXterm、公网网盘、Google Drive 以及终端直接上传。
toc: true
---

AutoDL 控制台自带的浏览器上传通道在面对数十 GB 的模型或数据集时往往很慢。这里整理四种常用做法，结合实际体验说明适用场景、速度表现和注意事项。

## 方法一：使用 MobaXterm（速度最快）

1. 访问 [MobaXterm 官网](https://mobaxterm.mobatek.net/) 下载并安装。  
2. 打开软件，点击 `Session` → `SSH`，填入 AutoDL 面板提供的连接参数：  
   - Remote host：`connect.westb.seetacloud.com`  
   - Specify username：`root`  
   - Port：`35545`
3. 首次连接会提示是否保存会话与主机指纹，分别选择 `OK` 和 `Accept`。  
4. 在密码输入框中右键选择 *Paste* 粘贴 AutoDL 提供的密码并回车。  
5. 登陆成功后，在左侧 SFTP 面板中即可拖拽文件上传，实测带宽可达 **10–100 MB/s**。

![MobaXterm 主界面](/assets/img/posts/2025-09-12-autodl_updata_best/9c7fb1801a4f40fc906907359c33de45.png)
![新建 SSH 会话](/assets/img/posts/2025-09-12-autodl_updata_best/78ff8c18986549d0a018356c2e628eb1.png)
![会话配置示例](/assets/img/posts/2025-09-12-autodl_updata_best/3a422a506c8441ab8e1abf6016c90bb5.png)

**优缺点**  
- 优点：速度快、图形界面易上手、支持断点续传。  
- 缺点：需在本地安装软件，部分企业电脑可能限制第三方可执行程序。

## 方法二：使用公网网盘（官方推荐方案）

以夸克网盘为例，上传速度稳定在 10 MB/s 左右，普通会员单次可上传约 100 GB。完成上传后，在 AutoDL 后台选择网盘同步功能即可把文件下载到实例中。

![夸克网盘上传速度](/assets/img/posts/2025-09-12-autodl_updata_best/a6bb92a3c0bc4195bd31dd30f523330e.png)
![官方文档指引](/assets/img/posts/2025-09-12-autodl_updata_best/ece24f3b791f44a491ea25bd378cc623.png)

**优缺点**  
- 优点：流程简单，官方文档有完整说明，新手友好。  
- 缺点：上传完成后还需再次下载，实际到实例的速度约等于上传速度的一半；大容量与高速通常需要会员。

## 方法三：Google Drive + gdown

1. 将文件上传至 Google Drive，并获取分享链接。  
2. 在 AutoDL 容器里安装 `gdown`（仅首次需要）：

   ```bash
   pip install gdown
   ```

3. 使用分享链接中的文件 ID 执行：

   ```bash
   gdown --fuzzy <share-link>
   ```

**优缺点**  
- 优点：可脚本化自动化，跨平台体验稳定。  
- 缺点：需要能够访问 Google 服务的网络环境，国内直接使用可能需要代理。

## 方法四：容器 Web 终端直接上传

在 AutoDL Web 终端页面中直接拖拽文件上传，无需安装额外工具，操作最简单。但速度通常只有 1–3 MB/s，仅适合补丁脚本或小体积资源。

![容器内上传界面](/assets/img/posts/2025-09-12-autodl_updata_best/e60370118fa3488c83e5be94ed9e1657.png)

---

### 选择建议

- 希望获得最高速度：推荐 **MobaXterm**。  
- 想要可视化流程且无需安装复杂工具：选择 **公网网盘**。  
- 需要脚本自动化：使用 **Google Drive + gdown**。  
- 仅处理小文件或临时补丁：直接用 **容器 Web 终端**。

根据自己的网络环境与协作需求选择合适方案，可以显著缩短数据分发时间。