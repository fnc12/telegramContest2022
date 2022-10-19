import UIKit
import Photos

extension UITableView {
    public func reloadDataAndKeepOffset() {
        // stop scrolling
        setContentOffset(contentOffset, animated: false)
            
        // calculate the offset and reloadData
        let beforeContentSize = contentSize
        reloadData()
        layoutIfNeeded()
        let afterContentSize = contentSize
            
        // reset the contentOffset after data is updated
        let newOffset = CGPoint(
            x: contentOffset.x + (afterContentSize.width - beforeContentSize.width),
            y: contentOffset.y + (afterContentSize.height - beforeContentSize.height))
        setContentOffset(newOffset, animated: false)
    }
}

class LibraryVC: UIViewController {
    var tableView: MyTableView!
    var targetView: TargetView!
    
    let cellId = "cellId"
    
    let viewModel = LibraryViewModel()
    
    var itemWidth = CGFloat(0)
    
    var scroller: Scroller!
    
    var libraryZoomerCalls = [LibraryZoomerCall]()
    var callIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        let viewWidth = view.frame.width
        
        viewModel.viewWidth = viewWidth
        viewModel.imagesPerRow = 10
        viewModel.rowHeight = viewWidth / CGFloat(viewModel.imagesPerRow)
        viewModel.originalRowHeight = viewModel.rowHeight
        
        tableView = .init().then {
            $0.delegate = self
            $0.dataSource = self
            $0.separatorColor = .clear
            $0.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(tableViewPinch(sender:))))
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(view.safeAreaLayoutGuide)
            }
        }
        
        targetView = .init(frame: .init(x: 0, y: 0, width: 1, height: 1)).then {
            $0.isHidden = true
            view.addSubview($0)
        }
        
        libraryZoomerCalls = [
            .zoomBegan(location: .init(x: viewWidth / 2, y: view.frame.height / 2), scale: 1),
        ]
        for i in stride(from: 1.001, to: 2.0, by: 0.001) {
            libraryZoomerCalls.append(.zoomChanged(scale: i))
        }
        libraryZoomerCalls.append(.zoomEnded(scale: 2.0))
        
        libraryZoomerCalls.append(.zoomBegan(location: .init(x: 3 * viewWidth / 4, y: view.frame.height / 2), scale: 1))
        for i in stride(from: 1.001, to: 2.0, by: 0.001) {
            libraryZoomerCalls.append(.zoomChanged(scale: i))
        }
        libraryZoomerCalls.append(.zoomEnded(scale: 2.0))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchResult = PHAsset.fetchAssets(with: .image, options: nil)
        viewModel.calculate()
        
        scroller = .init(originalContentSize: .init(width: view.frame.width, height: viewModel.originalRowHeight * CGFloat(viewModel.rowsCount)))
        
        print("photosCount = \(viewModel.photosCount)")
        
//        tableView.reloadData()
//        tableView.contentOffset = .init(x: 0, y: viewModel.originalRowHeight * 3)
//        scroller.contentOffset = .init(x: 0, y: -tableView.contentOffset.y)
        
//        print("initial content offset = \(tableView.contentOffset)")
        
//        tableView.contentOffsetToIngore = .init(x: 0, y: 117.0)
//        runScript()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func runScript() {
        targetView.isHidden = false
        delay(0.01) {
            self.callIndex += 1
            if self.callIndex < self.libraryZoomerCalls.count {
                let call = self.libraryZoomerCalls[self.callIndex]
                switch call {
                case .zoomBegan(let location, let scale):
                    self.scroller.zoomBegan(relativeScale: scale, location: location)
                    self.viewModel.rowHeight = self.viewModel.originalRowHeight * self.scroller.scale
                    
                    self.targetView.frame = .init(origin: location, size: .init(width: 1, height: 1))
                case .zoomChanged(let scale):
                    self.scroller.zoomChanged(relativeScale: scale)
                    self.viewModel.rowHeight = self.viewModel.originalRowHeight * self.scroller.scale
                case .zoomEnded(let scale):
                    self.scroller.zoomEnded(relativeScale: scale)
                    self.viewModel.rowHeight = self.viewModel.originalRowHeight * self.scroller.scale
                }
//                self.tableView.isContentOffsetImmutable = true
                print("before reloadData")
//                self.tableView.reloadData()
                self.tableView.reloadDataAndKeepOffset()
                print("after reloadData")
//                self.tableView.isContentOffsetImmutable = false
                let newContentOffset = CGPoint(x: self.tableView.contentOffset.x, y: -self.scroller.contentOffset.y)
                print("newContentOffset = \(newContentOffset)")
                self.tableView.setContentOffset(newContentOffset, animated: false)
                print("tableView.contentOffset = \(self.tableView.contentOffset)")
                self.runScript()
            } else {
                print("script ended")
            }
        }
    }
    
    //  MARK: - Events
    
    @objc func tableViewPinch(sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .began:
//            guard let senderView = sender.view else { return }
//            scroller.contentOffset = tableView.contentOffset
            scroller.zoomBegan(relativeScale: sender.scale, location: sender.location(in: view))
        case .changed:
            scroller.zoomChanged(relativeScale: sender.scale)
        case .ended:
            scroller.zoomEnded(relativeScale: sender.scale)
        default:
            break
        }
        viewModel.rowHeight = viewModel.originalRowHeight * scroller.scale
//        self.tableView.reloadData()
        self.tableView.reloadDataAndKeepOffset()
        let newContentOffset = CGPoint(x: tableView.contentOffset.x, y: -scroller.contentOffset.y)
        tableView.setContentOffset(newContentOffset, animated: false)
        print("newContentOffset = \(newContentOffset), tableView.contentOffset = \(tableView.contentOffset), state = \(sender.state.rawValue)")
    }
}

extension LibraryVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("contentOffset = \(scrollView.contentOffset)")
    }
}

extension LibraryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.rowHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let imageCell = cell as? ImageCell else { return }
        imageCell.photosStartX = scroller.contentOffset.x
        for i in 0..<viewModel.imagesPerRow {
            let photoIndex = indexPath.row * viewModel.imagesPerRow + i
            imageCell.photoViews[i].label.text = photoIndex.description
        }
    }
}

extension LibraryVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowsCount(for: viewModel.photosCount, imagesPerRow: viewModel.imagesPerRow)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        struct Cell {
            static let id = "id"
        }
        var res = tableView.dequeueReusableCell(withIdentifier: Cell.id)
        if nil == res {
            res = ImageCell(style: .default, reuseIdentifier: Cell.id).then {
                $0.selectionStyle = .none
                $0.imagesCount = viewModel.imagesPerRow
            }
        }
        return res!
    }
}

func delay(_ delay: Double, closure: @escaping () -> Void) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}
