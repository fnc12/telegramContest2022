import UIKit
import Photos

class LibraryViewModel {
    var fetchResult: PHFetchResult<PHAsset>?
    var viewWidth = CGFloat(0)
    var imagesPerRow = 3
    private(set) var rowsCount = 0
    var rowHeight = CGFloat(0)
    var originalRowHeight = CGFloat(0)
    
    var itemWidth: CGFloat {
        viewWidth / CGFloat(imagesPerRow)
    }
    
    var photosCount: Int {
        let res = fetchResult?.count ?? 0
        /*guard res <= 10 else {
            return 10
        }*/
        return res
//        return 1000
    }
    
    func rowHeight(for scale: CGFloat) -> CGFloat {
        originalRowHeight * scale
    }
    
    func calculate() {
        guard let fetchResult = fetchResult, imagesPerRow > 0 else {
            rowsCount = 0
            return
        }
        rowsCount = rowsCount(for: fetchResult.count, imagesPerRow: imagesPerRow)
//        rowsCount = ((fetchResult.count - 1) / imagesPerRow) + 1
    }
    
    func rowsCount(for photosCount: Int, imagesPerRow: Int) -> Int {
        return ((photosCount - 1) / imagesPerRow) + 1
    }
    
    func items(at row: Int) -> Int {
        guard let fetchResult = fetchResult else { return 0 }
        if row == rowsCount - 1 {
            return fetchResult.count % imagesPerRow
        } else {
            return imagesPerRow
        }
    }
    
    func indexPathToPlainIndex(indexPath: IndexPath) -> Int {
        return indexPath.section * imagesPerRow + indexPath.row
    }
 
    func image(at indexPath: IndexPath) -> UIImage? {
        guard let fetchResult = fetchResult else { return nil }
        let plainIndex = indexPathToPlainIndex(indexPath: indexPath)
        guard plainIndex < fetchResult.count else { return nil }
        let asset = fetchResult.object(at: plainIndex)
        return asset.image(with: CGSize(width: itemWidth, height: itemWidth))
    }
}

extension PHAsset {

    func image(with size: CGSize) -> UIImage {
        var thumbnail = UIImage()
        let imageManager = PHCachingImageManager()
        imageManager.requestImage(for: self, targetSize: size, contentMode: .aspectFit, options: nil, resultHandler: { image, _ in
            thumbnail = image!
        })
        return thumbnail
    }
}
