#FXExpandableLabel

<img src="https://raw.githubusercontent.com/apploft/ExpandableLabel/master/Resources/ExpandableLabel.gif">

## Requirements
- iOS 9.0+

## Installtion

### Cocoapods
For FXImageTextView, use the following entry in your Podfile:
```rb
pod 'FXExpandableLabel', '~>0.1'
```

### Carthage
Make the following entry in your Cartfile:

```
github "feixue299/ExpandableLabelOC" ~> 0.1
```

# Usage
Using FXExpandableLabel is very simple. In your storyboard, set the custom class of your UILabel to FXExpandableLabel and set the desired number of lines (for the collapsed state):

_**Note:** In Carthage, set Module to `FXExpandableLabel`._

```swift
expandableLabel.numberOfLines = 3
```

Apart from that, one can modify the following settings:

##### delegate
Set a delegate to get notified in case the link has been touched.

##### collapsed
Set _true_ if the label should be collapsed or _false_ for expanded.

```swift
expandableLabel.collapsed = true
```

##### collapsedAttributedLink
Set the link name (and attributes) that is shown when collapsed.

```swift
expandableLabel.collapsedAttributedLink = NSAttributedString(string: "Read More")
```

##### expandedAttributedLink
Set the link name (and attributes) that is shown when expanded.
It is optional and can be nil.

```swift
expandableLabel.expandedAttributedLink = NSAttributedString(string: "Read Less")
```

##### setLessLinkWith(lessLink: String, attributes: [String: AnyObject], position: NSTextAlignment?)

Setter for expandedAttributedLink with caption, String attributes and optional horizontal alignment as NSTextAlignment.
If the parameter position is nil, the collapse link will be inserted at the end of the text.

```swift
expandableLabel.setLessLinkWith(lessLink: "Close", attributes: [NSForegroundColorAttributeName:UIColor.red], position: nil)
```
<img width="320" src="https://raw.githubusercontent.com/apploft/ExpandableLabel/master/Resources/MoreLessExpand.gif">

##### ellipsis
Set the ellipsis that appears just after the text and before the link.

```swift
expandableLabel.ellipsis = NSAttributedString(string: "...")
```

