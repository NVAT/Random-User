//
//  DetailsViewController.swift
//  Brainstorm

import UIKit
import MapKit


protocol DetailsViewControllerDelegate {
    func updateUsers(isRemove:Bool, uuid:String)
}

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderPhoneLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var saveUserButton: GradientButton!
    @IBOutlet weak var removeUserButton: UIButton!
    internal var delegate:DetailsViewControllerDelegate?
    internal var params:Results!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = params.name.first.wrapp+" "+params.name.last.wrapp
        
        initUserDetail()
        createMapAnnotation()
    }
    
    
    private func initUserDetail() {
        
        if (params.picture.isSaved.wrapp) || LocalDataViewModel.shared.isExist(uuid: params.login.uuid.wrapp) {
            
            //MARK: - If called from local storage
            if let dataDecoded = Data(base64Encoded: params.picture.medium.wrapp, options: .ignoreUnknownCharacters) {
                profileImageView.image = UIImage(data: dataDecoded)
            }
            //MARK: - When the user is already saved but is called from the remote server
            else {
                profileImageView.image = cachedImage.object(forKey: params.picture.medium.wrapp as NSString)
            }
            
            removeUserButton.setTitleColor(UIColor.red, for: .normal)
            removeUserButton.isHidden = false
            saveUserButton.isDisabled = true
            
        }else if let cachedImage = cachedImage.object(forKey: params.picture.medium.wrapp as NSString) {
            profileImageView.image = cachedImage
        }
        
        
        nameLabel?.text = params.name.first.wrapp+" "+params.name.last.wrapp
        
        genderPhoneLabel?.text = params.gender.wrapp+" "+params.phone.wrapp
        
        countryLabel.text = params.location.country.wrapp
        
        addressLabel?.text = params.location.street.number!.toString+" "+params.location.state.wrapp+" "+params.location.street.name.wrapp
    }
    
    
    //MARK: - Set user location
    private func createMapAnnotation() {
        
        if let latitude = params.location.coordinates.latitude?.toDouble,
           let longitude = params.location.coordinates.longitude?.toDouble {
            let location = MKPointAnnotation()
            //location.title = params.location.country
            location.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            mapKit.addAnnotation(location)
            
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            mapKit.setRegion(region, animated: true)
            
        }
    }
    
    
    //MARK: - Save user details to the local storage
    @IBAction func saveUserData(_ sender:UIButton) {
        
        guard let imageData = profileImageView.image?.pngData() else { return }
        
        params.picture.medium = imageData.base64EncodedString(options: .lineLength64Characters)
        
        LocalDataViewModel.shared.insertValues(param: params)
        delegate?.updateUsers(isRemove:false, uuid: params.login.uuid.wrapp)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    //MARK: - Remove user details from the local storage
    @IBAction func removeUserData(_ sender:UIButton) {
        
        LocalDataViewModel.shared.deleteValues(uuid: params.login.uuid.wrapp)
        delegate?.updateUsers(isRemove:true, uuid: params.login.uuid.wrapp)
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

extension String {
    var toDouble:Double {
        return (self as NSString).doubleValue
    }
}

extension Int {
    var toString:String {
        return String(self)
    }
}

extension Optional where Wrapped == String {
    var wrapp: String {
        return self ?? ""
    }
}

extension Optional where Wrapped == Bool {
    var wrapp: Bool {
        return self ?? false
    }
}
