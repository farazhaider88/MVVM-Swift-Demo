//
//  VehiclesListController.swift
//  MVVM_Swift_Demo
//
//  Created by Malik Usman on 13/08/2019.
//  Copyright © 2019 usmanSystems. All rights reserved.
//

import UIKit
import DGActivityIndicatorView

class VehiclesListController: BaseViewController {

     // MARK : - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK : - Variables
    
    var dataSource = VehicleListDatasource()
    
    //Bounds of Hamburg city
    
    var coordinates = (p1Lat: 53.394655, p2Lat: 53.694865, p1Long: 9.757589, p2Long: 10.099891)
    
    private var viewModel : VehiclesListViewModel!
  
    
     /// ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = VehiclesListViewModel(dataSource: dataSource)
        
        getVehiclesList()
    }

    /// Method to fetch vehicle list with a web service
    /// Update tableview on datsource update
    /// show activity laoder on web service call
    
    private func getVehiclesList(){
        
        viewModel?.setupLoader = { [weak self] (loader) in
            loader == true ? self?.showLoader() : self?.hideLoader()
        }
        
        viewModel?.onError = {[weak self] (message) in
            self?.showAlertWith(message: message) 
        }
        
        self.tableView.dataSource = self.dataSource
        self.dataSource.data.addAndNotify(observer: self) { [weak self] _ in
            self?.tableView.reloadData()
        }
        
         viewModel?.fetchVehiclesList()
    }
    
    
    /// Method to setup view on view start
    
    override func setupAppearance(){
        super.setupAppearance()
        
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "world-map"), for: .normal)
        button.addTarget(self, action: #selector(barButtonAction), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
    }
    
    /// MAP - Bar button item action
    
    @objc func barButtonAction() {
        self.performSegue(withIdentifier: "VehiclesMapController", sender: nil)
    }
}



/// Tableview data source methods
/// Called on datasource change

class VehicleListDatasource : GenericDataSource<PoiList>, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeue(VehicleListCell.self, for: indexPath)
    
        cell.updateCell(model: data.value[indexPath.row])
        return cell
    }
}

