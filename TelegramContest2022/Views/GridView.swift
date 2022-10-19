import UIKit

class GridView: UIView {
    
    var itemViews = [UIView]()
    
    var size: (width: Int, height: Int) = (width: 0, height: 0)
    var itemWidth = CGFloat(0)
    var spaceBetweenItems = CGFloat(1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refresh() {
        itemViews.forEach { $0.removeFromSuperview() }
        itemViews.removeAll()
        
        guard itemWidth > 0 else { return }
        itemViews.reserveCapacity(size.width * size.height)
        for x in 0..<size.width {
            for y in 0..<size.height {
                UIView(frame: .init(x: (spaceBetweenItems + itemWidth) * CGFloat(x),
                                                   y: (spaceBetweenItems + itemWidth) * CGFloat(y),
                                                   width: itemWidth,
                                                   height: itemWidth)).do {
                    $0.backgroundColor = .cyan
                    let label = UILabel().then {
                        $0.text = "\(x)-\(y)"
                        $0.textColor = .black
                        $0.font = .systemFont(ofSize: 8)
                        $0.textAlignment = .center
                    }
                    $0.addSubview(label)
                    label.snp.makeConstraints { make in
                        make.center.equalToSuperview()
                    }
                    addSubview($0)
                    itemViews.append($0)
                }
            }
        }
        var frame = self.frame
        frame.size = .init(width: (itemWidth + spaceBetweenItems) * CGFloat(size.width) - spaceBetweenItems,
                           height: (itemWidth + spaceBetweenItems) * CGFloat(size.height) - spaceBetweenItems)
        self.frame = frame
    }
}
