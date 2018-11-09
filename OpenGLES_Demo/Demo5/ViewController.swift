//
//  ViewController.swift
//  Demo5
//
//  Created by ADDICE on 2018/11/6.
//  Copyright © 2018 ADDICE. All rights reserved.
//

import UIKit
import GLKit



class ViewController: GLKViewController {

    
    lazy var postions : [GLfloat] = [
        -0.5, -0.5, 0.0, 1, 0, 0,
        0.5, -0.5, 0.0,  0, 1, 0,
        0.0,  0.5, 0.0,   0, 0, 1,
    ]
    
    var VBO = GLuint()
    var VAO = GLuint()
    
    lazy var shaderProgram = glCreateProgram()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let view = view as? GLKView else {
            return
        }
        
        view.context = EAGLContext(api: .openGLES3)!
        view.drawableColorFormat = .RGBA8888
        EAGLContext.setCurrent(view.context)
        
        guard let vertextStr = try? String(contentsOfFile: Bundle.main.path(forResource: "VertexShader", ofType: "vert")!),
            let fragmentStr = try? String(contentsOfFile: Bundle.main.path(forResource: "FragmentShader", ofType: "frag")!)
            else {
            
            return
        }
        
        // 创建对应的 shader
        let vertextShader = glCreateShader(GLenum(GL_VERTEX_SHADER))
        vertextStr.withGLChar {
            var tmpStr : UnsafePointer<GLchar>? = $0
            glShaderSource(vertextShader, 1, &tmpStr, nil)
            glCompileShader(vertextShader)
        }
        
        let fragmentShader = glCreateShader(GLenum(GL_FRAGMENT_SHADER))
        fragmentStr.withGLChar {
            var tmpStr : UnsafePointer<GLchar>? = $0
            glShaderSource(fragmentShader, 1, &tmpStr, nil)
            glCompileShader(fragmentShader)
        }
        
        // 链接shader
        glAttachShader(shaderProgram, vertextShader)
        glAttachShader(shaderProgram, fragmentShader)
        glLinkProgram(shaderProgram)
        
        glGetShaderiv(shaderProgram, GLenum(GL_LINK_STATUS), nil)

        defer {
            glDeleteShader(vertextShader)
            glDeleteShader(fragmentShader)
        }
        
        glUseProgram(shaderProgram)
        
        glGenVertexArrays(1, &VAO)
        glGenBuffers(1, &VBO)

        glBindVertexArray(VAO)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), VBO)

        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<GLfloat>.size * postions.count, postions, GLenum(GL_STATIC_DRAW))
        
        let posistionAtt : GLuint = GLuint(glGetAttribLocation(shaderProgram, "position"))
        
        glVertexAttribPointer(posistionAtt, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(6 * MemoryLayout<GLfloat>.size), nil)
        glEnableVertexAttribArray(posistionAtt)
        
        let ptr = UnsafePointer<Int>.init(bitPattern: 3 * MemoryLayout<GLfloat>.size)
        
        let colorAtt : GLuint = GLuint(glGetAttribLocation(shaderProgram, "color"))
        glVertexAttribPointer(colorAtt, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(6 * MemoryLayout<GLfloat>.size), ptr)
        glEnableVertexAttribArray(colorAtt)
        
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        
        
        
        glBindVertexArray(VAO)
        
        glDrawArrays(GLenum(GL_TRIANGLES), 0, 3)
        
        
    }

}

