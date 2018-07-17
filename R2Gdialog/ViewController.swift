//
//  ViewController.swift
//  R2Gdialog
//
//  Created by Reza Rg on 2/2/16.
//  Copyright © 2016 Reza Rg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    let dialogNames = ["Simple Dialog","Two Button Dialog", "No Message Dialog", "Customized Dialog", "Custom Dialog With Blur", "Dialog With Event Handler"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func tableView(_ tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return dialogNames.count;
    }
    

    
    
    @objc func tableView(_ tableView: UITableView!, cellForRowAtIndexPath indexPath: IndexPath!) -> UITableViewCell! {
        
        let  cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as!  CustomCell
        cell.dialogName.text = dialogNames[indexPath.row]

        return cell
    }
    
    @objc func tableView(_ tableView: UITableView!, didSelectRowAtIndexPath indexPath: IndexPath!) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            showSimpleDialog()
        case 1:
            showTwoButtonDialog()
        case 2:
            showNoMessageDialog()
        case 3:
            showCustomizedDialog()
        case 4:
            showCustomizedDialogWithBlurBg()
        case 5:
            showDialogWithEventHandler()
        default:
            showSimpleDialog()
        }

    }
    
    @objc func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
    }
    
    

    @IBAction func showDialog(_ sender: AnyObject) {
        
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
    
    
    func showSimpleDialog() {
        R2GDialog().show(self, title: "Hello World!", message: "This is pretty simple dialog! try to move or fling it!", negativeButtonText: "OK")
        
    }
    
    func showTwoButtonDialog() {
        let alertview = R2GDialog()
        
        alertview.show(
            self,
            title: "Rate our app!",
            message:"Please rate our app on the application store. We promise to update app every week with new features!"
            ,option:  [keyTitleBackgrounColor : UIColor(red: 0.11, green: 0.61, blue: 0.45, alpha: 1.0), keyTitleTextColor: UIColor.white]
            ,negativeButtonText: "👎"
            ,positiveButtonText:  "👍"
        )
        
    }
    
    func showNoMessageDialog() {
        R2GDialog().show(self, title: "1800MYAPPLE", negativeButtonText: "Cancel", positiveButtonText: "Call")
    }
    
    func showCustomizedDialog() {
        let alertview = R2GDialog()
        
        let messageFont = UIFont(name: "fontawesome", size: 20)
        
        let options : Dictionary<String, AnyObject> = [
            keyTitleBackgrounColor : UIColor(red: 0.80, green: 0.16, blue: 0.20, alpha: 1.0),
            keyTitleTextColor : UIColor.white,
            keyMessageBackgrounColor : UIColor.white,
            keyMessageTextColor : UIColor.black,
            keyNegativeBackgrounColor : UIColor(red: 0.07, green: 0.33, blue: 0.53, alpha: 1.0),
            keyPositiveBackgrounColor : UIColor(red: 0.25, green: 0.60, blue: 1.00, alpha: 1.0),
            keyNegativeTextColor: UIColor.white,
            keyPositiveTextColor: UIColor.white,
            keyAlertCornerRadius : 8 as AnyObject,
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
    
    func showCustomizedDialogWithBlurBg() {
        let alertview = R2GDialog()
        
        let messageFont = UIFont(name: "futura", size: 18)
        
        let options : Dictionary<String, AnyObject> = [
            keyTitleBackgrounColor : UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1.0),
            keyTitleTextColor : UIColor(red: 0.90, green: 0.63, blue: 0.22, alpha: 1.0),
            keyMessageBackgrounColor : UIColor(red: 0.21, green: 0.21, blue: 0.21, alpha: 1.0),
            keyMessageTextColor : UIColor.white,
            keyMessageFont : messageFont!,
            keyNegativeBackgrounColor : UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1.0),
            keyPositiveBackgrounColor : UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1.0),
            keyNegativeTextColor: UIColor(red: 0.74, green: 0.20, blue: 0.11, alpha: 1.0),
            keyPositiveTextColor: UIColor(red: 0.35, green: 0.35, blue: 0.35, alpha: 1.0),
            keyDividerColor : UIColor(red: 0.90, green: 0.63, blue: 0.22, alpha: 1.0),
            keyAlertCornerRadius : 0 as AnyObject,
            keyBackgroundBlur : "Dark" as AnyObject,
            
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
    
    func showDialogWithEventHandler() {
        
        func flingCallback() {
            print ("Dialog was flinged!")
        }
        
        let alertview = R2GDialog()
        
        
        let titleFont = UIFont(name: "fontawesome", size: 40)
        
        let options : Dictionary<String, AnyObject> = [
            keyTitleBackgrounColor : UIColor(red: 0.94, green: 0.11, blue: 0.44, alpha: 1.0),
            keyTitleTextColor : UIColor.white,
            keyAlertFontName : "avenir" as AnyObject,
            keyTitleFont : titleFont!,
            keyMessageBackgrounColor : UIColor(red: 0.94, green: 0.11, blue: 0.44, alpha: 1.0),
            keyMessageTextColor : UIColor.white,
            keyNegativeBackgrounColor : UIColor(red: 0.78, green: 0.10, blue: 0.36, alpha: 1.0),
            keyPositiveBackgrounColor : UIColor(red: 0.78, green: 0.10, blue: 0.36, alpha: 1.0),
            keyNegativeTextColor: UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.0),
            keyPositiveTextColor: UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.0),
            keyDividerStroke: 0 as AnyObject,
            keyAlertCornerRadius : 0 as AnyObject,
            keyBackgroundBlur : "Light" as AnyObject,
            
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
            ,onFling : flingCallback
            ,onDismisis:{
                //Do whatever you want!
                print("Dialog was dismissed")}
        )
        
        
        alertview.onShow { () -> Void in
            //Do whatever you want!
            print("Dialog is showing!")
        }
        
        alertview.onPositiveClick { () -> Void in
            //Do whatever you want!
            print("Positive was tapped")
        }   
    }
}

