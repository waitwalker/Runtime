&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Objective-C是基于c语言的封装,使C语言具有了面向对象的能力.OC的本质最终还是转换c语言来执行,而这个转换的过程是通过Runtime这个运行时库来完成的.平常我们只需要写面对对象的OC代码,不用太关心一些底层转换原理及过程.但是有些情况.比如需要动态给一个类添加方法,添加成员变量,添加协议,没有实现方法的报错解析定位等,就需要了解这个底层实现来更好的解决实际开发中遇到的问题.<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文也是对之前编译查看的Runtime源码的一个复习过程,主要有以下几步:
### 一.下载源码及相关依赖<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;苹果开源网站:[http://opensource.apple.com/](http://opensource.apple.com/),其为我们提供了Runtime的实现源码objc4,这个objc4有多个版本,版本号越大说明是最新源码.<br>
![苹果开源平台](http://upload-images.jianshu.io/upload_images/1715253-131232ef2da1515f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
#### 1.下载objc4源码
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;首先打开苹果开源网站,可以看到苹果针对不同的设备平台有不同的开源项目已经对应的系统版本,找到对应的平台对应的版本点击下载objc4源码,本文依赖的是objc4-750版本.也可以在[https://opensource.apple.com/tarballs/](https://opensource.apple.com/tarballs/)上面搜索所有开源项目源码的压缩包.<br>
![objc4源码](http://upload-images.jianshu.io/upload_images/1715253-fbed6e632659dcff.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
#### 2.下载objc4相关依赖库
objc4相关依赖库:Libc，dyld，libauto，libclosure，libdispatch，libpthread，xnu.这些依赖库中包含了Runtime源码库中需要的一些文件.
#### 3.解压缩所有下载的压缩包库.

![源码解压后](http://upload-images.jianshu.io/upload_images/1715253-fabaa6bd03263beb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
### 二.编译&错误解决<br>
#### 1.环境:
target platform: **macOS**<br>
macOS: **10.14**<br>
Xcode: **10.1**<br>
#### 2.遇到的错误&解决
**1)error: The i386 architecture is deprecated. You should update your ARCHS build setting to remove the i386 architecture. (in target 'objc')**<br>
解决:找target对应编译设置(Build Settings)->CPU架构(Architecture)->标准(Standard arcgutectures)

![错误1](http://upload-images.jianshu.io/upload_images/1715253-bebc4c3e29d47f8f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**2)在objc-os.h头文件中报'sys/reason.h' file not found错误**

解决:工程目录下创建include/sys目录,在编译设置(Build Settings里面搜索,Header Search Paths,然后将include索引添加进去),然后在之前下载的依赖包中搜索reason.h头文件,复制到include/sys目录下

![错误2](http://upload-images.jianshu.io/upload_images/1715253-149cea545b66f79a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
**3)在objc-os.h头文件中报'mach-o/dyld_priv.h' file not found错误**
解决:同上一步,创建include/mach-o目录,复制dyld_priv.h头文件到相应目录

![错误3](http://upload-images.jianshu.io/upload_images/1715253-7a009d4875664966.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**4)在objc-os.h头文件中报'os/lock_private.h' file not found错误**

解决:这个文件并没有再我们下载的依赖库中,需要去开源官网下载,然后操作同上一步<br>

**5)以下是遇到的类似问题:**

'os/base_private.h' file not found;<br>
'pthread/tsd_private.h' file not found;<br>
'System/machine/cpu_capabilities.h' file not found;<br>
'os/tsd.h' file not found;<br>
'pthread/spinlock_private.h' file not found;<br>
'System/pthread_machdep.h' file not found;<br>
'CrashReporterClient.h' file not found;这个需要在编译设置(Build Settings添加宏变量Build Settings->Preprocessor Macros中加入：LIBC_NO_LIBCRASHREPORTERCLIENT)<br>
'Block_private.h' file not found;<br>
'objc-shared-cache.h' file not found;<br>
'isa.h' file not found;<br>
'_simple.h' file not found;<br>
在objc-errors.mm文件中报:Use of undeclared identifier 'CRGetCrashLogMessage'错误;<br>

![错误5](http://upload-images.jianshu.io/upload_images/1715253-7730fb32289af992.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**6)链接时候错误:**

ld: can't open order file: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.14.sdk/AppleInternal/OrderFiles/libobjc.order
clang: error: linker command failed with exit code 1 (use -v to see invocation)

解决:将Build Settings->Linking->Order File改为工程根目录下的libobjc.order，即：$(SRCROOT)/libobjc.order。

![错误6](http://upload-images.jianshu.io/upload_images/1715253-81be9877600720d1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**7)编译脚本错误**
xcodebuild: error: SDK "macosx.internal" cannot be located.
xcrun: error: unable to find utility "clang++", not a developer tool or in PATH

解决:把Target-objc的Build Phases->Run Script(markgc)里的内容macosx.internal改为macosx，这里猜测macosx.internal为苹果内部的macosx

![错误7](http://upload-images.jianshu.io/upload_images/1715253-fe07a0f8d034da6b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**8)error: no such public header file: '/tmp/objc.dst/usr/include/objc/ObjectiveC.apinotes'错误**

解决:把Text-Based InstallAPI Verification Model里的值改为Errors Only

![错误8](http://upload-images.jianshu.io/upload_images/1715253-0bd60bd7502eb574.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 3.编译成功
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;解决以上错误后,再次编译应该基本Succeeded.

![编译成功](http://upload-images.jianshu.io/upload_images/1715253-d6481492106e77dd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 三.调试
#### 1.创建调试target
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文编译针对的是macOS平台,可以创建一个macOS app或者一个 Command Line Tool 来调试.这里我们就创建一个Command Line Tool target:

![debug target](http://upload-images.jianshu.io/upload_images/1715253-5b9356137395b41e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 2.编写代码调试
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;新创建一个class,命名为newClass,打印出class name.可以查看调用栈,确实调用的是我们编译后的Runtime库:
```
#import <Foundation/Foundation.h>
#import <objc/message.h>
#import <objc/runtime.h>

int main(int argc, const char * argv[]) {
@autoreleasepool {

Class newClass = objc_allocateClassPair(objc_getClass("NSObject"), "newClass", 0);
objc_registerClassPair(newClass);
id newObject = [[newClass alloc]init];
NSLog(@"%s",class_getName([newObject class]));
NSLog(@"Hello, World!");
}
return 0;
}
```

![debug_1](http://upload-images.jianshu.io/upload_images/1715253-ff32f2b6e67bfb93.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![debug_2](http://upload-images.jianshu.io/upload_images/1715253-41cd2b1e03f16de5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
### 四.编译后源码库
**编译后的源码放在[Github](https://github.com/waitwalker/Runtime), 如果对你有帮助,请给一个star吧!**

### 五.博客地址&相关文章
**博客地址:** https://waitwalker.github.io/

系列文章:

[1. Runtime源码编译](https://waitwalker.github.io/2019/04/08/Runtime%E6%BA%90%E7%A0%81%E7%BC%96%E8%AF%91/)

[2. objc_object解读](https://waitwalker.github.io/2019/04/10/objc-object%E8%A7%A3%E8%AF%BB/)

[3. Method解读](https://waitwalker.github.io/2019/04/12/Method%E8%A7%A3%E8%AF%BB/)

[4. Class解读](https://waitwalker.github.io/2019/04/15/Class%E8%A7%A3%E8%AF%BB/)

[5. Ivar objc_property_t Protocol解读](https://waitwalker.github.io/2019/04/15/Ivar-objc-property-t-Protocol%E8%A7%A3%E8%AF%BB/)

[6. Block解读](https://waitwalker.github.io/2019/04/18/Block解读/)

### 六.参考文献
[https://pewpewthespells.com/blog/buildsettings.html](https://pewpewthespells.com/blog/buildsettings.html)<br>
[https://blog.csdn.net/wotors/article/details/52489464](https://blog.csdn.net/wotors/article/details/52489464)


