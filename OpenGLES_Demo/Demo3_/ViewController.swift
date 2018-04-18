//
//  ViewController.swift
//  Demo3
//
//  Created by ADDICE on 2018/4/11.
//  Copyright © 2018年 ADDICE. All rights reserved.
//

import UIKit
import GLKit
import OpenGLES

struct SceneVertex {
    var positionCoords : GLKVector3
    var textureCoords : GLKVector2
    
    static var size : Int {
        return MemoryLayout<GLKVector2>.size + MemoryLayout<GLKVector3>.size
    }
    
    init(_ positionCoordsValue: (Float, Float, Float),_ textureCoordsValue:(Float, Float)) {
        self.positionCoords = GLKVector3(v: positionCoordsValue)
        self.textureCoords = GLKVector2(v: textureCoordsValue)
    }
}

extension Array where Element == SceneVertex {
    
    var size : Int {
        return Element.size * count
    }
    
    
}

class ViewController: GLKViewController {
    
    lazy var context = EAGLContext(api: .openGLES3)!
    
    lazy var vertices: [SceneVertex] = {
        
        let vertice1 = SceneVertex((-0.5, -0.5, 0), (0, 0))
        let vertice2 = SceneVertex((0.5, -0.5, 0), (1.0, 0))
        let vertice3 = SceneVertex((-0.5, 0.5, 0), (0, 1.0))
        
        return [vertice1, vertice2, vertice3]
    }()
    
    lazy var baseEffect: GLKBaseEffect = {
        let effect = GLKBaseEffect()
        effect.useConstantColor = GLboolean(GL_TRUE)
        // 绘制图形的颜色，比如这个是设置 alpha 为 1 的白色
        effect.constantColor = GLKVector4(v: (1,1,1,1))
        return effect
    }()
    
    lazy var textureBufferID : GLuint = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let glkView = view as? GLKView else {
            return
        }
        
        glkView.context = context
        
        
        
        EAGLContext.setCurrent(glkView.context)
        
        // 以下两步等同于
        glGenTextures(1, &textureBufferID)
        
        glBindTexture(GLenum(GL_ARRAY_BUFFER), textureBufferID)
        
        glBufferData(GLenum(GL_ARRAY_BUFFER), vertices.size, vertices, GLenum(GL_STATIC_DRAW))
        
        // 复制图片像素的颜色数据到绑定的纹理缓存中
//        glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA, GLsizei(imgRef.width), GLsizei(imgRef.height), 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), imgRef.decode)
        
//        glTexParameterf(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GLfloat(GLenum(GL_LINEAR)))
        
        
//        print("glGetError():\(glGetError())")
        
        do {
            let imgRef : CGImage = #imageLiteral(resourceName: "s27239039.png").cgImage!
            let textinfo : GLKTextureInfo = try GLKTextureLoader.texture(with: imgRef, options: nil)
            
            baseEffect.texture2d0.name = textinfo.name
            baseEffect.texture2d0.target = GLKTextureTarget(rawValue: textinfo.target)!

        } catch {
            print(error.localizedDescription)
        }

        
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        baseEffect.prepareToDraw()
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_REPEAT)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_REPEAT)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), textureBufferID)
        
        glEnableVertexAttribArray(GLuint(3))
        
        glVertexAttribPointer(GLuint(GLKVertexAttrib.position.rawValue), GLint(3), GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(SceneVertex.size), nil)
        
        glEnableVertexAttribArray(GLuint(2))
        var usp = MemoryLayout<GLKVector3>.stride
        glVertexAttribPointer(GLuint(GLKVertexAttrib.position.rawValue), GLint(2), GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(SceneVertex.size), &usp)
        
        glDrawArrays(GLenum(GL_TRIANGLES), 0, GLsizei(3))
        
    }

}

