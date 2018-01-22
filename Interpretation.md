
首先，从ViewController -> LoginViewController

用到了RACSubject。这个类继承自RACSignal, 同时，它也实现了<RACSubcriber>协议。意味着他比较灵活，既可以做signal来发送信号，又可以做subscriber监听signal。

RACSubject通常来替代delegate，来反向传值。在合适的时机 sendNext: ，将value传出去
在Login页面声明一个subject，需要的时候利用它sendNext来传值，在Root页subscribeNext:监听next事件

展开1: 

RACSubcriber 协议有四个必须实现的方法 sendNext: sendCompleted sendError: didSubscribeWithDisposable:

sendNext: 产生了新value，将它发送给subscriber
sendCompleted 发送完成消息，不带value。这一步之后释放subscriber
sendError: 把error消息发给subsriber
didSubscribeWithDisposable: 

展开2:

RACSubcriber 协议还有个同名的class

展开3:

RACSubject 是RACSignal的子类。它和RACSignal的最大区别就是，RACSubject天然就是hot的。

cold 指的是一个signal没有subscriber，产生了新value也不会发送，等有了subscriber就一次性将所有的value都发送给subscirber

hot 是一直发送新value。eg: 1s发送@1，2s发送@2，在1.5s处才有了一个subscirber，那么这个subscirber只会收到@2这个值。如果一个subject也想收到历史值，用replaySubject

-----

RAC(self.viewModel, phone) = self.phoneTextField.rac_textSignal;

RAC宏 作用是将一个Obj的对象和signal绑定。RAC放在左侧，要绑定的signal放在右侧。RAC里两个参数是 TARGET : 对象 KEYPATH : 属性

rac_textSignal 是 RAC针对UITextField的一个category。作用是监听textField的AllEditingEvent，直到textfield销毁。

    - (RACSignal *)rac_textSignal {
	@weakify(self);
	return [[[[[RACSignal
		defer:^{                //defer: 将signal的创建推迟到真正有subscriber订阅它的时候，懒加载。用作将hot变为cold
			@strongify(self);
			return [RACSignal return:self];
		}]
		concat:[self rac_signalForControlEvents:UIControlEventAllEditingEvents]]
		map:^(UITextField *x) {
			return x.text;
		}]
		takeUntil:self.rac_willDeallocSignal]
		setNameWithFormat:@"%@ -rac_textSignal", self.rac_description];
}

----

weakify strongify 两个宏 前面加个@没啥用
作用是防止循环引用造成内存泄漏

用到的地方是RACOberve宏，内部是使用self

扩展1: 
RACSubject，map后内部最后会调用到bind方法，也会引起循环引用。所以一个subject调用了map等操作后，都得sendCompleted

---

RACCommand 用于表示事件的执行 RAC提供了三个category UIButton UIBarButtonItem UIRefreshControl

    button.rac_command

        - initWithBlockSignal: 创建一个command

        button的enabled 就和 command的enabled绑定了。

        executionSignals 传递的value就是创建command时的blockSignal

        errors  和signal不同，error消息不会通过sendError: 而是通过这个属性传递的

        doNext: 是signal的一个 operation 。作用是在sendNext: 之前做block中的工作，用来注入副作用


---

ViewModel 层里

RACObserve 宏 是监听TARGET 的 KEYPATH

创建command用 -initWithEnabled:signalBlock: enabled参数是控制command是否可用的

combineLatest:reduce: 