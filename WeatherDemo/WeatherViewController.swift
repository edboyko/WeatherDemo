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
        
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchWeatherData()
    }

    
    func fetchWeatherData() {
        
        let locationManager = CLLocationManager()
        guard let location = locationManager.location else {
            return
        }
        
        NetworkManager().fetchWeatherData(for: location) { (weatherResponse, errorDescription) in
            
            DispatchQueue.main.async { [weak self] in
                if let errorDescription = errorDescription {
                    guard let errorAlert = self?.alert(title: errorDescription) else {
                        return
                    }
                    
                    self?.present(errorAlert, animated: true, completion: nil)
                }
                else if let weatherResponse = weatherResponse {
                    self?.displayData(from: weatherResponse)
                }
                
            }
        }
    }
    
    func displayData(from weatherInfo: WeatherResponseModel) {
        
        locationCell.detailTextLabel?.text = weatherInfo.name
        conditionCell.detailTextLabel?.text = weatherInfo.weather.first?.main
        
        
        temperatureCell.detailTextLabel?.text = "\(weatherInfo.main.temp)"
        windSpeedCell.detailTextLabel?.text = "\(weatherInfo.wind.speed)"
        windDirectionCell.detailTextLabel?.text = "\(weatherInfo.wind.deg)"
    }
    
    @objc func refreshData() {
        self.tableView.refreshControl?.endRefreshing()
    }

}

