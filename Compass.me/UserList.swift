import UIKit
import Foundation

class UserList: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchText: UITextField!
    
    var users: [User] = []
    var filteredUsers: [User] = []
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell")!
        let user = filteredUsers[indexPath.row]
        let text = user.name
        cell.textLabel?.text = text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you selected row: \(indexPath.row)")
        let selectedUser = filteredUsers[indexPath.row]
        gotoNextView(user: selectedUser)
    }
    
    func loadUserList()->Void{
        users = []
        filteredUsers = []
        searchText.text = ""
        let urlStr = "https://glacial-waters-86425.herokuapp.com/users"
        if let url = URL(string: urlStr) {
            if let d = try? Data(contentsOf: url) {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: d as Data, options: []) as! [[String:Any]]
                    for user in parsedData {
                        users.append(User(dictionary: user))
                    }
                    filteredUsers = users
                    tableView.reloadData()
                }catch let err{
                    print("E: \(err)")
                }
            }else{
                print("List could not be loaded")
            }
        }
    }
    
    func gotoNextView(user: User)->Void{
        let nextView = self.storyboard?.instantiateViewController(withIdentifier: "FindFriend") as! FindFriend
        nextView.user = user
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    @IBAction func didChange(_ sender: Any) {
        let text = searchText?.text ?? ""
        if (text == "") {
            filteredUsers = users
        }
        else {
            filteredUsers = users.filter({ (user) -> Bool in
                user.name.lowercased().range(of: text) != nil
            })
        }
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        filteredUsers = []
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadUserList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}



