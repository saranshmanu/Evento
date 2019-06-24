//
//  ScheduleViewController.swift
//  
//
//  Created by Saransh Mittal on 21/07/18.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    @IBAction func refresh(_ sender: Any) {
        NetworkEngine.getSession {_ in 
            if session.count != 0{
                let a = session
                let b = a["event"] as! NSDictionary
                let c = b["eventSessions"] as! [NSDictionary]
                self.schedule = c
                self.timelineTableView.reloadData()
            }
        }
    }
    @IBOutlet weak var timelineTableView: UITableView!
    var schedule = [NSDictionary]()
    
    func getDateInISOFormat(dateString: String) -> Double {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd-MM-yyyy'T'HH:mm' 'a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        let sessionDate = dateFormatter.date(from:dateString)!
        let session = sessionDate.timeIntervalSince1970
        return session
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if session.count != 0{
            let a = session
            let b = a["event"] as! NSDictionary
            let c = b["eventSessions"] as! [NSDictionary]
            schedule = c
            timelineTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func initTableView() {
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = timelineTableView.dequeueReusableCell(withIdentifier: "timeline", for: indexPath) as! TimelineTableViewCell
        let flag = schedule[indexPath.row]
        cell.title.text = flag["name"] as? String
        cell.time.text = flag["startTime"] as? String
        cell.date.text = flag["date"] as? String
        let isoDate = getDateInISOFormat(dateString: cell.date.text! + "T" + cell.time.text!)
        if isoDate <= Date().timeIntervalSince1970 {
            cell.tick.isHidden = false
        } else {
            cell.tick.isHidden = true
        }
        return cell
    }
}
