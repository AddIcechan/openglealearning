//
//  Extension.swift
//  OpenGLES_Demo
//
//  Created by ADDICE on 2018/11/2.
//  Copyright © 2018 ADDICE. All rights reserved.
//

import Foundation
import GLKit

struct SceneVertor {
    var postion : GLKVector3
    var texture : GLKVector2
    
    init(_ value:(Float, Float, Float, Float, Float)) {
        self.postion = GLKVector3(v: (value.0, value.1, value.2))
        self.texture = GLKVector2(v: (value.3, value.4))
    }
}

protocol GLKitExtensionProtocol { }

extension GLKitExtensionProtocol where Self == Int32 {
    
    var glEnum : GLenum {
       return GLenum(self)
    }
    
}

extension GLKitExtensionProtocol where Self == Int {
    
    var glsizei : GLsizei {
        return GLsizei(self)
    }
    
}

extension Int32 : GLKitExtensionProtocol { }

extension Float32 : GLKitExtensionProtocol { }

extension Int : GLKitExtensionProtocol { }

extension String {
    
    
    
}

struct Poza<T> {
    let base : T
    init(_ base: T) {
        self.base = base
    }
}

protocol NameCompatible {
    associatedtype CompatibleType = Numeric
    var pz : Poza<CompatibleType> { get }
    static var PZ : Poza<CompatibleType>.Type { get }
}

extension NameCompatible {
    var pz : Poza<Self> {
        return Poza(self)
    }
    
    public static var PZ : Poza<Self>.Type {
        return Poza<Self>.self
    }
    
}

extension Int32 : NameCompatible { }

extension Poza where T == Int32 {
    
    var glEnum : GLenum {
        return GLenum(base)
    }
    
}

extension Array {
    
    var size : Int {
        return count * MemoryLayout<Element>.size
    }
    
}

extension Bool {
    
//    var numberValue : NSNumber {
//        return NSNumber(value: self)
//    }
}


extension String {
    
    func withGLChar(_ operation:(UnsafePointer<GLchar>) -> ()) {
        if let value = self.cString(using:String.Encoding.utf8) {
            operation(UnsafePointer<GLchar>(value))
        } else {
            fatalError("Could not convert this string to UTF8: \(self)")
        }
    }
    
}



//extension UnsafePointer {
//    subscript<Field>(field: KeyPath<Pointee, Field>) -> UnsafePointer<Field> {
//        return (UnsafeRawPointer(self) + (MemoryLayout<Pointee>.offset(of: field) ?? 0))
//            .assumingMemoryBound(to: Field.self)
//    }
//}
//
//extension UnsafeMutablePointer {
//    subscript<Field>(field: KeyPath<Pointee, Field>) -> UnsafePointer<Field> {
//        return (UnsafeRawPointer(self) + (MemoryLayout<Pointee>.offset(of: field) ?? 0))
//            .assumingMemoryBound(to: Field.self)
//    }
//
//    subscript<Field>(field: WritableKeyPath<Pointee, Field>) -> UnsafeMutablePointer<Field> {
//        return (UnsafeMutableRawPointer(self) + (MemoryLayout<Pointee>.offset(of: field) ?? 0))
//            .assumingMemoryBound(to: Field.self)
//    }
//}
