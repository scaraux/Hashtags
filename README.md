# Hashtags

[![CI Status](https://img.shields.io/travis/gottingoscar@gmail.com/Hashtags.svg?style=flat)](https://travis-ci.org/gottingoscar@gmail.com/Hashtags)
[![Version](https://img.shields.io/cocoapods/v/Hashtags.svg?style=flat)](https://cocoapods.org/pods/Hashtags)
[![License](https://img.shields.io/cocoapods/l/Hashtags.svg?style=flat)](https://cocoapods.org/pods/Hashtags)
[![Platform](https://img.shields.io/cocoapods/p/Hashtags.svg?style=flat)](https://cocoapods.org/pods/Hashtags)


Hashtags is a Swift library for displaying, customizing and interacting with a list of #hashtags

## :star: Features
- Simplistic and easy to use
- Fully customizable
- Dynamic height


##  📲 Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## 📋 Requirements

Hashtags requires iOS 9 and Swift 4

##  📦 Installation

Hashtags is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Hashtags'
```

## 😏 Usage

### Basics

#### 1) Create a Hashtag

```swift
let tag = HashTag(word: "another", isRemovable: true)
```

The boolean `isRemovable` defines if the hashtag can be removed from the list, by displaying a button next to it.

####  2) Create the view

You can use the Hashtags view either directly from the code, or through your Interface Builder.

#####  With code:

```swift
var hashtags = HashtagView(frame: ...)

hashtags.backgroundColor = UIColor.lightGray
hashtags.tagBackgroundColor = UIColor.blue
hashtags.cornerRadius = 5.0
hashtags.tagCornerRadius = 5.0
hashtags.tagPadding = 5.0
hashtags.horizontalTagSpacing = 7.0
hashtags.verticalTagSpacing = 5.0

self.view.addSubview(hashtags)
```

####  With Interface builder:


#### 3) Add hashtags to the view

```swift
let hashtag = ...
hashtagsView.addTag(tag: tag)
```

You can add one, or multiples hashtags at the time. Same if you want to remove them.

```swift
func addTag(tag: HashTag)
func addTags(tags: [HashTag])
func removeTag(tag: HashTag)
func removeTags()
```

### Dynamic height

You may want to expand the size of your `HashtagView` when the hashtags exceed the actual size of the view.

To do so, implement `HashtagsViewResizingDelegate` :

```swift
UIViewController: HashtagsViewResizingDelegate {
	func viewShouldResizeTo(size: CGSize) {
		// Your code here
	}
}
```

#### Example:

One good way to expand the height of your `HashtagsView`  when needed is to set a height constraint on it (from the code or interface builder). Then you can modify the `constant` property of the constraint when the view needs to be expanded. Add an animation and you got it !


```swift
UIViewController: HashtagsViewResizingDelegate {
	func viewShouldResizeTo(size: CGSize) {
		guard let constraint = self.heightConstraint else {
			return
		}
		constraint.constant = size.height
		UIView.animate(withDuration: 0.4) {
			self.view.layoutIfNeeded()
		}
	}
}
```

***NOTE:** If you are using interface builder, you might want to link your height constraint to your parent view with an `@IBOutlet`. Check our example project for more details.*


##  🎨 Customization

### Appearance

You can change style attributes of the view and the design of the hashtags themselves.

- `containerPaddingLeft`

- `containerPaddingRight`

- `containerPaddingTop`

- `containerPaddingBottom`

- `horizontalTagSpacing`

- `horizontalTagSpacing`

- `tagPadding`

- `tagCornerRadius`

- `tagBackgroundColor`

- `tagTextColor`

- `removeButtonSize`

-  `removeButtonSpacing`


## 👱 Author

Oscar Gotting, gottingoscar@gmail.com

## 🚔 License

Hashtags is available under the MIT license. See the LICENSE file for more info.
