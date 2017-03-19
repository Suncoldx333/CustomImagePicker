//
//  ImagePickerBottomView.swift
//  SWCampus
//
//  Created by 11111 on 2017/3/6.
//  Copyright © 2017年 WanHang. All rights reserved.
//

import UIKit

@objc(ImagePickerBottomViewDelegate)
protocol ImagePickerBottomViewDelegate {
    func albumIconClick()
    func cameraIconClick()
}

public class ImagePickerBottomView: UIView {

    override init(frame: CGRect){
        super.init(frame: frame)
        initUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var delegate : ImagePickerBottomViewDelegate! = nil
    var albumLabel : UILabel!
    var cameraLabel : UILabel!
    var filterLabel : UILabel!
    public var bottomViewTypeOpen : Int{
        get{
            return bottomViewType
        }
        set(viewType){
            self.changeBottomType(type: viewType)
        }
    }
    var bottomViewType : Int!   //视图类型 0-图库/拍照 1-滤镜
    var curChose : Int!    //视图类型0时，当前选择的类型 0-图库，1-拍照
    
    func initUI() {
        curChose = 0
        self.frame = CGRect.init(x: 0, y: ScreenHeight - 40.5, width: ScreenWidth, height: 40.5)
        self.backgroundColor = ColorMethodho(hexValue: 0xfafafa)
        
        let typeChoseTap = UITapGestureRecognizer.init(target: self, action: #selector(typeChose(sender:)))
        self.addGestureRecognizer(typeChoseTap)
        
        let seline = CALayer.init()
        seline.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 0.5)
        seline.backgroundColor = ColorMethodho(hexValue: 0xcccccc).cgColor
        self.layer.addSublayer(seline)
        
        filterLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0.5, width: ScreenWidth, height: 40))
        filterLabel.text = "滤镜"
        filterLabel.textColor = ColorMethodho(hexValue: 0x333333)
        filterLabel.font = UIFont.boldSystemFont(ofSize: 13)
        filterLabel.textAlignment = NSTextAlignment.center
        filterLabel.isHidden = true
        self.addSubview(filterLabel)
        
        albumLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0.5, width: ScreenWidth/2, height: 40))
        albumLabel.text = "图库"
        albumLabel.textColor = ColorMethodho(hexValue: 0x333333)
        albumLabel.font = UIFont.boldSystemFont(ofSize: 13)
        albumLabel.textAlignment = NSTextAlignment.center
        albumLabel.isHidden = true
        self.addSubview(albumLabel)
        
        cameraLabel = UILabel.init(frame: CGRect.init(x: ScreenWidth/2, y: 0.5, width: ScreenWidth/2, height: 40))
        cameraLabel.text = "拍照"
        cameraLabel.textColor = ColorMethodho(hexValue: 0xb2b2b2)
        cameraLabel.font = UIFont.boldSystemFont(ofSize: 13)
        cameraLabel.textAlignment = NSTextAlignment.center
        cameraLabel.isHidden = true
        self.addSubview(cameraLabel)
        
    }
    
    func typeChose(sender : UITapGestureRecognizer) {
        let tapX : CGFloat = sender.location(in: self).x
        
        if bottomViewType == 0 {
            if tapX < ScreenWidth/2 {
                //点击图库
                if curChose == 0 {
                    print("repeat")
                }else{
                    curChose = 0
                    albumLabel.textColor = ColorMethodho(hexValue: 0x333333)
                    cameraLabel.textColor = ColorMethodho(hexValue: 0xb2b2b2)
                    delegate.albumIconClick()
                }
            }else{
                //点击拍照
                if curChose == 1 {
                    print("repeat")
                }else{
                    curChose = 1
                    albumLabel.textColor = ColorMethodho(hexValue: 0xb2b2b2)
                    cameraLabel.textColor = ColorMethodho(hexValue: 0x333333)
                    delegate.cameraIconClick()
                }
            }
        }else{
            print("filter")
        }
    }
    
    func changeBottomType(type : Int) {
        bottomViewType = type
        if type == 0 {
            filterLabel.isHidden = true
            albumLabel.isHidden = false
            cameraLabel.isHidden = false
        }else{
            filterLabel.isHidden = false
            albumLabel.isHidden = true
            cameraLabel.isHidden = true
        }
    }

}
