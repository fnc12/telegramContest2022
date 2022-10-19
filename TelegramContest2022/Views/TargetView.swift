import UIKit

class TargetView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = false
        
        UIView().do {
            $0.backgroundColor = .red
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(3)
                make.height.equalTo(20)
                make.center.equalToSuperview()
            }
        }
        UIView().do {
            $0.backgroundColor = .red
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(20)
                make.height.equalTo(3)
                make.center.equalToSuperview()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
