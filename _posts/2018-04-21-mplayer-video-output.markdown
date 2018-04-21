在Linux下，包括mplayer在内的大多数视频播放器都支持诸如X11、vx和SVGA等多种视频输出选项，可这些输出选项究竟是什么意思，它们之间又有什么区别呢？

在 选择视频输出选项时，理想的情况是能够将视频显示的工作由CPU交给显卡，而CPU则纯粹处理解码工作。另外，许多由硬件驱动的视频输出选项允许你将视频 图象放大到较大的尺寸甚至全屏，相反，没有硬件驱动的视频输出选项通常很难对视频图象进行缩放等操作，例外的情况是你拥有一块高速的CPU来处理这些操 作。

xv选项

xv表示XVideo，xv视频输出选项是我们可能碰到的最主要的硬件加速类型，许多媒体播 放器也将它设为默认的视频输出选项。xv使用X的XVideo扩展来作为硬件加速，因此它需要较新的XFree86，同时也需要相关的显卡驱动支持。我们 一般可以使用xvinfo指令来查看你的显卡是否支持xv输出：

 $ xvinfo

 X-Video Extension version 2.2         screen #0 
 Adaptor #0: "Intel(R) 830M/845G/852GM/855GM/865G Video Overlay" 
 number of ports: 1 
 port base: 56 
 operations supported: PutImage 
  … 

如果你无法看到类似的大量的输出信息，则意味着系统当前不支持xv选项，必须配置X下的XVideo选项或下载特定的显卡驱动。

xv模式不仅提供视频的硬件加速，还提供视频的缩放(scaling)、视频亮度(brightness)及对比度(contrast)的调整，因此，你在调整视频显示时并不会给CPU提供额外的负担。

 $ mplayer -vo xv filename 

X11选项

输 出到X11的视频选项不提供任何硬件的加速。所有视频输出的显示(display)和比例(scaling)等都是由软件完成。理论上说，你应当在所有其 它选项都无效的情况下选择这一选项，因为输出到X11是最慢也是最耗费CPU时间的，另外，也要避免调整视频比例的大小，取而代之应该调整X的分辨率到较 低的一个状态。

 $ mplayer -vo x11 filename

SDL选项

SDL 表示Simple Directmedia Layer，简单的直接媒体层。这个SDL提供了一个统一的视频和音频接口，一般的电脑游戏经常辉调用这个接口，因为这个接口使得程序在不知道视频设备的 情况下，通过这个接口来访问底层的视频设备。一个程序可以将视频输出到SDL，然后由SDL负责将这些视频输出交送到它所知道的视频设备驱动。不过SDL 的一个不足的地方是它采用的是软件处理，因此建议在选择这一视频输出之前优先尝试xv选项。而对于视频播放器来讲，相比较其它视频输出选项，SDL可以提 供一个更稳定、更正确、更持久的视频输出。因此，当其它视频输出选项出现问题时，不妨尝试一下SDL。

 $ mplayer -vo sdl filename

DGA选项

DGA 表示Direct Graphics Access，直接图形访问。它允许程序跳过X服务器直接写入framebuffer内存区。DGA选项使得程序不会占用很多的CPU时间，也可以输出全 屏的视频画面，但不足的是，它却只能输出全屏的视频画面。另外，尽管DGA占用的CPU时间不多，但它却并不是硬件驱动模式。一般情况下，可以在选择 X11模式前优先选择这一模式，因为它能够提供全屏输出，而X11无法完成这一任务。

在使用这一模式前，必须在你的X服务器中激活DGA扩展，同时，你必须具备root权限。

 $ grep DGA /var/log/Xorg.0.log

 (II) Loading extension XFree86-DGA

以上的输出表示DGA扩展已经存在。

 $ mplayer -vo dga filename

SVGA选项

这 个选项使得媒体播放器可以在一个命令行控制台来播放视频，完全不需要X的支持。使用这一视频输出选项的前提是系统已经安装了svgalib相关的库。尽管 它采用的同样是软件处理，但却给一些老旧的显示设备或者一些不支持framebuffer的显卡提供了一个额外的输出选项。同样，它要求用户具备root 权限。

 $ mplayer -vo svga filename

Framebuffer选项

这一选项和SVGA选项十分类似，它同样允许用户在一个命令行控制台来播放视频，同样和SVGA相类似的是，它支持绝大多数的显卡，因此你几乎不必考虑硬件支持的问题，当然，前提是你的内核必须支持framebuffer(fbdev)。

 $ mplayer -vo framebuffer filename

VESA选项

这 一选项和SVGA以及Framebuffer相类似，同样允许用户在脱离X的情况下在命令行终端来播放视频。VESA相较于Framebuffer的一个 优点是，它并不要求你在内核中激活某些图形相关的支持选项，你需要的只是一个兼容VESA的BIOS。和其它输出到命令行控制台的选项相类似，VESA采 用的是软件处理，而且要求用户具有root 权限。

 $ mplayer -vo vesa filename

除了以上这些主要的视频输出选项之外，mplayer还支持另外很多其它选项，可以有以下指令查看：

 $ mplayer -vo help

一般而言，输出到命令行控制台的这些选项并不常用。而当你查看mplayer的默认配置文件时，你可以看vo的排列顺序为：

 vo = xv,sdl,x11

回顾以上的选项介绍，这一排列还有很有道理的。
