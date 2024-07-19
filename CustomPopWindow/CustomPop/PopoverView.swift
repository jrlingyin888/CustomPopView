//
//  PopoverView.swift
//  CustomPopWindow
//
//  Created by jerrywang on 2024/7/18.
//

import UIKit

enum PopoverViewArrowDirection : Int {
    //箭头位置
    case up = 1    //上中
    case down = 2  //下中
    case left = 3  //左中
    case right = 4 //右中
}


class PopoverView: UIView {

    var backView: UIView?
    
    private var _arrowOrigin:CGPoint = CGPoint.zero
    private var _arrowWidth:CGFloat = 10.0              //defatult
    private var _arrowHeight:CGFloat = 10.0             //defatult
    
    private var _contentWidth:CGFloat = CGFloat.zero
    private var _contentHeight:CGFloat = CGFloat.zero
    private var _direction:PopoverViewArrowDirection = .up
    
    
    init(arrowOrigin origin:CGPoint,contentWidth contentW:CGFloat,contentHeight contentH:CGFloat,arrowDirection direction:PopoverViewArrowDirection) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        _arrowOrigin = origin
        
        _contentWidth = contentW
        _contentHeight = contentH
        _direction = direction
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    func setupView(){
        //背景颜色为无色
        backgroundColor = UIColor.clear
        
        backView = UIView(frame: CGRect(x: _arrowOrigin.x, y: _arrowOrigin.y + _arrowHeight, width: _contentWidth, height: _contentHeight))
        backView?.center.x = _arrowOrigin.x
        
        backView?.layer.cornerRadius = 11  //设置圆角
        backView!.backgroundColor = .purple //内容背景色
        
        addSubview(backView!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let touch = touches.first, let view = touch.view, view.isEqual(backView) {
            // Handle the case when touch.view is equal to backView
        } else {
            dismiss()
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
//        context.clear(rect)
        
        let startX = _arrowOrigin.x
        let startY = _arrowOrigin.y
        
//        let path = CGMutablePath()
        
        if (_direction == .up) {
            
            // Define the arrow path
            
            context.move(to: CGPoint(x: startX, y: startY))
            context.addLine(to: CGPoint(x: startX + self._arrowWidth / 2, y: startY + self._arrowHeight))
            context.addLine(to: CGPoint(x: startX - self._arrowWidth / 2, y: startY + self._arrowHeight))
//            path.closeSubpath()
            
            // Fill the arrow
//            context.addPath(path)
        }
        context.closePath()
        
//        context.setFillColor(UIColor.purple.cgColor)
        backView?.backgroundColor?.setFill()
        backgroundColor?.setStroke()
//        context.fillPath()
        context.drawPath(using: .fillStroke)
        // Add shadow on the sides
//        let shadowPath = UIBezierPath(cgPath: path)
//        self.layer.shadowPath = shadowPath.cgPath
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PopoverView {
 
    func showPopView() {
        
        guard let _backView = backView else { return }
        
        let result = _backView.subviews
        for view in result {
            view.isHidden = true
        }

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.addSubview(self)
        }
      
        //动画效果弹出
        alpha = 0

        if (_direction == .up) {
            _backView.frame = CGRect(x: _arrowOrigin.x, y: _arrowOrigin.y + _arrowHeight, width: 0, height: 0)
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.alpha = 1
                _backView.frame = CGRect(x: self!._arrowOrigin.x, y: self!._arrowOrigin.y + self!._arrowHeight, width: self!._contentWidth, height: self!._contentHeight)
                _backView.center.x = self!._arrowOrigin.x
            }, completion: { _ in
                for view in result {
                    view.isHidden = false
                }
            })
        }
    }
    
    func dismiss() {
        guard let _backView = backView else { return }
        
        let result = _backView.subviews
        for view in result {
            view.removeFromSuperview()
        }
        
             //动画效果淡出
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.alpha = 0
            _backView.frame = CGRect(x: self!._arrowOrigin.x, y: self!._arrowOrigin.y, width: 0, height: 0)
        }, completion: { finished in
            if finished {
                self.removeFromSuperview()
            }
        })
        
        
    }
    
}
