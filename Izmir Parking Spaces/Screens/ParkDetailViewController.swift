//
//  ParkDetailViewController.swift
//  Izmir Parking Spaces
//
//  Created by Murat Baykor on 13.06.2020.
//  Copyright © 2020 Murat Baykor. All rights reserved.
//

import UIKit
import MapKit

class ParkDetailViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var freeCount: UILabel!
    @IBOutlet weak var occupiedCount: UILabel!
    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var providerLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var paidLabel: UILabel!
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var cashLabel: UILabel!
    @IBOutlet weak var paymentStackView: UIStackView!
    
    @IBOutlet var collectionOfLabels:[UILabel]?
    
    var park: Parks?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Park Detail"
        configureHeaderView()
        configureDetailView()
    }

    
    private func configureHeaderView() {
        headerView.layer.cornerRadius = 10
        goButton.layer.cornerRadius = 10
        
        guard let park = park else { return }
        statusLabel.text = park.status
        freeCount.text = "\(park.occupancy!.total.free)"
        occupiedCount.text = "\(park.occupancy!.total.occupied)"
        
    }
    
    
    private func configureDetailView() {
        detailView.layer.cornerRadius = 10
        
        guard let park = park else { return }
        nameLabel.text = park.title
        providerLabel.text = park.provider
        typeLabel.text = park.type
        
        if park.isPaid! {
            paidLabel.text = "Yes"
        } else {
            paidLabel.text = "Free"
            paymentStackView.isHidden = true
        }
        
        paidLabel.text = park.isPaid! ? "Yes" : "Free"
        cardLabel.isHidden = park.payment!.card ? false : true
        cashLabel.isHidden = park.payment!.cash ? false : true
        
        for days in collectionOfLabels! {
            days.text = park.openingHours!.monday
        }
        
    }
    
    
    @IBAction func goButtonAction(_ sender: UIButton) {
        let launchOption = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        
        park?.mapItem?.openInMaps(launchOptions: launchOption)
    }
    
}
