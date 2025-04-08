//
//  FavouriteViewController.swift
//  iOSMachineTest
//
//  Created by Anil Yadav on 12/03/25.
//  Email: anilyadavjnt@gmail.com
//  Contact No: +91-975211420
//

import UIKit

class FavouriteViewController: UIViewController {
    
    
    @IBOutlet weak var favouriteTableView: UITableView!
    
    var favouriteUsers = [FavouriteUser]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNibs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(titleString: "Favourite")
        fetchUsersFromLocalStorage()
    }
    
    func registerNibs() {
        favouriteTableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
    }
    
    fileprivate func fetchUsersFromLocalStorage() {
        favouriteUsers = CoreDataStack.shared.fetchFavouriteUsers()
        favouriteTableView.reloadData()
    }
}

extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        cell.favouriteUser = favouriteUsers[indexPath.row]
        cell.configureCell(with: favouriteUsers[indexPath.row])
        cell.removeFromfavouriteCallBack = { [self] userList in
            if let userList = userList {
                CoreDataStack.shared.deleteUser(by: Int64(userList.id))
                if !favouriteUsers.isEmpty {
                    favouriteUsers.remove(at: indexPath.row)
                }
                tableView.reloadData()
            }
        }
        return cell
    }
}
