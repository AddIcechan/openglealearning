//
//  OGLKView.swift
//  Demo2
//
//  Created by ADDICE on 2018/3/29.
//  Copyright © 2018年 ADDICE. All rights reserved.
//

import UIKit
import OpenGLES

protocol OGLKViewDelegate {
    func glkView(_ view:OGLKView, drawIn rect: CGRect)
}

class OGLKView: UIView {

    // MARK: properties
    var context : EAGLContext? {
        didSet {
            // 需要判断先前的 context 和 新赋值的 context 是否一致，一致的话，那么没有必要再往下直接渲染的一些步骤
            guard oldValue != context else { return }
            
            EAGLContext.setCurrent(context)
            
            // 先清除 缓存标识
            if 0 != defaultFrameBuffer {
                glDeleteBuffers(1, &defaultFrameBuffer)
                defaultFrameBuffer = 0
            }
            
            if 0 != colorRenderBuffer {
                glDeleteBuffers(1, &colorRenderBuffer)
                colorRenderBuffer = 0
            }
            
            glGenFramebuffers(1, &defaultFrameBuffer)
            
            glBindFramebuffer(GLenum(GL_FRAMEBUFFER), defaultFrameBuffer)
            
            glGenRenderbuffers(1, &colorRenderBuffer)
            
            glBindRenderbuffer(GLenum(GL_RENDERBUFFER), colorRenderBuffer)
            
            // 不太理解这个函数的用法。按照字面理解就是把 颜色缓冲 给渲染到 帧缓冲 去
            glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_RENDERBUFFER), colorRenderBuffer)
            
        }
    }
    
    var delegate : OGLKViewDelegate?
    
    var defaultFrameBuffer : GLuint = 0
    
    var colorRenderBuffer : GLuint = 0
    
    var drawableWidth : GLint {
        
        var width : GLint = 0
        
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GLenum(GL_RENDERBUFFER_WIDTH), &width)
        
        return width
    }
    
    var drawableHeight : GLint {
        
        var height : GLint = 0
        
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GLenum(GL_RENDERBUFFER_HEIGHT), &height)
        
        return height
        
    }
    
    // MARK: functions
    convenience init(frame: CGRect, with context: EAGLContext?) {
        self.init(frame: frame)
        
        if let eaglLayer = self.layer as? CAEAGLLayer {
            /* 设置一些 OpenGL ES 渲染用到的一些参数
             kEAGLDrawablePropertyRetainedBacking 是表示绘图后是否保存其内容
             */
            eaglLayer.drawableProperties = [kEAGLDrawablePropertyRetainedBacking: false,
                                            kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8]
            
        }
        
    }
    
    override class var layerClass: AnyClass {
        // 重写 layer 方法，需返回 CAEAGLLayer ,而非 CALayer
        return CAEAGLLayer.self
    }
    
    override func display(_ layer: CALayer) {
        
        EAGLContext.setCurrent(context)
        
        glViewport(0, 0, drawableWidth, drawableHeight)
        
        context?.presentRenderbuffer(Int(GL_RENDERBUFFER))
        
    }
    
    override func draw(_ rect: CGRect) {
        delegate?.glkView(self, drawIn: rect)
    }
    
    override func layoutSubviews() {
        if let eaglLayer = self.layer as? CAEAGLLayer {
            
            context?.renderbufferStorage(Int(GL_RENDERBUFFER), from: eaglLayer)
            
            // 绑定颜色
            glBindRenderbuffer(GLenum(GL_RENDERBUFFER), colorRenderBuffer)
            
            let status : GLenum = glCheckFramebufferStatus(GLenum(GL_FRAMEBUFFER))
            
            if status != GL_FRAMEBUFFER_COMPLETE {
                print("failed to render with status: \(status)")
            }
            
        }
    }
    
    deinit {
        if EAGLContext.current() == context {
            EAGLContext.setCurrent(nil)
        }

        context = nil
    }
    
}
