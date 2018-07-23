//
//  HomeViewController.swift
//  Evento
//
//  Created by Saransh Mittal on 24/07/18.
//  Copyright © 2018 Saransh Mittal. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = sponsorsCollectionView.dequeueReusableCell(withReuseIdentifier: "sponsors", for: indexPath) as! SponsorsCollectionViewCell
        return cell
    }
    

    @IBOutlet weak var sponsorsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sponsorsCollectionView.delegate = self
        sponsorsCollectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
