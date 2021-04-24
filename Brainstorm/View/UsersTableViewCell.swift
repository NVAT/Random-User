//
//  UsersTableViewCell.swift
//  Brainstorm
//
//  Created by Lsoft on 21.04.21.
//

import UIKit

internal var cachedImage = NSCache<NSString, UIImage>()

class UsersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderPhoneLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    static let identifier = "userIdentifier"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 10
        profileImageView.clipsToBounds = true
        profileImageView.image = nil
    }
    
    func setCellItems(param:Results) {
        
        nameLabel?.text = param.name.first.wrapp+" "+param.name.last.wrapp
        
        genderPhoneLabel?.text = param.gender.wrapp+" "+param.cell.wrapp
        
        countryLabel.text = param.location.country.wrapp
        
        addressLabel?.text = param.location.state.wrapp+" "+param.location.city.wrapp+" "+param.location.street.name!
        
        if param.picture.isSaved.wrapp {
            
            if let dataDecoded = Data(base64Encoded: param.picture.medium.wrapp, options: .ignoreUnknownCharacters) {
                profileImageView.image = UIImage(data: dataDecoded)
            }
        }
        else if let cachedImage = cachedImage.object(forKey: param.picture.medium.wrapp as NSString) {
            profileImageView.image = cachedImage
        }
        else{
            if let url = param.picture.medium {
                
                let activityIndicator = UIActivityIndicatorView(frame: profileImageView.frame)
                activityIndicator.startAnimating()
                profileImageView.addSubview(activityIndicator)
                activityIndicator.center = profileImageView.center
                profileImageView.load(url: url){
                    if let image = self.profileImageView.image {
                        activityIndicator.stopAnimating()
                        cachedImage.setObject(image, forKey: url as NSString)
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    
}


extension UIImageView {
    func load(url: String, compleated: @escaping (() -> ())) {
        guard let url = URL(string: url) else {return}
        DispatchQueue.global().async { [weak self] in
            guard self != nil else {return}
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        compleated()
                    }
                }
            }
        }
    }
}
