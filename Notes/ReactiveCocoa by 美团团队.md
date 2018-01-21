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