//
//  ViewController.swift
//  WeatherDemo
//
//  Created by Edwin Boyko on 22/08/2018.
//  Copyright © 2018 Edwin Boyko. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UITableViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var locationCell: UITableViewCell!
    @IBOutlet weak var conditionCell: UITableViewCell!
    @IBOutlet weak var temperatureCell: UITableViewCell!
    @IBOutlet weak var windSpeedCell: UITableViewCell!
    @IBOutlet weak var windDirectionCell: UITableViewCell!
    
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.refreshControl?.beginRefreshing()
        fetchWeatherData()
    }
    
    func setupRefreshControl() {
        
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(fetchWeatherData), for: .valueChanged)
    }
    
    func displayData(from weatherInfo: WeatherInfo) {
        
        locationCell.detailTextLabel?.text = weatherInfo.locationName
        conditionCell.detailTextLabel?.text = weatherInfo.conditions
        temperatureCell.detailTextLabel?.text = weatherInfo.airTemperature
        windSpeedCell.detailTextLabel?.text = weatherInfo.windSpeed
        windDirectionCell.detailTextLabel?.text = weatherInfo.windDirection
        
        tableView.reloadData()
    }
    
    @objc func fetchWeatherData() {
        
        let locationManager = CLLocationManager()
        guard let location = locationManager.location else {
            return
        }
        
        NetworkManager().fetchWeatherData(for: location) { (weatherInfo, errorDescription) in
            
            DispatchQueue.main.async { [weak self] in
                
                if let refreshControl = self?.tableView.refreshControl {
                    if refreshControl.isRefreshing {
                        refreshControl.endRefreshing()
                    }
                }
                
                if let errorDescription = errorDescription {
                    self?.showErrorAlert(errorText: errorDescription)
                }
                else if let weatherInfo = weatherInfo {
                    self?.displayData(from: weatherInfo)
                }
            }
        }
    }
    
    func showErrorAlert(errorText: String) {
        let errorAlert = self.alert(title: errorText)
        
        self.present(errorAlert, animated: true, completion: nil)
    }
}

