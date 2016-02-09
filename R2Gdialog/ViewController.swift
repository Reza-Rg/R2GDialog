//
//  ViewController.swift
//  R2Gdialog
//
//  Created by Reza Rg on 2/2/16.
//  Copyright © 2016 Reza Rg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var i = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func showDialog(sender: AnyObject) {
        
        func myCallback() {
            print ("called")
        }
        
        let alertview = R2GDialog()
        
        alertview.onShow { () -> Void in
            print("Showing dialog")
        }
        alertview.onPositiveClick { () -> Void in
            print("Positive clicked")
        }
        alertview.onNegativeClick { () -> Void in
            print("Negative clicked")
        }
        alertview.onFling { () -> Void in
            print("Dialog flinged")
        }
        alertview.onTouchOutside { () -> Void in
            print("Touched outside ")
        }
        alertview.onDismisis{ () -> Void in
            print("Dialod dismissed")
        }
        
        
    }
    
    
    @IBAction func showSimpleDialog(sender: AnyObject) {
        R2GDialog().show(self, title: "Hello World!", message: "This is pretty simple dialog! try to move or fling it!", negativeButtonText: "OK")
        
    }
    
    @IBAction func showTwoButtonDialog(sender: AnyObject) {
        let alertview = R2GDialog()
        
        alertview.show(
            self,
            title: "Rate our app!",
            message:"Please rate our app on the application store. We promise to update app every week with new features!"
            ,option:  [keyTitleBackgrounColor : UIColor(red: 0.11, green: 0.61, blue: 0.45, alpha: 1.0), keyTitleTextColor: UIColor.whiteColor()]
            ,negativeButtonText: "👎"
            ,positiveButtonText:  "👍"
        )
        
    }
    
    @IBAction func showNoMessageDialog(sender: AnyObject) {
        R2GDialog().show(self, title: "1800MYAPPLE", negativeButtonText: "Cancel", positiveButtonText: "Call")
    }
    
    @IBAction func showCustomizedDialog(sender: AnyObject) {
        let alertview = R2GDialog()
        
        let messageFont = UIFont(name: "fontawesome", size: 20)
        
        let options : Dictionary<String, AnyObject> = [
            keyTitleBackgrounColor : UIColor(red: 0.80, green: 0.16, blue: 0.20, alpha: 1.0),
            keyTitleTextColor : UIColor.whiteColor(),
            keyMessageBackgrounColor : UIColor.whiteColor(),
            keyMessageTextColor : UIColor.blackColor(),
            keyNegativeBackgrounColor : UIColor(red: 0.07, green: 0.33, blue: 0.53, alpha: 1.0),
            keyPositiveBackgrounColor : UIColor(red: 0.25, green: 0.60, blue: 1.00, alpha: 1.0),
            keyNegativeTextColor: UIColor.whiteColor(),
            keyPositiveTextColor: UIColor.whiteColor(),
            keyAlertCornerRadius : 8,
            keyButtonsFont : messageFont!,
            
        ]
        
        
        alertview.show(
            self,
            title: "Lorem ipsum dolor sit amet",
            message:"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus."
            ,option: options
            ,negativeButtonText: ""
            ,positiveButtonText:  ""
        )
        
    }
    
    @IBAction func showCustomizedDialogWithBlurBg(sender: AnyObject) {
        let alertview = R2GDialog()
        
        let messageFont = UIFont(name: "futura", size: 18)
        
        let options : Dictionary<String, AnyObject> = [
            keyTitleBackgrounColor : UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1.0),
            keyTitleTextColor : UIColor(red: 0.90, green: 0.63, blue: 0.22, alpha: 1.0),
            keyMessageBackgrounColor : UIColor(red: 0.21, green: 0.21, blue: 0.21, alpha: 1.0),
            keyMessageTextColor : UIColor.whiteColor(),
            keyMessageFont : messageFont!,
            keyNegativeBackgrounColor : UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1.0),
            keyPositiveBackgrounColor : UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1.0),
            keyNegativeTextColor: UIColor(red: 0.74, green: 0.20, blue: 0.11, alpha: 1.0),
            keyPositiveTextColor: UIColor(red: 0.35, green: 0.35, blue: 0.35, alpha: 1.0),
            keyDividerColor : UIColor(red: 0.90, green: 0.63, blue: 0.22, alpha: 1.0),
            keyAlertCornerRadius : 0,
            keyBackgroundBlur : "Dark",
            
        ]
        
        
        alertview.show(
            self,
            title: "Uninstall application?",
            message:"Are you sure you want to uninstall such an awesome application? You will regret this action, and we miss you."
            ,option: options
            ,negativeButtonText: "Yes!"
            ,positiveButtonText:  "No!"
        )
        
    }
    
    @IBAction func showDialogWithEventHandler(sender: AnyObject) {
        
        
        func flingCallback() {
            print ("Dialog was flinged!")
        }
        
        let alertview = R2GDialog()
        
        
        let titleFont = UIFont(name: "fontawesome", size: 40)
        
        let options : Dictionary<String, AnyObject> = [
            keyTitleBackgrounColor : UIColor(red: 0.94, green: 0.11, blue: 0.44, alpha: 1.0),
            keyTitleTextColor : UIColor.whiteColor(),
            keyAlertFontName : "avenir",
            keyTitleFont : titleFont!,
            keyMessageBackgrounColor : UIColor(red: 0.94, green: 0.11, blue: 0.44, alpha: 1.0),
            keyMessageTextColor : UIColor.whiteColor(),
            keyNegativeBackgrounColor : UIColor(red: 0.78, green: 0.10, blue: 0.36, alpha: 1.0),
            keyPositiveBackgrounColor : UIColor(red: 0.78, green: 0.10, blue: 0.36, alpha: 1.0),
            keyNegativeTextColor: UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.0),
            keyPositiveTextColor: UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.0),
            keyDividerStroke: 0,
            keyAlertCornerRadius : 0,
            keyBackgroundBlur : "Light",
            
        ]
        
        alertview.show(
            self,
            title: "",
            message:"A critical error was occured! Would you like to report to developers?"
            ,option: options
            ,negativeButtonText: "Nope!"
            ,positiveButtonText:  "Sure!"
            ,onNegativeClick:{
                //Do whatever you want!
                print("You selected no")}
            ,onDismisis:{
                //Do whatever you want!
                print("Dialog was dismissed")}
            ,onFling : flingCallback
        )
        
        
        alertview.onShow { () -> Void in
            //Do whatever you want!
            print("Dialog is showing!")
        }
        
        alertview.onPositiveClick { () -> Void in
            //Do whatever you want!
            self.i++
            print("Positive was tapped \(self.i)")
        }
        
        
    }
    
    
    
    
    
    
    
    
}

