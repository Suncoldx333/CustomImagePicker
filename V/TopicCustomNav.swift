//
//  TopicCustomNav.swift
//  SWCampus
//
//  Created by 11111 on 2017/3/6.
//  Copyright © 2017年 WanHang. All rights reserved.
//

import UIKit

@objc(topicCustomNavDelegate)
protocol topicCustomNavDelegate {
    func leftIconClick()
    func centerIconClick()
    func rightIconClick()
}

public class TopicCustomNav: UIView {

    override init(frame: CGRect){
        super.init(frame: frame)
        initUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var delegate : topicCustomNavDelegate! = nil
    var centerView : UIView!
    var centerLabel : UILabel!
    var rightLabel : UILabel!
    var rightImageView : UIImageView!
    var navCloseImage : UIImageView!
    
    public var rightTitle : String{      //rightTitle = "image"时，显示Icon,其它则显示输入的文字
        get{
            return rightLabel.text!
        }
        set(title){
            self.changeRightIntoTitle(titelRight: title)
        }
    }
    
    public var leftIcon : String{
        get{
            return self.leftIcon
        }
        set(iconName){
            self.leftIconName(iconName: iconName)
        }
    }
    
    public var contentExitTag : Int{
        get{
            return contentExitTagOpen
        }
        set(exitTag){
            self.contentExit(state: exitTag)
        }
    }
    var contentExitTagOpen : Int!
    
    func initUI() {
        
        self.frame = CGRect.init(x: 0, y: 20, width: ScreenWidth, height: 44.5)
        self.backgroundColor = ColorMethodho(hexValue: 0xfafafa)
        contentExitTagOpen = 0
        
        //左侧视图
        let leftView : UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 30 + 15, height: 44))
        let leftTap = UITapGestureRecognizer.init(target: self, action: #selector(navCloseTap))
        leftView.addGestureRecognizer(leftTap)
        self.addSubview(leftView)
        
        navCloseImage = UIImageView.init(frame: CGRect.init(x: 15, y: 14.5, width: 15, height: 15))
        navCloseImage.image = #imageLiteral(resourceName: "4545NavClose.png")
        navCloseImage.isUserInteractionEnabled = false
        leftView.addSubview(navCloseImage)
        
        //中间视图
        centerView = UIView.init(frame: CGRect.init(x: 45, y: 0, width: ScreenWidth - 45 - 42, height: 44))
        centerView.isUserInteractionEnabled = false
        let centerTap = UITapGestureRecognizer.init(target: self, action: #selector(navCenterTap))
        centerView.addGestureRecognizer(centerTap)
        self.addSubview(centerView)
        
        centerLabel = UILabel.init(frame: CGRect.init(x: 45, y: 0, width: ScreenWidth - 45 - 42, height: 44))
        centerLabel.isUserInteractionEnabled = false
        centerLabel.textColor = ColorMethodho(hexValue: 0x333333)
        centerLabel.font = UIFont.boldSystemFont(ofSize: 13)
        centerLabel.textAlignment = NSTextAlignment.center
        self.addSubview(centerLabel)
        
        //右侧视图
        let rightView : UIView = UIView.init(frame: CGRect.init(x: ScreenWidth - 30 - 18, y: 0, width: 30 + 18, height: 44))
        let rightTap = UITapGestureRecognizer.init(target: self, action: #selector(navRightTap))
        rightView.addGestureRecognizer(rightTap)
        self.addSubview(rightView)
        
        rightLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 15 + 18, height: 44))
        rightLabel.textColor = ColorMethodho(hexValue: 0x333333)
        rightLabel.font = UIFont.systemFont(ofSize: 13)
        rightLabel.textAlignment = NSTextAlignment.right
        rightLabel.isHidden = true
        rightView.addSubview(rightLabel)
        
        rightImageView = UIImageView.init(frame: CGRect.init(x: 15, y: 16, width: 18, height: 12))
        rightImageView.image = #imageLiteral(resourceName: "5436NavSure.png")
        rightImageView.isHidden = true
        rightView.addSubview(rightImageView)
        
        //底部分割线
        let seline = CALayer.init()
        seline.frame = CGRect.init(x: 0, y: 44, width: ScreenWidth, height: 0.5)
        seline.backgroundColor = ColorMethodho(hexValue: 0xcccccc).cgColor
        self.layer.addSublayer(seline)
        
    }
    
    func navCloseTap() {
        delegate.leftIconClick()
    }
    
    func navCenterTap() {
        delegate.centerIconClick()
    }
    
    func navRightTap() {
        
        delegate.rightIconClick()
    }
    
    func changeRightIntoTitle(titelRight : String) {
        rightLabel.text = titelRight
        if titelRight == "image" {
            rightLabel.isHidden = true
            rightImageView.isHidden = false
        }else{
            rightLabel.isHidden = false
            rightImageView.isHidden = true
        }
    }
    
    func contentExit(state : Int) {
        contentExitTagOpen = state
        if state == 0 {
            rightLabel.textColor = ColorMethodho(hexValue: 0x333333).withAlphaComponent(0.3)
        }else if state == 1 {
            rightLabel.textColor = ColorMethodho(hexValue: 0x333333).withAlphaComponent(1.0)
        }
    }
    
    func leftIconName(iconName : String) {
        navCloseImage.image = UIImage.init(named: iconName)
    }

}
