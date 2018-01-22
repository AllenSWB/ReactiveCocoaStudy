# ReactiveCocoa by [美团团队](https://tech.meituan.com/tag/ReactiveCocoa)

####[ReactiveCocoa核心元素与信号流](https://tech.meituan.com/ReactiveCocoaSignalFlow.html)

####[ReactiveCocoa中潜在的内存泄漏及解决方案](https://tech.meituan.com/potential-memory-leak-in-reactivecocoa.html)

####[RACSignal的Subscription深入分析](https://tech.meituan.com/RACSignalSubscription.html)

####cold hot

- [细说ReactiveCocoa的冷信号与热信号（一）](https://tech.meituan.com/talk-about-reactivecocoas-cold-signal-and-hot-signal-part-1.html)
    
- [细说ReactiveCocoa的冷信号与热信号（二）](https://tech.meituan.com/talk-about-reactivecocoas-cold-signal-and-hot-signal-part-2.html)

- [细说ReactiveCocoa的冷信号与热信号（三）](https://tech.meituan.com/talk-about-reactivecocoas-cold-signal-and-hot-signal-part-3.html)


热信号是主动的，即使你没有订阅事件，它仍然会时刻推送。如第二个例子，信号在50秒被创建，51秒的时候1这个值就推送出来了，但是当时还没有订阅者。而冷信号是被动的，只有当你订阅的时候，它才会发送消息。如第一个例子。
热信号可以有多个订阅者，是一对多，信号可以与订阅者共享信息。如第二个例子，订阅者1和订阅者2是共享的，他们都能在同一时间接收到3这个值。而冷信号只能一对一，当有不同的订阅者，消息会从新完整发送。如第一个例子，我们可以观察到两个订阅者没有联系，都是基于各自的订阅时间开始接收消息的。

纯函数：

副作用：

---

使用RACSubject，如果进行了map操作，那么一定要发送完成信号，不然会内存泄漏。

讲道理，RACSignal和RACSubject虽然都是信号，但是它们有一个本质的区别：
RACSubject会持有订阅者（因为RACSubject是热信号，为了保证未来有事件发送的时候，订阅者可以收到信息，所以需要对订阅者保持状态，做法就是持有订阅者），而RACSignal不会持有订阅者。

对一个信号进行了map操作，那么最终会调用到bind。
如果源信号是RACSubject，由于RACSubject会持有订阅者，所以产生了循环引用(内存泄漏)；
如果源信号是RACSignal，由于RACSignal不会持有订阅者，那么也就不存在循环引用。

其实在ReactiveCocoa的实现中，几乎所有的操作底层都会调用到bind这样一个方法，包括但不限于：
map、filter、merge、combineLatest、flattenMap ……

所以在使用ReactiveCocoa的时候也一定要仔细，对信号操作完成之后，记得发送完成信号，不然可能在不经意间就导致了内存泄漏。


---