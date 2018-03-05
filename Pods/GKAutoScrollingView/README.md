# GKAutoScrollingView
[![codebeat badge](https://codebeat.co/badges/1e08e783-8fb1-485d-9ded-a21c461aef2f)](https://codebeat.co/projects/github-com-gkye-gkautoscrollingview)
[![Version](https://img.shields.io/cocoapods/v/GKAutoScrollingView.svg?style=flat)](http://cocoapods.org/pods/GKAutoScrollingView)
[![License](https://img.shields.io/cocoapods/l/GKAutoScrollingView.svg?style=flat)](http://cocoapods.org/pods/GKAutoScrollingView)
[![Platform](https://img.shields.io/cocoapods/p/GKAutoScrollingView.svg?style=flat)](http://cocoapods.org/pods/GKAutoScrollingView)

A customizable, easy to use infinite scroll view similar to the App Store banner.

![Demo](https://raw.githubusercontent.com/gkye/GKAutoScrollingView/master/demo.gif)

## Installation

GKAutoScrollingView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:
```ruby
pod "GKAutoScrollingView"
```

## Example

Check out the demo.

# Usage

1: Add `AutoScrollingView` to your `UIViewController`. <br>
2: Set `dataSource` and `delegate` (optional) 

```swift
class ViewController: UIViewController, AutoScrollingViewDataSource, AutoScrollingViewDelegate {
  var autoScrollView: AutoScrollingView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    autoScrollView = AutoScrollingView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300))
    autoScrollView.dataSource = self
    autoScrollView.delegate = self
    self.view.addSubview(autoScrollView)
  }
  
}
```
  3:  Conform to `AutoScrollingView` `dataSource`  
```swift
extension MyViewController: AutoScrollingViewDataSource{
  func createImageViews()->[UIImageView]{
    var array: [UIImageView] = []
    for index in 0...3 {
      let img = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300))
      img.image = UIImage(named: "\(index)")
      array.append(img)
    }
    return array
  }
  
  func setAutoScrollingViewDataSource(autoScrollingView: AutoScrollingView) -> [UIView] {
    return createImageViews()
  }
}
```
4: Conform to `AutoScrollingView` `delegate` (all optional)
```swift
extension MyViewController: AutoScrollingViewDelegate{
  func autoScrollingView(autoScrollingView: AutoScrollingView, didSelectItem index: Int) {
    print("did select")
  }
  
  func autoScrollingView(autoScrollingView: AutoScrollingView, didChangeStatus status: ScrollingState) {
    print(status.rawValue)
  }
  
  func autoScrollingView(autoScrollingView: AutoScrollingView, didAutoScroll index: Int) {
    print("auto scrolling at index ", index)
  }
}
```

# Protocols

### DataSource
Return an array of `UIView's` to be used within the `ScrollView`
```swift
  func setAutoScrollingViewDataSource(autoScrollingView: AutoScrollingView)->[UIView]
```

### Delegate

Returns the index of the selected view
```swift
optional func autoScrollingView(autoScrollingView: AutoScrollingView, didSelectItem index: Int)
```

Returns  the index of `currentItem` before view is scrolled
```swift
optional func autoScrollingView(autoScrollingView: AutoScrollingView, didAutoScroll index: Int)
```

Returns an `AutoScrollingView` the status of the scroll automation. (`Unpaused` or `Paused`
```swift
optional func autoScrollingView(autoScrollingView: AutoScrollingView, didChangeStatus status: ScrollingState)
```

### Methods 

Stops the automation of the `ScrollView`
```swift
pauseScrolling()
```

Starts the automation of scrolling (if scrolling is paused)
```
startScrolling()
```

### Properties 

Set the interval between `autoScrolling`. Default is `2.0` seconds.
```swift 
public var timerInterval: Double!
```
## License

GKAutoScrollingView is available under the MIT license. See the LICENSE file for more info.





