## LocalSocket，Socket/ Websocket/ Http,P2P等网络编程(步骤)（Demo）

!!! Note

最近在做 Socket 的一些处理，这里统计了很多的 Demo 以及编程步骤和基本原理做一个简单的记录：

## socket 

所谓Socket通常也称作“套接字”，用于描述IP地址和端口，是一个通信链的句柄.Socket有两种主要的操作方式：面向连接（TCP）的和无连接的（UDP，DatagramSocket）。Java.net中提供了两个类Socket和ServerSocket，分别用来表示双向连接的客户端和服务端。
sockets（套接字）编程有三种，流式套接字（SOCK_STREAM），数据报套接字（SOCK_DGRAM），原始套接字（SOCK_RAW）；基于TCP的socket编程是采用的流式套接字。
输入和输出流要用`DataOutputStream`和`DataOutputStream`，不可以用`PrintWriter`、`StreamReader`等。

>  Android跨进程通讯之`LocalSocket`和`LocalServerSocket`，`LocalSocket`与`Socket`

 对于`Linux`系统来说，“一切皆为文件”，`Socket`也不例外

`Socket`按照收发双方的媒介来说有三种类型：

1. 通过网络端口；

2. 通过文件系统；

3. 通过内存映射文件。

   具体说来，三种类型均可以用来作为IPC的Socket：

   1. 通过本地回环接口(即LoopBack)127.0.0.1来收发数据；

   2. 通过文件作为收发数据的中转站；

   3. 在内存中开辟一块区域作为收发数据的中转站，此区域仍然使用文件读写API进行访问。

      `LocalSocket`支持方式2和方式3，从效率的角度来说，显然是方式3效率最高，那么下面我们就使用`LocalSocket`来演示如何实现Java端进程与C端进程之间的IPC。
      `localsocket` 传输大量的数据例如一张图片，`localsocket` 本身的缓冲区大小是有限定的。

      两个办法：

      1. 扩充缓冲区的大小；

      2. 接收端分多次接收然后每一次的都拼装起来。

         `Socket`最初用在基于`TCP/IP`网络间进程通信中，以客户端/服务器模式进行通信。实现异步操作，共享资源集中处理，提高客户端响应能力。
         在 Android API 中，有几个类对`localsocket`进行了封装，不仅可以用来应用程序之间进行IPC通信，还可以跨应用程序层和 Linux 层运行的程序进行通信。local socket，也叫做 Unix Domain Socket。

[Android利用 LocalSocket 实现 Java 端进程与 C 端进程之间的IPC](https://www.cnblogs.com/zealotrouge/p/3152941.html])
[Android进程间通信之LocalSocket通信]( http://www.cnblogs.com/Joanna-Yan/p/4708400.html)

##  P2P

[一个基于局域网的 P2P 聊天应用,P2P Chat](https://github.com/LinYaoTian/P2PChat)

## TCP与UDP的区别？？

TCP（Tranfer Control Protocol）的缩写，是一种面向连接的保证传输的协议，在传输数据流前，双方会先建立一条虚拟的通信道。可以很少差错传输数据。

UDP(User DataGram Protocol)  的缩写，是一种无连接的协议，使用 `UDP` 传输数据时，每个数据段都是一个独立的信息，包括完整的源地址和目的地，在网络上以任何可能的路径传到目的地，因此，能否到达目的地，以及到达目的地的时间和内容的完整性都不能保证。
所以TCP必UDP多了建立连接的时间。相对UDP而言，TCP具有更高的安全性和可靠性。 TCP协议传输的大小不限制，一旦连接被建立，双方可以按照一定的格式传输大量的数据，而UDP是一个不可靠的协议，大小有限制，每次不能超过64K。

一个TCP连接必须要经过三次“对话”才能建立起来，其中的过程非常复杂，我们这里只做简单、形象的介绍，你只要做到能够理解这个过程即可。我们来看看这 三次对话的简单过程:

* 主机A向主机B发出连接请求数据包:“我想给你发数据，可以吗?”，这是第一次对话;

* 主机B向主机A发送同意连接和要求同步(同步就 是两台主机一个在发送，一个在接收，协调工作)的数据包:“可以，你什么时候发?”，这是第二次对话;

* 主机A再发出一个数据包确认主机B的要求同步:“我 现在就发，你接着吧!”，这是第三次对话。

* 三次“对话”的目的是使数据包的发送和接收同步，经过三次“对话”之后，主机A才向主机B正式发送数据

  B面向非连接”就是在正式通信前不必与对方先建立连接，不管对方状态就直接发送。

  现在的手机短信非常相似:

  * 你在发短信的时候，只需要输入对方手机号就OK了。

    UDP适用于一次只传送少量数据、对可靠性要求不高的应用环境。
    我们经常使用“ping”命令来测试两台主机之间TCP/IP通信是否正常，其实“ping”命令的原理就是向对方主机发送UDP数据包，然后对方主机确认收到数据包，如果数据包是否到达的消息及时反馈回来，那么网络就是通的.

## 网络编程

[谈一谈网络编程学习经验（C/C++]( https://cloud.github.com/downloads/chenshuo/documents/LearningNetworkProgramming.pdf)

## Socket DEMO

 Socket的使用类型主要有两种：

1. 流套接字（streamsocket）：基于 TCP协议，采用 流的方式 提供可靠的字节流服务；

2. 数据报套接字(datagramsocket)：基于 UDP协议，采用 数据报文 提供数据打包发送的服务。

   

   [binbinYang---android 手机端写Socket服务端和Socket客户端](http://blog.csdn.net/yangbin0513/article/details/51878951) 
   [Android中Socket通信之TCP与UDP传输原理](http://blog.csdn.net/u010687392/article/details/44649589)
   [android之socket编程实例](http://blog.csdn.net/x605940745/article/details/17001641)
   [Android开发之Socket通信](http://blog.csdn.net/reboot123/article/details/7579952)
   [socket重连和断开 Android；socket TCP断线重连 ，socket双向通信 局域网内socket重连和断开？
   [Android Socket连接（模拟心跳包，断线重连，发送数据等]( https://blog.csdn.net/yuzhiqiang_1993/article/details/78094909)
   [Android-socket服务端断重启后，android客户端自动重连] (https://www.cnblogs.com/yunfang/p/5030030.html)
   [AndroidSocketClient](https://github.com/vilyever/AndroidSocketClient) 

[A socket send and receive agreement framework; Easy use IO]( https://github.com/qiujuer/Blink)

 [socket编程实现UDP数据传输基于DatagramSocket与DatagramPacket API实现.
a simple demo for socket](https://github.com/Carson-Ho/Socket_learning) 
[Socket封装，支持TCP/UDP客户端和服务端，支持自定义粘包处理、验证处理、解析处理](https://github.com/Blankeer/XAndroidSocket) 
[仿茄子快传的一款文件传输应用，涉及到Socket通信，包括TCP，UDP通信]( https://github.com/mayubao/KuaiChuan)

-- [socket 实现了两个真机的简单通信：](https://blog.csdn.net/zhangli_/article/details/53466215)
[客户端代码：](https://git.oschina.net/zhanglihow/SocketClient)
[服务端代码：](https://git.oschina.net/zhanglihow/SocketServer)

[使用Socket处理跨进程的实时聊天](https://github.com/SpikeKing/SocketDemo)
[Socket编程](http://blog.csdn.net/harvic880925/article/category/1402759) 
NAT 心得- http://blog.csdn.net/harvic880925/article/details/8870073
数字电视- http://blog.csdn.net/wutong_login/article/category/483133
P2P中的NAT穿越方案- http://blog.csdn.net/wutong_login/article/category/483134
FTI们在使用的开源库- http://blog.csdn.net/hpu_zyh/article/details/48769703

-- JS socket
JS WebSocketHeartBeat- https://github.com/zimv/WebSocketHeartBeat
幸好有SockJS，在不支持WebSocket的情况下，它会退回到其他的推送技术。 
SockJS推送技术- https://github.com/sockjs/sockjs-client
nodeJS实现的socket服务器端Demo，使用protobuf作为数据格式- https://github.com/bobo892589/socket_server_demo
WebSocket JS- https://github.com/joewalnes/reconnecting-websocket

-- Java Socket
Java Socket网络编程一- http://blog.csdn.net/google_huchun/article/details/62041121
Java Socket网络编程二- http://blog.csdn.net/Google_huchun/article/details/62041238
JAVA Socket 实现 UDP 编程--http://blog.csdn.net/qq_23473123/article/details/51464272
JAVA 通过 Socket 实现 TCP 编程--http://blog.csdn.net/qq_23473123/article/details/51461894
Java Socket实战-http://blog.csdn.net/jdsjlzx/article/category/1081161
Java Scoket编程- http://blog.csdn.net/jia20003/article/category/1270931

-- Socket封装，支持TCP/UDP客户端和服务端，支持自定义粘包处理、验证处理、解析处理- https://github.com/Blankeer/XAndroidSocket
a simple demo for socket- https://github.com/Carson-Ho/Socket_learning

-- C/C++ socket
多进程的tcp服务器C源码-https://github.com/CTTCassie/Linux/tree/master/network/tcp_server1 
多线程的tcp服务器C源码-https://github.com/CTTCassie/Linux/tree/master/network/tcp_server2
socket编程-- 基于TCP协议的网络程序 - http://blog.chinaunix.net/uid-22488454-id-3059636.html

## H5的与原生的WebSocket

 WebSocket的数据在发送时，被组织为依次序的一串数据帧(data frame)，然后进行传送。
传送的帧类型分为两类：数据帧(data frame)和控制帧(Control frame)。数据帧可以携带文本数据或者二进制数据；控制帧包含关闭帧(Close frame)和Ping/Pong帧。
websocket不仅节约了header的问题（websocket的head信息只有短短的2个字节）。更加重要的是是通信的稳定性.
其中最重要的字段为opcode(4bit)和MASK(1bit)：

1. MASK值，从客户端进行发送的帧必须置此位为1，从服务器发送的帧必须置为0。如果任何一方收到的帧不符合此要求，则发送关闭帧(Close frame)关闭连接。
2. opcode的值： 0x1代表此帧为文本数据帧, 0x2代表此帧为二进制数据帧, 0x8为控制帧中的连接关闭帧(close frame), 0x9为控制帧中的Ping帧, 0xA(十进制的10)为控制帧中的Pong帧。
3. Ping/Pong帧： Ping帧和Pong帧用于连接的保活(keepalive)或者诊断对端是否在线。这两种帧的发送和接收不对WEB应用公开接口，由实现WebSocket协议的底层应用(例如浏览器)来实现它。

WebSocket Android 端的使用封装- https://github.com/0xZhangKe/WebSocketDemo
WebSocket与Java- http://blog.csdn.net/ricohzhanglong/article/details/17492799
Bozhidar Bozhanov- https://dzone.com/users/199388/glamdring.html
okhttp websocket断线重连的机制- https://github.com/Rabtman/WsManager
WebSocket & WAMP in Java for Android and Java 8- https://github.com/crossbario/autobahn-java

WebSocket实战-- http://blog.csdn.net/qq_35253454/article/details/52432655
WebSocket安卓客户端实现详解(一)--连接建立与重连- https://blog.csdn.net/zly921112/article/details/72973054
websocket 断线重连- https://my.oschina.net/codingBingo/blog/633985 https://github.com/joewalnes/reconnecting-websocket
Java-WebSocket地址：https://github.com/TooTallNate/Java-WebSocket

WebSocket安卓客户端实现- https://github.com/TakahikoKawasaki/nv-websocket-client
websocket- http://blog.csdn.net/cdnight/article/category/2723311

WebSocket与服务器端进行实时通讯的方式。WebSocket是HTML5中的一部分，但是在Android与服务器交互中使用是正常使用的，而且比socket的更易用- 
[http://download.csdn.NET/detail/xia09222826/9316719](http://download.csdn.net/detail/xia09222826/9316719)
http://zengrong.net/post/2199.htm

采用类似 Chuck 项目（https://github.com/jgilfelt/chuck）的思路，为 OkHttp 添加 interceptor 以收集请求结果，并将其以 UI 形式直观地展示出来。
okhttp websocket断线重连的机制- https://github.com/Rabtman/WsManager

WebSocket & WAMP in Java for Android and Java 8- https://github.com/crossbario/autobahn-java
仿茄子快传的一款文件传输应用，涉及到Socket通信，包括TCP，UDP通信- https://github.com/mayubao/KuaiChuan
Java WebSocket和JavaScript中的websocket的使用，js中websocket的使用这个好理解，就是扮演一个客户端的角色，Java中的WebSocket分两种角色，一种是Java客户端终端的WebSocket（作用类似于javascript中的WebSocket），还有一种角色是Java服务器终端。
websocket使用案例- http://download.csdn.net/download/u012702547/9954347%3E

android-websockets- http://blog.csdn.net/rznice/article/details/20043537  
https://my.oschina.net/oppo4545/blog/199996
https://github.com/codebutler/android-websockets 
http://ninecmd.com/archives/794

## C/C++ socket编程过程

 服务器端编程的步骤：
	1：加载套接字库，创建套接字(WSAStartup()/socket())；
	2：绑定套接字到一个IP地址和一个端口上(bind())；
	3：将套接字设置为监听模式等待连接请求(listen())；
	4：请求到来后，接受连接请求，返回一个新的对应于此次连接的套接字(accept())；
	5：用返回的套接字和客户端进行通信(send()/recv())；
	6：返回，等待另一连接请求；
	7：关闭套接字，关闭加载的套接字库(closesocket()/WSACleanup())。
客户端编程的步骤：
	1：加载套接字库，创建套接字(WSAStartup()/socket())；
	2：向服务器发出连接请求(connect())；
	3：和服务器端进行通信(send()/recv())；
	4：关闭套接字，关闭加载的套接字库(closesocket()/WSACleanup())。

## Android socket编程过程

 创建服务器的步骤：
	1，指定端口实例化一个ServerSocket
	2，调用ServerSocket的accept方法以在等待连接期间造成阻塞
	3，获取位于该底层Socket的流以进行读写操作
	4，将数据封装成流
	5，对Socket进行读写
	6，关闭打开的流
创建客户端的步骤：
	1，通过IP地址和端口实例化Socket，请求连接服务器
	2，获取Socket上的流以进行读写
	3，把流包装进BufferedReader/PrintWriter的实例
	4，对Socket进行读写
	5，关闭打开的流.

## HTML网页源码的获取或图片流的获取

// C++发送HTTP请求获取网页HTML代码- http://blog.csdn.net/leixiaohua1020/article/details/12530683
// Android基础——HTML网页源码的获取- http://blog.sina.com.cn/s/blog_6b04c8eb01013v9n.html

```java
public class FetchHtmlUtils {
    public static void main(String[] args) {
        try {
            String htmlSource = testGetHtml("[http://www.baidu.com](http://www.baidu.com/)");
            System.out.print(htmlSource);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public static byte[] readStream(InputStream inputStream) throws Exception {
        byte[] buffer = new byte[1024];
        int len = -1;
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();

        while ((len = inputStream.read(buffer)) != -1) {
            byteArrayOutputStream.write(buffer, 0, len);
        }
        inputStream.close();
        byteArrayOutputStream.close();
        return byteArrayOutputStream.toByteArray();
    }

    public static String testGetHtml(String urlpath) throws Exception {
        URL url = new URL(urlpath);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setConnectTimeout(6 * 1000);
        conn.setRequestMethod("GET");

        if (conn.getResponseCode() == 200) {
            InputStream inputStream = conn.getInputStream();
            byte[] data = readStream(inputStream);
            String html = new String(data);
            return html;
        }
        return null;
    }
}
```



### Socket服务端（Server）：

```java
package com.socket;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketException;
import java.net.SocketTimeoutException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class SocketServer {
    public static String _pattern = "yyyy-MM-dd HH:mm:ss SSS";
    public static SimpleDateFormat format = new SimpleDateFormat(_pattern);
    // 设置超时间
    public static int _sec = 0;

    public static void main(String[] args) {
        System.out.println("----------Server----------");
        System.out.println(format.format(new Date()));

        ServerSocket server;
        try {
            server = new ServerSocket(8001);
            System.out.println("监听建立 等你上线\n");

            Socket socket = server.accept();
            System.out.println(format.format(new Date()));
            System.out.println("建立了链接\n");

            BufferedReader br = new BufferedReader(new InputStreamReader(socket.getInputStream()));

            socket.setSoTimeout(_sec * 1000);
            System.out.println(format.format(new Date()) + "\n" + _sec + "秒的时间 快写\n");
            System.out.println(format.format(new Date()) + "\nClient:" + br.readLine() + "\n");

            Writer writer = new OutputStreamWriter(socket.getOutputStream());

            System.out.println(format.format(new Date()));
            System.out.println("我在写回复\n");

            writer.write("收到\n");
            Thread.sleep(10000);
            writer.flush();

            System.out.println(format.format(new Date()));
            System.out.println("写完啦 你收下\n\n\n\n\n");
        } catch (SocketTimeoutException e) {
            System.out.println(format.format(new Date()) + "\n" + _sec + "秒没给我数据 我下啦\n\n\n\n\n");
            e.printStackTrace();
        } catch (SocketException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```





###  Socket客户端 (Client)：

```java
package com.socket.v3;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.net.Socket;
import java.net.SocketException;
import java.net.SocketTimeoutException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class SocketClient {
    public static String _pattern = "yyyy-MM-dd HH:mm:ss SSS";
    public static SimpleDateFormat format = new SimpleDateFormat(_pattern);
    // 设置超时间
    public static int _sec = 5;
    public static void main(String[] args) {
        System.out.println("----------Client----------");

        Socket socket = null;
        try {
// 与服务端建立连接
            socket = new Socket("127.0.0.1", 8001);
            socket.setSoTimeout(_sec * 1000);

            System.out.println(format.format(new Date()));
            System.out.println("建立了链接\n");

// 往服务写数据
            Writer writer = new OutputStreamWriter(socket.getOutputStream());

            System.out.println(format.format(new Date()));
            System.out.println("我在写啦\n");
            Thread.sleep(10000);
            writer.write("有没有收到\n");
            System.out.println(format.format(new Date()));
            System.out.println("写完啦 你收下\n");

            writer.flush();
            BufferedReader br = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            System.out.println(format.format(new Date()) + "\n" + _sec + "秒的时间 告诉我你收到了吗\n");
            System.out.println(format.format(new Date()) + "\nServer:" + br.readLine());

        } catch (SocketTimeoutException e) {
            System.out.println(format.format(new Date()) + "\n" + _sec + "秒没收到回复 我下啦\n\n\n\n\n");
            e.printStackTrace();
        } catch (SocketException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

