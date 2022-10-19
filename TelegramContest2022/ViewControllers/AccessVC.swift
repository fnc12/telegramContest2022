import UIKit
import SnapKit
import Then
import PhotosUI

class AccessVC: UIViewController {
    var accessIconImageView: UIImageView!
    var accessLabel: UILabel!
    var allowAccessButton: UIButton!
    
    @available(iOS 14, *)
    var accessLevel: PHAccessLevel { .readWrite }
    
    struct AccessLabelText {
        static let `default` = "Access Your Photos and Videos"
        static let restricted = "Oops. Access is Restricted"
        static let denied = "On ho, Access is Denied"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        accessIconImageView = .init(image: .init(named: "accessIcon")!).then {
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(144)
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().inset(289)
            }
        }
        
        accessLabel = .init().then {
            $0.text = AccessLabelText.default
            $0.textColor = .white
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 20)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(accessIconImageView.snp.bottom).inset(-20)
                make.centerX.equalToSuperview()
                make.left.right.equalToSuperview().inset(16)
            }
        }
        
        allowAccessButton = .init(type: .custom).then {
            $0.addTarget(self, action: #selector(allowAccessButtonTouched), for: .touchUpInside)
            $0.setBackgroundImage(.init(color: .blue), for: .normal)
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.setTitle("Allow Access", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 17)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.height.equalTo(50)
                make.left.right.equalToSuperview().inset(16)
                make.top.equalTo(accessLabel.snp.bottom).inset(-28)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        if #available(iOS 14.0, *) {
            let authorizationStatus = PHPhotoLibrary.authorizationStatus(for: accessLevel)
            switch authorizationStatus {
            case .restricted:
                accessLabel.text = AccessLabelText.restricted
            case .denied:
                accessLabel.text = AccessLabelText.denied
            default:
                accessLabel.text = AccessLabelText.default
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 14.0, *) {    //  TODO: add iOS 13 scenario
            tryToGoToLibrary(authorizationStatus: PHPhotoLibrary.authorizationStatus(for: accessLevel))
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //  MARK: - Private
    
    func tryToGoToLibrary(authorizationStatus: PHAuthorizationStatus) {
        if #available(iOS 14.0, *) {
            let authorizationStatus = PHPhotoLibrary.authorizationStatus(for: accessLevel)
            if authorizationStatus == .authorized {
                let libraryVC = Library2VC()
//                let libraryVC = LibraryVC()
                navigationController?.pushViewController(libraryVC, animated: true)
            }
        }
    }
    
    //  MARK: - Events
    
    @objc func allowAccessButtonTouched() {
        if #available(iOS 14.0, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] newStatus in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.tryToGoToLibrary(authorizationStatus: newStatus)
                }
            }
        }
    }
}

