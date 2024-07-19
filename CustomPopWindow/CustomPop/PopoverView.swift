//
//  PopoverView.swift
//  CustomPopWindow
//
//  Created by jerrywang on 2024/7/18.
//

import UIKit

enum PopoverViewArrowDirection : Int {
    //Arrow position
    case up = 1
    case down = 2
    case left = 3
    case right = 4
}


class PopoverView: UIView {

    var backView: UIView?
    
    private var _arrowOrigin:CGPoint = CGPoint.zero
    
    private var _padding_h:CGFloat = 10.0               //Lateral spacing
    private var _padding_v:CGFloat = 50.0               //Vertical spacing
    
    private var _arrowWidth:CGFloat = 15.0              //defatult
    private var _arrowHeight:CGFloat = 10.0             //defatult
    
    private var _contentWidth:CGFloat = CGFloat.zero
    private var _contentHeight:CGFloat = CGFloat.zero
    private var _direction:PopoverViewArrowDirection = .up
    
    //Can be passed to the target view
    init(targetView tarView:UIView,contentWidth contentW:CGFloat,contentHeight contentH:CGFloat,arrowDirection direction:PopoverViewArrowDirection) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        //Calculate the origin position of the target view in the full screen
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
    
    //The original coordinates can be passed in
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
        backgroundColor = UIColor.clear
        
        /**
         
         it will determine whether the width and height of the view have exceeded the screen,
         and if they have, it will be processed accordingly
         
         */
        if _contentWidth >= UIScreen.main.bounds.width {
            _contentWidth = UIScreen.main.bounds.width - 20     //you can customize how much processing goes beyond the screen
        }
        if _contentHeight >= UIScreen.main.bounds.height {
            _contentHeight = UIScreen.main.bounds.height - 100  //You can customize how much processing goes beyond the screen
        }
        
        backView = UIView(frame: CGRect(x: _arrowOrigin.x, y: _arrowOrigin.y + _arrowHeight, width: _contentWidth, height: _contentHeight))
        backView?.center.x = _arrowOrigin.x
        
        backView?.layer.cornerRadius = 11
        backView!.backgroundColor = .purple
        
        addSubview(backView!)
    }
    
    //Set the origin position of the arrow in the corresponding direction
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
            
            //To determine whether backView is beyond the screen, how to go beyond the left side of the screen, set the left margin of backiew 10, and if it goes beyond the right side of the screen, set the right margin of backView 10
            if _backView.frame.origin.x < _padding_h {
                _backView.frame.origin.x = _padding_h
            }
            if _backView.frame.origin.x + _contentWidth > (UIScreen.main.bounds.width - _padding_h) {
                _backView.frame.origin.x = UIScreen.main.bounds.width - _contentWidth - _padding_h
            }
            
        }else if (_direction == .down) {
            _backView.frame = CGRect(x: _arrowOrigin.x, y: _arrowOrigin.y - _arrowHeight - _contentHeight, width: _contentWidth, height: _contentHeight)
            _backView.center.x = _arrowOrigin.x
            
            //Id.
            if _backView.frame.origin.x < _padding_h {
                _backView.frame.origin.x = _padding_h
            }
            if _backView.frame.origin.x + _contentWidth > (UIScreen.main.bounds.width - _padding_h) {
                _backView.frame.origin.x = UIScreen.main.bounds.width - _contentWidth - _padding_h
            }
            
        }else if (_direction == .left) {
            
            _backView.frame = CGRect(x: _arrowOrigin.x + _arrowHeight, y: _arrowOrigin.y, width: _contentWidth, height: _contentHeight)
            _backView.center.y = _arrowOrigin.y
            
            //To determine whether backView is beyond the screen, how to go beyond the top of the screen, set the top margin of backiew 50, and if it goes beyond the bottom screen, set the bottom margin of backView 50
            if _backView.frame.origin.y <= _padding_v {
                _backView.frame.origin.y = _padding_v
            }
            if _backView.frame.origin.y + _contentHeight > (UIScreen.main.bounds.height - _padding_v) {
                _backView.frame.origin.y = UIScreen.main.bounds.height - _contentHeight - _padding_v
            }
            
        }else if (_direction == .right) {
            _backView.frame = CGRect(x: _arrowOrigin.x - _arrowHeight - _contentWidth, y: _arrowOrigin.y, width: _contentWidth, height: _contentHeight)
            _backView.center.y = _arrowOrigin.y
            
            //Id.
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
    
    func setArrowY(_ y:CGFloat) {
        self._arrowOrigin.y = y
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
