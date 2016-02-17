# ALAccordion

## Overview

ALAccordion is an accordion style container view for iOS that manages a set of expandable/collapsable content sections. When a section opens, it consumes the full screen (see screenshots).

Each section of the accordion is associated with a custom view controller that manages its own header and content views. ALAccordion relies on autolayout to provide an intrinsic content size for the header view. This makes it super easy to have custom section headers that can be modified and animated by each section.

ALAccordion also allows an optional header and footer view that are hidden when a section is opened. 

## Requirements

* Xcode 7
* Swift 2.0
* Requires iOS 7+
* Requires AutoLayout

**Note:** ALAccordion uses ARC

## Screenshots

![ALAccordion Screenshot](https://cloud.githubusercontent.com/assets/954694/7263154/f78d41e4-e876-11e4-931b-8beaed97b023.png)
![ALAccordion Demo](https://cloud.githubusercontent.com/assets/954694/7263156/fa14c554-e876-11e4-80fd-310ebad2c0c9.gif)

## Demo

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

### Installation with Cocoapods

ALAccordion is written in Swift, so to install with Cocoapods, you must target `iOS 8` or later.

Install Cocoapods 0.36.0 or newer
```shell
[sudo] gem install cocoapods
```

Add ALAccordion to your Podfile. **Note**: You must add the `use_frameworks!` line to use Swift in Cocoapods:
```ruby
# Podfile
target 'My Target' do
  use_frameworks!
  pod "ALAccordion"
end
```

### Manual Installation

Add the files in the ALAccordion/Classes directory to your project

## Usage

Below shows the basic usage of the ALAccordion. See the example project for a more comprehensive example.

### ALAccordionController

ALAccordionController is a UIViewController subclass container view, that manages the sections. 

First of all, create a view controller that subclasses ALAccordionController.

```swift
class ALHomeViewController: ALAccordionController
{
  override func viewDidLoad()
  {
    super.viewDidLoad()
  }
}
```

#### Accordion Header / Footer
You can add an optional header and/or footer to the accordion by setting the `headerView` and `footerView` properties.

**Note:** The accordion uses the intrinsic content size of the header andfooter views for layout, so ensure you setup your autolayout constraints correctly.

```swift
override func viewDidLoad()
{
  ...
    
  // Header
  let header = UILabel()
  header.text = "Accordion Header"
  self.headerView = header

  // Footer
  let footer = UILabel()
  footer.text = "Accordion Footer"
  self.footerView = footer
}
```

#### Create Sections

To create your sections, you must pass the ALAccordion a list of view controllers in the order that they will be displayed. The view controllers can be instantiated from a storyboard, or by code.

**Note:** The view controllers must conform to the `ALAccordionSectionDelegate` protocol (see below)

````swift
override func viewDidLoad()
{
  ...
    
  let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())

  let section1 = storyboard.instantiateViewControllerWithIdentifier("firstVC") as! Section1ViewController
  let section2 = storyboard.instantiateViewControllerWithIdentifier("secondVC") as! Section2ViewController
  let section3 = storyboard.instantiateViewControllerWithIdentifier("thirdVC") as! Section3TableViewController

  self.setViewControllers(section1, section2, section3)
}
```

### Section View Controllers

You should provide the ALAccordionController a new instance of a UIViewController for each section in your accordion. 

A section view controller must conform to the `ALAccordionSectionDelegate` protocol. That is, it must provide a headerView. Again, like the ALAccordionController header and footer views, the headerView must use autolayout to provide an intrinsic content size. By changing the constraints on your header view, you can easily change the size of the header, eg when the section is opening, to show more detail.

```swift
class ALFirstSectionViewController: UIViewController, ALAccordionSectionDelegate
{
  override func viewDidLoad()
  {
    super.viewDidLoad()
  }

  // MARK: - ALAccordionControllerDelegate
  
  // Required
  lazy var headerView: UIView =
  {
    let header = UILabel()
    header.text = "Section 1 Header"

    return header
  }()

  // Optional
  func sectionWillOpen(#animated: Bool)
  {
      
  }

  // Optional
  func sectionWillClose(#animated: Bool)
  {
      
  }

  // Optional
  func sectionDidOpen()
  {
      
  }

  // Optional
  func sectionDidClose()
  {
      
  }
}
```

**Note:** You must manually specify how each section should open. The example below shows how to open the section with a tap gesture on the headerView.

```swift
lazy var headerView: UIView =
{
  let header = UILabel()
  header.text = "Section 1 Header"

  // Add a tap gesture recogniser to open the section
  let tapGR = UITapGestureRecognizer(target: self, action: "headerTapped:")
  header.addGestureRecognizer(tapGR)

  return header
}()

func headerTapped(recognizer: UITapGestureRecognizer)
{
  // Get the section for this view controller
  if let sectionIndex = self.accordionController?.sectionIndexForViewController(self)
  {
    // If this section is open, close it - otherwise, open it
    if self.accordionController!.openSectionIndex == sectionIndex
    {
      self.accordionController?.closeSectionAtIndex(sectionIndex, animated: true)
    }
    else
    {
      self.accordionController?.openSectionAtIndex(sectionIndex, animated: true)
    }
  }
}
```

## ToDo, Notes & Limitations

* Highlight state on header views in example
* When embedding a UITableViewController in a section, there is an undesired effect on the cells the first time the section opens. The avoid this, call `self.view.layoutIfNeeded()` in your `viewDidLoad` method for the section view controller.
* Currently, ALAccordion can only display a limited number of sections and in their closed state, must not exceed the height of the device. In the future, we plan to allow scrollable headers. Feel free to send a pull request!

## License

ALAccordion is available under the MIT license. See the LICENSE file for more info.

## About

Alliants Limited

* [Github](https://github.com/Alliants)
* [Website](http://alliants.com)
* [Twitter (@alliants)](https://twitter.com/alliants)
