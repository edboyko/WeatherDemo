//
//  ViewController.swift
//  WeatherDemo
//
//  Created by Edwin Boyko on 22/08/2018.
//  Copyright © 2018 Edwin Boyko. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var currentLocation: CLLocation?
    var locationManager = CLLocationManager()
    
    var tableViewDataSource: WeatherTableViewDataSource?
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    
    // MARK: - Fetching data actions
    
    @IBAction func refreshDataAction(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
    
    func refreshData() {
        self.tableView.refreshControl?.beginRefreshing()
        fetchWeatherData()
    }
    
    @objc func fetchWeatherData() {
        
        guard let location = currentLocation else {
            hideRefreshControl()
            return
        }
        
        NetworkManager().fetchWeatherData(for: location) { (weatherInfo, errorDescription) in
            
            // Access main thread to edit UI
            DispatchQueue.main.async { [weak self] in
                
                if let errorDescription = errorDescription {
                    if let weatherInfo = weatherInfo {
                        if let _ = self?.tableViewDataSource {
                            self?.showErrorAlert(errorText: errorDescription)
                        }
                        else {
                            self?.hideRefreshControl()
                            self?.displayData(from: weatherInfo, lastDateUpdated: weatherInfo.lastUpdatedString)
                        }
                    }
                    else {
                        self?.showErrorAlert(errorText: "No data available.", errorDescription: errorDescription)
                    }
                }
                else {
                    if let weatherInfo = weatherInfo {
                        self?.hideRefreshControl()
                        self?.displayData(from: weatherInfo, lastDateUpdated: weatherInfo.lastUpdatedString)
                    }
                }
            }
        }
    }
    // MARK: - UI Manipulations
    
    func displayData(from weatherInfo: WeatherInfo, lastDateUpdated: String? = nil, messageForDisplay: String? = nil) {
        
        tableViewDataSource = WeatherTableViewDataSource(weatherInfo: weatherInfo)
        
        tableViewDataSource?.headerContent = messageForDisplay
        tableViewDataSource?.footerContent = lastDateUpdated
        
        tableView.dataSource = tableViewDataSource
        
        tableView.reloadData()
    }
    
    func hideRefreshControl() {
        
        if let refreshControl = self.tableView.refreshControl {
            if refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
        }
    }
    
    func showErrorAlert(errorText: String, errorDescription: String? = nil) {
        let errorAlert = self.alert(title: errorText, message: errorDescription)
        
        self.present(errorAlert, animated: true) { [weak self] () in
            
            self?.hideRefreshControl()
        }
    }
    
    func setupRefreshControl() {
        
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(fetchWeatherData), for: .valueChanged)
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        else {
            DispatchQueue.main.async { [weak self] in
                self?.showErrorAlert(errorText: "No location available to fetch weather data.")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = locations.first
        
        print("Current Location: ", currentLocation?.description ?? "N/A")
        
        manager.stopUpdatingLocation()
        refreshData()
        
    }
}
