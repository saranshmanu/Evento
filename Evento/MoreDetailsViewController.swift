//
//  MoreDetailsViewController.swift
//  Evento
//
//  Created by Saransh Mittal on 22/07/18.
//  Copyright © 2018 Saransh Mittal. All rights reserved.
//

import UIKit

class MoreDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == sponsorsCollectionView{
            return 10
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == sponsorsCollectionView{
            let cell = sponsorsCollectionView.dequeueReusableCell(withReuseIdentifier: "sponsors", for: indexPath)
            return cell
        } else {
            let cell = speakersCollectionView.dequeueReusableCell(withReuseIdentifier: "speakers", for: indexPath)
            return cell
        }
    }
    

    @IBOutlet weak var speakersCollectionView: UICollectionView!
    @IBOutlet weak var sponsorsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sponsorsCollectionView.dataSource = self
        sponsorsCollectionView.delegate = self
        speakersCollectionView.dataSource = self
        speakersCollectionView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
