//
//  ViewController.swift
//  CustomPopWindow
//
//  Created by jr on 2024/7/18.
//

import UIKit

enum ButtonTag : Int {
    case RedTag = 10
    case YellowTag = 11
    case BlueTag = 12
    case GreenTag = 13
    case PinkTag = 14
    case OrangeTag = 15
}


class ViewController: UIViewController {

    private lazy var label: UILabel = {
        let view = UILabel(frame: CGRectMake(10, 10, 170, 100))
        view.text = "你好啊 Hello world！\n我很好，没关系\nI'm fine It doesn't matter\nNice to meet you!"
        view.textColor = .white
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 15)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let btn = UIButton(frame: CGRect(x: 30, y: 100, width: 100, height: 50))
        btn.backgroundColor = .red
        btn.tag = ButtonTag.RedTag.rawValue
        btn.setTitle("arrow up", for: .normal)
        btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        view.addSubview(btn)
        
        
        let btn2 = UIButton(frame: CGRect(x: 30, y: 400, width: 100, height: 50))
        btn2.backgroundColor = .yellow
        btn2.tag = ButtonTag.YellowTag.rawValue
        btn2.setTitle("arrow left", for: .normal)
        btn2.setTitleColor(.black, for: .normal)
        btn2.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        view.addSubview(btn2)
        
        let btn3 = UIButton(frame: CGRect(x: 30, y: UIScreen.main.bounds.height - 150, width: 100, height: 50))
        btn3.backgroundColor = .blue
        btn3.tag = ButtonTag.BlueTag.rawValue
        btn3.setTitle("arrow down", for: .normal)
        btn3.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        view.addSubview(btn3)
        
        let btn4 = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 130, y: 100, width: 100, height: 50))
        btn4.backgroundColor = .green
        btn4.tag = ButtonTag.GreenTag.rawValue
        btn4.setTitle("arrow up", for: .normal)
        btn4.setTitleColor(.black, for: .normal)
        btn4.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        view.addSubview(btn4)
        
        let btn5 = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 130, y: 400, width: 100, height: 50))
        btn5.backgroundColor = .systemPink
        btn5.tag = ButtonTag.PinkTag.rawValue
        btn5.setTitle("arrow right", for: .normal)
        btn5.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        view.addSubview(btn5)
        
        let btn6 = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 130, y: UIScreen.main.bounds.height - 150, width: 100, height: 50))
        btn6.backgroundColor = .orange
        btn6.tag = ButtonTag.OrangeTag.rawValue
        btn6.setTitle("arrow down", for: .normal)
        btn6.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        view.addSubview(btn6)
    }

    @objc func btnClick(_ btn:UIButton) {

        if btn.tag == ButtonTag.RedTag.rawValue {
            let popView = PopoverView(targetView: btn, contentWidth: 200, contentHeight: 200, arrowDirection: .up)
            //添加弹窗内容视图
            popView.contentAddSubView(label)
            
            popView.showPopView()
            
        } else if btn.tag == ButtonTag.YellowTag.rawValue {
            
            let popView = PopoverView(targetView: btn, contentWidth: 200, contentHeight: 200, arrowDirection: .left)
            //添加弹窗内容视图
            popView.contentAddSubView(label)
            
            popView.showPopView()
            
        } else if btn.tag == ButtonTag.BlueTag.rawValue {
            
            let popView = PopoverView(targetView: btn, contentWidth: 200, contentHeight: 200, arrowDirection: .down)
            //添加弹窗内容视图
            popView.contentAddSubView(label)
            
            popView.showPopView()
            
        } else if btn.tag == ButtonTag.GreenTag.rawValue {
            
            let popView = PopoverView(targetView: btn, contentWidth: 200, contentHeight: 200, arrowDirection: .up)
            //添加弹窗内容视图
            popView.contentAddSubView(label)
            
            popView.showPopView()
            
        } else if btn.tag == ButtonTag.PinkTag.rawValue {
            
            let popView = PopoverView(targetView: btn, contentWidth: 200, contentHeight: 200, arrowDirection: .right)
            //添加弹窗内容视图
            popView.contentAddSubView(label)
            
            popView.showPopView()
            
        } else if btn.tag == ButtonTag.OrangeTag.rawValue {
            
            let popView = PopoverView(targetView: btn, contentWidth: 200, contentHeight: 200, arrowDirection: .down)
            //添加弹窗内容视图
            popView.contentAddSubView(label)
            
            popView.showPopView()
            
        }
    }

}

