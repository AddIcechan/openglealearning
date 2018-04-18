//
//  ViewController.m
//  Demo3
//
//  Created by ADDICE on 2018/4/17.
//  Copyright © 2018年 ADDICE. All rights reserved.
//

#import "ViewController.h"
#import <OpenGLES/EAGL.h>

struct SceneVertex {
    GLKVector3 positionCoords;
    GLKVector2 textureCoords;
};

typedef struct SceneVertex SceneVertex;

//typedef struct {
//    GLKVector3  positionCoords;
//    GLKVector2  textureCoords;
//}
//SceneVertex;

static const SceneVertex vertices[] =
{
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}}, // lower left corner
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}}, // lower right corner
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}}, // upper left corner
};

@interface ViewController ()

@property (nonatomic, assign) GLuint textureBufferID;

@property (nonatomic, strong) EAGLContext *context;

@property (nonatomic, strong) GLKBaseEffect *effect;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    dispatch_block_wait(^{
//        
//        NSLog(@"111");
//        
//        sleep(2);
//        
//        NSLog(@"222");
//        
//    }, DISPATCH_TIME_NOW);
    
    GLKView *view = (GLKView *)self.view;
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    view.context = self.context;
    
    [EAGLContext setCurrentContext:view.context];
    
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.constantColor = GLKVector4Make(1, 1, 1, 1);
    self.effect.useConstantColor = GL_TRUE;
    
    glGenBuffers(1, &_textureBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, _textureBufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    UIImage *img = [UIImage imageNamed:@"s27239039"];
    CGImageRef ref = [img CGImage];
    NSError *error;
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:ref options:nil error:&error];
    if (!error) {
        self.effect.texture2d0.target = textureInfo.target;
        self.effect.texture2d0.name = textureInfo.name;
    }
    
    
    
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    [self.effect prepareToDraw];
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL + offsetof(SceneVertex, positionCoords));
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL + offsetof(SceneVertex, textureCoords));
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
    
}



@end
