import XCTest
@testable import TelegramContest2022

extension FloatingPoint {
    func isNearlyEqual(to value: Self) -> Bool {
        let absA = abs(self)
        let absB = abs(value);
        let diff = abs(self - value);

        if self == value { // shortcut, handles infinities
            return true
        } else if self == .zero || value == .zero || (absA + absB) < Self.leastNormalMagnitude {
            // a or b is zero or both are extremely close to it
            // relative error is less meaningful here
            return diff < Self.ulpOfOne * Self.leastNormalMagnitude
        } else { // use relative error
            return diff / min((absA + absB), Self.greatestFiniteMagnitude) < .ulpOfOne;
        }
    }
}

extension CGSize {
    func isNearlyEqual(to value: Self) -> Bool {
        return width.isNearlyEqual(to: value.width) && height.isNearlyEqual(to: value.height)
    }
}

extension CGPoint {
    func isNearlyEqual(to value: Self) -> Bool {
        return x.isNearlyEqual(to: value.x) && y.isNearlyEqual(to: value.y)
    }
}

class ScrollerTests: XCTestCase {
    
    func testZoomQuater() {
        let scroller = Scroller(originalContentSize: .init(width: 100, height: 100))
        scroller.zoomBegan(relativeScale: 1.1, location: .init(x: 25, y: 25))
        XCTAssertEqual(scroller.scale, 1.1)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 110, height: 110)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -2.5000000000000036, y: -2.5000000000000036)) //  OMG
        
        scroller.zoomChanged(relativeScale: 1.2)
        XCTAssertEqual(scroller.scale, 1.2)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 120, height: 120)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -5, y: -5))
        
        scroller.zoomChanged(relativeScale: 1.3)
        XCTAssertEqual(scroller.scale, 1.3)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 130, height: 130)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -7.5, y: -7.5))
        
        scroller.zoomChanged(relativeScale: 1.4)
        XCTAssertEqual(scroller.scale, 1.4)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 140, height: 140)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -10, y: -10))
        
        scroller.zoomChanged(relativeScale: 1.5)
        XCTAssertEqual(scroller.scale, 1.5)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 150, height: 150)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -12.5, y: -12.5))
        
        scroller.zoomChanged(relativeScale: 1.6)
        XCTAssertEqual(scroller.scale, 1.6)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 160, height: 160)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -15, y: -15))
        
        scroller.zoomChanged(relativeScale: 1.7)
        XCTAssertEqual(scroller.scale, 1.7)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 170, height: 170)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -17.5, y: -17.5))
        
        scroller.zoomChanged(relativeScale: 1.8)
        XCTAssertEqual(scroller.scale, 1.8)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 180, height: 180)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -20, y: -20))
        
        scroller.zoomChanged(relativeScale: 1.9)
        XCTAssertEqual(scroller.scale, 1.9)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 190, height: 190)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -22.5, y: -22.5))
        
        scroller.zoomEnded(relativeScale: 2.0)
        XCTAssertEqual(scroller.scale, 2.0)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 200, height: 200)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -25, y: -25))
    }
    
    func testZoomRight() {
        let scroller = Scroller(originalContentSize: .init(width: 100, height: 100))
        scroller.zoomBegan(relativeScale: 1.1, location: .init(x: 100, y: 0))
        XCTAssertEqual(scroller.scale, 1.1)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 110, height: 110)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -10.000000000000014, y: 0))
        
        scroller.zoomChanged(relativeScale: 1.2)
        XCTAssertEqual(scroller.scale, 1.2)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 120, height: 120)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -20, y: 0))
        
        scroller.zoomChanged(relativeScale: 1.3)
        XCTAssertEqual(scroller.scale, 1.3)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 130, height: 130)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -30, y: 0))
        
        scroller.zoomChanged(relativeScale: 1.4)
        XCTAssertEqual(scroller.scale, 1.4)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 140, height: 140)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -40, y: 0))
        
        scroller.zoomChanged(relativeScale: 1.5)
        XCTAssertEqual(scroller.scale, 1.5)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 150, height: 150)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -50, y: 0))
        
        scroller.zoomChanged(relativeScale: 1.6)
        XCTAssertEqual(scroller.scale, 1.6)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 160, height: 160)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -60, y: 0))
        
        scroller.zoomChanged(relativeScale: 1.7)
        XCTAssertEqual(scroller.scale, 1.7)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 170, height: 170)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -70, y: 0))
        
        scroller.zoomChanged(relativeScale: 1.8)
        XCTAssertEqual(scroller.scale, 1.8)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 180, height: 180)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -80, y: 0))
        
        scroller.zoomChanged(relativeScale: 1.9)
        XCTAssertEqual(scroller.scale, 1.9)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 190, height: 190)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -90, y: 0))
        
        scroller.zoomEnded(relativeScale: 2.0)
        XCTAssertEqual(scroller.scale, 2.0)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 200, height: 200)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -100, y: 0))
    }
    
    func testZoomLeft() {
        let scroller = Scroller(originalContentSize: .init(width: 100, height: 100))
        scroller.zoomBegan(relativeScale: 1.1, location: .init(x: 0, y: 0))
        XCTAssertEqual(scroller.scale, 1.1)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 110, height: 110)))
        XCTAssertEqual(scroller.contentOffset, .init(x: 0, y: 0))
        
        scroller.zoomChanged(relativeScale: 1.2)
        XCTAssertEqual(scroller.scale, 1.2)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 120, height: 120)))
        XCTAssertEqual(scroller.contentOffset, .init(x: 0, y: 0))
        
        scroller.zoomChanged(relativeScale: 1.3)
        XCTAssertEqual(scroller.scale, 1.3)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 130, height: 130)))
        XCTAssertEqual(scroller.contentOffset, .init(x: 0, y: 0))
        
        scroller.zoomChanged(relativeScale: 1.4)
        XCTAssertEqual(scroller.scale, 1.4)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 140, height: 140)))
        XCTAssertEqual(scroller.contentOffset, .init(x: 0, y: 0))
        
        scroller.zoomChanged(relativeScale: 1.5)
        XCTAssertEqual(scroller.scale, 1.5)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 150, height: 150)))
        XCTAssertEqual(scroller.contentOffset, .init(x: 0, y: 0))
        
        scroller.zoomChanged(relativeScale: 1.6)
        XCTAssertEqual(scroller.scale, 1.6)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 160, height: 160)))
        XCTAssertEqual(scroller.contentOffset, .init(x: 0, y: 0))
        
        scroller.zoomChanged(relativeScale: 1.7)
        XCTAssertEqual(scroller.scale, 1.7)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 170, height: 170)))
        XCTAssertEqual(scroller.contentOffset, .init(x: 0, y: 0))
        
        scroller.zoomChanged(relativeScale: 1.8)
        XCTAssertEqual(scroller.scale, 1.8)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 180, height: 180)))
        XCTAssertEqual(scroller.contentOffset, .init(x: 0, y: 0))
        
        scroller.zoomChanged(relativeScale: 1.9)
        XCTAssertEqual(scroller.scale, 1.9)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 190, height: 190)))
        XCTAssertEqual(scroller.contentOffset, .init(x: 0, y: 0))
        
        scroller.zoomEnded(relativeScale: 2.0)
        XCTAssertEqual(scroller.scale, 2.0)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 200, height: 200)))
        XCTAssertEqual(scroller.contentOffset, .init(x: 0, y: 0))
    }
    
    func testZoomCenter() {
        let scroller = Scroller(originalContentSize: .init(width: 100, height: 100))
        scroller.zoomBegan(relativeScale: 1.1, location: .init(x: 50, y: 50))
        XCTAssertEqual(scroller.scale, 1.1)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 110, height: 110)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -5.000000000000007, y: -5.000000000000007)) //  OMG
        
        scroller.zoomChanged(relativeScale: 1.2)
        XCTAssertEqual(scroller.scale, 1.2)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 120, height: 120)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -10, y: -10))
        
        scroller.zoomChanged(relativeScale: 1.3)
        XCTAssertEqual(scroller.scale, 1.3)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 130, height: 130)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -15, y: -15))
        
        scroller.zoomChanged(relativeScale: 1.4)
        XCTAssertEqual(scroller.scale, 1.4)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 140, height: 140)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -20, y: -20))
        
        scroller.zoomChanged(relativeScale: 1.5)
        XCTAssertEqual(scroller.scale, 1.5)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 150, height: 150)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -25, y: -25))
        
        scroller.zoomChanged(relativeScale: 1.6)
        XCTAssertEqual(scroller.scale, 1.6)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 160, height: 160)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -30, y: -30))
        
        scroller.zoomChanged(relativeScale: 1.7)
        XCTAssertEqual(scroller.scale, 1.7)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 170, height: 170)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -35, y: -35))
        
        scroller.zoomChanged(relativeScale: 1.8)
        XCTAssertEqual(scroller.scale, 1.8)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 180, height: 180)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -40, y: -40))
        
        scroller.zoomChanged(relativeScale: 1.9)
        XCTAssertEqual(scroller.scale, 1.9)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 190, height: 190)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -45, y: -45))
        
        scroller.zoomEnded(relativeScale: 2.0)
        XCTAssertEqual(scroller.scale, 2.0)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 200, height: 200)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -50, y: -50))
        
        scroller.zoomBegan(relativeScale: 1.1, location: .init(x: 25, y: 25))
        XCTAssertEqual(scroller.scale, 2.2)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 220, height: 220)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -57.500000000000014, y: -57.500000000000014))
        
        scroller.zoomChanged(relativeScale: 1.2)
        XCTAssertEqual(scroller.scale, 2.4)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 240, height: 240)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -65, y: -65))
        
        scroller.zoomChanged(relativeScale: 1.3)
        XCTAssertEqual(scroller.scale, 2.6)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 260, height: 260)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -72.5, y: -72.5))
        
        scroller.zoomChanged(relativeScale: 1.4)
        XCTAssertEqual(scroller.scale, 2.8)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 280, height: 280)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -80, y: -80))
        
        scroller.zoomChanged(relativeScale: 1.5)
        XCTAssertEqual(scroller.scale, 3.0)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 300, height: 300)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -87.5, y: -87.5))
        
        scroller.zoomChanged(relativeScale: 1.6)
        XCTAssertEqual(scroller.scale, 3.2)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 320, height: 320)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -95, y: -95))
        
        scroller.zoomChanged(relativeScale: 1.7)
        XCTAssertEqual(scroller.scale, 3.4)
        XCTAssert(scroller.zoomedContentSize.isNearlyEqual(to: .init(width: 340, height: 340)))
        XCTAssertEqual(scroller.contentOffset, .init(x: -102.5, y: -102.5))
    }
}
