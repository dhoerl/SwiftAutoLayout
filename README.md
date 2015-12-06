## SwiftAutoLayout

Latest Update Nov 2, 2015

SwiftAutoLayout is a very small DSL for Auto Layout, intended to provide a more declarative way to express layout constraints.

### dhoerl Notes
This code is a great example of doing something quite useful in a few lines of code. What is
so interesting here is that the original author leverages Swift Structures to create intermediate objects that themselves are never
exposed to the user.

While the original author has done a masterful job, the code got stale and was not keeping up with changes to Swift nor NSLayoutConstraint. 

dhoerl Changes:    

* flipped the multiplication/division operators to align with Apple's AutoLayout Guide
* support using constants and multipliers on either side of an equality (additive contants change sign, multiplicative ones invert)
* support 'priority' with '! value' 
* supply an 'identifier' value using '-? String'
* support setting 'active'' to false using a trailing '--'
* class vars return the standard values for sibling and superview spacing
* postfix operators to add ('+^') or subtract ('-^) the sibling space
* add additional methods to permit the use of 'Ints' in multipliers, constants, and priority
* add the new 'NSLayoutAttribute' attributes introduced in iOS8
* incorporate the latest @testability feature (which made it possible to remove most 'public' methods
* add tests for 'priority', sibling postfix operators, and the 'active' flag
* reverted the code back to the original author's function overloaded version, which he had to back out because of Swift 1.0 compiler bugs

While I'm aware of other larger projects to support Auto Layout, I prefer small and easy to understand, as in the end you may end up needing to support the code yourself.

[Note that the original code did not provide any warnings that use of a constant and/or multiplier on the left side of an equality would silently fail.
These functions should not be public, since this code might be used in a framework/library of an app that also uses it.]

### Original Notes

 Here's a quick example:
 
```swift
// this:
let constraint = view1.al_left == 2 * view2.al_right + 10 ~ 100
		
// is equivalent to:
let constraint = NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view2, attribute: NSLayoutAttribute.Right, multiplier: 2.0, constant: 10.0) with a priority of 100
```

You may notice that this looks a lot like the linear equation that a constraint represents. From the [Apple documentation](https://developer.apple.com/library/mac/documentation/AppKit/Reference/NSLayoutConstraint_Class/NSLayoutConstraint/NSLayoutConstraint.html):

> The relationship involves a first attribute, a relationship type, and a modified second value formed by multiplying an attribute by a constant factor and then adding another constant factor to it. In other words, constraints look very much like linear equations of the following form:
>
> `attribute1 == multiplier × attribute2 + constant`

SwiftAutolayout allows you to more effectively communicate the intent of a constraint by making the syntax more similar to the equation that it represents.

### Attributes

Layout attributes are defined as properties added in an extension of `UIView`. For example, `UIView.al_width` and `UIView.al_height` represent `NSLayoutAttribute.Width` and `NSLayoutAttribute.Height`, respectively. 

### Relations

Relations are expressed using the overloaded operators `==` (`NSLayoutRelation.Equal`), `>=` (`NSLayoutRelation.GreaterThanOrEqual`), and `<=` (`NSLayoutRelation.LessThanOrEqual`). 

If you think I'm crazy for overloading operators like `==` (even though it doesn't have any pre-existing behaviour with structs), you can also use plain old function calls:

```swift
// this:
let constraint = view1.al_left == 2.0 * view2.al_right + 10.0
		
// is equivalent to:
let constraint = view1.al_left.equalTo(2.0 * view2.al_right + 10.0))
```
`equalTo()`, `greaterThanOrEqualTo()`, and `lessThanOrEqualTo()` are equivalent to `==`, `>=`, and `<=`, respectively.

### Contact

* Indragie Karunaratne
* [@indragie](http://twitter.com/indragie)
* [http://indragie.com](http://indragie.com)

### License

SwiftAutoLayout is licensed under the MIT License.
