//
//  ViewController.swift
//  Demo4
//
//  Created by ADDICE on 2018/11/1.
//  Copyright © 2018 ADDICE. All rights reserved.
//

import UIKit
import GLKit

/*
 1. 用四个坐标进行绘制的话，该如何绘制
 2. 坐标 和 纹理分开成两个数组进行绘制时，是否需要有一些偏差计算，否则结果和用想要的相差甚远。
 */

class ViewController: GLKViewController {
    
    lazy var vertices : [GLKVector3] = [
        
        GLKVector3(v: (0.5, -0.5, 0)),    // 左下
        GLKVector3(v: (0.5, 0.5, 0)),     // 右下
        GLKVector3(v: (-0.5, 0.5, 0)),     // 左上
        
        GLKVector3(v: (0.5, -0.5, 0)),
        GLKVector3(v: (-0.5, 0.5, 0)),
        GLKVector3(v: (-0.5, -0.5, 0)),
        
    ]
    
    lazy var textures : [GLKVector2] = [
        
        GLKVector2(v: (1,0)),
        GLKVector2(v: (1,1)),
        GLKVector2(v: (0,1)),
        
        GLKVector2(v: (1,0)),
        GLKVector2(v: (0,1)),
        GLKVector2(v: (0,0)),
    ]
    
    lazy var sceneVertors : [SceneVertor] = [
        SceneVertor((0.5, -0.5, 0, 1, 0)),
        SceneVertor((0.5, 0.5, 0, 1, 1)),
        SceneVertor((-0.5, 0.5, 0, 0, 1)),

        SceneVertor((0.5, -0.5, 0, 1, 0)),
        SceneVertor((-0.5, 0.5, 0, 0, 1)),
        SceneVertor((-0.5, -0.5, 0, 0, 0)),
    ]
    
    
    
    lazy var context = EAGLContext(api: .openGLES2)
    
    /// 着色器
    lazy var baseEffect : GLKBaseEffect = {
        let effect = GLKBaseEffect()
        effect.useConstantColor = GLboolean(GL_TRUE)
        // 绘制图形的颜色，比如这个是设置 alpha 为 1 的白色
        effect.constantColor = GLKVector4(v: (1,1,1,1))
        return effect
    }()
    
    lazy var vertextBufferId = GLuint()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let view = view as? GLKView else {
            return
        }
        
        view.context = context!
        view.drawableColorFormat = .RGBA8888
        // 设置 EAGLContext 当前的 context
        EAGLContext.setCurrent(view.context)
        
        // 设置背景色, 默认是黑色，也就是 (0,0,0,1)
        glClearColor(0, 0, 0, 1)
        
        glGenBuffers(1, &vertextBufferId)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertextBufferId)
        
        glBufferData(GLenum(GL_ARRAY_BUFFER), sceneVertors.count * MemoryLayout<SceneVertor>.size, sceneVertors, GLenum(GL_STATIC_DRAW))
        
        do {
            
            let ciImg = UIImage(named: "test")?.cgImage
            
            let textureInfo = try GLKTextureLoader.texture(with: ciImg!, options: [GLKTextureLoaderOriginBottomLeft: NSNumber(value: true)])

            baseEffect.texture2d0.name = textureInfo.name
            baseEffect.texture2d0.target = GLKTextureTarget(rawValue: textureInfo.target)!
            
        } catch {
            print(error)
        }
        
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.position.rawValue))
    
        let positionPointer = UnsafePointer<Int>.init(bitPattern: MemoryLayout<SceneVertor>.offset(of: \SceneVertor.postion)!)
        
        glVertexAttribPointer(GLuint(GLKVertexAttrib.position.rawValue), GLint(3), GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<SceneVertor>.size), positionPointer)
        
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.texCoord0.rawValue))
        
        let texturePointer = UnsafeMutablePointer<Int>.init(bitPattern: MemoryLayout<SceneVertor>.offset(of: \SceneVertor.texture)!)
        glVertexAttribPointer(GLuint(GLKVertexAttrib.texCoord0.rawValue), GLint(2), GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<SceneVertor>.size), texturePointer)
        
        
        
    }

    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        
        baseEffect.prepareToDraw()
        
        glDrawArrays(GLenum(GL_TRIANGLES), 0, GLsizei(sceneVertors.count))
        
    }
    
}



