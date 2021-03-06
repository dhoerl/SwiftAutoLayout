//  SwiftAutoLayout
//  Lightweight Auto Layout Assistant. Write constraints in a more declarative way.

//  Copyright (c) 2014 Indragie Karunaratne. All rights reserved.
//  Copyright (c) 2015 David Hoerl. All rights reserved.
//
//  Licensed under the MIT license, see LICENSE file for more info.

#if os(OSX)
    import AppKit
    public typealias ALView = NSView
#elseif os(iOS)
    import UIKit
    public typealias ALView = UIView
#endif

public struct ALLayoutItem {
	static var standardConstantBetweenSiblings: CGFloat =	{
																let view = UIView()
																let constraint = NSLayoutConstraint.constraintsWithVisualFormat("[view]-[view]", options:[], metrics:nil, views:["view": view])[0]
																return constraint.constant ;    // 8.0
															}()
	static var standardConstantBetweenSuperview: CGFloat =	{
																let view = UIView()
																let constraint = NSLayoutConstraint.constraintsWithVisualFormat("[view]-|", options:[], metrics:nil, views:["view": view])[0]
																return constraint.constant ;    // 20.0
															}()
    let view: ALView
    let attribute: NSLayoutAttribute
    let multiplier: CGFloat
    let constant: CGFloat
    
    init(view: ALView, attribute: NSLayoutAttribute, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) {
        self.view = view
        self.attribute = attribute
        self.multiplier = multiplier
        self.constant = constant
    }

    func relateTo(right: ALLayoutItem, relation: NSLayoutRelation) -> NSLayoutConstraint {
		let multiplier: CGFloat
		if self.multiplier == 1 && right.multiplier == 1 {
			multiplier = 1
		} else
		if right.multiplier != 1 && self.multiplier == 1 {
			multiplier = right.multiplier
		} else
		if right.multiplier == 1 && self.multiplier != 1 {
			multiplier = 1.0/self.multiplier
		} else {
			fatalError("Cannot have both a left and right multiplier")
		}
        return NSLayoutConstraint(item: view, attribute: attribute, relatedBy: relation, toItem: right.view, attribute: right.attribute, multiplier: multiplier, constant: right.constant - self.constant)
    }
    
    func relateTo(right: CGFloat, relation: NSLayoutRelation) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, attribute: attribute, relatedBy: relation, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: right)
    }
    
    /// Equivalent to NSLayoutRelation.Equal
    func equalTo(right: ALLayoutItem) -> NSLayoutConstraint {
        return relateTo(right, relation: .Equal)
    }
    
    /// Equivalent to NSLayoutRelation.Equal
    func equalTo(right: CGFloat) -> NSLayoutConstraint {
        return relateTo(right, relation: .Equal)
    }
    
    /// Equivalent to NSLayoutRelation.GreaterThanOrEqual
    func greaterThanOrEqualTo(right: ALLayoutItem) -> NSLayoutConstraint {
        return relateTo(right, relation: .GreaterThanOrEqual)
    }
    
    /// Equivalent to NSLayoutRelation.GreaterThanOrEqual
    func greaterThanOrEqualTo(right: CGFloat) -> NSLayoutConstraint {
        return relateTo(right, relation: .GreaterThanOrEqual)
    }
    
    /// Equivalent to NSLayoutRelation.LessThanOrEqual
    func lessThanOrEqualTo(right: ALLayoutItem) -> NSLayoutConstraint {
        return relateTo(right, relation: .LessThanOrEqual)
    }
    
    /// Equivalent to NSLayoutRelation.LessThanOrEqual
    func lessThanOrEqualTo(right: CGFloat) -> NSLayoutConstraint {
        return relateTo(right, relation: .LessThanOrEqual)
    }
}

/// Multiplies the operand's multiplier by the RHS value
public func * (left: CGFloat, right: ALLayoutItem) -> ALLayoutItem {
	return ALLayoutItem(view: right.view, attribute: right.attribute, multiplier: right.multiplier * left, constant: right.constant)
}
public func * (left: Int, right: ALLayoutItem) -> ALLayoutItem {
	return ALLayoutItem(view: right.view, attribute: right.attribute, multiplier: right.multiplier * CGFloat(left), constant: right.constant)
}
/// Divides the operand's multiplier by the LHS value
public func / (left: CGFloat, right: ALLayoutItem) -> ALLayoutItem {
	return ALLayoutItem(view: right.view, attribute: right.attribute, multiplier: right.multiplier / left, constant: right.constant)
}
public func / (left: Int, right: ALLayoutItem) -> ALLayoutItem {
	return ALLayoutItem(view: right.view, attribute: right.attribute, multiplier: right.multiplier / CGFloat(left), constant: right.constant)
}

/// Adds the RHS value to the operand's constant
public func + (left: ALLayoutItem, right: CGFloat) -> ALLayoutItem {
	return ALLayoutItem(view: left.view, attribute: left.attribute, multiplier: left.multiplier, constant: left.constant + right)
}
public func + (left: ALLayoutItem, right: Int) -> ALLayoutItem {
	return ALLayoutItem(view: left.view, attribute: left.attribute, multiplier: left.multiplier, constant: left.constant + CGFloat(right))
}

postfix operator +^ {}
public postfix func +^ (left: ALLayoutItem) -> ALLayoutItem {
    return ALLayoutItem(view: left.view, attribute: left.attribute, multiplier: left.multiplier, constant: ALLayoutItem.standardConstantBetweenSiblings)
}
postfix operator -^ {}
public postfix func -^ (left: ALLayoutItem) -> ALLayoutItem {
    return ALLayoutItem(view: left.view, attribute: left.attribute, multiplier: left.multiplier, constant: -ALLayoutItem.standardConstantBetweenSiblings)
}

/// Subtracts the RHS value from the operand's constant
public func - (left: ALLayoutItem, right: CGFloat) -> ALLayoutItem {
	return ALLayoutItem(view: left.view, attribute: left.attribute, multiplier: left.multiplier, constant: left.constant - right)
}
public func - (left: ALLayoutItem, right: Int) -> ALLayoutItem {
	return ALLayoutItem(view: left.view, attribute: left.attribute, multiplier: left.multiplier, constant: left.constant - CGFloat(right))
}

/// Alow '!' to set the priority, as a trailing operation
infix operator ! { associativity left precedence 100 }
public func ! (constraint: NSLayoutConstraint, priority: UILayoutPriority) -> NSLayoutConstraint {
    constraint.priority = priority
    return constraint
}
public func ! (constraint: NSLayoutConstraint, priority: Int) -> NSLayoutConstraint {
    constraint.priority = UILayoutPriority(priority)
    return constraint
}
/// Support identifier
infix operator -? { associativity left precedence 100 }
public func -? (constraint: NSLayoutConstraint, identifier: String) -> NSLayoutConstraint {
    constraint.identifier = identifier
    return constraint
}
/// Support active
public postfix func -- (constraint: NSLayoutConstraint) -> NSLayoutConstraint {
    constraint.active = false
    return constraint
}


/// Equivalent to NSLayoutRelation.Equal
public func == (left: ALLayoutItem, right: ALLayoutItem) -> NSLayoutConstraint {
	return left.equalTo(right)
}

/// Equivalent to NSLayoutRelation.Equal
public func == (left: ALLayoutItem, right: CGFloat) -> NSLayoutConstraint {
    return left.equalTo(right)
}
public func == (left: ALLayoutItem, right: Int) -> NSLayoutConstraint {
    return left.equalTo(CGFloat(right))
}

/// Equivalent to NSLayoutRelation.GreaterThanOrEqual
public func >= (left: ALLayoutItem, right: ALLayoutItem) -> NSLayoutConstraint {
	return left.greaterThanOrEqualTo(right)
}

/// Equivalent to NSLayoutRelation.GreaterThanOrEqual
public func >= (left: ALLayoutItem, right: CGFloat) -> NSLayoutConstraint {
    return left.greaterThanOrEqualTo(right)
}
public func >= (left: ALLayoutItem, right: Int) -> NSLayoutConstraint {
    return left.greaterThanOrEqualTo(CGFloat(right))
}

/// Equivalent to NSLayoutRelation.LessThanOrEqual
public func <= (left: ALLayoutItem, right: ALLayoutItem) -> NSLayoutConstraint {
	return left.lessThanOrEqualTo(right)
}

/// Equivalent to NSLayoutRelation.LessThanOrEqual
public func <= (left: ALLayoutItem, right: CGFloat) -> NSLayoutConstraint {
    return left.lessThanOrEqualTo(right)
}
public func <= (left: ALLayoutItem, right: Int) -> NSLayoutConstraint {
    return left.lessThanOrEqualTo(CGFloat(right))
}

public extension ALView {
    func al_operand(attribute: NSLayoutAttribute) -> ALLayoutItem {
        return ALLayoutItem(view: self, attribute: attribute)
    }
    
    /// Equivalent to NSLayoutAttribute.Left
    var al_left: ALLayoutItem {
        return al_operand(.Left)
    }
    
    /// Equivalent to NSLayoutAttribute.Right
    var al_right: ALLayoutItem {
        return al_operand(.Right)
    }
    
    /// Equivalent to NSLayoutAttribute.Top
    var al_top: ALLayoutItem {
        return al_operand(.Top)
    }
    
    /// Equivalent to NSLayoutAttribute.Bottom
    var al_bottom: ALLayoutItem {
        return al_operand(.Bottom)
    }
    
    /// Equivalent to NSLayoutAttribute.Leading
    var al_leading: ALLayoutItem {
        return al_operand(.Leading)
    }
    
    /// Equivalent to NSLayoutAttribute.Trailing
    var al_trailing: ALLayoutItem {
        return al_operand(.Trailing)
    }
    
    /// Equivalent to NSLayoutAttribute.Width
    var al_width: ALLayoutItem {
        return al_operand(.Width)
    }
    
    /// Equivalent to NSLayoutAttribute.Height
    var al_height: ALLayoutItem {
        return al_operand(.Height)
    }
    
    /// Equivalent to NSLayoutAttribute.CenterX
    var al_centerX: ALLayoutItem {
        return al_operand(.CenterX)
    }
    
    /// Equivalent to NSLayoutAttribute.CenterY
    var al_centerY: ALLayoutItem {
        return al_operand(.CenterY)
    }
    
    /// Equivalent to NSLayoutAttribute.Baseline
    var al_baseline: ALLayoutItem {
        return al_operand(.Baseline)
    }

    /// Equivalent to NSLayoutAttribute.FirstBaseline
    var al_firstBaseline: ALLayoutItem {
        return al_operand(.FirstBaseline)
    }

    /// Equivalent to NSLayoutAttribute.LastBaseline
    var al_lastBaseline: ALLayoutItem {
        return al_operand(.LastBaseline)
    }

    /// Equivalent to NSLayoutAttribute.LeftMargin
    var al_leftMargin: ALLayoutItem {
        return al_operand(.LeftMargin)
    }

    /// Equivalent to NSLayoutAttribute.RightMargin
    var al_rightMargin: ALLayoutItem {
        return al_operand(.RightMargin)
    }

    /// Equivalent to NSLayoutAttribute.TopMargin
    var al_topMargin: ALLayoutItem {
        return al_operand(.TopMargin)
    }

    /// Equivalent to NSLayoutAttribute.BottomMargin
    var al_bottomMargin: ALLayoutItem {
        return al_operand(.BottomMargin)
    }

    /// Equivalent to NSLayoutAttribute.LeadingMargin
    var al_leadingMargin: ALLayoutItem {
        return al_operand(.LeadingMargin)
    }

    /// Equivalent to NSLayoutAttribute.TrailingMargin
    var al_trailingMargin: ALLayoutItem {
        return al_operand(.TrailingMargin)
    }

    /// Equivalent to NSLayoutAttribute.CenterXWithinMargins
    var al_centerXWithinMargins: ALLayoutItem {
        return al_operand(.CenterXWithinMargins)
    }

    /// Equivalent to NSLayoutAttribute.CenterYWithinMargins
    var al_centerYWithinMargins: ALLayoutItem {
        return al_operand(.CenterYWithinMargins)
    }
}
