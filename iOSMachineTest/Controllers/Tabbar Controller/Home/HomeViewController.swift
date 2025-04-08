//
//  HomeViewController.swift
//  iOSMachineTest
//
//  Created by Anil Yadav on 12/03/25.
//  Email: anilyadavjnt@gmail.com
//  Contact No: +91-975211420
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeTableView: UITableView!
    
    var userListModel: UserListModel?
    var favouriteUsers = [FavouriteUser]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNibs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(titleString: "Home")
        getUserList()
    }
    
    fileprivate func registerNibs() {
        homeTableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
    }
    
    fileprivate func getUserList() {
        var request = URLRequest(url: URL(string: "https://reqres.in/api/users?page=2")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data else {
                    print(String(describing: error))
                    return
                }
                if let model = try? JSONDecoder().decode(UserListModel.self, from: data) {
                    self.userListModel = model
                    self.fetchUsersFromLocalStorage()
                }
            }
        }
        task.resume()
    }
    
    fileprivate func fetchUsersFromLocalStorage() {
        favouriteUsers = CoreDataStack.shared.fetchFavouriteUsers()
        favouriteUsers.forEach { user in
            if let index = self.userListModel?.data?.firstIndex(where: {$0.id ?? 0 == user.id}) {
                self.userListModel?.data?[index].isFavorite = user.isFavorite
            }
        }
        homeTableView.reloadData()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userListModel?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        cell.userList = userListModel?.data?[indexPath.row]
        cell.configureCell(with: userListModel?.data?[indexPath.row])
        cell.favouriteButtonCallback = { userList in
            if let userList = userList {
                self.userListModel?.data?[indexPath.row] = userList
                tableView.reloadRows(at: [indexPath], with: .automatic)
                if userList.isFavorite ?? false {
                    self.addUserToFavoriteList(userList)
                } else {
                    CoreDataStack.shared.deleteUser(by: Int64(userList.id ?? 0))
                }
            }
        }
        return cell
    }
    
    fileprivate func addUserToFavoriteList(_ user: UserList?) {
        //Creating Core Data Object
        let favouriteUser = FavouriteUser(context: CoreDataStack.shared.managedContext)
        favouriteUser.id = Int64(user?.id ?? 0)
        favouriteUser.first_name = user?.firstName
        favouriteUser.last_name = user?.lastName
        favouriteUser.email = user?.email ?? ""
        favouriteUser.avatar = user?.avatar ?? ""
        favouriteUser.isFavorite = user?.isFavorite ?? false

        //Saving Core Data Object in core data
        CoreDataStack.shared.saveUser(user: favouriteUser)
    }


}
