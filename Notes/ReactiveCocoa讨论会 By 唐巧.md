# 摘抄

####通常使用 RAC 的规范是什么

大家可以参考这样的一条规范来做，首先通过 RACSignal#return RACSignal#createSignal 这类的创建一个 OOP 世界到 FRP 世界的一个转换，从而得到一个 Signal。

之后 signal 在不接触 OOP 的情况下进行数据的各类变换，注意 FP 的引用透明和变量不可变特性。

最后用 RAC 宏、RACSignal#subscribe、NSObject+liftSelect 这些操作把 FRP 的世界带回到 OOP 的世界里。

####几个适用的场景

一、UI 操作，连续的动作与动画部分，例如某些控件跟随滚动。

二、网络库，因为数据是在一定时间后才返回回来，不是立刻就返回的。

三、刷新的业务逻辑，当触发点是多种的时候，业务往往会变得很复杂，用 delegate、notification、observe 混用，难以统一。这时用 RAC 可以保证上层的高度一致性，从而简化逻辑上分层。

只要有通知的业务逻辑，RAC 都方便有效化解。

雷纯锋：概括的说，应该就是统一所有异步事件吧。

不适用的场景，与时间无关的，需要积极求解的计算，例如视图的单次渲染。

####调试技巧和经验分享

RAC 源码下有 instruments 的两个插件，方便大家使用。

signalEvents 这个可以看到流动的信号的发出情况，对于时序的问题可以比较好的解决。

diposable 可以检查信号的 disposable 是否正常

调试的话，如果是性能调试，主要是经验 + Instruments，经验类似于：少用 RACCommand、RACSequence 这样的，Instruments 可以用它的 Time Profile 来看。

如果是 Bug 调试，主要还是靠 Log，配合一些 Xcode 插件，比如 MCLog(可以很方便地过滤日志)，如果要还原堆栈的话，就加一个断点。

####RACSequence 的性能问题

臧成威：是的，Sequence 的性能很差。

臧成威：由于 OC 没有引用透明和尾递归优化。

雷纯锋：它主要是用来实现懒计算吧。

#### MVC 中 Controller 的臃肿问题何解？

Controller 里面就只应该存放这些不能复用的代码，这些代码包括：

在初始化时，构造相应的 View 和 Model。
监听 Model 层的事件，将 Model 层的数据传递到 View 层。
监听 View 层的事件，并且将 View 层的事件转发到 Model 层。

####如何对 ViewController 瘦身？

[ 《Lighter View Controllers》](https://www.objc.io/issues/1-view-controllers/lighter-view-controllers/)

+ 将 UITableView 的 Data Source 分离到另外一个类中。
+ 将数据获取和转换的逻辑分别到另外一个类中。
+ 将拼装控件的逻辑，分离到另外一个类中。

####ReactiveCocoa

+ 函数式编程（Functional Programming），函数也变成一等公民了，可以拥有和对象同样的功能，例如当成参数传递，当作返回值等。看看 Swift 语言带来的众多函数式编程的特性，就你知道这多 Cool 了。
+ 响应式编程（React Programming），原来我们基于事件（Event）的处理方式都弱了，现在是基于输入（在 ReactiveCocoa 里叫 Signal）的处理方式。输入还可以通过函数式编程进行各种 Combine 或 Filter，尽显各种灵活的处理。
+ 无状态（Stateless），状态是函数的魔鬼，无状态使得函数能更好地测试。
+ 不可修改（Immutable），数据都是不可修改的，使得软件逻辑简单，也可以更好地测试。


