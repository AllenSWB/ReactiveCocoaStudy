#从C-41看RAC和MVVM


---

RAC(self.viewModel, name) = [cell.textField.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal];

我们发现赋值等号的右边不是用 RACObserve 创建的Signal，而是使用 ReactiveCocoa 对 textField 做的扩展 rac_textSignal, 它实际上是创建了一个监听 textField 的 UIControlEventEditingChanged 事件的信号。 takeUntil:cell.rac_prepareForReuseSignal 则是指只有当 cell 的 -prepareForReuse被调用时才触发这个信号的 next 或 completed 事件。

---

RACChannelTo(self, name) = RACChannelTo(self.model, name);

RACChannelTo(self, name) = RACChannelTo(self.model, name); 这种写法是个双向绑定，也就是 self.name 改变，self.model.name 会改变；反之 self.model.name 改变的话，self.name 也会改变。

RACChannelTo(self, filmType, @(ASHRecipeFilmTypeColourNegative)) = RACChannelTo(self.model, filmType, @(ASHRecipeFilmTypeColourNegative));

RACChannelTo(self, filmType, @(ASHRecipeFilmTypeColourNegative)) 里面第三个参数是指，如果值的变化中出现 nil，那么就会使用这个值来代替，相当于一个默认值。

这是为什么 MVVM 通常会依赖 ReactiveCocoa 的原因之二，即 ViewModel 和 Model 的改变通常是需要双向同步的。

---

我们发现一个属性不仅仅只能绑定由单个值改变触发的信号，还可以绑定由多个值改变触发的聚合信号。通过 combineLatest:reduce: 我们可以聚合多个信号成一个信号，让属性的改变是依赖多个值的变化的。

---

程序里，一个 ViewController(View层) 持有一个 ViewModel，一个 ViewModel 对应一个 Model。ViewController(View层) 对于 ViewModel 使用单向绑定，将 ViewModel 的变化反应到 ViewController(View层)；ViewModel 对于 Model 使用双向绑定，不论修改 ViewModel 或是 Model 都会实现数据的同步更新。

于是我们把很多原本放在 ViewController 里的逻辑独立了出来，让属于 View层 的 ViewController 去做 View层 应该做的事情，而不要关心原本不属于它的事情。当然我们也没有把独立出来的这部分事情放在 Model 里，并不污染真正属于数据存储部分的逻辑。于是其实我们独立出来的这个部分，就成了 ViewModel。

---