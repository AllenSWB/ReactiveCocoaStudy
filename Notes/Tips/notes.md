#学习ReactiveCocoa一周总结

###FRP

####FP 

    >纯函数就是返回值只由输入值决定、而且没有可见副作用的函数或者表达式。这和数学中的函数是一样的，比如：
        f(x) = 5x + 1
    这个函数在调用的过程中除了返回值以外的没有任何对外界的影响，除了入参x以外也不受任何其他外界因素的影响。   
    (https://tech.meituan.com/talk-about-reactivecocoas-cold-signal-and-hot-signal-part-2.html)

    ////////////////////////////////

    高阶函数需要满足下面两个条件:
        
    一个或者多个函数作为输入。
    有且仅有一个函数输出。      


###MVVM

    MVVM的架构模式。

    Model层是少不了的了，我们得有东西充当DTO(数据传输对象)，当然，用字典也是可以的，编程么，要灵活一些。Model层是比较薄的一层，如果学过Java的小伙伴的话，对JavaBean应该不陌生吧。
    ViewModel层，就是View和Model层的粘合剂，他是一个放置用户输入验证逻辑，视图显示逻辑，发起网络请求和其他各种各样的代码的极好的地方。说白了，就是把原来ViewController层的业务逻辑和页面逻辑等剥离出来放到ViewModel层。
    View层，就是ViewController层，他的任务就是从ViewModel层获取数据，然后显示。


###ReactiveCocoa整体架构

> (http://www.cocoachina.com/ios/20160106/14880.html)

+ 信号源: RACStream 及其子类
+ 订阅者：RACSubscriber 的实现类及其子类；
+ 调度器：RACScheduler 及其子类；
+ 清洁工：RACDisposable 及其子类。

###知识点

####RACStream

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


####pull-driven & push-driven

#####RACSignal 是 push-driven 的，主动类型。

一个signal产生了新值，只要这时候它有subscriber，就会将值发送出去

#####RACSequence 是 pull-driven 的，被动类型

    eg : todo: 


####Event

RACSignal能且只能产生三种事件: next completed error

next: 成功产生一个value
completed: signal结束标志，不带值
error: 出错，理解结束。优先级比较高，一串signals，其中一个signal出现error了，整个都挂了

####冷信号、热信号 cold state / hot state

> 美团三连

- [细说ReactiveCocoa的冷信号与热信号（一）](https://tech.meituan.com/talk-about-reactivecocoas-cold-signal-and-hot-signal-part-1.html)
    
- [细说ReactiveCocoa的冷信号与热信号（二）](https://tech.meituan.com/talk-about-reactivecocoas-cold-signal-and-hot-signal-part-2.html)

- [细说ReactiveCocoa的冷信号与热信号（三）](https://tech.meituan.com/talk-about-reactivecocoas-cold-signal-and-hot-signal-part-3.html)


一个RACSignal没有subscriber处于cold。有人subscribe后变成hot ????

####副作用 Side Effects

multicast ???

RACMulticastConnection 多次订阅一个signal，signal里的block只走一次


#####副作用的表现

一个signal 订阅3次，每次block都会走，这种情况可能是我们想要的，也可能不是。

#####副作用的解决

replay 

####循环引用的坑

RACObserve(TARGET, KEYPATH) 内部调用了self

RACSubject map后 需要sendComplete，因为最后bind

####一些宏的使用

RAC

RACObserve

weakify strongify

RACChannelTo 相互绑定

####RACSignal

empty
return
dynmicSignal

createSignalWithBlock:

####RACSequence

SequeenceSupport 
性能问题

NSArray NSMutableArray

####RACSignal / RACSequence / 二者相互转换

//signal 和 sequence相互转变 https://www.jianshu.com/p/fea4637706f8

####RACSubject

继承自RACSignal


####RACSignal -> hot

####RACCommand

RAC里有三个UIKit的RACCommandSupport分类: UIBarButtonItem、UIButton、UIRefreshControl

以UIButton为例

        @interface UIButton (RACCommandSupport)
        
        // 设置Button的command，按钮点击，走command的block。按钮是否可以点击和command的'canExecute'属性绑定在一块。('canExecute'已废弃，换成了enabled)
        @property (nonatomic, strong) RACCommand *rac_command;
        
        @end
        
         ////////////////////我是分割线///////////////////
        
        @interface RACCommand : NSObject
        
        @property (nonatomic, strong, readonly) RACSignal *enabled;

        //signal of signals , 意思是singal传的值是一个signal_B(创建command时blockSignal中返回的signal),
        //要取blockSignal中signal sendXXX, subscribe 这个 signal_B即可        
        @property (nonatomic, strong, readonly) RACSignal *executionSignals;

        //表示这个signal是否正在excute。 常见case是 网络请求的loading图的展示与隐藏
        @property (nonatomic, strong, readonly) RACSignal *executing;

        //如果blockSignal中的signal sendError 从这个属性读error
        @property (nonatomic, strong, readonly) RACSignal 
        *errors;

        //是否允许多个并发执行 default NO
        @property (atomic, assign) BOOL allowsConcurrentExecution;


        @end

         ////////////////////我是分割线///////////////////
         
         UIButton *btn = [[UIButton alloc] init];
         [self.view addSubview:btn];
         btn.backgroundColor = [UIColor blueColor];
         btn.frame = CGRectMake(0, 400, 100, 100); 
                                          
         btn.enabled = NO;//设置按钮不可点击(1)
         
         //(2)  代码写到这里，按钮是不可点击的
          [[btn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
         NSLog(@"按钮点击了Event");//
    }];
        
        //(3)   给button设置了rac_command，按钮的enabled就和rac_command.enabled绑定了，这时候虽然在(1)出设置btn.enabled = NO，但此时按钮是可以点击的。
         btn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"按钮点击了");//此时按钮
        return [RACSignal empty];
    }];

####RACScheduler

对GCD的一层封装???

是RAC对线程的简单封装，事件可以在指定的scheduler上分发和执行。不特殊指定，事件的分发和执行都在一个默认的后台线程里做。

subscriber执行时的block一定是非并发执行。

####RACDisposable

####RACEvent

####RACMulticastConnection

####Operations

####map

####filter

    
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


---

combineLatest:reduce:

doNext:
doComplete:

####KVO UIEvent Delegate Notification

####Categories

lift

####RACSubscriber

protocol class

####bind概念 

####racsequence的head tail

-------

####RACSignal

热信号在我们生活中有很多的例子，比如订阅杂志时并不会把之前所有的期刊都送到我们手中，只会接收到订阅之后的期刊；而对于冷信号的话，举一个不恰当的例子，每一年的高考考生在『订阅』高考之后，收到往年所有的试卷，并在高考之后会取消订阅。

####RACSequence


####RACSubject  
在大多数情况下，我们也只会使用 RACSubject 自己或者 RACReplaySubject。

RACSubject 在 RACSignal 对象之上进行了简单的修改，将原有的冷信号改造成了热信号，将不可变变成了可变。

虽然 RACSubject 的实现并不复杂，只是存储了一个遵循 RACSubscriber 协议的对象列表以及所有的消息，但是在解决实际问题时却能够很好地解决很多与网络操作相关的问题。

####RACDisposable

    用于取消订阅或者清理资源，当信号发送完成或者发送错误的时候，就会自动触发它。

####RACCommand

    _executionSignals = [[[self.addedExecutionSignalsSubject
        map:^(RACSignal *signal) {
            return [signal catchTo:[RACSignal empty]];
        }]
        deliverOn:RACScheduler.mainThreadScheduler]
        setNameWithFormat:@"%@ -executionSignals", self];
        
它只是将信号中的所有的错误 NSError 转换成了 RACEmptySignal 对象，并派发到主线程上。

RACMulticastConnection

Note that you shouldn't create RACMulticastConnection manually. Instead use -[RACSignal publish] or -[RACSignal multicast:].




    /**
     - subscribeNext:
     1. 创建subscriber
     2.subscribe singal
     
     subscriber的销毁时机是signal sendComplete: 或 sendError:
     */

     // 1.RACCommand有个执行信号源executionSignals，这个是signal of signals(信号的信号),意思是信号发出的数据是信号，不是普通的类型。
    // 2.订阅executionSignals就能拿到RACCommand中返回的信号，然后订阅signalBlock返回的信号，就能获取发出的值。


####Ohter

1. ReactiveCocoa Unknown warning group ‘-Wreceiver-is-weak’,ignored警告 (Xcode 9)

        解决: http://www.cocoachina.com/ios/20170915/20580.html

         #define RACObserve(TARGET, KEYPATH) \
                ({ \
                    __weak id target_ = (TARGET); \
                    [target_ rac_valuesForKeyPath:@keypath(TARGET, KEYPATH) observer:self]; \
                })


------

publish / replay / multicast

-replay 方法和 -publish 差不多，只是内部封装的热信号不同，并在方法调用时就连接原信号：


###常用场景

RACCommand

RACSubject

----

RACTuple