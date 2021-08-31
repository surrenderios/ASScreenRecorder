//
//  CIImageView.swift
//  FaceSnaps
//
//  Created by Patrick on 3/15/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//
import AVFoundation
import UIKit
import GLKit

/// This small GLKView subclass is used for displaying CIImages rapidly, often as the result of a CIFilter.
///
/// Assigning an image to the CIImageView's image property will result in the image getting redrawn using provided CIContext.
class CIImageView: GLKView, GLKViewDelegate {
    var ciContext: CIContext!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        self.context = EAGLContext(api: .openGLES2)!
        EAGLContext.setCurrent(self.context)
        self.ciContext = CIContext(eaglContext: self.context)
        delegate = self
        enableSetNeedsDisplay = true
        isOpaque  = false
    }

    @objc public var image: CIImage? {
        didSet {
            self.setNeedsDisplay()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }

    public func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(0, 0, 0, 0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))

        guard let image = self.image else {
            return
        }
        let scale = UIScreen.main.scale
        let scaledRect = CGRect(x: rect.minX, y: rect.minY, width: rect.width * scale, height: rect.height * scale)
        self.ciContext.draw(image, in: image.extent, from: image.extent)
    }
}
