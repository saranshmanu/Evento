//
//  HomeViewController.swift
//  Evento
//
//  Created by Saransh Mittal on 24/07/18.
//  Copyright © 2018 Saransh Mittal. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var sponsors = [NSDictionary]()
    
    override func viewDidAppear(_ animated: Bool) {
        if session.count != 0{
            let a = session
            let b = a["event"] as! NSDictionary
            let c = b["sponsors"] as! [NSDictionary]
            sponsors = c
            sponsorsCollectionView.reloadData()
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        NetworkEngine.getSession {_ in
            if session.count != 0{
                let a = session
                let b = a["event"] as! NSDictionary
                let c = b["sponsors"] as! [NSDictionary]
                self.sponsors = c
                self.sponsorsCollectionView.reloadData()
                print("sponsors reloaded")
            }
        }
    }
    
    @IBOutlet weak var sponsorsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func initCollectionView() {
        sponsorsCollectionView.delegate = self
        sponsorsCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sponsors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sponsors", for: indexPath) as! SponsorsCollectionViewCell
        let flag = sponsors[indexPath.row] as! NSDictionary
        cell.sponsorTextLabel.text = flag["name"] as! String
        if flag["img_url"] != nil {
            let url = flag["img_url"] as! String
            if sponsorsImages[url] != nil{
                if let a:UIImage = sponsorsImages[url] as! UIImage {
                    cell.sponsorImageView.image = a
                } else {
                    cell.sponsorImageView.image = UIImage.init(named: "white")
                }
            } else {
                cell.sponsorImageView.image = UIImage.init(named: "white")
            }
        } else {
            cell.sponsorImageView.image = UIImage.init(named: "white")
        }
        return cell
    }
}
