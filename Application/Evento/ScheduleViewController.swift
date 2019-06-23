//
//  ScheduleViewController.swift
//  
//
//  Created by Saransh Mittal on 21/07/18.
//

import UIKit

class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var schedule = [NSDictionary]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = timelineTableView.dequeueReusableCell(withIdentifier: "timeline", for: indexPath) as! TimelineTableViewCell
        if schedule != nil{
            let flag = schedule[indexPath.row] as! NSDictionary
            cell.title.text = flag["name"] as! String
            cell.time.text = flag["startTime"] as! String
            cell.date.text = flag["date"] as! String
            let date = Date()
            let calender = Calendar.current
            let currentDate = date.timeIntervalSince1970
            var isoDate = cell.date.text! + "T" + cell.time.text!
//            isoDate = String(isoDate.dropLast())
//            isoDate = String(isoDate.dropLast())
//            isoDate = String(isoDate.dropLast())
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "dd-MM-yyyy'T'HH:mm' 'a"
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
            let sessionDate = dateFormatter.date(from:isoDate)!
            let session = sessionDate.timeIntervalSince1970
            if session <= currentDate {
                cell.tick.isHidden = false
            } else {
                cell.tick.isHidden = true
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        timelineTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }
    
    @IBAction func refresh(_ sender: Any) {
        NetworkEngine.getSession {_ in 
            if session.count != 0{
                let a = session
                let b = a["event"] as! NSDictionary
                let c = b["eventSessions"] as! [NSDictionary]
                self.schedule = c
                self.timelineTableView.reloadData()
                print("timeline reloaded")
            }
        }
    }
    @IBOutlet weak var timelineTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
}
