//
//  MapController.swift
//  PhotoAndLocationShare
//
//  Created by Helen Kulka on 8/18/19.
//  Copyright © 2019 Helen Kulka. All rights reserved.
//

import UIKit
import MapKit

protocol LocationSearchControllerDelegate: class {
    func searchControllerFindName(Name: String)
    
    func searchControllerFindLocation(Location: CLLocationCoordinate2D)
}

class LocationSearchController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: LocationSearchControllerDelegate?
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    let cellid = "cellid"
    var searchResultsTableView: UITableView!
    var resultSearchController: UISearchController? = nil
    var responseName: String = ""
    //var responseCoordinate: CLLocationCoordinate2D
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.definesPresentationContext = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        searchResultsTableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        searchResultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellid)
        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
        self.view.addSubview(searchResultsTableView)
        
        ////////
        
        resultSearchController = UISearchController(searchResultsController: nil)
        resultSearchController?.searchBar.delegate = self
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        searchBar.setImage(#imageLiteral(resourceName: "pin"), for: .search, state: .normal)
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        navigationItem.titleView = resultSearchController?.searchBar
        
        
        
        searchCompleter.delegate = self
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        //let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath as IndexPath)
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellid)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row selected")
        //tableView.deselectRow(at: indexPath, animated: true)
        
        let completion = searchResults[indexPath.row]
        let searchRequest = MKLocalSearchRequest(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        DispatchQueue.main.async {
            search.start { (response, error) in
                
                if (response != nil && error == nil)
                {
                    guard let name = response?.mapItems[0].name else { return }
                    guard let location = response?.mapItems[0].placemark.coordinate else { return }
                    self.responseName = name
                    self.delegate?.searchControllerFindName(Name: name)
                    self.delegate?.searchControllerFindLocation(Location: location)
                    self.handlePush()
                }
                
            }
        }
    }
    
    func handlePush() {
        navigationController?.popViewController(animated: true)
    }
    
}


extension LocationSearchController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchCompleter.queryFragment = searchText
    }
}

extension LocationSearchController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}
