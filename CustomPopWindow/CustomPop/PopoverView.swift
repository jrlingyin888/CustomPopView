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
    
    private var _padding_h:CGFloat = 10.0               //横向间距
    private var _padding_v:CGFloat = 50.0               //竖向间距
    
    private var _arrowWidth:CGFloat = 15.0              //defatult
    private var _arrowHeight:CGFloat = 10.0             //defatult
    
    private var _contentWidth:CGFloat = CGFloat.zero
    private var _contentHeight:CGFloat = CGFloat.zero
    private var _direction:PopoverViewArrowDirection = .up
    
    //可传入目标视图
    init(targetView tarView:UIView,contentWidth contentW:CGFloat,contentHeight contentH:CGFloat,arrowDirection direction:PopoverViewArrowDirection) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        //计算出目标视图在全屏中的原点位置
        var pointInScreenView = CGPoint.zero
        if let superview = tarView.superview {
            let pointInWindow = superview.convert(tarView.frame.origin, to: nil)
            let pointInScreen = tarView.window?.convert(pointInWindow, to: UIScreen.main.coordinateSpace)
            pointInScreenView = pointInScreen!
        }
        
        _arrowOrigin = arrowOriginWithTargetView(tarView, pointInScreenView,direction)
        _contentWidth = contentW
        _contentHeight = contentH
        _direction = direction
        
        setupView()
    }
    
    //可传入原始坐标
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        //背景颜色为无色
        backgroundColor = UIColor.clear
        
        //这里会判断视图的宽高是否已经超出屏幕了，如超出则做出相应的处理
        if _contentWidth >= UIScreen.main.bounds.width {
            _contentWidth = UIScreen.main.bounds.width - 20  //这里可自定义超出屏幕做多少的处理
        }
        if _contentHeight >= UIScreen.main.bounds.height {
            _contentHeight = UIScreen.main.bounds.height - 100  //这里可自定义超出屏幕做多少的处理
        }
        
        backView = UIView(frame: CGRect(x: _arrowOrigin.x, y: _arrowOrigin.y + _arrowHeight, width: _contentWidth, height: _contentHeight))
        backView?.center.x = _arrowOrigin.x
        
        backView?.layer.cornerRadius = 11  //设置圆角
        backView!.backgroundColor = .purple //内容背景色
        
        addSubview(backView!)
    }
    
    //设置对应方向的箭头原点位置
    private func arrowOriginWithTargetView(_ tarView:UIView,_ originPoint:CGPoint,_ direction:PopoverViewArrowDirection) -> CGPoint{
        var currentArrowOriginPoint:CGPoint = CGPointZero
        
        if (direction == .up) {

            currentArrowOriginPoint.x = originPoint.x + tarView.frame.width/2
            currentArrowOriginPoint.y = originPoint.y + tarView.frame.height
            
        }else if (direction == .down) {
            
            currentArrowOriginPoint.x = originPoint.x + tarView.frame.width/2
            currentArrowOriginPoint.y = originPoint.y
            
        }else if (direction == .left) {
            
            currentArrowOriginPoint.x = originPoint.x + tarView.frame.width
            currentArrowOriginPoint.y = originPoint.y + tarView.frame.height/2
            
        }else if (direction == .right) {
            
            currentArrowOriginPoint.x = originPoint.x
            currentArrowOriginPoint.y = originPoint.y + tarView.frame.height/2
        }
        
        return currentArrowOriginPoint
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

        let startX = _arrowOrigin.x
        let startY = _arrowOrigin.y

        // Define the arrow path
        if (_direction == .up) {
            
            context.move(to: CGPoint(x: startX, y: startY))
            context.addLine(to: CGPoint(x: startX + self._arrowWidth / 2, y: startY + self._arrowHeight))
            context.addLine(to: CGPoint(x: startX - self._arrowWidth / 2, y: startY + self._arrowHeight))

        }else if (_direction == .down) {
            
            context.move(to: CGPoint(x: startX, y: startY))
            context.addLine(to: CGPoint(x: startX - self._arrowWidth / 2, y: startY - self._arrowHeight))
            context.addLine(to: CGPoint(x: startX + self._arrowWidth / 2, y: startY - self._arrowHeight))
            
        }else if (_direction == .left) {
            
            context.move(to: CGPoint(x: startX, y: startY))
            context.addLine(to: CGPoint(x: startX + self._arrowHeight, y: startY - self._arrowWidth/2))
            context.addLine(to: CGPoint(x: startX + self._arrowHeight, y: startY + self._arrowWidth/2))
          
        }else if (_direction == .right) {
          
            context.move(to: CGPoint(x: startX, y: startY))
            context.addLine(to: CGPoint(x: startX - self._arrowHeight, y: startY - self._arrowWidth/2))
            context.addLine(to: CGPoint(x: startX - self._arrowHeight, y: startY + self._arrowWidth/2))
            
        }
        
        
        context.closePath()

        backView?.backgroundColor?.setFill()
        backgroundColor?.setStroke()
        context.drawPath(using: .fillStroke)

        refreshBackViewFrame()
    }
    
    
    func refreshBackViewFrame(){
        
        guard let _backView = backView else { return }
        
        if (_direction == .up) {
            _backView.frame = CGRect(x: _arrowOrigin.x, y: _arrowOrigin.y + _arrowHeight, width: _contentWidth, height: _contentHeight)
            _backView.center.x = _arrowOrigin.x
            
            //判断backView是否超出屏幕，如何超出屏幕左边则设置backiew的左边距 10，同样如果超出右边屏幕，则 backView 的右边距 10
            if _backView.frame.origin.x < _padding_h {
                _backView.frame.origin.x = _padding_h
            }
            if _backView.frame.origin.x + _contentWidth > (UIScreen.main.bounds.width - _padding_h) {
                _backView.frame.origin.x = UIScreen.main.bounds.width - _contentWidth - _padding_h
            }
            
        }else if (_direction == .down) {
            _backView.frame = CGRect(x: _arrowOrigin.x, y: _arrowOrigin.y - _arrowHeight - _contentHeight, width: _contentWidth, height: _contentHeight)
            _backView.center.x = _arrowOrigin.x
            
            //判断backView是否超出屏幕，如何超出屏幕左边则设置backiew的左边距 10，同样如果超出右边屏幕，则 backView 的右边距 10
            if _backView.frame.origin.x < _padding_h {
                _backView.frame.origin.x = _padding_h
            }
            if _backView.frame.origin.x + _contentWidth > (UIScreen.main.bounds.width - _padding_h) {
                _backView.frame.origin.x = UIScreen.main.bounds.width - _contentWidth - _padding_h
            }
            
        }else if (_direction == .left) {
            
            _backView.frame = CGRect(x: _arrowOrigin.x + _arrowHeight, y: _arrowOrigin.y, width: _contentWidth, height: _contentHeight)
            _backView.center.y = _arrowOrigin.y
            
            //判断backView是否超出屏幕，如何超出屏幕上边则设置backiew的上边距 50，同样如果超出下边屏幕，则 backView 的下边距 50
            if _backView.frame.origin.y <= _padding_v {
                _backView.frame.origin.y = _padding_v
            }
            if _backView.frame.origin.y + _contentHeight > (UIScreen.main.bounds.height - _padding_v) {
                _backView.frame.origin.y = UIScreen.main.bounds.height - _contentHeight - _padding_v
            }
            
        }else if (_direction == .right) {
            _backView.frame = CGRect(x: _arrowOrigin.x - _arrowHeight - _contentWidth, y: _arrowOrigin.y, width: _contentWidth, height: _contentHeight)
            _backView.center.y = _arrowOrigin.y
            
            //判断backView是否超出屏幕，如何超出屏幕上边则设置backiew的上边距 50，同样如果超出下边屏幕，则 backView 的下边距 50
            if _backView.frame.origin.y <= _padding_v {
                _backView.frame.origin.y = _padding_v
            }
            if _backView.frame.origin.y + _contentHeight > (UIScreen.main.bounds.height - _padding_v) {
                _backView.frame.origin.y = UIScreen.main.bounds.height - _contentHeight - _padding_v
            }
        }
        
    }
    
    func setArrowX(_ x:CGFloat) {
        self._arrowOrigin.x = x
        self.setNeedsLayout()
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

        _backView.frame = CGRect(x: _arrowOrigin.x, y: _arrowOrigin.y + _arrowHeight, width: 0, height: 0)
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.alpha = 1
            self?.refreshBackViewFrame()
            
        }, completion: { _ in
            for view in result {
                view.isHidden = false
            }
        })
        
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
    
    func contentAddSubView(_ view: UIView) {
        backView?.addSubview(view)
    }
    
}
