//
//  MacawChartView.swift
//  BarChart
//
//  Created by Suhas on 18/09/19.
//  Copyright © 2019 Suhas. All rights reserved.
//

import Foundation
import Macaw

class MacawChartView: MacawView {
    
    static let lastFewData          = createDummyDate()
    static let maxValue             = 6000
    static let maxValueLineHeight   = 180
    static let lineWidth:Double     = 275
    
    static let dataDivisor                  = Double(maxValue/maxValueLineHeight)
    static let adjustedData:[Double]        = lastFewData.map({ $0.viewCount / dataDivisor })
    static var animations:[Animation]       = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(node: MacawChartView.createChart(), coder: aDecoder)
        backgroundColor = .clear
    }
    
    private static func createChart() -> Group {
        var items: [Node] = addYAxisItem() + addXAxisItem()
        items.append(createBars())
        return Group(contents: items, place: .identity)
    }
    
    private static func addYAxisItem() -> [Node] {
        let maxLines            = 6
        let lineInterval        = Int(maxValue/maxLines)
        let yAxisHeight:Double  = 200
        let lineSpacing:Double  = 30
        
        var newNode: [Node]     = []
        for i in 1...maxLines {
            let y = yAxisHeight - (Double(i) * lineSpacing)
            let valueLine   = Line(x1: -5, y1: y, x2: lineWidth, y2: y).stroke(fill: Color.white.with(a: 0.10))
            let valueText   = Text(text: "\(i * lineInterval)", align: .max, baseline: .mid, place: .move(dx: -10, dy: y))
            valueText.fill  = Color.white
            newNode.append(valueLine)
            newNode.append(valueText)
        }
        
        let yAxis = Line(x1: 0, y1: 0, x2: 0, y2: yAxisHeight).stroke(fill: Color.white.with(a: 0.25))
        newNode.append(yAxis)
        return newNode
    }
    
    private static func addXAxisItem() -> [Node] {
        let chartBaseY: Double  = 200
        var newNode: [Node]     = []
        for i in 1...adjustedData.count {
            let x = (Double(i) * 50)
            let valueText   = Text(text: lastFewData[i - 1].showNumber, align: .max, baseline: .mid, place: .move(dx: x, dy: chartBaseY + 15))
            valueText.fill  = Color.white
            newNode.append(valueText)
        }
        let xAxis = Line(x1: 0, y1: chartBaseY, x2: lineWidth, y2: chartBaseY).stroke(fill: Color.white.with(a: 0.25))
        newNode.append(xAxis)
        
        return newNode
    }
    
    private static func createBars() -> Group {
        let fill    = LinearGradient(degree: 90, from: Color(val: 0xff4704), to: Color(val: 0xff4704).with(a: 0.33))
        let items   = adjustedData.map{ _ in Group() }
        
        animations  = items.enumerated().map { (i: Int, item: Group) in
            item.contentsVar.animation(delay: Double(i) * 0.1) { t in
                let height  = adjustedData[i] * t
                let rect    = Rect(x: Double(i) * 50 + 25, y: 200 - height, w: 30, h: height)
                return [rect.fill(with: fill)]
            }
        }
        return items.group()
    }
    
    private static func createDummyDate() -> [SwiftNewsVideo] {
        let one     = SwiftNewsVideo(showNumber: "55", viewCount: 3426)
        let two     = SwiftNewsVideo(showNumber: "56", viewCount: 5617)
        let three   = SwiftNewsVideo(showNumber: "57", viewCount: 5781)
        let four    = SwiftNewsVideo(showNumber: "58", viewCount: 4612)
        let five    = SwiftNewsVideo(showNumber: "59", viewCount: 5791)
        return [one, two, three, four, five]
    }
    
    static func playAnimations() {
        animations.combine().play()
    }
    
}
