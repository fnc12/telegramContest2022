import UIKit
import Photos

class Library2VC: UIViewController {
    var scrollView: UIScrollView!
    var cells = [Int: ImagesRowView]()
    var targetView: TargetView!
    
    let viewModel = LibraryViewModel()
    
    var scroller: Scroller!
    
    var calls = [ScrollerCall]()
    var callIndex = -1
    var shouldSyncScrollerWithScrollView: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        scrollView = .init().then {
            $0.delegate = self
            $0.backgroundColor = .white
            $0.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(scrollViewPinch(sender:))))
            $0.contentInsetAdjustmentBehavior = .never
            $0.clipsToBounds = false
            $0.layer.masksToBounds = false
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(view.safeAreaLayoutGuide)
//                make.edges.equalToSuperview()
            }
        }
        
        view.layoutIfNeeded()
        
        let viewWidth = view.frame.width
        print("viewWidth = \(viewWidth)")
        viewModel.viewWidth = viewWidth
        viewModel.imagesPerRow = 10
        viewModel.rowHeight = viewWidth / CGFloat(viewModel.imagesPerRow)
        viewModel.originalRowHeight = viewModel.rowHeight
        
        let zoomLocation = CGPoint(x: viewModel.rowHeight * 2, y: viewModel.rowHeight * 10)
        print("zoomLocation = \(zoomLocation)")
        calls.append(.zoomBegan(relativeScale: 1.0, location: zoomLocation))
        for i in stride(from: 1.0, to: 2.0, by: 0.01) {
            calls.append(.zoomChanged(relativeScale: i))
        }
        calls.append(.zoomEnded(relativeScale: 2.0))
        
        /*calls.append(.zoomBegan(relativeScale: 1.0, location: zoomLocation))
        for i in stride(from: 1.0, to: 2.0, by: 0.01) {
            calls.append(.zoomChanged(relativeScale: i))
        }
        calls.append(.zoomEnded(relativeScale: 2.0))*/
        
        calls.append(.zoomBegan(relativeScale: 1.0, location: zoomLocation))
        for i in stride(from: 1.0, to: 0.5, by: -0.01) {
            calls.append(.zoomChanged(relativeScale: i))
        }
        calls.append(.zoomEnded(relativeScale: 0.5))
        
//        let contentInsetAdjustmentBehavior = scrollView.contentInsetAdjustmentBehavior
        
        targetView = .init(frame: .init(x: zoomLocation.x, y: zoomLocation.y, width: 1, height: 1)).then {
            $0.isHidden = true
            view.addSubview($0)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchResult = PHAsset.fetchAssets(with: .image, options: nil)
        viewModel.calculate()
        
        scroller = .init(originalContentSize: .init(width: view.frame.width, height: viewModel.originalRowHeight * CGFloat(viewModel.rowsCount)),
                         viewportHeight: scrollView.frame.height)
        
        print("photosCount = \(viewModel.photosCount)")
        print("rowHeight = \(viewModel.rowHeight)")
        reloadData()
        
//        runScript()
        
        /*scroller.contentOffset = .init(x: -viewModel.rowHeight, y: -viewModel.rowHeight)
        scrollView.setContentOffset(.init(x: scrollView.contentOffset.x, y: -scroller.contentOffset.y), animated: false)
        refreshPhotosStartX()*/
        
//        scroller.scale = 2
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let scrollView {
            scroller?.viewportHeight = scrollView.frame.height
        }
    }
    
    func runScript() {
        targetView.isHidden = false
        delay(0.01) {
            self.callIndex += 1
            if self.callIndex < self.calls.count {
                let call = self.calls[self.callIndex]
                self.perform(call: call)
                self.runScript()
            } else {
                print("script ended")
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func reloadData() {
        cells.forEach { $1.removeFromSuperview() }
        cells.removeAll()
        
        scrollView.contentSize = .init(width: view.frame.width, height: viewModel.rowHeight * CGFloat(viewModel.rowsCount))
        let rowSize = CGSize(width: viewModel.viewWidth * scroller.scale, height: viewModel.rowHeight)
        for rowIndex in 0..<viewModel.rowsCount {
            ImagesRowView(frame: .init(origin: .init(x: 0, y: CGFloat(rowIndex) * viewModel.rowHeight), size: rowSize)).do {
                $0.imagesCount = viewModel.imagesPerRow
                $0.photoViews.enumerated().forEach {
                    $1.label.text = ($0 + rowIndex * viewModel.imagesPerRow).description
                }
                scrollView.addSubview($0)
                cells[rowIndex] = $0
            }
        }
    }
    
    func refreshPhotosStartX() {
        cells.forEach {
            $1.photosStartX = scroller.contentOffset.x
        }
    }
    
    func perform(call: ScrollerCall) {
        scroller.perform(call: call)
        viewModel.rowHeight = viewModel.originalRowHeight * scroller.scale
        scrollView.contentSize = .init(width: scrollView.frame.width, height: scroller.zoomedContentSize.height)
//        print("scrollView.setContentOffset(\(CGPoint(x: scrollView.contentOffset.x, y: -scroller.contentOffset.y)))")
        shouldSyncScrollerWithScrollView = false
        scrollView.setContentOffset(.init(x: scrollView.contentOffset.x, y: -scroller.contentOffset.y), animated: false)
        shouldSyncScrollerWithScrollView = true
        let scrollViewYMax = scrollView.contentSize.height - scrollView.frame.height
        /*if scrollView.contentOffset.y > scrollViewYMax {
            print("scrollView contentOffset is invalid, scrollViewYMax = \(scrollViewYMax), scrollView.contentOffset.y = \(scrollView.contentOffset.y), content height = \(scrollView.contentSize.height), scrollView.height = \(scrollView.frame.height)")
        }*/
        cells.forEach {
            $1.frame = .init(x: 0, y: CGFloat($0) * viewModel.rowHeight, width: scrollView.frame.width, height: viewModel.rowHeight)
        }
        refreshPhotosStartX()
        
        if case ScrollerCall.zoomEnded = call {
            let desiredImagesPerColumn = evaluateDesiredImagesPerColumn()
            let desiredScale = viewModel.viewWidth / (viewModel.originalRowHeight * CGFloat(desiredImagesPerColumn))
//            print("cells per screen width = \(viewModel.viewWidth / viewModel.rowHeight), desiredImagesPerColumn = \(desiredImagesPerColumn)")
//            print("scale = \(scroller.scale), desiredScale = \(desiredScale)")
        }
    }
    
    func evaluateDesiredImagesPerColumn() -> Int {
        return Int(floor(viewModel.viewWidth / viewModel.rowHeight + 0.5))
    }
    
    //  MARK: - Events
    
    @objc func scrollViewPinch(sender: UIPinchGestureRecognizer) {
        var call: ScrollerCall?
        switch sender.state {
        case .began:
            guard let senderView = sender.view else { return }
            var location = sender.location(in: senderView)
            location.y -= scrollView.contentOffset.y
            call = .zoomBegan(relativeScale: sender.scale, location: location)
//            scroller.contentOffset = scrollView.contentOffset
        case .changed:
            call = .zoomChanged(relativeScale: sender.scale)
        case .ended:
            call = .zoomEnded(relativeScale: sender.scale)
        default:
            break
        }
        if let call {
            perform(call: call)
        }
    }
}

extension Library2VC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if shouldSyncScrollerWithScrollView {
            scroller.contentOffset = .init(x: scroller.contentOffset.x, y: -scrollView.contentOffset.y)
        }
//        print("scrollViewDidScroll: scroller.y = \(scroller.contentOffset.y), scrollView.y = \(scrollView.contentOffset.y)")
//        scrollView.setContentOffset(.init(x: scrollView.contentOffset.x, y: -scroller.contentOffset.y), animated: false)
    }
}
