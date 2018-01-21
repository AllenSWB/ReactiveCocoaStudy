# Note


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

####RACDisposable

    用于取消订阅或者清理资源，当信号发送完成或者发送错误的时候，就会自动触发它。

####RACSignal (Operations)


####MVVM

    MVVM的架构模式。

    Model层是少不了的了，我们得有东西充当DTO(数据传输对象)，当然，用字典也是可以的，编程么，要灵活一些。Model层是比较薄的一层，如果学过Java的小伙伴的话，对JavaBean应该不陌生吧。
    ViewModel层，就是View和Model层的粘合剂，他是一个放置用户输入验证逻辑，视图显示逻辑，发起网络请求和其他各种各样的代码的极好的地方。说白了，就是把原来ViewController层的业务逻辑和页面逻辑等剥离出来放到ViewModel层。
    View层，就是ViewController层，他的任务就是从ViewModel层获取数据，然后显示。

####Ohter

1. ReactiveCocoa Unknown warning group ‘-Wreceiver-is-weak’,ignored警告 (Xcode 9)

        解决: http://www.cocoachina.com/ios/20170915/20580.html

         #define RACObserve(TARGET, KEYPATH) \
                ({ \
                    __weak id target_ = (TARGET); \
                    [target_ rac_valuesForKeyPath:@keypath(TARGET, KEYPATH) observer:self]; \
                })