import UIKit
import SnapKit
import Then
import PhotosUI

class ViewController: UIViewController {
    var accessIconImageView: UIImageView!
    var accessLabel: UILabel!
    var allowAccessButton: UIButton!
    
    let accessLevel = PHAccessLevel.readWrite
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tryToGoToLibrary(authorizationStatus: PHPhotoLibrary.authorizationStatus(for: accessLevel))
    }
    
    //  MARK: - Private
    
    func tryToGoToLibrary(authorizationStatus: PHAuthorizationStatus) {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus(for: accessLevel)
        if authorizationStatus == .authorized {
            print("it is time to go to library")
        }
    }
    
    //  MARK: - Events
    
    @objc func allowAccessButtonTouched() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] newStatus in
            guard let self = self else { return }
            self.tryToGoToLibrary(authorizationStatus: newStatus)
        }
    }
    
}

