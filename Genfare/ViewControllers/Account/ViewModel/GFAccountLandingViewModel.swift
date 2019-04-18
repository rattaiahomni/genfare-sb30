//
//  GFAccountLandingViewModel.swift
//  Genfare
//
//  Created by vishnu on 01/02/19.
//  Copyright © 2019 Omniwyse. All rights reserved.
//

import Foundation
import RxSwift

class GFAccountLandingViewModel :WalletProtocol{
    
    let disposebag = DisposeBag()
    
    // Initialise ViewModel's
    //let firstNameViewModel = NameTextViewModel()
    
    // Fields that bind to our view's
    let isSuccess : Variable<Bool> = Variable(false)
    let isLoading : Variable<Bool> = Variable(false)
    let errorMsg : Variable<String> = Variable("")
    let accountBased : Variable<Bool> = Variable(false)
    let cardBased : Variable<Bool> = Variable(false)
    
    func formErrorString() -> String {
        return ""
    }

    func checkWalletStatus() {
        if NetworkManager.Reachability {
            fetchProducts()
             fireEvent()
        }else{
            isSuccess.value = true
            updateAccountType()
        }
    }
    func getConfigApi(){
        let configValues = GFConfigService()
        configValues.fetchConfigurationValues { (success,error) in
            if success! {
                print("configured")
            }
            else{
                print("error")
            }
            
        }
    }
    
    func currentEvent() -> Event? {
        let records:Array<Event> = GFDataService.fetchRecords(entity: "Event") as! Array<Event>
        
        if records.count > 0 {
            for i in records{
                return i
            }
            
            //return records.first
        }
        
        return nil
    }
    func fireEvent(){
        let event:Event? = self.currentEvent()
        if event != nil{
            let eventFired = GFWalletEventService(walletID: self.walledId(), ticketid: NSNumber(value: Int(event!.identifier!)!), clickedTime: event!.clickedTime, event: event!)
            
            eventFired.execute { (success,error) in
                if success {
                    GFDataService.deleteFiredEventRecord(entity: "Event", clickedTime:  event!.clickedTime!)
                }
                else{
                    print("error")
                }
                
            }
        }
    }
    
    func fetchProducts() {
        let products:GFFetchProductsService = GFFetchProductsService(walletID: self.walledId())
        isLoading.value = true

        products.getProducts { [unowned self] (success, error) in
            self.isLoading.value = false

            if success {
                print("Got Product contents successfully")
                self.getEncryptionKeys()
                self.getConfigApi()
            }else{
                self.errorMsg.value = error as! String
            }
        }
    }
    
    func getEncryptionKeys() {
        let encryptionkeys = GFEncryptionKeysService()
        encryptionkeys.fetchEncryptionKeys { (success, error) in
            if success {
                self.updateAccountType()
            }else{
                self.errorMsg.value = error as! String
            }
        }
    }
    
    func updateAccountType() {
        let products = GFFetchProductsService.getProducts()
        let items = products.filter({ (product:Product) -> Bool in
            return product.ticketTypeDescription == "Stored Value"
        })
        if items.count > 0 {
            //show account based
            accountBased.value = true
        }else{
            //show card based
            cardBased.value = true
        }
    }
}
