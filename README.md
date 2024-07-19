# CustomPopView
The prompt window with arrows can set the origin position of arrows, and can automatically adapt to the screen beyond the screen range.

含有箭头的提示窗，可设置箭头的原点位置，超出屏幕范围可以自动适配屏幕。

* 展示效果


https://github.com/user-attachments/assets/9baa651a-461d-4ed5-ac6a-cc71986429c7

## 使用
* 先设置一个 Button

        let btn = UIButton(frame: CGRect(x: 30, y: 100, width: 100, height: 50))
        btn.backgroundColor = .red
        btn.tag = ButtonTag.RedTag.rawValue
        btn.titleLabel?.numberOfLines = 0
        btn.setTitle("arrow up\narrow.x = 35", for: .normal)
        btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        view.addSubview(btn)
  
* 然后在 button 的点击事件里执行弹窗操作
  
       let popView = PopoverView(targetView: btn, contentWidth: 200, contentHeight: 200, arrowDirection: .up)
       //添加弹窗内容视图 label 可自定义其他视图包含 UIView、UILabel、UIImageView 等
       popView.contentAddSubView(label)
       popView.showPopView()

* 如果需要设置箭头的 x 或 y 值：

       let popView = PopoverView(targetView: btn, contentWidth: 200, contentHeight: 200, arrowDirection: .up)
       popView.contentAddSubView(label)
       popView.setArrowX(35)//设置箭头 x
       popView.setArrowY(35)//设置箭头 y
       popView.showPopView()

## 总结
* 非常简单方便的弹窗提示功能，有需要改进的可以告知，我会尽力完善更多的功能给大家使用
* 微WeChat:Jun_Yeong-Huang
* QQ:2596631084
* 邮箱：2596631084@qq.com
* X(推特)：@JerryWang1905
