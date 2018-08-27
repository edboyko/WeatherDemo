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
    @IBOutlet weak var weatherImageView: UIImageView!
    
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
    
    // Shows activity indicator and fetches weather data
    func refreshData() {
        self.tableView.refreshControl?.beginRefreshing()
        fetchWeatherData()
    }
    
    @objc func fetchWeatherData() {
        
        // Do not proceed if location is not available
        guard let location = currentLocation else {
            hideRefreshControl()
            return
        }
        
        NetworkManager().fetchWeatherData(for: location) { (weatherInfo, errorDescription) in
            
            // Access main thread to edit UI
            DispatchQueue.main.async { [weak self] in
                
                // If problem occurred
                if let errorDescription = errorDescription {
                    
                    // Cache data could still be available for display
                    if let weatherInfo = weatherInfo {
                        
                        // If data source exists that means data is already displayed and does not need to be displayed
                        if let _ = self?.tableViewDataSource {
                            self?.showErrorAlert(errorText: errorDescription)
                        }
                        else { // If data source does not exist, there is no data displayed on the screen
                            self?.hideRefreshControl()
                            
                            // Display data on the screen
                            self?.displayData(from: weatherInfo, lastDateUpdated: weatherInfo.lastUpdatedString)
                        }
                    }
                    else {
                        // Inform user that no data available for display
                        self?.showErrorAlert(errorText: "No data available.", errorDescription: errorDescription)
                    }
                }
                else { // No problems occurred
                    if let weatherInfo = weatherInfo {
                        self?.hideRefreshControl()
                        
                        // Display data on the screen
                        self?.displayData(from: weatherInfo, lastDateUpdated: weatherInfo.lastUpdatedString)
                    }
                }
            }
        }
    }
    
    // MARK: - UI Manipulations
    func displayData(from weatherInfo: WeatherInfo, lastDateUpdated: String? = nil, messageForDisplay: String? = nil) {
        // Create data source for the table view
        tableViewDataSource = WeatherTableViewDataSource(weatherInfo: weatherInfo)
        
        tableViewDataSource?.headerContent = messageForDisplay
        tableViewDataSource?.footerContent = lastDateUpdated
        
        // Assign data source to the table view's dataSource property
        tableView.dataSource = tableViewDataSource
        
        // Update table view
        tableView.reloadData()
        
        if let weatherURL = weatherInfo.imageURL { // Check if weather data has image URL
            
            // Download image data
            NetworkManager().downloadImage(imageURL: weatherURL) { [weak self] (image, errorDesc) in
                DispatchQueue.main.async {
                    if let error = errorDesc {
                        print(error)
                    }
                    
                    // Display image if was able to retrieve successfully
                    if let weatherImage = image {
                        self?.weatherImageView.image = weatherImage
                    }
                }
            }
        }
        
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
    
    // Creates refresh control and assigns selector to it, so it could be used to refresh weather data
    func setupRefreshControl() {
        
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(fetchWeatherData), for: .valueChanged)
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse { // User allowed access to current location
            locationManager.startUpdatingLocation() // Start location updates to get current location
        }
        else { // User denied access to current location
            
            DispatchQueue.main.async { [weak self] in
                
                // Inform user that weather data will not be displayed as location is unavailable
                self?.showErrorAlert(errorText: "No location available to fetch weather data.")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Assign location to currentLocation property to fetch weather data based on this location later
        currentLocation = locations.first
        
        print("Current Location: ", currentLocation?.description ?? "N/A")
        
        // Do not update locations anymore as current location is already available
        manager.stopUpdatingLocation()
        
        refreshData()
        
    }
}
