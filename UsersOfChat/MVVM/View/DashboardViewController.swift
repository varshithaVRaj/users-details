//
//  DashboardViewController.swift
//  UsersOfChat
//
//  Created by Varshitha VRaj on 01/08/25.
//

import UIKit

class DashboardViewController: UIViewController{
    
    @IBOutlet var usersListTableView: UITableView!
    
    let viewModel = DashboardViewModel()
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchDetailsofUsers()
        setUpTableView()
    }
    
    
    private func fetchDetailsofUsers(){
        
        setupActivityIndicator()
        
        
        viewModel.fetchArtWorks{ result in
            
            if result{
                
                print("the total users: \(String(describing: self.viewModel.listOfUsers?.count))")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.usersListTableView.reloadData()
                }
               
            }else{
                print("Could'nt fetch")
            }
            
        }
    
    }
    
    
    private func setUpTableView(){
        
        usersListTableView.delegate = self
        usersListTableView.dataSource = self
        usersListTableView.register(UINib(nibName: "DashboardTableViewCell", bundle: nil), forCellReuseIdentifier: "DashboardTableViewCell")
    }
    
    private func setupActivityIndicator() {
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.hidesWhenStopped = true
            view.addSubview(activityIndicator)
            
            // Center the activity indicator
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    
}

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.listOfUsers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardTableViewCell", for: indexPath) as! DashboardTableViewCell
        
        if let data = viewModel.listOfUsers?[indexPath.row]{
            
            if let firstName = data.firstName, let lastName = data.lastName{
                cell.label.text = "\(firstName) \(lastName)"
            }
            
           
            
            if let image = data.image{
                cell.profileImage?.loadImageFromURL(from: image)
            }
        
            
        }
        
        return cell
    }
    
 
}
