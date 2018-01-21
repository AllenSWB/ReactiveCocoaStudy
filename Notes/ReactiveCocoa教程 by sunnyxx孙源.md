# ReactiveCocoa Tutorial

####[宏](http://blog.sunnyxx.com/2014/03/06/rac_1_macros/)

1. RAC(TARGET, KEYPATH, NILVALUE)

RAC(TARGET, KEYPATH)    //和👆一样，NILVALUE 默认 nil

作用：
将一个对象的一个属性和一个signal绑定。signal每产生一个value。都会执行[Obj setValue:forKeyPath:]   //RAC可以绑定基本值
使用：
RAC(Obj, keyPath) = RACSignal 

2. RACObserve(TARGET, KEYPATH)

作用：
观察Target的keypath属性，相当于KVO，产生一个'signal'
使用：
RAC(nameLabel, text) = RACObserve(user, name) 

3. weakify(...) & strongify(...)

作用：
管理block中对self的引用
使用：
成对出现，先weakify后strongify，前面加@


####[百变RACStream](http://blog.sunnyxx.com/2014/03/06/rac_2_racstream/)

1. 函数式编程Functional Programming ([FP](https://baike.baidu.com/item/fp/10082701?fr=aladdin))
    
理解：输入一个值A，调用一个高阶函数，返回一个结果B。过程是，A作为一个入参调用func1，func1(A)作为一个入参调用func2，func2((func1(A)))得到一个结果B。

A -> func1 - func2 -> B 嵌套组成一个序列，形成一个流Stream

ps: 高阶函数func3 = func1 + func2

一个高阶函数必须满足两个条件
a. 一个或者多个函数作为输入。
b. 有且仅有一个函数输出。

2. RACStream

        + (__kindof RACStream<ValueType> *)empty;
        + (__kindof RACStream<ValueType> *)return:(nullable ValueType)value;
        typedef RACStream * _Nullable (^RACStreamBindBlock)(ValueType _Nullable value, BOOL *stop);
        + (__kindof RACStream *)bind:(RACStreamBindBlock (^)(void))block;
        + (__kindof RACStream *)concat:(RACStream *)stream;
        + (__kindof RACStream *)zipWith:(RACStream *)stream;


empty 不返回值，立刻结束completed。理解成RAC里的nil

return 直接返回给定值，然后立刻结束

bind 是RACStream监测’value‘和控制’state‘的基本方法

concat 和 zipWith是将两个RACStream连接起来的基本方法

        [A concat:B] //A存在的时候，A发送value，B不能。A completed后，轮到B发送value 
        [A zipWith:B]   //A和B都产生value才会输出RACTuple，只有一个产生value，它会挂起等待另个。某一个completed后，就解散。


####[RACSignal的巧克力工厂](http://blog.sunnyxx.com/2014/03/06/rac_3_racsignal/)

1. RACSignal 和 RACSequence
    
RACSignal 是 'push-driven'。主动模式，产生value就告诉subscriber
RACSequence 是 'pull-driven'。被动模式。

2. Status - Cold & Hot

一个RACSignal没有subscriber处于cold。有人subscribe后变成hot

3. Event

RACSignal能且只能产生三种事件: next completed error

next: 成功产生一个value
completed: signal结束标志，不带值
error: 出错，理解结束。优先级比较高，一串signals，其中一个signal出现error了，整个都挂了

4. Side Effects

multicast ???

5. RACScheduler 是RAC对线程的简单封装，事件可以在指定的scheduler上分发和执行。不特殊指定，事件的分发和执行都在一个默认的后台线程里做。

subscriber执行时的block一定是非并发执行。

####[只取所需的Filters](http://blog.sunnyxx.com/2014/04/19/rac_4_filters/)

    map 将原值转换成我们想要的值
    filter 只取满足条件的部分值
    combine 将多个值组合成一个值
    
filter分两类：next值过滤类型、起止点值过滤类型

1. next值过滤类型

        filter: 
        flattenMap: //将原来的signal经过过滤转换成只返回过滤值得signal
        ignore: //忽略给定的值
        ignoreValues    //忽略所有值，只关心signal结束，只取completion和error两个消息。这个操作出现在signal有终止条件的情况下
        distinctUntilChanged    //将这次的值和上次的值比较，当相同时被忽略掉

2. 起止点值过滤类型

    主动提前选择开始和结束条件，分两种类型take型(取)、skip型(跳)
    
        take:(NSUinteger)n //从开始取n次的值，后面的值忽略
        takeLast:(NSUInteger)   //一开始不知道signal有多少个next值，RAC将所有next值存起来，原signal在completed、error时候将n个依次发送给接受者
        takeUntil:(RACSignal *) //这个signal一直到..时才停止
        takeUntilBlock:(BOOL(^)(id x)) //
        takeWhileBlock:(BOOL(^)(id x)   //
        skip: //跳过n次的next值
        skipUntilBlock: //
        skipWhileBlock: //


