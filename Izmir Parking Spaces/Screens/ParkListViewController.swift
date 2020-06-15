//
//  ParkListViewController.swift
//  Izmir Parking Spaces
//
//  Created by Murat Baykor on 13.06.2020.
//  Copyright © 2020 Murat Baykor. All rights reserved.
//

import UIKit

class ParkListViewController: DataLoadingVC {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var parks: [Parks] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var parksData: [ParkData] = [] {
        didSet {
            for park in parksData {
                let newPark = Parks(park: park)
                parks.append(newPark!)
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureTableView()
        loadParks()
    }
    
    
    private func configureNavBar() {
        navigationItem.title = "Parks"
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "map.fill"), style: .plain, target: self, action: #selector(showMapView))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshParkData))
    }
    
    
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
    @objc func showMapView() {
        if let vc = storyboard?.instantiateViewController(identifier: "ParkMapView") as? ParkMapViewController {
            navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    
    @objc func refreshParkData() {
        loadParks()
    }
    
    
    private func loadParks() {
        showLoadingView()
        NetworkManager.shared.getParksData { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result {
            case .success(let parks):
                self.parksData = parks
            case .failure(let error):
                self.presentAlertOnMainThread(alertTitle: "Error", alertMessage: error.rawValue, buttonTitle: "Ok")
            }
        }
    }

    
}


extension ParkListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parks.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParkCell", for: indexPath)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.text = parks[indexPath.row].title
        cell.detailTextLabel?.text = parks[indexPath.row].parkInfo
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "ParkDetail") as? ParkDetailViewController {
            vc.park = parks[indexPath.row]
            tableView.deselectRow(at: indexPath, animated: true)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
