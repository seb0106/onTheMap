//*
// * Copyright (C) Schweizerische Bundesbahnen SBB, 2020.
//*

import Foundation
import UIKit

class LocationListViewController: UITableViewController{
    
    var studentLocation: StudentLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = UdacityClient.getStudentsLocation(){
            students, error in
            print(error)
            print(students)
            StudentLocationModel.studentLocation = students.results
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    func handleGetStudentLocation(success: StudentLocation, error: Error?) {
        if success.results.isEmpty {
            studentLocation? = success
            tableView.reloadData()
        } else {
            print(error ?? "")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return StudentLocationModel.studentLocation.count
}
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocationModel.studentLocation.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)
        cell.textLabel?.text = StudentLocationModel.studentLocation[indexPath.row].firstName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = StudentLocationModel.studentLocation[indexPath.row]
        let url = URL(string: selectedCell.mediaURL)
        if let url = url{
            UIApplication.shared.open(url){
                status in
                if status == false{
                    let alert = UIAlertController(title: "URL invalid", message: "There was a problem with opening the URL of the account.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
                print(status)
            }
        }
        print(selectedCell.mediaURL)
    }
}
