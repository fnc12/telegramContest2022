import Foundation

class Scroller {
    var contentOffset = CGPoint(x: 0, y: 0)
    private(set) var originalContentSize: CGSize
    private(set) var zoomedContentSize: CGSize
    private(set) var scale = CGFloat(1)
    
    private struct ZoomContext {
        let location: CGPoint
        let startScale: CGFloat
        let startContentOffset: CGPoint
        let startContentSize: CGSize
    }
    private var zoomContext: ZoomContext?
    
    init(originalContentSize: CGSize) {
        self.originalContentSize = originalContentSize
        self.zoomedContentSize = originalContentSize
    }
    
    func zoomBegan(relativeScale: CGFloat, location: CGPoint) {
        guard nil == zoomContext else {
            fatalError()
        }
        zoomContext = .init(location: location, startScale: scale, startContentOffset: contentOffset, startContentSize: zoomedContentSize)
        processZoom(relativeScale: relativeScale)
    }
    
    func zoomChanged(relativeScale: CGFloat) {
        processZoom(relativeScale: relativeScale)
    }
    
    func zoomEnded(relativeScale: CGFloat) {
        processZoom(relativeScale: relativeScale)
        self.zoomContext = nil
    }
    
    func perform(call: ScrollerCall) {
        switch call {
        case .zoomBegan(let relativeScale, let location):
            zoomBegan(relativeScale: relativeScale, location: location)
        case .zoomChanged(let relativeScale):
            zoomChanged(relativeScale: relativeScale)
        case .zoomEnded(let relativeScale):
            zoomEnded(relativeScale: relativeScale)
        }
    }
    
    private func processZoom(relativeScale: CGFloat) {
        guard let zoomContext = zoomContext else {
            fatalError()
        }
        scale = zoomContext.startScale * relativeScale
        zoomedContentSize = originalContentSize * scale
        let xOffset = zoomContext.location.x - zoomContext.startContentOffset.x
        let leftSideRatio = xOffset / zoomContext.startContentSize.width
        let yOffset = zoomContext.location.y - zoomContext.startContentOffset.y
        let rightSideRatio = yOffset / zoomContext.startContentSize.height
        contentOffset.x = zoomContext.location.x - zoomedContentSize.width * leftSideRatio
        contentOffset.y = zoomContext.location.y - zoomedContentSize.height * rightSideRatio
    }
}

fileprivate func *(lhs: CGSize, rhs: CGFloat) -> CGSize {
    return .init(width: lhs.width * rhs, height: lhs.height * rhs)
}

fileprivate func -(lhs: CGPoint, rhs: CGSize) -> CGPoint {
    return .init(x: lhs.x - rhs.width, y: lhs.y - rhs.height)
}

fileprivate func /(lhs: CGSize, rhs: CGFloat) -> CGSize {
    return .init(width: lhs.width / rhs, height: lhs.height / rhs)
}

enum ScrollerCall {
    case zoomBegan(relativeScale: CGFloat, location: CGPoint)
    case zoomChanged(relativeScale: CGFloat)
    case zoomEnded(relativeScale: CGFloat)
    
    /*var scale: CGFloat {
        switch self {
        case .zoomBegan(let relativeScale, _):
            return relativeScale
        case .zoomChanged(let relativeScale):
            return relativeScale
        case .zoomEnded(let relativeScale):
            return relativeScale
        }
    }*/
}
