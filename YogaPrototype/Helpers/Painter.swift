//
//  Painter.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 24.11.2021.
//

import SwiftUI

class Painter: UIView {
    typealias Body = (CGContext, CGRect) -> Void
    
    var body: Body
    
    init(frame: CGRect, body: @escaping Body) {
        self.body = body
        super.init(frame: frame)

        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard
            let ctx = UIGraphicsGetCurrentContext()
        else {
            return
        }
        
        ctx.saveGState()
        body(ctx, rect)
        ctx.restoreGState()
    }
}

