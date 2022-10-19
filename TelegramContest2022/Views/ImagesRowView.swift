import UIKit

class ImagesRowView: UIView {
    var photoViews = [SinglePhotoView]()
    
    var imagesCount = 0 {
        didSet {
            refresh()
        }
    }
    
    var photosStartX = CGFloat(0)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard !photoViews.isEmpty else { return }
        let b = bounds.size
        let size = CGSize(width: b.height, height: b.height)
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
            addSubview(singlePhotoView)
            photoViews.append(singlePhotoView)
        }
        setNeedsLayout()
    }
}
