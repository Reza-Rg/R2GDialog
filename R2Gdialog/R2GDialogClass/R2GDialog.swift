//
//  R2GDialog.swift
//  R2Gdialog
//
//  Created by Reza Rg on 2/2/16.
//  Copyright © 2016 Reza Rg. All rights reserved.
//

import Foundation
import UIKit

//AlertView
let keyBackgroundBlur = "BackgroundBlur"

let keyAlertCornerRadius = "AlertCornerRadius"
let keyAlertShadowColor = "AlertShadowColor"
let keyAlertShadowOpacity = "AlertShadowOpacity"

//Font
let keyAlertFontName = "AlertFontName"

let keyTitleFont = "TitleFont"
let keyMessageFont = "MessageFont"
let keyButtonsFont = "ButtonsFont"

let keyAlertTitleFontSize = "AlertTitleFontSize"
let keyAlertTextFontSize = "AlertTextFontSize"
let keyAlertButtonsFontSize = "AlertButtonsFontSize"

//TextColors
let keyTitleTextColor = "TitleTextColor"
let keyMessageTextColor = "MessageTextColor"

let keyNegativeTextColor = "NegativeTextColor"
let keyPositiveTextColor = "PositiveTextColor"

//BackgroundColor
let keyTitleBackgrounColor = "TitleBakcgrounColor"
let keyMessageBackgrounColor = "MessageBakcgrounColor"

let keyNegativeBackgrounColor = "NegativeBakcgrounColor"
let keyPositiveBackgrounColor = "PositiveBakcgrounColor"


//BorderSettings
let keyDividerStroke = "DividerWidth"
let keyDividerColor = "DividerColor"


class R2GDialog: UIViewController, UIGestureRecognizerDelegate {
    
    var isShowing = false
    
    @objc fileprivate dynamic var alertView : UIView!
    
    fileprivate let alertWidth : CGFloat = 270
    
    fileprivate var titleLabelMargin : CGFloat = 3
    fileprivate let messageLabelTopMargin : CGFloat = 8
    fileprivate let messageLabelSideMargin : CGFloat = 10
    
    fileprivate var buttonHeight : CGFloat = 40
    
    fileprivate var dividerHeight : CGFloat = 0.5
    
    fileprivate var cornerRadius :CGFloat = 8.0
    
    fileprivate var dividerColor : UIColor = UIColor.gray

    fileprivate var titleTextColor = UIColor.blue
    fileprivate var messageTextColor : UIColor = UIColor.black
    
    fileprivate var titleBackgrounColor = UIColor.white
    fileprivate var messageBackgrounColor = UIColor.white

    fileprivate var positiveBackgrounColor = UIColor.white
    fileprivate var negativeBackgrounColor = UIColor.white
    
    fileprivate var negativeTextColor = UIColor.red
    fileprivate var positiveTextColor = UIColor.blue
    
    fileprivate var shadowColor = UIColor.black.cgColor;
    fileprivate var shadowOpacity : Float = 0.3;
    
    fileprivate var buttonsFont : UIFont! = UIFont.systemFont(ofSize: 15)
    fileprivate var titleFont : UIFont! = UIFont.systemFont(ofSize: 16)
    fileprivate var messageFont : UIFont! = UIFont.systemFont(ofSize: 15)
    
    
    fileprivate var showAction : (()->Void)! = {}
    fileprivate var negativeAction:(()->Void)! = {}
    fileprivate var positiveAction:(()->Void)! = {}
    fileprivate var flingAction:(()->Void)! = {}
    fileprivate var dismissAction:(()->Void)! = {}
    fileprivate var touchOutsideAction:(()->Void)! = {}
    
    weak var rootViewController:UIViewController!
    
    fileprivate let velocityThreshold : CGFloat = 600
    
    fileprivate var animator : UIDynamicAnimator!
    
    fileprivate var attachment : UIAttachmentBehavior!
    fileprivate var snap : UISnapBehavior!
    fileprivate var gravity: UIGravityBehavior!
    
    fileprivate var closeType : CloseType = .fling
    
    fileprivate enum CloseType{
        case negative
        case positive
        case fling
        case touchOutside
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName:nibNameOrNil, bundle:nibBundleOrNil)
    }
    
    
    override internal func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let globalPoint = alertView.superview?.convert(alertView.center, to: nil)
        
        if(abs(globalPoint!.x)  > view.frame.width + 1.3 * (alertView.frame.width)){
            removeAlert()
            closeType = .fling
        }else if(globalPoint!.y > view.frame.height + 2 * alertView.frame.height){
            removeAlert()
            if (closeType == .negative || closeType == .positive ){
                
            }else{
                closeType = .fling
            }
        }else if(globalPoint!.y < 0 && abs(globalPoint!.y) > view.frame.height + 4 * alertView.frame.height){
            removeAlert()
            closeType = .fling
            
        }
        
    }
    
    func removeAlert(){
        
        if (!isShowing){
            return
        }
        
        isShowing = false
        
        self.alertView.removeObserver(self, forKeyPath: "center")
        self.view.alpha = 1
        UIView.animate(withDuration: 0.4, animations: {
            self.view.alpha = 0
            }, completion: { finished in
                self.animator.removeAllBehaviors()
                self.removeFromParentViewController()
                self.view.removeFromSuperview()
                
                
                switch self.closeType{
                case .negative:
                    if let _ = self.negativeAction{
                        self.negativeAction()
                    }
                case .positive:
                    self.positiveAction()
                case .fling:
                    self.flingAction()
                case .touchOutside:
                    self.touchOutsideAction()
                }
                
                self.dismissAction()
        })
    }
    
    
    func show(_ viewController: UIViewController, title : String!="" , message:String!="", option: Dictionary<String, AnyObject>?=nil, negativeButtonText:String, positiveButtonText:String?=nil, onNegativeClick:(()->Void)! = nil, onPositiveClick:(()->Void)! = nil, onShow:(()->Void)! = nil, onFling:(()->Void)! = nil ,onDismisis:(()->Void)! = nil ,onTouchOutside:(()->Void)! = nil) {
        
        self.rootViewController = viewController.view.window!.rootViewController
        self.rootViewController.addChildViewController(self)
        self.rootViewController.view.addSubview(view)
       
        
        if let c = option?[keyMessageTextColor] as? UIColor {
            messageTextColor = c
        }
        if let c = option?[keyTitleTextColor] as? UIColor {
            titleTextColor = c
        }
        if let c = option?[keyAlertCornerRadius] as? CGFloat {
            cornerRadius = c
        }
        
        if let c = option?[keyDividerStroke] as? CGFloat {
            dividerHeight = c
        }
        if let c = option?[keyDividerColor] as? UIColor {
            dividerColor = c
        }
        if let c = option?[keyNegativeBackgrounColor] as? UIColor {
            negativeBackgrounColor = c
        }
        if let c = option?[keyPositiveBackgrounColor] as? UIColor {
            positiveBackgrounColor = c
        }
        if let c = option?[keyTitleBackgrounColor] as? UIColor {
            titleBackgrounColor = c
        }
        if let c = option?[keyMessageBackgrounColor] as? UIColor {
            messageBackgrounColor = c
        }
        if let c = option?[keyNegativeTextColor] as? UIColor {
            negativeTextColor = c
        }
        if let c = option?[keyPositiveTextColor] as? UIColor {
            positiveTextColor = c
        }
        if let c = option?[keyAlertShadowColor] as? UIColor {
            shadowColor = c.cgColor
        }
        if let c = option?[keyAlertShadowOpacity] as? Float {
            shadowOpacity = c
        }
        if let c = option?[keyAlertFontName] as? String {
            buttonsFont = UIFont(name: c, size: 15)
            titleFont = UIFont(name: c, size: 16)
            messageFont = UIFont(name: c, size: 15)
        }
        if let c = option?[keyTitleFont] as? UIFont {
            titleFont = c
        }
        if let c = option?[keyMessageFont] as? UIFont {
            messageFont = c
        }
        if let c = option?[keyButtonsFont] as? UIFont {
            buttonsFont = c
        }
        if let c = option?[keyBackgroundBlur] as? String {
            
            
            let blurType : UIBlurEffectStyle
            switch c {
            case "Light":
                blurType = UIBlurEffectStyle.light
            case "ExtraLight":
                blurType = UIBlurEffectStyle.extraLight
            case "Dark":
                blurType = UIBlurEffectStyle.dark
            default:
                blurType = UIBlurEffectStyle.light
            }
            
            let blurEffect = UIBlurEffect(style: blurType)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
            view.addSubview(blurEffectView)
            
            blurEffectView.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
            blurEffectView.alpha = 1
                }, completion: { finished in

            })

            
        }else {
            self.view.backgroundColor = UIColor.clear
            UIView.animate(withDuration: 0.3, animations: {
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
                }, completion: { finished in
                    
            })
        }
        
        animator = UIDynamicAnimator(referenceView: view)

        
        var titleHeight : CGFloat = 0.0
        if (!title.isEmpty){
            titleHeight = getStringHeight(title, font: titleFont, width: alertWidth - 2 * (messageLabelSideMargin)) + (2 * (titleLabelMargin))
            if (titleHeight < 40.0){
                titleHeight = 40.0
            }
        }else{
            titleHeight = 0
        }
        
        var messageHeight : CGFloat = 0.0
        if (!message.isEmpty){
            messageHeight = getStringHeight(message, font: messageFont, width: alertWidth - 2 * (messageLabelSideMargin)) + (2 * (messageLabelTopMargin))
        }else{
            messageHeight = 0
        }


        let alertHeight = titleHeight + messageHeight + buttonHeight + (2 * dividerHeight)
        
        //AlerView
        let alertViewFrame: CGRect = CGRect(x: self.view.bounds.midX - alertWidth / 2, y: -1.2 * alertHeight, width: alertWidth, height: alertHeight)
        alertView = UIView(frame: alertViewFrame)
        alertView.backgroundColor = UIColor.clear
        alertView.layer.cornerRadius = cornerRadius;
        alertView.layer.shadowColor = UIColor.black.cgColor;
        alertView.layer.shadowOffset = CGSize(width: 0, height: 5);
        alertView.layer.masksToBounds = true
        if (cornerRadius > 1.0){
            alertView.layer.shadowOpacity = shadowOpacity
            alertView.layer.shadowRadius = cornerRadius
        }
        
        //Title
        let titleLabel = UIBorderedLabel(frame: CGRect(x: 0, y: 0, width: alertWidth , height: titleHeight))
        titleLabel.text = title
        titleLabel.backgroundColor = titleBackgrounColor
        titleLabel.textColor = titleTextColor
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = titleFont
        titleLabel.leftInset = messageLabelSideMargin
        titleLabel.rightInset = messageLabelSideMargin
        titleLabel.topInset = titleLabelMargin
        titleLabel.bottomInset = titleLabelMargin
        alertView.addSubview(titleLabel)
        
        //Divider
        if (!title.isEmpty){
            let line1 = drawLineFromPoint(0, y: titleHeight, width: alertWidth, lineColor: dividerColor, stroke: dividerHeight)
            alertView.addSubview(line1)
        }
        
        //Message
        let msgLabel = UIBorderedLabel(frame: CGRect(x: 0, y: titleHeight + dividerHeight, width: alertWidth, height: messageHeight))
        msgLabel.text = message
        msgLabel.font = messageFont
        msgLabel.numberOfLines = 0
        msgLabel.textAlignment = .center
        msgLabel.backgroundColor = messageBackgrounColor
        msgLabel.textColor = messageTextColor
        msgLabel.leftInset = messageLabelSideMargin
        msgLabel.rightInset = messageLabelSideMargin
        msgLabel.topInset = messageLabelTopMargin
        msgLabel.bottomInset = messageLabelTopMargin
        alertView.addSubview(msgLabel)
        
        //Divider
        if (!message.isEmpty){
            let line2 = drawLineFromPoint(0, y: titleHeight + messageHeight + dividerHeight, width: alertWidth, lineColor: dividerColor, stroke: dividerHeight)
            alertView.addSubview(line2)
        }
        
        //Negative Button
        let negativeButton = MyButton()
        negativeButton.setTitle(negativeButtonText, for: UIControlState())
        negativeButton.setTitleColor(negativeTextColor, for: UIControlState())
        negativeButton.setBg(negativeBackgrounColor)
        negativeButton.titleLabel!.font = buttonsFont
        negativeButton.frame = CGRect(x: 0, y: alertHeight - buttonHeight, width: alertWidth, height: buttonHeight)
        negativeButton.addTarget(self, action: #selector(R2GDialog.negativeTapped), for: UIControlEvents.touchUpInside)
        alertView.addSubview(negativeButton)
        
        //Positive Button
        if let _ = positiveButtonText{
            let positiveButton = MyButton()
            positiveButton.frame = CGRect(x: 0, y: alertHeight - buttonHeight, width: alertWidth / 2, height: buttonHeight)
            positiveButton.setTitle(positiveButtonText, for: UIControlState())
            positiveButton.setTitleColor(positiveTextColor, for: UIControlState())
            positiveButton.setBg(positiveBackgrounColor)
            positiveButton.titleLabel!.font = buttonsFont
            negativeButton.frame = CGRect(x: alertWidth / 2, y: alertHeight - buttonHeight, width: alertWidth / 2, height: buttonHeight)
            positiveButton.addTarget(self, action: #selector(R2GDialog.positiveTapped), for: UIControlEvents.touchUpInside)
            alertView.addSubview(positiveButton)
            
            //Divider
            let line3 = drawVerticalLineFromPoint((alertWidth - dividerHeight) / 2, y: alertHeight - buttonHeight, height: buttonHeight, lineColor: dividerColor, stroke: dividerHeight)
            alertView.addSubview(line3)
        }
        
        view.addSubview(alertView)

        //Liseners
        if onNegativeClick != nil {
            self.onNegativeClick(onNegativeClick)
        }
        if onPositiveClick != nil {
            self.onPositiveClick(onPositiveClick)
        }
        if onShow != nil {
            self.onShow(onShow)
        }
        if onFling != nil {
            self.onFling(onFling)
        }
        if onDismisis != nil {
            self.onDismisis(onDismisis)
        }
        if onTouchOutside != nil {
            self.onTouchOutside(onTouchOutside)
        }
        
        //UIDynamicBehaviors
        gravity = UIGravityBehavior(items: [alertView])
        snap = UISnapBehavior(item: alertView, snapTo: CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY))
        animator.addBehavior(snap)
        
        //Observer
        alertView.addObserver(self, forKeyPath: "center", options: NSKeyValueObservingOptions.new , context: nil)
        
        //Outside tap gesture recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(R2GDialog.tapped(_:)))
        view.addGestureRecognizer(tap)
        tap.delegate = self
        
        //Pan dialog gesture recognizer
        let pan = UIPanGestureRecognizer(target: self, action: #selector(R2GDialog.panned(_:)))
        alertView.addGestureRecognizer(pan)
        
        isShowing = true;
        self.showAction()
    }
    
    
    @objc internal func panned(_ pan: UIPanGestureRecognizer){
        let panLocationInView = pan.location(in: view)
        let panLocationInAlertView = pan.location(in: alertView)
        
        if(pan.state == .began){
            animator.removeAllBehaviors()
            let offset = UIOffsetMake(panLocationInAlertView.x - alertView.bounds.midX, panLocationInAlertView.y - alertView.bounds.midY);
            attachment = UIAttachmentBehavior(item: alertView, offsetFromCenter: offset, attachedToAnchor: panLocationInView)
            animator.addBehavior(attachment)
            
            
        }else if (pan.state == .changed){
            attachment.anchorPoint = panLocationInView
        }else if (pan.state == .ended){
            animator.removeAllBehaviors()
            let xVelocity = abs(pan.velocity(in: self.view).x)
            let yVelocity = abs(pan.velocity(in: self.view).y)
            let velocity = max(xVelocity, yVelocity)
            
            if(velocity > velocityThreshold){
                self.animator!.removeAllBehaviors()
                let itemBehavior = UIDynamicItemBehavior(items: [alertView]);
                itemBehavior.addLinearVelocity(pan.velocity(in: self.view), for: alertView)
                
                animator.addBehavior(itemBehavior)
                
                gravity.magnitude = 3.5
                animator.addBehavior(gravity)
                
                return;
            }
            
            if pan.translation(in: view).y > 100 {
                gravity.magnitude = 3.5
                animator.addBehavior(gravity)
            }else{
                animator.addBehavior(snap)
            }
        }
        
    }
    
    @objc func tapped (_ pan: UIPanGestureRecognizer){
        closeType = .touchOutside
        removeAlert()
    }
    
    @objc internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view!.isDescendant(of: alertView){
            return false
        }
        return true
    }
    
    
    
    
    func onShow(_ action: @escaping ()->Void) {
        self.showAction = action
    }
    func onFling(_ action: @escaping ()->Void) {
        self.flingAction = action
    }
    func onNegativeClick(_ action: @escaping ()->Void) {
        self.negativeAction = action
    }
    func onPositiveClick(_ action: @escaping ()->Void) {
        self.positiveAction = action
    }
    func onDismisis(_ action: @escaping ()->Void) {
        self.dismissAction = action
    }
    func onTouchOutside(_ action: @escaping ()->Void) {
        self.touchOutsideAction = action
    }
    
    @objc func positiveTapped(){
        animator.removeAllBehaviors()
        gravity.magnitude = 3.5
        animator.addBehavior(gravity)
        closeType = .positive
    }
    
    @objc func negativeTapped(){
        animator.removeAllBehaviors()
        gravity.magnitude = 3.5
        animator.addBehavior(gravity)
        closeType = .negative
    }
    
}


//Helpers:
func getStringHeight(_ mytext: String, font: UIFont, width: CGFloat)->CGFloat {
    let size = CGSize(width: width,height: CGFloat.greatestFiniteMagnitude)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineBreakMode = .byWordWrapping;
    let attributes = [NSAttributedStringKey.font:font,
        NSAttributedStringKey.paragraphStyle:paragraphStyle.copy()]
    
    let text = mytext as NSString
    let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
    return rect.size.height
}

func drawLineFromPoint(_ x : CGFloat, y:CGFloat, width:CGFloat, lineColor: UIColor, stroke:CGFloat) -> UIView {
    let rect: CGRect = CGRect(x: x, y: y, width: width, height: stroke)
    let lineView = UIView(frame: rect)
    lineView.backgroundColor = lineColor
    return lineView
}

func drawVerticalLineFromPoint(_ x : CGFloat, y:CGFloat, height:CGFloat, lineColor: UIColor, stroke:CGFloat) -> UIView {
    let rect: CGRect = CGRect(x: x, y: y, width: stroke, height: height)
    let lineView = UIView(frame: rect)
    lineView.backgroundColor = lineColor
    return lineView
}



//Custom Views
class MyButton : UIButton {
    typealias ControlState = UInt
    lazy fileprivate var backgroundColors = [ControlState: CGColor]()
    
    override internal var isEnabled: Bool {
        didSet {
            updateForStateChange()
        }
    }
    
    override internal var isHighlighted: Bool {
        didSet {
            updateForStateChange()
        }
    }
    
    override internal var isSelected: Bool {
        didSet {
            updateForStateChange()
        }
    }
    
    fileprivate func updateForStateChange() {
        changeBackgroundColorForStateChange()
    }
    
    fileprivate func changeBackgroundColorForStateChange(_ animated: Bool = false) {
        if let color = backgroundColors[state.rawValue] ?? backgroundColors[UIControlState().rawValue] {
            if layer.backgroundColor == nil || UIColor(cgColor: layer.backgroundColor!) != UIColor(cgColor: color) {
                layer.backgroundColor = color
            }
        }
    }
    
    internal func setBackgroundColor(_ color: UIColor, forState state: UIControlState = UIControlState(), animated: Bool = false) {
        backgroundColors[state.rawValue] = color.cgColor
        changeBackgroundColorForStateChange(animated)
    }
    
    func setBg(_ color: UIColor){
        setBackgroundColor(color, forState: UIControlState())
        setBackgroundColor(color.darkerColor(), forState: .highlighted)
    }
    
}


class UIBorderedLabel: UILabel {
    var topInset:       CGFloat = 0
    var rightInset:     CGFloat = 0
    var bottomInset:    CGFloat = 0
    var leftInset:      CGFloat = 0
    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: self.topInset, left: self.leftInset, bottom: self.bottomInset, right: self.rightInset)
        self.setNeedsLayout()
        return super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
}

//Extensions
extension UIColor {
    
    func darkerColor() -> UIColor {
        let color = self
        
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        
        if color.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: max(r - 0.2, 0.0), green: max(g - 0.2, 0.0), blue: max(b - 0.2, 0.0), alpha: a)
        }
        
        return UIColor()
    }
    
    
    func lighterColor() -> UIColor {
        let color = self
        
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        
        if color.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: min(r + 0.2, 1.0), green: min(g + 0.2, 1.0), blue: min(b + 0.2, 1.0), alpha: a)
        }
        
        return UIColor()
    }
    
}
