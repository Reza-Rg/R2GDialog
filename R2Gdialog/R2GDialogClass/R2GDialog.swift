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
    
    private dynamic var alertView : UIView!
    
    private let alertWidth : CGFloat = 270
    
    private var titleLabelMargin : CGFloat = 3
    private let messageLabelTopMargin : CGFloat = 8
    private let messageLabelSideMargin : CGFloat = 10
    
    private var buttonHeight : CGFloat = 40
    
    private var dividerHeight : CGFloat = 0.5
    
    private var cornerRadius :CGFloat = 8.0
    
    private var dividerColor : UIColor = UIColor.grayColor()

    private var titleTextColor = UIColor.blueColor()
    private var messageTextColor : UIColor = UIColor.blackColor()
    
    private var titleBackgrounColor = UIColor.whiteColor()
    private var messageBackgrounColor = UIColor.whiteColor()

    private var positiveBackgrounColor = UIColor.whiteColor()
    private var negativeBackgrounColor = UIColor.whiteColor()
    
    private var negativeTextColor = UIColor.redColor()
    private var positiveTextColor = UIColor.blueColor()
    
    private var shadowColor = UIColor.blackColor().CGColor;
    private var shadowOpacity : Float = 0.3;
    
    private var buttonsFont : UIFont! = UIFont.systemFontOfSize(15)
    private var titleFont : UIFont! = UIFont.systemFontOfSize(16)
    private var messageFont : UIFont! = UIFont.systemFontOfSize(15)
    
    
    private var showAction : (()->Void)! = {}
    private var negativeAction:(()->Void)! = {}
    private var positiveAction:(()->Void)! = {}
    private var flingAction:(()->Void)! = {}
    private var dismissAction:(()->Void)! = {}
    private var touchOutsideAction:(()->Void)! = {}
    
    weak var rootViewController:UIViewController!
    
    private let velocityThreshold : CGFloat = 600
    
    private var animator : UIDynamicAnimator!
    
    private var attachment : UIAttachmentBehavior!
    private var snap : UISnapBehavior!
    private var gravity: UIGravityBehavior!
    
    private var closeType : CloseType = .Fling
    
    private enum CloseType{
        case Negative
        case Positive
        case Fling
        case TouchOutside
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName:nibNameOrNil, bundle:nibBundleOrNil)
    }
    
    
    override internal func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        let globalPoint = alertView.superview?.convertPoint(alertView.center, toView: nil)
        
        if(abs(globalPoint!.x)  > view.frame.width + 1.3 * (alertView.frame.width)){
            removeAlert()
            closeType = .Fling
        }else if(globalPoint!.y > view.frame.height + 2 * alertView.frame.height){
            removeAlert()
            if (closeType == .Negative || closeType == .Positive ){
                
            }else{
                closeType = .Fling
            }
        }else if(globalPoint!.y < 0 && abs(globalPoint!.y) > view.frame.height + 4 * alertView.frame.height){
            removeAlert()
            closeType = .Fling
            
        }
        
    }
    
    func removeAlert(){
        
        if (!isShowing){
            return
        }
        
        isShowing = false
        
        self.alertView.removeObserver(self, forKeyPath: "center")
        self.view.alpha = 1
        UIView.animateWithDuration(0.4, animations: {
            self.view.alpha = 0
            }, completion: { finished in
                self.animator.removeAllBehaviors()
                self.removeFromParentViewController()
                self.view.removeFromSuperview()
                
                
                switch self.closeType{
                case .Negative:
                    if let _ = self.negativeAction{
                        self.negativeAction()
                    }
                case .Positive:
                    self.positiveAction()
                case .Fling:
                    self.flingAction()
                case .TouchOutside:
                    self.touchOutsideAction()
                }
                
                self.dismissAction()
        })
    }
    
    
    func show(viewController: UIViewController, title : String!="" , message:String!="", option: Dictionary<String, AnyObject>?=nil, negativeButtonText:String, positiveButtonText:String?=nil, onNegativeClick:(()->Void)! = nil, onPositiveClick:(()->Void)! = nil, onShow:(()->Void)! = nil, onFling:(()->Void)! = nil ,onDismisis:(()->Void)! = nil ,onTouchOutside:(()->Void)! = nil) {
        
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
            shadowColor = c.CGColor
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
                blurType = UIBlurEffectStyle.Light
            case "ExtraLight":
                blurType = UIBlurEffectStyle.ExtraLight
            case "Dark":
                blurType = UIBlurEffectStyle.Dark
            default:
                blurType = UIBlurEffectStyle.Light
            }
            
            let blurEffect = UIBlurEffect(style: blurType)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
            view.addSubview(blurEffectView)
            
            blurEffectView.alpha = 0
            UIView.animateWithDuration(0.3, animations: {
            blurEffectView.alpha = 1
                }, completion: { finished in

            })

            
        }else {
            self.view.backgroundColor = UIColor.clearColor()
            UIView.animateWithDuration(0.3, animations: {
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
        let alertViewFrame: CGRect = CGRectMake(CGRectGetMidX(self.view.bounds) - alertWidth / 2, -1.2 * alertHeight, alertWidth, alertHeight)
        alertView = UIView(frame: alertViewFrame)
        alertView.backgroundColor = UIColor.clearColor()
        alertView.layer.cornerRadius = cornerRadius;
        alertView.layer.shadowColor = UIColor.blackColor().CGColor;
        alertView.layer.shadowOffset = CGSizeMake(0, 5);
        alertView.layer.masksToBounds = true
        if (cornerRadius > 1.0){
            alertView.layer.shadowOpacity = shadowOpacity
            alertView.layer.shadowRadius = cornerRadius
        }
        
        //Title
        let titleLabel = UIBorderedLabel(frame: CGRectMake(0, 0, alertWidth , titleHeight))
        titleLabel.text = title
        titleLabel.backgroundColor = titleBackgrounColor
        titleLabel.textColor = titleTextColor
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .Center
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
        let msgLabel = UIBorderedLabel(frame: CGRectMake(0, titleHeight + dividerHeight, alertWidth, messageHeight))
        msgLabel.text = message
        msgLabel.font = messageFont
        msgLabel.numberOfLines = 0
        msgLabel.textAlignment = .Center
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
        negativeButton.setTitle(negativeButtonText, forState: UIControlState.Normal)
        negativeButton.setTitleColor(negativeTextColor, forState: .Normal)
        negativeButton.setBg(negativeBackgrounColor)
        negativeButton.titleLabel!.font = buttonsFont
        negativeButton.frame = CGRectMake(0, alertHeight - buttonHeight, alertWidth, buttonHeight)
        negativeButton.addTarget(self, action: Selector("negativeTapped"), forControlEvents: UIControlEvents.TouchUpInside)
        alertView.addSubview(negativeButton)
        
        //Positive Button
        if let _ = positiveButtonText{
            let positiveButton = MyButton()
            positiveButton.frame = CGRectMake(0, alertHeight - buttonHeight, alertWidth / 2, buttonHeight)
            positiveButton.setTitle(positiveButtonText, forState: UIControlState.Normal)
            positiveButton.setTitleColor(positiveTextColor, forState: .Normal)
            positiveButton.setBg(positiveBackgrounColor)
            positiveButton.titleLabel!.font = buttonsFont
            negativeButton.frame = CGRectMake(alertWidth / 2, alertHeight - buttonHeight, alertWidth / 2, buttonHeight)
            positiveButton.addTarget(self, action: Selector("positiveTapped"), forControlEvents: UIControlEvents.TouchUpInside)
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
        snap = UISnapBehavior(item: alertView, snapToPoint: CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)))
        animator.addBehavior(snap)
        
        //Observer
        alertView.addObserver(self, forKeyPath: "center", options: NSKeyValueObservingOptions.New , context: nil)
        
        //Outside tap gesture recognizer
        let tap = UITapGestureRecognizer(target: self, action: "tapped:")
        view.addGestureRecognizer(tap)
        tap.delegate = self
        
        //Pan dialog gesture recognizer
        let pan = UIPanGestureRecognizer(target: self, action: "panned:")
        alertView.addGestureRecognizer(pan)
        
        isShowing = true;
        self.showAction()
    }
    
    
    internal func panned(pan: UIPanGestureRecognizer){
        let panLocationInView = pan.locationInView(view)
        let panLocationInAlertView = pan.locationInView(alertView)
        
        if(pan.state == .Began){
            animator.removeAllBehaviors()
            let offset = UIOffsetMake(panLocationInAlertView.x - CGRectGetMidX(alertView.bounds), panLocationInAlertView.y - CGRectGetMidY(alertView.bounds));
            attachment = UIAttachmentBehavior(item: alertView, offsetFromCenter: offset, attachedToAnchor: panLocationInView)
            animator.addBehavior(attachment)
            
            
        }else if (pan.state == .Changed){
            attachment.anchorPoint = panLocationInView
        }else if (pan.state == .Ended){
            animator.removeAllBehaviors()
            let xVelocity = abs(pan.velocityInView(self.view).x)
            let yVelocity = abs(pan.velocityInView(self.view).y)
            let velocity = max(xVelocity, yVelocity)
            
            if(velocity > velocityThreshold){
                self.animator!.removeAllBehaviors()
                let itemBehavior = UIDynamicItemBehavior(items: [alertView]);
                itemBehavior.addLinearVelocity(pan.velocityInView(self.view), forItem: alertView)
                
                animator.addBehavior(itemBehavior)
                
                gravity.magnitude = 3.5
                animator.addBehavior(gravity)
                
                return;
            }
            
            if pan.translationInView(view).y > 100 {
                gravity.magnitude = 3.5
                animator.addBehavior(gravity)
            }else{
                animator.addBehavior(snap)
            }
        }
        
    }
    
    func tapped (pan: UIPanGestureRecognizer){
        closeType = .TouchOutside
        removeAlert()
    }
    
    @objc internal func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if touch.view!.isDescendantOfView(alertView){
            return false
        }
        return true
    }
    
    
    
    
    func onShow(action: ()->Void) {
        self.showAction = action
    }
    func onFling(action: ()->Void) {
        self.flingAction = action
    }
    func onNegativeClick(action: ()->Void) {
        self.negativeAction = action
    }
    func onPositiveClick(action: ()->Void) {
        self.positiveAction = action
    }
    func onDismisis(action: ()->Void) {
        self.dismissAction = action
    }
    func onTouchOutside(action: ()->Void) {
        self.touchOutsideAction = action
    }
    
    func positiveTapped(){
        animator.removeAllBehaviors()
        gravity.magnitude = 3.5
        animator.addBehavior(gravity)
        closeType = .Positive
    }
    
    func negativeTapped(){
        animator.removeAllBehaviors()
        gravity.magnitude = 3.5
        animator.addBehavior(gravity)
        closeType = .Negative
    }
    
}


//Helpers:
func getStringHeight(mytext: String, font: UIFont, width: CGFloat)->CGFloat {
    let size = CGSizeMake(width,CGFloat.max)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineBreakMode = .ByWordWrapping;
    let attributes = [NSFontAttributeName:font,
        NSParagraphStyleAttributeName:paragraphStyle.copy()]
    
    let text = mytext as NSString
    let rect = text.boundingRectWithSize(size, options:.UsesLineFragmentOrigin, attributes: attributes, context:nil)
    return rect.size.height
}

func drawLineFromPoint(x : CGFloat, y:CGFloat, width:CGFloat, lineColor: UIColor, stroke:CGFloat) -> UIView {
    let rect: CGRect = CGRectMake(x, y, width, stroke)
    let lineView = UIView(frame: rect)
    lineView.backgroundColor = lineColor
    return lineView
}

func drawVerticalLineFromPoint(x : CGFloat, y:CGFloat, height:CGFloat, lineColor: UIColor, stroke:CGFloat) -> UIView {
    let rect: CGRect = CGRectMake(x, y, stroke, height)
    let lineView = UIView(frame: rect)
    lineView.backgroundColor = lineColor
    return lineView
}



//Custom Views
class MyButton : UIButton {
    typealias ControlState = UInt
    lazy private var backgroundColors = [ControlState: CGColor]()
    
    override internal var enabled: Bool {
        didSet {
            updateForStateChange()
        }
    }
    
    override internal var highlighted: Bool {
        didSet {
            updateForStateChange()
        }
    }
    
    override internal var selected: Bool {
        didSet {
            updateForStateChange()
        }
    }
    
    private func updateForStateChange() {
        changeBackgroundColorForStateChange()
    }
    
    private func changeBackgroundColorForStateChange(animated: Bool = false) {
        if let color = backgroundColors[state.rawValue] ?? backgroundColors[UIControlState.Normal.rawValue] {
            if layer.backgroundColor == nil || UIColor(CGColor: layer.backgroundColor!) != UIColor(CGColor: color) {
                layer.backgroundColor = color
            }
        }
    }
    
    internal func setBackgroundColor(color: UIColor, forState state: UIControlState = .Normal, animated: Bool = false) {
        backgroundColors[state.rawValue] = color.CGColor
        changeBackgroundColorForStateChange(animated)
    }
    
    func setBg(color: UIColor){
        setBackgroundColor(color, forState: .Normal)
        setBackgroundColor(color.darkerColor(), forState: .Highlighted)
    }
    
}


class UIBorderedLabel: UILabel {
    var topInset:       CGFloat = 0
    var rightInset:     CGFloat = 0
    var bottomInset:    CGFloat = 0
    var leftInset:      CGFloat = 0
    override func drawTextInRect(rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: self.topInset, left: self.leftInset, bottom: self.bottomInset, right: self.rightInset)
        self.setNeedsLayout()
        return super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
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
