//
//  VehiclesListViewModel.swift
//  MVVM_Swift_Demo
//
//  Created by Malik Usman on 15/08/2019.
//  Copyright © 2019 usmanSystems. All rights reserved.
//

import Alamofire
import Foundation

class VehiclesListViewModel {
    // MARK: - Properties
    
    var apiClient: APIClientProtocol?
    var dataSource: GenericDataSource<PoiList>
    var onError: ((String) -> ())?
    var setupLoader: ((Bool) -> ())?
    
    /// Property with didSet to notify activity loader hide show
    
    var showLoader: Bool = false {
        didSet {
            setupLoader?(showLoader)
        }
    }
    
    /// Property with didSet to notify error message on network response failure
    
    var errorMessage: String = "" {
        didSet {
            onError?(errorMessage)
        }
    }
    
    // MARK: - Initializer
    
    init(apiClient: APIClientProtocol = APIClient(), dataSource: GenericDataSource<PoiList> = VehicleListDatasource()) {
        self.apiClient = apiClient
        self.dataSource = dataSource
    }
}

// MARK: - Extension

/// Conformation class for vehicle list web service protocol
/// Will fetch list of vehicles and update datasource on response

extension VehiclesListViewModel: VehicleListViewContract {
    /// Web service call to fetch list of vehicles at provided bounds
    /// from the given components.
    ///
    /// - Parameter p1Lat: point1 latitude as param.
    /// - Parameter p1Lon: point1 longitude as param.
    /// - Parameter p2Lat: point2 latitude as param.
    /// - Parameter p2Lon: point2 longitude as param.
    
    func getVehiclesListRquest() {
        let request = APIRouter.vehiclelist
        // check if api service object is initialized and not nil
        guard apiClient != nil else {
            errorMessage = APIError.requestError.rawValue
            return
        }
        
        showLoader = true
        apiClient?.performRequest(route: request) { [weak self](response: DataResponse<VehicleListModel>) in
            self?.showLoader = false
            
            if let error = response.error{
                self?.errorMessage = error.localizedDescription
            }else if let response = response.result.value{
                self?.dataSource.data.value = response.poiList ?? []
            }else{
                self?.errorMessage = APIError.requestError.rawValue
            }
        }
        
    }
}
