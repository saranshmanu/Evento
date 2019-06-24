//
//  KeynoteSpeakersViewController.swift
//  Evento
//
//  Created by Saransh Mittal on 22/07/18.
//  Copyright © 2018 Saransh Mittal. All rights reserved.
//

import UIKit

class KeynoteSpeakersViewController: UIViewController {
    
    var speakers = [NSDictionary]()
    
    override func viewDidAppear(_ animated: Bool) {
        if session.count != 0{
            let a = session
            let b = a["event"] as! NSDictionary
            let c = b["speakers"] as! [NSDictionary]
            speakers = c
            speakersCollectionView.reloadData()
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        NetworkEngine.getSession {_ in 
            if session.count != 0{
                let a = session
                let b = a["event"] as! NSDictionary
                let c = b["speakers"] as! [NSDictionary]
                self.speakers = c
                self.speakersCollectionView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var speakersCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension KeynoteSpeakersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func initCollectionView() {
        speakersCollectionView.delegate = self
        speakersCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return speakers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "speakers", for: indexPath) as! SpeakersCollectionViewCell
        let flag = speakers[indexPath.row]
        cell.speakerNameLabel.text = flag["name"] as? String
        cell.speakerDesignationLabel.text = flag["description"] as? String
        let url = flag["image_url"] as! String
        if speakersImages[url] != nil{
            if let a:UIImage = speakersImages[url] {
                cell.speakerImageLabel.image = a
            } else {
                cell.speakerImageLabel.image = UIImage.init(named: "blank")
            }
        } else {
            cell.speakerImageLabel.image = UIImage.init(named: "blank")
        }
        return cell
    }
}
