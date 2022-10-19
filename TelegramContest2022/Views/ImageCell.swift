import UIKit

class ImageCell: UITableViewCell {
    var photoViews = [SinglePhotoView]()
    
    var imagesCount = 0 {
        didSet {
            refresh()
        }
    }
    
    var photosStartX = CGFloat(0)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard !photoViews.isEmpty else { return }
        let b = bounds.size
        let size = CGSize(width: b.height, height: b.height)
//        print("offsetRatio = \(offsetRatio), totalWidth = \(totalWidth), startX = \(startX)")
        for (photoViewIndex, photoView) in photoViews.enumerated() {
            photoView.frame = .init(origin: .init(x: photosStartX + CGFloat(photoViewIndex) * size.width, y: 0), size: size)
        }
    }
    
    //  MARK: - Public
    
    func refresh() {
        photoViews.forEach { $0.removeFromSuperview() }
        photoViews.removeAll()
        photoViews.reserveCapacity(imagesCount)
        for _ in 0..<imagesCount {
            let singlePhotoView = SinglePhotoView()
            contentView.addSubview(singlePhotoView)
            photoViews.append(singlePhotoView)
        }
        setNeedsLayout()
    }
}
