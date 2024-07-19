//
//  ViewController.swift
//  CustomPopWindow
//
//  Created by jr on 2024/7/18.
//

import UIKit

class ViewController: UIViewController {

    var popView:PopoverView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let btn = UIButton(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
        btn.backgroundColor = .yellow
        btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        view.addSubview(btn)
        
        
    }

    @objc func btnClick(_ btn:UIButton) {
        btn.isSelected = !btn.isSelected
        
        
        
        if popView == nil {
            popView = PopoverView(arrowOrigin: CGPoint(x: 150, y: 200), contentWidth: 200, contentHeight: 200, arrowDirection: .up)
            
        }
        
//        if btn.isSelected {
            popView!.showPopView()
//        }else{
//            popView?.dismiss()
//        }
        
        
    }

}

