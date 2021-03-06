//
//  SwiftAutoLayoutTests.swift
//  SwiftAutoLayoutTests
//
//  Created by Indragie on 6/17/14.
//  Copyright (c) 2014 Indragie Karunaratne. All rights reserved.
//  Copyright (c) 2015 David Hoerl. All rights reserved.
//

@testable import SwiftAutoLayout
import XCTest

// The imports from SwiftAutoLayout don't cascade here
#if os(OSX)
    import AppKit
#elseif os(iOS)
    import UIKit
#endif


class SwiftAutoLayoutTests: XCTestCase {
    let view1 = ALView(frame: CGRectZero)
    let view2 = ALView(frame: CGRectZero)
    
    func testAttributeValues() {
        XCTAssertEqual(view1.al_left.attribute, NSLayoutAttribute.Left, "Expect ALView.al_left to have the attribute NSLayoutAttribute.Left")
        XCTAssertEqual(view1.al_right.attribute, NSLayoutAttribute.Right, "Expect ALView.al_right to have the attribute NSLayoutAttribute.Right")
        XCTAssertEqual(view1.al_top.attribute, NSLayoutAttribute.Top, "Expect ALView.al_top to have the attribute NSLayoutAttribute.Top")
        XCTAssertEqual(view1.al_bottom.attribute, NSLayoutAttribute.Bottom, "Expect ALView.al_bottom to have the attribute NSLayoutAttribute.Bottom")
        XCTAssertEqual(view1.al_leading.attribute, NSLayoutAttribute.Leading, "Expect ALView.al_leading to have the attribute NSLayoutAttribute.Leading")
        XCTAssertEqual(view1.al_trailing.attribute, NSLayoutAttribute.Trailing, "Expect ALView.al_trailing to have the attribute NSLayoutAttribute.Trailing")
        XCTAssertEqual(view1.al_width.attribute, NSLayoutAttribute.Width, "Expect ALView.al_width to have the attribute NSLayoutAttribute.Width")
        XCTAssertEqual(view1.al_height.attribute, NSLayoutAttribute.Height, "Expect ALView.al_height to have the attribute NSLayoutAttribute.Height")
        XCTAssertEqual(view1.al_centerX.attribute, NSLayoutAttribute.CenterX, "Expect ALView.al_centerX to have the attribute NSLayoutAttribute.CenterX")
        XCTAssertEqual(view1.al_centerY.attribute, NSLayoutAttribute.CenterY, "Expect ALView.al_centerY to have the attribute NSLayoutAttribute.CenterY")
        XCTAssertEqual(view1.al_baseline.attribute, NSLayoutAttribute.Baseline, "Expect ALView.al_baseline to have the attribute NSLayoutAttribute.Baseline")
    }
    
    func testOperandDefaultValues() {
        let operands = [view1.al_left,
                        view1.al_right,
                        view1.al_top,
                        view1.al_bottom,
                        view1.al_leading,
                        view1.al_trailing,
                        view1.al_width,
                        view1.al_height,
                        view1.al_centerX,
                        view1.al_centerY,
                        view1.al_baseline]
        
        for operand in operands {
            XCTAssertEqual(view1, operand.view, "Expect view to be correct")
            XCTAssertEqual(operand.constant, CGFloat(0.0), "Expect default constant to be 0.0")
            XCTAssertEqual(operand.multiplier, CGFloat(1.0), "Expect default multiplier to be 1.0")
        }
    }
    
    func testEqual() {
        let equal = view1.al_left.equalTo(view2.al_right)
        XCTAssertEqual(equal.relation, NSLayoutRelation.Equal, "Expect ALLayoutItem.equalTo to produce constraint with NSLayoutRelation.Equal relation")
        
        let equalOperator = view1.al_left == view2.al_right;
        XCTAssertEqual(equalOperator.relation, NSLayoutRelation.Equal, "Expect == operator to produce constraint with NSLayoutRelation.Equal relation")
    }
    
    func testGreaterThanOrEqual() {
        let gte = view1.al_left.greaterThanOrEqualTo(view2.al_right)
        XCTAssertEqual(gte.relation, NSLayoutRelation.GreaterThanOrEqual, "Expect ALLayoutItem.greaterThanOrEqualTo to produce constraint with NSLayoutRelation.GreaterThanOrEqual relation")
        
        let gteOperator = view1.al_left >= view2.al_right;
        XCTAssertEqual(gteOperator.relation, NSLayoutRelation.GreaterThanOrEqual, "Expect >= operator to produce constraint with NSLayoutRelation.GreaterThanOrEqual relation")
    }
    
    func testLessThanOrEqual() {
        let lte = view1.al_left.lessThanOrEqualTo(view2.al_right)
        XCTAssertEqual(lte.relation, NSLayoutRelation.LessThanOrEqual, "Expect ALLayoutItem.lessThanOrEqualTo to produce constraint with NSLayoutRelation.LessThanOrEqual relation")
        
        let lteOperator = view1.al_left <= view2.al_right;
        XCTAssertEqual(lteOperator.relation, NSLayoutRelation.LessThanOrEqual, "Expect <= operator to produce constraint with NSLayoutRelation.LessThanOrEqual relation")
    }
    
    func testAddition() {
        var constraint = view1.al_left == view2.al_right + 10.0
        XCTAssertEqual(constraint.constant, CGFloat(10.0), "Expect constraint constant to be 10.0")
			constraint = view1.al_left - 10.0 == view2.al_right
        XCTAssertEqual(constraint.constant, CGFloat(10.0), "Expect constraint constant to be 10.0")
    }
    
    func testSubtraction() {
        let constraint = view1.al_left == view2.al_right - 10.0
        XCTAssertEqual(constraint.constant, CGFloat(-10.0), "Expect constraint constant to be -10.0")
    }

    func testMultiplicationR() {
        let constraint0 = view1.al_left == 2.0 * view2.al_right
        XCTAssertEqual(constraint0.multiplier, CGFloat(2.0), "Expect constraint multiplier to be 2.0")
        let constraint1 = view1.al_left == 2 * view2.al_right
        XCTAssertEqual(constraint1.multiplier, CGFloat(2.0), "Expect constraint multiplier to be 2")
    }

    func testMultiplicationL() {
        let constraint0 = 0.5 * view1.al_left == view2.al_right
        XCTAssertEqual(constraint0.multiplier, CGFloat(2.0), "Expect constraint multiplier to be 2.0")
        let constraint1 = 2 * view1.al_left == view2.al_right
        XCTAssertEqual(constraint1.multiplier, CGFloat(0.5), "Expect constraint multiplier to be 0.5")
    }
	
    func testDivision() {
        let constraint = view1.al_left == 2.0 / view2.al_right
        XCTAssertEqual(constraint.multiplier, CGFloat(0.5), "Expect constraint multiplier to be 0.5")
    }

    func testPriority() {
        let constraint0 = view1.al_left == view2.al_right ! 30.0
        XCTAssertEqual(constraint0.priority, UILayoutPriority(30), "Expect constraint multiplier to be 30")
        let constraint1 = view1.al_left == view2.al_right ! 30
        XCTAssertEqual(constraint1.priority, UILayoutPriority(30), "Expect constraint multiplier to be 30")
    }

    func testIdentifier() {
        let constraint = view1.al_left == view2.al_right -? "Howdie!"
        XCTAssertEqual(constraint.identifier, "Howdie!", "Expect identifier multiplier to be \"Howdie!\"")
    }

    func testCompleteConstraint() {
        let constraint = view1.al_left == 4 * view2.al_right + 20.0 - 10.0
        XCTAssertEqual(constraint.firstItem as? ALView, view1, "Expect first item to be view1")
        XCTAssertEqual(constraint.firstAttribute, NSLayoutAttribute.Left, "Expect first attribute to be NSLayoutAttribute.Left")
        XCTAssertEqual(constraint.relation, NSLayoutRelation.Equal, "Expect constraint relation to be NSLayoutRelation.Equal")
        XCTAssertEqual(constraint.secondItem as? ALView, view2, "Expect second item to be view2")
        XCTAssertEqual(constraint.secondAttribute, NSLayoutAttribute.Right, "Expect second attribute to be NSLayoutAttribute.Right")
        XCTAssertEqual(constraint.constant, CGFloat(10.0), "Expect constraint constant to be 10.0")
        XCTAssertEqual(constraint.multiplier, CGFloat(4.0), "Expect constraint multiplier to be 4.0")
    }
    
    func testConstantMultiplierOnLeftSide() {
        let constraint = 4 * view1.al_left + 20.0 - 10.0 == view2.al_right
        XCTAssertEqual(constraint.constant, CGFloat(-10.0), "Expect constraint constant to be negative when on left")
        XCTAssertEqual(constraint.multiplier, CGFloat(0.25), "Expect constraint multiplier to be the inverse of what it would be on the right")
    }

	func testStandardWidths() {
        let constraint0 = view1.al_left == view2.al_right+^
        XCTAssertEqual(constraint0.constant, ALLayoutItem.standardConstantBetweenSiblings, "Expect constraint constant to be 8")
        let constraint1 = view1.al_left-^ == view2.al_right
        XCTAssertEqual(constraint1.constant, ALLayoutItem.standardConstantBetweenSiblings, "Expect constraint constant to be 8")
    }

    func testRelationsWithoutSecondView() {
		let val = CGFloat(10.0 * 2.0)
        let constraints = [view1.al_width == val,
                           view1.al_width.equalTo(val),
                           view1.al_width >= val,
                           view1.al_width.greaterThanOrEqualTo(val),
                           view1.al_width <= val,
                           view1.al_width.lessThanOrEqualTo(val)]

        for constraint in constraints {
            XCTAssertEqual(constraint.constant, CGFloat(val), "Expect constraint constant to be \(val)")
            XCTAssertEqual(constraint.multiplier, CGFloat(1.0), "Expect constraint multiplier to be 1.0")
        }
    }
}
