import Foundation

struct Preferences {
    static var windowWidth : CGFloat = 1000
    static var windowHeight : CGFloat = 1000
    static var fractalID : Int = 2
    
    static var initialScale : Float = 1
    static var scaleFactor : Float = 10
    
    
    
}
struct MandelBrotPreferences {
    static var maxItterations : UInt32 = 500
    
    static var initialCOffset : [Float] = [0, 0]
    static var COffsetFactors : [Float] = [0, 0]
}


struct ReverseMandelBrotPreferences {
    static var maxItterations : UInt32 = 500
    static var CConst : [Float] = [ -0.5251993,  -0.5251993]
}
