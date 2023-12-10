//
//  CreateWorkerAddressViewModel.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 15/10/2023.
//

import Foundation
import Presentation
import Domain
import Resolver
import UIComponents

class CreateWorkerAddressViewModel: BaseViewModel<CreateWorkerAddressViewModel.Input, CreateWorkerAddressViewModel.Output> {
    enum Input {
        case viewDidLoad
        case confirm
        
        case tapProvince
        
        case tapDistrict
        
        case tapWard
        
        case updateProvince(_ province: Province)
        
        case updateDistrict(_ district: District)
        
        case updateWard(_ ward: Ward)
        
        case updateAdderss(_ address: String?)
    }
    
    struct Output: VMOutPut {
        var didConfirm: (Worker) -> Void
        
        var loading: () -> Void
        
        var provinces: ([SelectionItem<Province>]) -> Void
        
        var districts: ([SelectionItem<District>]) -> Void
        
        var wards: ([SelectionItem<Ward>]) -> Void
        
        var error: (String) -> Void
        
        var address: (Address) -> Void
        
        var status: (Bool) -> Void
    }
    
    @Injected
    private var useCase: IAddressUseCase
    
    private var provinces: [Province] = []
    
    private var districts: [District] = []
    
    private var wards: [Ward] = []
    
    private var genericAccount: Worker
    
    init(genericAccount: Worker) {
        self.genericAccount = genericAccount
    }
    
    override func handle(_ input: Input) {
        switch input {
        case .viewDidLoad:
           getData()
            reloadAddress()
        case .confirm:
            output.didConfirm(genericAccount)
        case .tapProvince:
            output.provinces(self.provinces.map({ .init(title: $0.name, isSelected: self.genericAccount.province?.id == $0.id, rawData: $0)}))
        case .tapDistrict:
            getDistrict()
        case .tapWard:
            getWard()
        case .updateProvince(let province):
            if province.id == genericAccount.province?.id { return }
            genericAccount.set(province: province)
            genericAccount.set(ward: nil)
            genericAccount.set(district: nil)
            reloadAddress()
            setStatus()
        case .updateDistrict(let district):
            if district.id == genericAccount.district?.id { return }
            genericAccount.set(district: district)
            genericAccount.set(ward: nil)
            reloadAddress()
            setStatus()
        case .updateWard(let ward):
            genericAccount.set(ward: ward)
            reloadAddress()
            setStatus()
        case .updateAdderss(let address):
            genericAccount.set(address: address)
            setStatus()
        }
    }
    
    private func setStatus() {
        let addressStatus = genericAccount.province != nil
        && genericAccount.district != nil
        && genericAccount.ward != nil
        && !(genericAccount.address ?? "").isEmpty
        
        output.status(addressStatus)
    }
    
    private func reloadAddress() {
        output.address(.init(account: genericAccount))
    }
    
    private func getData() {
        output.loading()
        useCase.getProvince().done { provinces in
            self.provinces = provinces
        }.catch { error in
            self.output.error(error.localizedDescription)
        }.finally {
            self.output.hideLoading()
        }
    }
    
    private func getDistrict() {
        output.loading()
        useCase.getDistrict(provinceId: self.genericAccount.province?.id ?? 0).done { districts in
            self.districts = districts
        }.catch { error in
            self.output.error(error.localizedDescription)
        }.finally {
            self.output.hideLoading()
            self.output.districts(self.districts.map({ .init(title: $0.name, isSelected: self.genericAccount.district?.id == $0.id, rawData: $0)}))
        }

    }
    
    private func getWard() {
        output.loading()
        useCase.getWard(provinceId: self.genericAccount.province?.id ?? 0,
                        districtId: self.genericAccount.district?.id ?? 0).done { wards in
            self.wards = wards
        }.catch { error in
            self.output.error(error.localizedDescription)
        }.finally {
            self.output.hideLoading()
            self.output.wards(self.wards.map({ .init(title: $0.name, isSelected: $0.id == self.genericAccount.ward?.id, rawData: $0)}))
        }
    }
}

extension CreateWorkerAddressViewModel {
    struct Address {
        var province: String
        var district: String
        var ward: String
        var address: String
        
        init(account: Worker) {
            self.province = account.province?.name ?? ""
            self.district = account.district?.name ?? ""
            self.ward = account.ward?.name ?? ""
            self.address = account.address ?? ""
        }
    }
}
