# Stylish
### _Stylesheets For Storyboards_
Stylish is a library that lets you create stylesheets in code or in JSON for controlling virtually any property of your UIViews, UILabels, UIButtons, etc. as well as the properties of any custom views you create yourself.

![][image-1]

The real magic happens in storyboards, however, where you can assign one or more styles to a view, label, button, etc. right inside the Interface Builder inspector, and immediately see the live preview of the applied styles right inside the storyboard.  No need to compile or run the app in the simulator or on device, since Stylish uses @IBDesignable to apply styles at design time as well.  

For the first time, this provides a single solution for creating and applying styles and themes that are rendered both in the running app _and_ in the storyboard. So what you see at design time will finally match what users will see in the app. 

- Get the full benefits of a real styling system: update a style in one place, and every view using that style updates as well.  Only now, they update both at runtime _and_ in the storyboard.
- Change the global stylesheet either in your info.plist, or in the code at runtime, and the app instantly updates to reflect the new theme.
- Stylish is completely customizable and extensible, but it comes with a full implementation of stylesheet parsing from JSON. Your app can even load updated stylesheets over the web and cache them as the new default theme, allowing you to tweak the the appearance or any other property of your objects after the app is deployed, or based on user, time of year, etc. 
- Stylish makes it easy to rapidly test our and iterate on designs right from Xcode:  you can apply or remove multiple styles in real time, right from the storyboard and see immediately how they will look on device.  Or, update your JSON stylesheet in one window while your storyboard auto-updates with the changes in another window.

## Installation

Since Swift has not yet reached ABI or module format stability, Apple does not support or advise distributing Swift libraries compiled outside of your project.  Instead, the recommended approach is: 

1. Include the Stylish repo (this repo) as a git submodule in your project (or just check out the version of the entire Stylish repo you want to use and add it to your project as a subdirectory)
2. Drag Stylish.xcodeproj into your own Xcode project or workspace (see the StylishExample project in this repo as a reference)
3. In your own app target(s) on the "General" tab, scroll down to "Embedded Binaries", click the plus button and choose Stylish.framework. Again, you can refer to the StylishExample project to see what this looks like.

These steps will ensure that the Stylish framework is compiled as part of your own app's build phases as needed and that the Stylish.framework will be using the same version of Swift and the Swift compiler as the rest of your project.

- (**_Optional but recommended_**) add a key called “Stylesheet” to your app’s info.plist. The value of this key will tell Stylish which Stylesheet class to load by default, both during design and at runtime.
- In order to use a JSON stylesheet, add a file called stylesheet.json to your app bundle, and specify “JSONStylesheet” as the value for the “Stylesheet” key you added in info.plist. See information below for adding style classes to your stylesheet.json so they can be used in your app.

## Example Project

To see Stylish in action, download the the folder “StylishExample” from this repo and open it in the latest version of Xcode. Open “Main.Storyboard” in Interface Builder and watch after a moment as the unstyled labels, buttons, and views are suddenly rendered fully styled right in Xcode. 

Now, go the the info.plist for the StylishExample app and change the “Stylesheet” key’s value from “Graphite” to “Aqua”. Then return to Main.storyboard and watch as the appearance of the scene completely changes without writing any code or even compiled the app.

Go back to the info.plist and change the value for the key “Stylesheet” to now be “JSONStylesheet”.  Go back to Main.storyboard and once again, the whole scene will transform to reflect the new Stylesheet loaded from JSON. 

At this point, you can open stylesheet.json in Xcode and start changing some of the color, font, or other values in the stylesheet, then return to Main.storyboard to watch the changes you made appear live in Interface Builder.

Or, you can create a new storyboard from scratch, add views, labels, buttons, and images and then add the already-defined styles from the sample project to those views using the inspector and watch them immediately take effect. To set styles in the storyboard, select the view you want to style, and go to the attributes inspector tab in the right panel of Xcode.  This is the tab where you normally set things like color, alpha, font, etc. At the top you will see two new fields you can fill out:  “styles” and “stylesheet”.  

These fields only appear for view classes that conform to the “Styleable” protocol and which are “@IBDesignable”.  Unfortunately, it’s not possible to add “@IBDesignable” via extension, so for plain UIKit components, you have to set their custom class to the Stylish version of them: `StyleableUIView`, `StyleableUILabel`, `StyelableUIButton`, and `StyleableUIImageView`.

- After you have placed some Styleable components in your blank storyboard, try adding some of these styles to buttons or plain views:  `PrimaryBackgroundColor`, `SecondaryBackgroundColor`, or `Rounded`

- For buttons, add the style: `DefaultButton`

- For labels, try some of these `HeaderText`, `BodyText`, `ThemeTitle`, or `HighlightedText`

In Stylish, styles are not inherited, but they are additive, so you can assign multiple styles to a view by separating their names with a comma, e.g.  `PrimaryBackgroundColor, Rounded` will  first apply the style “PrimaryBackgroundColor” to the view, and then it will apply the style “Rounded”. If “Rounded” defines values for certain properties that are different than what “PrimaryBackgroundColor” defined for those same properties, the values from “Rounded” will overwrite the previous values, since it is listed after “PrimaryBackgroundColor” in the list of styles.  This approach gives you very fine control over exactly how you want to combine and reuse styles for any given view. 

To see an example of how to make one of your own custom views Styleable and live previewable in the storyboard with Stylish, take a look at the example inside “ProgressBar.swift”

Lastly, you can try creating some of your own defined styles by opening “Aqua.swift” or “Graphite.swift” and following the instructions and comments in either of those two files. 


## Creating a Style

A simple Style Class looks like this:

```
struct RoundedStyle : StyleClass {
    var stylePropertySets = StylePropertySetCollection()
    
    init() {
        UIView.cornerRadius = 20.0
    }
} 
```

It gets added to a Stylesheet along with a string identifier like this:

```
class MyStylesheet : Stylesheet {
    let styleClasses:[(identifier:String, styleClass:StyleClass)]()

    required init() {
         styleClasses = [(“Rounded", RoundedStyle())]()
    }
```

Alternative, the same Stylesheet and Style can be created in JSON like this:

```
[  
{  
    "styleClass" : “Rounded”,  
    "properties" :  [  
         {  
         "propertySetName" : "UIViewPropertySet",  
         "propertyName" : “cornerRadius”,  
         "propertyType" : “cgfloat”,  
         "propertyValue" : 20.0  
         }  
     ]  
}  
]
```

To now apply this style to a view in a Storyboard, make sure the view is set to a custom class that implements the Styelable protocol (e.g. StyleableUIView), select it on the canvas, go to the Attributes Inspector in the right-hand panel of Xcode and add the string `Rounded` to the field at the top of the panel labeled "styles" and the string `MyStylesheet` to the field labeled "Stylesheet".  When you press Return / Enter, the view will update immediately on the canvas.  

## Terminology

**StyleClass**: A set of values that will be applied to a set of corresponding properties on a target view. Same concept as in CSS.  “StyleClass” and “Style” are often used interchangeably.

**Stylesheet**: A collection of named Styles (a.k.a. StyleClasses) that tie together into a theme.  For example, a Stylesheet called “Default” may define Styles called “Header”, “Body”, “Highlighted”, etc. And in this Stylesheet, the “Body” style may define a value of 16 pts for the fontSize property of any targeted view. There might be another Stylesheet called “Large Type” that also defines Styles / StyleClasses with the names “Header”, “Body”, and “Highlighted”.  But in the “Large Type” Stylesheet, the “Body” style has a value of 28 pts for the fontSize property. In the app, a label with the style “Body” will be set to a font size of 16 pts when the “Default” Stylesheet is active, and 28 pts when the “Large Type” Stylesheet is active.  So views are associated with fixed Style names, and Stylesheets define different sets of values for the same collection of named Styles.  

**StylePropertySet**: A struct that groups together and defines what  properties of a particular type of view can have values defined for them.

**Styleable**: The protocol that classes must conform to to participate in the Stylish process. Adopting this protocol automatically adds some method implementations to the class, as well as some requirement. 

**@IBDesignable**: An attribute that can be added to any UIView subclass which indicates to Interface Builder / Xcode that it should be rendered live on the storyboard canvas.

## Help

If you have any questions or need help customizing or using Stylish in your project, please open an issue in this repo, or feel free to contact me via

Twitter: @\_danielhall   
Email: daniel@danielhall.io


Happy Styling!



[image-1]:	Stylish.gif
