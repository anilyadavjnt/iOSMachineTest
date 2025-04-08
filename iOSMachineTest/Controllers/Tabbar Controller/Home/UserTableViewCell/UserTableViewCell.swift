//
//  UserTableViewCell.swift
//  iOSMachineTest
//
//  Created by Anil Yadav on 12/03/25.
//  Email: anilyadavjnt@gmail.com
//  Contact No: +91-975211420
//

import UIKit
import SDWebImage

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var uaerNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    var favouriteButtonCallback: ((UserList?) -> Void)!
    var removeFromfavouriteCallBack: ((FavouriteUser?) -> Void)!
    var userList: UserList?
    var favouriteUser: FavouriteUser?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    fileprivate func setupUI() {
        mainView.layer.cornerRadius = 10
        userImageView.layer.cornerRadius = 10
        favouriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        favouriteButton.tintColor = .black
        mainView.addShadow()
    }
    
    func configureCell(with userList: UserList?) {
        self.userList = userList
        uaerNameLabel.text = (userList?.firstName ?? "") + " " + (userList?.lastName ?? "")
        userEmailLabel.text = userList?.email
        userImageView.sd_setImage(with: URL(string: userList?.avatar ?? ""), placeholderImage: UIImage(named: "placeholder"))
        
        if userList?.isFavorite ?? false {
            favouriteButton.tintColor = .systemRed
        } else {
            self.userList?.isFavorite = false
            favouriteButton.tintColor = .black
        }
    }
    
    func configureCell(with user: FavouriteUser) {
        self.favouriteUser = user
        uaerNameLabel.text = (user.first_name ?? "") + " " + (user.last_name ?? "")
        userEmailLabel.text = user.email
        userImageView.sd_setImage(with: URL(string: user.avatar ?? ""), placeholderImage: UIImage(named: "placeholder"))
        favouriteButton.tintColor = .systemRed
    }
    
    @IBAction func favouriteButtonAction(_ sender: UIButton) {
        if let userList = userList {
            if !(userList.isFavorite ?? false) {
                sender.tintColor = .systemRed
                self.userList?.isFavorite = true
            } else {
                self.userList?.isFavorite = false
                sender.tintColor = .black
            }
            favouriteButtonCallback(self.userList)
        } else {
            removeFromfavouriteCallBack(favouriteUser)
        }
    }
}
