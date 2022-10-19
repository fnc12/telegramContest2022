import Foundation

class Scroller {
    var contentOffset = CGPoint(x: 0, y: 0)
    private(set) var originalContentSize: CGSize
    private(set) var zoomedContentSize: CGSize
    private(set) var scale = CGFloat(1)
    var viewportHeight = CGFloat(0)
    
    private struct ZoomContext {
        let location: CGPoint
        let startScale: CGFloat
        let startContentOffset: CGPoint
        let startContentSize: CGSize
    }
    private var zoomContext: ZoomContext?
    
    init(originalContentSize: CGSize, viewportHeight: CGFloat) {
        self.originalContentSize = originalContentSize
        self.zoomedContentSize = originalContentSize
        self.viewportHeight = viewportHeight
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
        update(newScale: zoomContext.startScale * relativeScale,
               location: zoomContext.location,
               startContentOffset: zoomContext.startContentOffset,
               startContentSize: zoomContext.startContentSize)
    }
    
    func update(newScale: CGFloat, location: CGPoint, startContentOffset: CGPoint, startContentSize: CGSize) {
        let newZoomedContentSize = originalContentSize * newScale
        update(newScale: newScale, newContentOffset: CGPoint(x: location.x - newZoomedContentSize.width * ((location.x - startContentOffset.x) / startContentSize.width),
                                                             y: location.y - newZoomedContentSize.height * ((location.y - startContentOffset.y) / startContentSize.height)))
    }
    
    func update(newScale: CGFloat, newContentOffset: CGPoint) {
        var newContentOffset2 = newContentOffset
        let newZoomedContentSize = originalContentSize * newScale
        let contentOffsetYMax = -newZoomedContentSize.height + viewportHeight
        if newContentOffset2.y > 0 {
            newContentOffset2.y = 0
        } else if newContentOffset2.y < contentOffsetYMax {
            newContentOffset2.y = contentOffsetYMax
        }
        scale = newScale
        zoomedContentSize = newZoomedContentSize
        contentOffset = newContentOffset2
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
}
