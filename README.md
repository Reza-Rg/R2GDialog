# R2GDialog
A fully customizable and interactive dialog for iOS inspired by Swarm dialogs.

A pretty simple and fully customizable alertview, which you can interact with dialog by swiping and flinging it around!

##Preview
<img src="https://media.giphy.com/media/26FPFyzSRZOJvAxq0/giphy.gif" data-canonical-src="https://media.giphy.com/media/26FPFyzSRZOJvAxq0/giphy.gif" width="280"/>
<img src="https://media.giphy.com/media/l4KhMt7TXJuV5j81a/giphy.gif" data-canonical-src="https://media.giphy.com/media/l4KhMt7TXJuV5j81a/giphy.gif" width="280"/>

##Installation
Just copy `R2GDialog.swift` file from `R2GDialogClass` into your project, and you are good to go!

##Usage
You can see example for usage.

###Simple dialog:

```Swift
R2GDialog().show(
                self,
                title: "Hello World!",
                message: "This is pretty simple dialog! try to move or fling it!",
                negativeButtonText: "OK")
```

###Customized dialog

To customize dialog view, you should create a dictionary, and pass it to R2GDialog().

```Swift
        let alertview = R2GDialog()
        let options : Dictionary<String, AnyObject> = [
            keyTitleBackgrounColor : UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1.0),
            keyTitleTextColor : UIColor(red: 0.90, green: 0.63, blue: 0.22, alpha: 1.0),
            keyMessageBackgrounColor : UIColor(red: 0.21, green: 0.21, blue: 0.21, alpha: 1.0),
            keyMessageTextColor : UIColor.whiteColor(),
            keyMessageFont : UIFont(name: "futura", size: 18)!,
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
```

###Callbacks

You can add callbacks like:
```Swift
        alertview.show(
            self,
            title: "Bug report",
            message:"A critical error was occured! Would you like to report to developers?"
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
```
or:
```Swift
        alertview.onShow { () -> Void in
            //Do whatever you want!
            print("Dialog is showing!")
        }
        
        alertview.onPositiveClick { () -> Void in
            //Do whatever you want!
            self.i++
            print("Positive was tapped \(self.i)")
        }
```

###Customization
You can customize any of following attrs:
```
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
```

##Collaboration
Feel free to collaborate with ideas, issues and/or pull requests.

## License

    The MIT License (MIT)

    Copyright (c) 2014 codestergit

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
