# 李忠limboy & ReactiveCocoa

####[ReactiveCocoa与Functional Reactive Programming什么是Functional Reactive Programming](http://limboy.me/tech/2013/06/19/frp-reactivecocoa.html)

1. Functional Reactive Programming (FRC)

FRC提供了一种信号机制，通过信号记录值的变化。信号可以被叠加、分割、合并。通过对信号的组合，就不需要去监听某个值或事件。                                                   
2. ReactiveCocoa (RAC)

RAC中信号是'RACSignal'，信号是数据流，可以绑定和传递

> 可以把信号想象成水龙头，只不过里面不是水，而是玻璃球(value)，直径跟水管的内径一样，这样就能保证玻璃球是依次排列，不会出现并排的情况(数据都是线性处理的，不会出现并发情况)。水龙头的开关默认是关的，除非有了接收方(subscriber)，才会打开。这样只要有新的玻璃球进来，就会自动传送给接收方。可以在水龙头上加一个过滤嘴(filter)，不符合的不让通过，也可以加一个改动装置，把球改变成符合自己的需求(map)。也可以把多个水龙头合并成一个新的水龙头(combineLatest:reduce:)，这样只要其中的一个水龙头有玻璃球出来，这个新合并的水龙头就会得到这个球。                                
                                                                                    
3. RAC的大统一

RAC统一了KVO、UI Event、网络请求、异步的处理，因为它们本质上都是值的变化。

- KVO 

        //  KVO
        -observeValueForKeyPath:ofObject:change:context:
        //  RAC
        [RACAble(self.username) subscribeNext:^(NSString *newName) {
             NSLog(@"%@", newName);
        }];

- UI Event

        为系统UI提供了很多category
        
- 网络请求 & 异步

        通过自定义信号, 也就是RACSubject(继承自RACSignal，可以理解为自由度更高的signal)
        
        //比如一个异步网络操作，可以返回一个subject，然后将这个subject绑定到一个subscriber或另一个信号。
        
        - (void)doTest
        {
            RACSubject *subject = [self doRequest];
            
            [subject subscribeNext:^(NSString *value){
                NSLog(@"value:%@", value);
            }];
        }
        
        - (RACSubject *)doRequest
        {
            RACSubject *subject = [RACSubject subject];
        	// 模拟2秒后得到请求内容
        	// 只触发1次
        	// 尽管subscribeNext什么也没做，但如果没有的话map是不会执行的
        	// subscribeNext就是定义了一个接收体
            [[[[RACSignal interval:2] take:1] map:^id(id _){
                // the value is from url request
                NSString *value = @"content fetched from web";
                [subject sendNext:value];
                return nil;
            }] subscribeNext:^(id _){}];
            return subject;
        }

####[说说ReactiveCocoa 2](http://limboy.me/tech/2013/12/27/reactivecocoa-2.html)

1. Signal & Subscriber

> 这是RAC最核心的内容，这里我想用插头和插座来描述，插座是Signal，插头是Subscriber。想象某个遥远的星球，他们的电像某种物质一样被集中存储，且很珍贵。插座负责去获取电，插头负责使用电，而且一个插座可以插任意数量的插头。当一个插座(Signal)没有插头(Subscriber)时什么也不干，也就是处于冷(Cold)的状态，只有插了插头时才会去获取，这个时候就处于热(Hot)的状态。

'RACOberve'使用'KVO'监听属性变化。但不是所有属性都可以被'RACObserve'，该属性必须支持'KVO'。比如'NSURLCache'的'currentDiskUsage'就不能被'RACObserve'。

’Signal‘可以被修改(map)、过滤(filter)、叠加(combine)、串联(chain)

2. 冷信号Cold、热信号Hot

冷信号默认什么也不干。创建一个信号Signal，没有被订阅Subscrible，就是一个冷信号，什么也不会发生，block里不会走。

           RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
       
        NSLog(@"触发信号");
        [subscriber sendNext:@"hahaha"];
        [subscriber sendCompleted];
        
        return nil;
    }];

增加一个订阅，就变成Hot

          [signal subscribeNext:^(id  _Nullable x) {
              NSLog(@"订阅 %@",x);
          }];
          
          //console log
          2018-01-17 11:34:18.756355+0800 ReactiveCocoaDemo[2974:47797] 触发信号
        2018-01-17 11:34:18.756466+0800 ReactiveCocoaDemo[2974:47797] 订阅 hahaha
    
再增加一个订阅
        
        [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"新的订阅者 %@",x);
    }];
        //console log
        2018-01-17 11:44:41.920599+0800 ReactiveCocoaDemo[3146:54809] 触发信号
    2018-01-17 11:44:41.920717+0800 ReactiveCocoaDemo[3146:54809] 订阅 hahaha
    2018-01-17 11:44:41.920837+0800 ReactiveCocoaDemo[3146:54809] 触发信号
    2018-01-17 11:44:41.920929+0800 ReactiveCocoaDemo[3146:54809] 新的订阅者 hahaha
    
    信号的block走了两次，打印了两次"触发信号"。这种情况叫做 Side Effects
    
3. 副作用 Side Effects 
         
如果一个Signal有多个Subscriber，想要signal只触发一次。使用'replay'方法。它的作用是保证signal只触发一次，然后把sendNext的值存起来，下次有新的subcriber，直接发送缓存的数据。

         RACSignal *signal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSLog(@"触发信号");
        [subscriber sendNext:@"hahaha"];
        [subscriber sendCompleted];
        
        return nil;
    }] replay]; //replay方法
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅 %@",x);
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"新的订阅者 %@",x);
    }]; 
    
    //console log
    2018-01-17 11:50:19.512999+0800 ReactiveCocoaDemo[3185:57451] 触发信号
    2018-01-17 11:50:19.513126+0800 ReactiveCocoaDemo[3185:57451] 订阅 hahaha
    2018-01-17 11:50:19.513365+0800 ReactiveCocoaDemo[3185:57451] 新的订阅者 hahaha
    
4. RAC常用的Cocoa Categories

#####UIView Categories

    //UIActionSheet (RACSignalSupport)
    - (RACSignal<NSNumber *> *)rac_buttonClickedSignal;
    
    //UIAlertView (RACSignalSupport)
    - (RACSignal<NSNumber *> *)rac_buttonClickedSignal;
    - (RACSignal<NSNumber *> *)rac_willDismissSignal;
    
    //UIBarButtonItem (RACCommandSupport)
    @property (nonatomic, strong, nullable) RACCommand<__kindof UIBarButtonItem *, id> *rac_command;
    
    //UIButton (RACCommandSupport)
    @property (nonatomic, strong, nullable) RACCommand<__kindof UIButton *, id> *rac_command;
    
    //UICollectionReusableView (RACSignalSupport)
    @property (nonatomic, strong, readonly) RACSignal<RACUnit *> *rac_prepareForReuseSignal;
    
    //UIControl (RACSignalSupport)
    - (RACSignal<__kindof UIControl *> *)rac_signalForControlEvents:(UIControlEvents)controlEvents;
    
    //UIControl (RACSignalSupportPrivate)- (RACChannelTerminal *)rac_channelForControlEvents:(UIControlEvents)controlEvents key:(NSString *)key nilValue:(nullable id)nilValue;

    //UIDatePicker (RACSignalSupport)
    - (RACChannelTerminal<NSDate *> *)rac_newDateChannelWithNilValue:(nullable NSDate *)nilValue;

    //UIGestureRecognizer (RACSignalSupport)
    - (RACSignal<__kindof UIGestureRecognizer *> *)rac_gestureSignal;

    //UIImagePickerController (RACSignalSupport)
    - (RACSignal<NSDictionary *> *)rac_imageSelectedSignal;

    //UIRefreshControl (RACCommandSupport)
    @property (nonatomic, strong, nullable) RACCommand<__kindof UIRefreshControl *, id> *rac_command;
    
    //UISegmentedControl (RACSignalSupport)
    - (RACChannelTerminal<NSNumber *> *)rac_newSelectedSegmentIndexChannelWithNilValue:(nullable NSNumber *)nilValue;

    //UISlider (RACSignalSupport)
    - (RACChannelTerminal<NSNumber *> *)rac_newValueChannelWithNilValue:(nullable NSNumber *)nilValue;

    //UISwitch (RACSignalSupport)
    - (RACChannelTerminal<NSNumber *> *)rac_newOnChannel;
    
    //UITableViewCell (RACSignalSupport)
    @property (nonatomic, strong, readonly) RACSignal<RACUnit *> *rac_prepareForReuseSignal;

    //UITableViewHeaderFooterView (RACSignalSupport)
    @property (nonatomic, strong, readonly) RACSignal<RACUnit *> *rac_prepareForReuseSignal
    
    //UITextField (RACSignalSupport)
    - (RACSignal<NSString *> *)rac_textSignal;
   
    //UITextView (RACSignalSupport)
    - (RACSignal<NSString *> *)rac_textSignal;

#####Data Structure Categories

常用数据结构的Category

    //NSArray<__covariant ObjectType> (RACSequenceAdditions)
    @property (nonatomic, copy, readonly) RACSequence<ObjectType> *rac_sequence;
    
    //NSData (RACSupport)
    + (RACSignal<NSData *> *)rac_readContentsOfURL:(nullable NSURL *)URL options:(NSDataReadingOptions)options scheduler:(RACScheduler *)scheduler;
    
    //NSDictionary<__covariant KeyType, __covariant ObjectType> (RACSequenceAdditions)
    @property (nonatomic, copy, readonly) RACSequence<RACTwoTuple<KeyType, ObjectType> *> *rac_sequence;
    @property (nonatomic, copy, readonly) RACSequence<KeyType> *rac_keySequence;
    @property (nonatomic, copy, readonly) RACSequence<ObjectType> *rac_valueSequence;
    
    //NSEnumerator<ObjectType> (RACSequenceAdditions)
    @property (nonatomic, copy, readonly) RACSequence<ObjectType> *rac_sequence;
    
    //NSIndexSet (RACSequenceAdditions)
    @property (nonatomic, copy, readonly) RACSequence<NSNumber *> *rac_sequence;

    //NSOrderedSet<__covariant ObjectType> (RACSequenceAdditions)
    @property (nonatomic, copy, readonly) RACSequence<ObjectType> *rac_sequence;
    
    // NSSet<__covariant ObjectType> (RACSequenceAdditions)
    @property (nonatomic, copy, readonly) RACSequence<ObjectType> *rac_sequence;
    
    // NSString (RACKeyPathUtilities)
    - (NSArray *)rac_keyPathComponents;
    - (NSString *)rac_keyPathByDeletingLastKeyPathComponent;
    - (NSString *)rac_keyPathByDeletingFirstKeyPathComponent;

    //NSString (RACSequenceAdditions)
    @property (nonatomic, copy, readonly) RACSequence<NSString *> *rac_sequence;
    
    //NSString (RACSupport)
    + (RACSignal<NSString *> *)rac_readContentsOfURL:(NSURL *)URL usedEncoding:(NSStringEncoding *)encoding scheduler:(RACScheduler *)scheduler;

#####NotificationCenter Category

    //NSNotificationCenter (RACSupport) 不用担心移除observer的问题。
    - (RACSignal<NSNotification *> *)rac_addObserverForName:(nullable NSString *)notificationName object:(nullable id)object;

#####NSObject Category

    //NSObject (RACDeallocating)
    - (RACSignal *)rac_willDeallocSignal;
    @property (atomic, readonly, strong) RACCompoundDisposable *rac_deallocDisposable;
        
    //NSObject (RACKVOWrapper)
    - (RACDisposable *)rac_observeKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options observer:(__weak NSObject *)observer block:(void (^)(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent))block;

    //NSObject (RACLifting) 满足一定条件时候
    - (RACSignal *)rac_liftSelector:(SEL)selector withSignals:(RACSignal *)firstSignal, ... NS_REQUIRES_NIL_TERMINATION;

    //NSObject (RACSelectorSignal)
    - (RACSignal<RACTuple *> *)rac_signalForSelector:(SEL)selector;
    - (RACSignal<RACTuple *> *)rac_signalForSelector:(SEL)selector fromProtocol:(Protocol *)protocol;


5. MVVM

ViewModel直接和View绑定，且对View一无所知。
Controller，在MVVM中，ViewController已经成了View的一部分。主要工作是处理布局、动画、接受系统事件、展示UI

6. Others

signal被一个subcriber subcribe后，subscriber的移除时机是：当subscriber被sendComplete或sendError时，或者手动调用[disposable dispose]
    
signal是线性的，不会出现并发情况(查看👆的水龙头举例)，除非显示的指定Scheduler。

errors有优先权，如果多个signals被同时监听，只要其中一个signal sendError，那么error就会立即传给subscriber，并导致signals终止执行，相当于exception。

生成signal时候，指定name，方便调试 -setNameWithFormat:

block代码中不要阻塞
    
####[基于AFNetworking2.0和ReactiveCocoa2.1的iOS REST Client](http://limboy.me/tech/2014/01/05/ios-rest-client-implementation.html)

####[ReactiveCocoa2实战](http://limboy.me/tech/2014/06/06/deep-into-reactivecocoa2.html)

1. Signal

一个signal可以被多个subscriber订阅，但每次被新的subscriber订阅时，都会导致数据源的处理逻辑被触发一次，这很有可能导致意想不到的结果，需要注意一下。 ==> Side Effects 副作用 (replay)

数据从signal传到subscriber时，可用通过'doXXX'做点事情

把signal左右局部变量时，如果没有被subscribe，方法执行完，该变量就会dealloc。但是如果signal被subscribe了，subscriber会持有该signal，直到signal sendComplete / sendError，才会解除持有关系，signal才会dealloc


2. RACCommand

[深入理解RACCommand](http://codeblog.shape.dk/blog/2013/12/05/reactivecocoa-essentials-understanding-and-using-raccommand/)

RACCommand通常表示某个Action的执行。以下几个重要属性

+ 'executionSignals' 是signal of signals，如果直接subscribe的话会直接得到一个signal，而不是value，所以一般配合switchToLatest使用
+ 'errors'  RACCommand不同于RACSignal，错误不通过SendErrors来实现，而是通过errors属性传递出来
+ 'executing'表示该command当前是否正在执行


3. 常用模式

    #####map + switchToLatest
    
    'switchToLatest'作用是自动切换signal of signals到最后一个
    'map'作用是对'sendNext'的value做处理，返回我们想要的值
    
    
    #####takeUntil
    
    'takeUntil:someSignal'作用是当someSignal sendNext时，当前signal就sendCompleted。
    
    一个常用的场景是cell上button点击事件
        
        //如果不加takeUntil，每次cell被重用，button都会被添加addTareget
        [[[cell.detailButton
            	rac_signalForControlEvents:UIControlEventTouchUpInside]
            	takeUntil:cell.rac_prepareForReuseSignal]
            	subscribeNext:^(id x) {
            		// generate and push ViewController
            }];
       
       
    #####替换Delegate
    
    #####[ReactiveViewModel](https://github.com/ReactiveCocoa/ReactiveViewModel.git)的didBecomActiveSignal
            
    #####RACSubject的使用场景
     
     一般不推荐使用，因为它太灵活。不过也有场景使用它比较方便。
     
4. MVVM

    ViewModel中signal property command的使用
    
    一般来说可以使用property就直接用，外部用RACObserve即可。
    使用signal的场景，一般涉及到多个property或多个signal合并为一个signal。
    command往往与UIControl、网络请求相关。

5. 常见场景
6. 注意事项

- ReactiveCocoaLayout最好不用或少用，性能不好，容易造成卡顿。
- 多写注释，方便调试
- strongify、weakify 循环引用问题。eg: RACObserve(thing,keypath)，总会引用self，即使target不是self。所以只要有RACObserve都要用weakify、strongify
 
        
####[MVVM without ReactiveCocoa](http://limboy.me/tech/2015/09/27/ios-mvvm-without-reactivecocoa.html)

- ViewController 尽量不涉及业务逻辑，让 ViewModel 去做这些事情。
- ViewController 只是一个中间人，接收 View 的事件、调用 ViewModel 的方法、响应 ViewModel 的变化。
- ViewModel 不能包含 View，不然就跟 View 产生了耦合，不方便复用和测试。
- ViewModel 之间可以有依赖。
- ViewModel 避免过于臃肿，不然维护起来也是个问题。

