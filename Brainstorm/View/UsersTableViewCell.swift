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
        
        genderPhoneLabel?.text = param.gender.wrapp+" "+param.phone.wrapp
        
        countryLabel.text = param.location.country.wrapp
        
        addressLabel?.text = param.location.street.number!.toString+" "+param.location.state.wrapp+" "+param.location.street.name.wrapp
        
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
                
                let activityIndicator = profileImageView.indicatorView
                profileImageView.addSubview(activityIndicator)
                profileImageView.load(url: url){ image in
                    
                    DispatchQueue.main.async {
                        
                        activityIndicator.stopAnimating()
                        if let image = image {
                            self.profileImageView.image = image
                            cachedImage.setObject(image, forKey: url as NSString)
                        }else{
                            self.profileImageView.image = UIImage(named: "defalut")
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    
}


extension UIImageView {
    func load(url: String, compleated: @escaping ((_ image:UIImage?) -> ())) {
        if let url = URL(string: url) {
            DispatchQueue.global().async { [weak self] in
                guard self != nil else {return}
                
                if let data = try? Data(contentsOf: url) {
                    let image = UIImage(data: data)
                    compleated(image)
                }else{
                    compleated(nil)
                }
            }
        }else{
            compleated(nil)
        }
    }
}

extension UIView {
    
    var indicatorView:UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(frame: self.frame)
        activityIndicator.startAnimating()
        activityIndicator.backgroundColor = UIColor.black
        activityIndicator.color = UIColor.white
        activityIndicator.center = self.center
        return activityIndicator
    }
}
