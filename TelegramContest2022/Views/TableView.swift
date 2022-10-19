import UIKit

class TableView: UITableView {
    var isContentOffsetImmutable: Bool = false
    
    static var setContentOffsetCallsCount = 0
    
    var contentOffsetToIngore: CGPoint?
    
    override var contentOffset: CGPoint {
        set {
            Self.setContentOffsetCallsCount += 1
            guard !isContentOffsetImmutable else { return }
            guard contentOffsetToIngore != newValue else {
                print("ignored \(newValue)")
                return
            }
            if (15...18).contains(Self.setContentOffsetCallsCount) {
                var i = 0
                i += 1
            }
            print("\(Self.setContentOffsetCallsCount)) will set contentOffset \(newValue)")
            super.contentOffset = newValue
        }
        get {
            return super.contentOffset
        }
    }
    
    override func setContentOffset(_ contentOffset: CGPoint, animated: Bool) {
        print("will set contentOffset \(contentOffset), animted \(animated)")
        super.setContentOffset(contentOffset, animated: animated)
    }
}
