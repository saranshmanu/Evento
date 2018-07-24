//
//  MoreDetailsViewController.swift
//  Evento
//
//  Created by Saransh Mittal on 22/07/18.
//  Copyright © 2018 Saransh Mittal. All rights reserved.
//

import UIKit

class MoreDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
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
        networkEngine.getSession {
            if session.count != 0{
                let a = session
                let b = a["event"] as! NSDictionary
                let c = b["speakers"] as! [NSDictionary]
                self.speakers = c
                self.speakersCollectionView.reloadData()
                print("speakers reloaded")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return speakers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = speakersCollectionView.dequeueReusableCell(withReuseIdentifier: "speakers", for: indexPath) as! SpeakersCollectionViewCell
        if speakers != nil{
            let flag = speakers[indexPath.row] as! NSDictionary
            cell.speakerNameLabel.text = flag["name"] as! String
            cell.speakerDesignationLabel.text = flag["description"] as! String
            let url = flag["image_url"] as! String
            if speakersImages[url] != nil{
                if let a:UIImage = speakersImages[url] as! UIImage {
                    cell.speakerImageLabel.image = a
                } else {
                    cell.speakerImageLabel.image = UIImage.init(named: "blank")
                }
            }
        }
        return cell
    }
    
    @IBOutlet weak var speakersCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speakersCollectionView.dataSource = self
        speakersCollectionView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
