//
//  ViewController.swift
//  Demo2
//
//  Created by ADDICE on 2018/3/29.
//  Copyright © 2018年 ADDICE. All rights reserved.
//

import UIKit
import OpenGLES
import GLKit

//struct SceneVertex {
//    var positionCoords : GLKVector3
//    
//    init(_ positionCoords: GLKVector3) {
//        self.positionCoords = positionCoords
//    }
//}


class ViewController: UIViewController {
    
    /// 上下文
    lazy var context = EAGLContext(api: .openGLES3)
    
    /// 着色器
    lazy var baseEffect : GLKBaseEffect = {
        let effect = GLKBaseEffect()
        effect.useConstantColor = GLboolean(GL_TRUE)
        // 绘制图形的颜色，比如这个是设置 alpha 为 1 的白色
        effect.constantColor = GLKVector4(v: (1,1,1,1))
        return effect
    }()
    
    /// 顶点数据， 使用 三个顶点 来绘制一个 三角形, GLKVector3 相当于空间坐标轴的三个顶点，xyz，每个坐标轴的范围均是 [-1,1]。另外，空间坐标轴的原点是在屏幕中心
    lazy var vertor3s: [GLKVector3] =  [
        GLKVector3(v: (-1, -1, 0)),       // 左下角
        GLKVector3(v: (1, -1, 0)),        // 右下角
        GLKVector3(v: (-1, 1, 0))         // 左上角
    ]
    
    /// 缓存的唯一标识符，当前表示为 0。而 0 也恰恰表示没有缓存
    lazy var vertextBufferId = GLuint()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let glkView = OGLKView(frame: view.bounds, with: context)
        glkView.delegate = self
        view.addSubview(glkView)
        
        EAGLContext.setCurrent(glkView.context)
        
        // 设置背景色, 默认是黑色，也就是 (0,0,0,1)
        glClearColor(0.5, 0.5, 0.5, 1)
        
        /*
         概括来港，前三个步骤就是：
         1. 为缓存生成一个唯一标识符
         2. 为接下来的运算绑定缓存
         3. 复制数据到缓存中
         */
        
        // 1. 为缓存生成唯一标识符
        glGenBuffers(1, &vertextBufferId)
        // 2. 告诉 OpenGLES 接下来准备使用一个缓存
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertextBufferId)
        // 3. 复制顶点数据到当前 context 所绑定的缓存顶点数据。 GL_ARRAY_BUFFER 是 OpenGL 的缓存对象类型之一。而 glBufferData(,,,) 的四个参数，1⃣️表示 缓存对象类型；2⃣️表示顶点数据的内存大小；3⃣️表示我们需要的数据；4⃣️表示我们希望显卡怎样管理我们的数据，GL_STATIC_DRAW 指数据不会或几乎不会改变，另外还有 GL_DYNAMIC_DRAW 指数据会被改变很多，GL_STREAM_DRAW 指数据每次绘制都会改变
        glBufferData(GLenum(GL_ARRAY_BUFFER), vertor3s.count * MemoryLayout<GLKVector3>.size, vertor3s, GLenum(GL_STATIC_DRAW))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: OGLKViewDelegate {
    
    func glkView(_ view: OGLKView, drawIn rect: CGRect) {
        // 开始渲染时，需要先调用 着色器 的 prepareToDraw
        baseEffect.prepareToDraw()
        
        // 清除屏幕的颜色缓存
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT));
        
        // 4. 告诉 OpenGL 在接下来的渲染中是否使用缓存数据
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.position.rawValue))
        // 5. 告诉 OpenGL 在缓存中的数据的类型和所有需要访问的数据的内存偏移值。该函数有 6 个参数。1⃣️表示当前绑定的缓存包含每个顶点的位置信息；2⃣️表示每个顶点是有三个元素组成的，其实就是xyz；3⃣️表示每个部分都保存为一个浮点型的数据；4⃣️表示小数点固定数据是否可以被改变；5⃣️表示每个顶点数据所占的字节大小，也叫“步幅”；6⃣️使用nil，表示可以从当前绑定的顶点缓存的开始位置访问顶点数据
        glVertexAttribPointer(GLuint(GLKVertexAttrib.position.rawValue), GLint(3), GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLKVector3>.size), nil)
        // 6. 执行绘图。该函数有 3 个参数。1⃣️表示绘图类型；2⃣️表示缓存里的需要渲染的第一个顶点的位置；3⃣️表示需要渲染的顶点个数
        glDrawArrays(GLenum(GL_TRIANGLES), 0, GLsizei(vertor3s.count))
    }
    
}
