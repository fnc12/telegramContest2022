import Foundation

class LibraryZoomer {
    let columnsCountMax = 10
    
    var offsetRatio = CGFloat(0.5)
    private var pinchLocation = CGPoint()
    private var scale = CGFloat(1)
    var viewportWidth = CGFloat(0)
    var rowHeight = CGFloat(0)
    var oldRowHeight = CGFloat(0)
    var contentOffsetX = CGFloat(0)
    var contentWidth = CGFloat(0)
    
    func zoomBegan(at location: CGPoint, scale: CGFloat) {
        pinchLocation = location
        let leftContentWidth = (viewportWidth * self.scale - viewportWidth) * offsetRatio
        print("scale = \(scale), pinchLocation.x = \(pinchLocation.x), viewportWidth = \(viewportWidth), offsetRatio = \(offsetRatio), leftContentWidth = \(leftContentWidth)")
        offsetRatio = (pinchLocation.x + leftContentWidth) / (viewportWidth * self.scale)
        print("location = \(pinchLocation), offsetRatio = \(offsetRatio)")
        update(with: scale)
    }
    
    func zoomChanged(scale: CGFloat) {
        update(with: scale)
    }
    
    func zoomEnded(scale: CGFloat) {
        self.scale *= scale
        update(with: scale)
        oldRowHeight = rowHeight
        print("ended scale = \(scale), self.scale = \(self.scale)")
    }
    
    private func update(with scale: CGFloat) {
        rowHeight = oldRowHeight * scale
        contentWidth = rowHeight * CGFloat(columnsCountMax)
        print("contentWidth = \(contentWidth), rowHeight = \(rowHeight), self.scale = \(self.scale), scale = \(scale)")
        contentOffsetX = viewportWidth * offsetRatio - contentWidth * offsetRatio
    }
}

enum LibraryZoomerCall {
    case zoomBegan(location: CGPoint, scale: CGFloat)
    case zoomChanged(scale: CGFloat)
    case zoomEnded(scale: CGFloat)
}
