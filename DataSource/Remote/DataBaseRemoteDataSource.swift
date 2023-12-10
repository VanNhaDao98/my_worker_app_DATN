//
//  DataBaseRemoteDataSource.swift
//  DataSource
//
//  Created by Dao Van Nha on 31/10/2023.
//

import Foundation
import PromiseKit
import FirebaseDatabase

struct DataBaseRemoteDataSource {
    
    init() {}
    
    func create() {
        
        let dataBaseRef = Database.database().reference()
        let ref = dataBaseRef.child("Jobs")
        
        let datas: [[String: Any]] = [
            ["id": 1,
             "code": "water",
             "name": "Thợ Nước"],
            ["id": 2,
             "code": "electricity",
             "name": "Thợ Điện"],
            ["id": 3,
             "code": "refrigeration",
             "name": "Thợ điện gia dụng"],
            ["id": 4,
             "code": "thone",
             "name": "Thợ nề"],
            ["id": 5,
             "code": "betong",
             "name": "Thợ bê tông"],
            ["id": 6,
             "code": "cotthep",
             "name": "Thợ cốt thép"],
            ["id": 7,
             "code": "sonvoi",
             "name": "Thợ sơn vôi"],
            ["id": 8,
             "code": "turner",
             "name": "Thợ tiện"],
            ["id": 9,
             "code": "machine",
             "name": "Thợ nguội"],
            ["id": 10,
             "code": "miller",
             "name": "Thợ phay"],
            ["id": 11,
             "code": "planer",
             "name": "Thợ bào"],
            ["id": 12,
             "code": "noun",
             "name": "Thợ rèn"],
            ["id": 13,
             "code": "farrier",
             "name": "Thợ gò"],
            ["id": 14,
             "code": "welder",
             "name": "Thợ hàn xì"],
            ["id": 15,
             "code": "electricwelder",
             "name": "Thợ hàn điện"],
            ["id": 16,
             "code": "carpenter",
             "name": "Thợ mộc"]

        ]
        
        ref.setValue(datas) { error, reference in
            if let error = error {
                print("Lỗi khi lưu : \(error.localizedDescription)")
            } else {
                print(" tạo thành công.")
            }
        }
        
        
        
        //        // Khởi tạo tham chiếu đến Firebase Realtime Database
        //        let databaseRef = Database.database().reference()
        //
        //        // Tạo một cấu trúc dữ liệu cho sinh viên
        //        struct Student {
        //            var name: String?
        //            var age: Int?
        //        }
        //
        //        // Tạo danh sách sinh viên
        //        let students: [Student] = [
        //            Student(name: "John Doe", age: nil),
        //            Student(name: "Jane Smith", age: 22),
        //            // Thêm các sinh viên khác vào danh sách
        //        ]
        //
        //        // Tham chiếu đến nút "students" trong Firebase Realtime Database
        //        let studentsRef = databaseRef.child("students")
        //
        //        // Lặp qua danh sách sinh viên và thêm từng sinh viên vào Firebase
        //        for student in students {
        //            let studentData: [String: Any] = [
        //                "name": student.name,
        //                "age": student.age
        //                // Thêm các trường dữ liệu khác tùy theo nhu cầu
        //            ]
        //
        //            studentsRef.childByAutoId().setValue(studentData) { (error, _) in
        //                if let error = error {
        //                    print("Lỗi khi thêm sinh viên: \(error.localizedDescription)")
        //                } else {
        //                    print("Sinh viên đã được thêm thành công.")
        //                }
        //            }
        //        }
    }
    
    
    func readDemo() -> Promise<String> {
        Promise { resolver in
            let databaseRef = Database.database().reference()
            
            let customNodeId = "-NiALu6HFrCaehBA9Y4y" // Thay "yourCustomId"
            let customNodeRef = databaseRef.child("students") // Thay
            customNodeRef.child(customNodeId).observe(.value) { (snapshot) in
                if snapshot.exists() {
                    if let data = snapshot.value as? [String: Any] {
                        resolver.fulfill(data["name"] as? String ?? "nhadv")
                        NotificationCenter.default.post(name: Notification.Name("demo"), object: nil)
                        //                        print(data["name"] as? String ?? "nhadv")
                    }
                } else {
                    resolver.fulfill("connectEmpty")
                }
            }
            
        }
        
        // Khởi tạo tham chiếu đến Firebase Realtime Database
    }
    
    
    func getDistrict(provinceId: Int) -> Promise<[DistrictModel]> {
        Promise { resolver in
            let ref = Database.database().reference()
            let district = ref.child("districts").child("districts")
            
            let query = district.queryOrdered(byChild: "province_id").queryEqual(toValue: provinceId)
            query.observeSingleEvent(of: .value, with: { (snapshot) in
                guard snapshot.exists() else { return resolver.fulfill([]) }
                guard let datas = snapshot.value as? [String: [String: Any]] else { return resolver.fulfill([])}
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: datas, options: [])
                    let decoder = JSONDecoder()
                    let locations = try decoder.decode([String: DistrictModel].self, from: jsonData)
                    var districts = [DistrictModel]()
                    for location in locations {
                        districts.append(location.value)
                    }
                    resolver.fulfill(districts)
                } catch {
                    resolver.reject(error)
                }
            }) { (error) in
                resolver.reject(error)
            }
        }
    }
    
    func getProvince() -> Promise<[ProvinceModel]> {
        Promise { resolver in
            let ref = Database.database().reference()
            let province = ref.child("provinces")
            
            let query = province.queryOrdered(byChild: "country_id").queryEqual(toValue: 201)
            
            query.observeSingleEvent(of: .value, with: { (snapshot) in
                guard snapshot.exists() else { return resolver.fulfill([])}
                guard let datas = snapshot.value as? [[String: Any]] else { return resolver.fulfill([]) }
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: datas, options: [])
                    let decoder = JSONDecoder()
                    let locations = try decoder.decode([ProvinceModel].self, from: jsonData)
                    resolver.fulfill(locations)
                } catch {
                    resolver.reject(error)
                }
            }) { (error) in
                resolver.reject(error)
            }
        }
    }
    
    func getWard(provinceId: Int, districtId: Int) -> Promise<[WardModel]> {
        Promise { resolver in
            let ref = Database.database().reference()
            let district = ref.child("wards").child("wards")
            
            let query = district
                .queryOrdered(byChild: "district_id")
                .queryEqual(toValue: districtId)
            
            query.observeSingleEvent(of: .value, with: { (snapshot) in
                guard snapshot.exists() else { return resolver.fulfill([])}
                guard let datas = snapshot.value as? [String: [String: Any]] else { return resolver.fulfill([]) }
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: datas, options: [])
                    let decoder = JSONDecoder()
                    let locations = try decoder.decode([String: WardModel].self, from: jsonData)
                    var wards = [WardModel]()
                    for location in locations {
                        wards.append(location.value)
                    }
                    resolver.fulfill(wards)
                } catch {
                    resolver.reject(error)
                }}) { (error) in
                    resolver.reject(error)
                }
        }
    }
    
    func createCustomer(regist: WorkerModel) -> Promise<Void> {
        
        Promise { resolver in
            let databaseRef = Database.database().reference()
            let customerRef = databaseRef.child("customers").child(regist.id ?? "anonymous")
            
            do {
                let jsonData = try JSONEncoder().encode(regist)
                if let json = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
                    customerRef.setValue(json) { error, _ in
                        guard let error = error else { return resolver.fulfill_()}
                        resolver.reject(error)
                    }
                }
            } catch {
                resolver.reject(error)
            }
            
        }
    }
    
    
    func genericAccount(id: String) -> Promise<WorkerModel?> {
        return Promise { resolver in
            let databaseRef = Database.database().reference()
            let customerRef = databaseRef.child("customers")
            
            customerRef.child(id).observeSingleEvent(of: .value, with: { snapshot in
                guard snapshot.exists() else { return resolver.fulfill( nil) }
                guard let data = snapshot.value as? [String: Any] else { return resolver.fulfill(nil)}
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data)
                    let account = try JSONDecoder().decode(WorkerModel.self, from: jsonData)
                    resolver.fulfill(account)
                } catch {
                    resolver.reject(error)
                }
            }){ (error) in
                resolver.reject(error)
            }
        }
    }
    
    func getDegree() -> Promise<[DegreeModel]> {
        Promise { resolver in
            let ref = Database.database().reference()
            let degree = ref.child("degree")
            
            degree.observeSingleEvent(of: .value, with: { snapshot in
                guard snapshot.exists() else { return resolver.fulfill( []) }
                guard let datas = snapshot.value as? [[String: Any]] else { return resolver.fulfill([]) }
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: datas, options: [])
                    let degrees = try JSONDecoder().decode([DegreeModel].self, from: jsonData)
                    resolver.fulfill(degrees)
                } catch {
                    resolver.reject(error)
                }
            }){ (error) in
                resolver.reject(error)
            }
        }
    }
    
    func getJobs() -> Promise<[JobModel]> {
        Promise { resolver in
            let ref = Database.database().reference()
            let jobRef = ref.child("Jobs")
            
            jobRef.observeSingleEvent(of: .value, with: { snapshot in
                guard snapshot.exists() else { return resolver.fulfill( []) }
                guard let datas = snapshot.value as? [[String: Any]] else { return resolver.fulfill([]) }
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: datas)
                    let jobs = try JSONDecoder().decode([JobModel].self, from: jsonData)
                    resolver.fulfill(jobs)
                } catch {
                    resolver.reject(error)
                }
            }) { error in
                resolver.reject(error)
            }
        }
    }
    
    func createGenericWorker(account: WorkerModel) -> Promise<Void> {
        Promise { resolver in
            let ref = Database.database().reference()
            let workerRef = ref.child("Worker").child(account.id ?? "anonymous")
            do {
                let jsonData = try JSONEncoder().encode(account)
                if let json = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
                    workerRef.setValue(json) { error, _ in
                        guard let error = error else { return resolver.fulfill_()}
                        resolver.reject(error)
                    }
                }
            } catch {
                resolver.reject(error)
            }
        }
    }
    
    func createDegree(uid: String, degrees: [AccountDegreeModel]) -> Promise<Void> {
        Promise { resolver in
            let ref = Database.database().reference()
            let degreeRef = ref.child("DegreeWorker").child(uid)
            do {
                let jsonData = try JSONEncoder().encode(degrees)
                if let json = try JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] {
                    degreeRef.setValue(json) { error, _ in
                        guard let error = error else { return resolver.fulfill_()}
                        resolver.reject(error)
                    }
                }
            } catch {
                resolver.reject(error)
            }
        }
    }
    
    func createMaterials(workerId: String, materials: [MaterialModel]) -> Promise<Void> {
        Promise { resolver in
            let ref = Database.database().reference()
            let materialRef = ref.child("MetarialWorker").child(workerId)

            do {
                let jsonData = try JSONEncoder().encode(materials)
                if let json = try JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] {
                    materialRef.setValue(json) { error, _ in
                        guard let error = error else { return resolver.fulfill_()}
                        resolver.reject(error)
                    }
                }
            } catch {
                resolver.reject(error)
            }
        }
    }
    
    
    func getMaterial(id: String) -> Promise<[MaterialModel]> {
        return Promise { resolver in
            let databaseRef = Database.database().reference()
            let materialRef = databaseRef.child("MetarialWorker")
            
            materialRef.child(id).observeSingleEvent(of: .value, with: { snapshot in
                guard snapshot.exists() else { return resolver.fulfill([])}
                guard let datas = snapshot.value as? [[String: Any]] else { return resolver.fulfill([])}
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: datas, options: [])
                    let decoder = JSONDecoder()
                    let material = try decoder.decode([MaterialModel].self, from: jsonData)
                    resolver.fulfill(material)
                } catch {
                    resolver.reject(error)
                }
                
            }){ (error) in
                resolver.reject(error)
            }
        }
    }
    
    func getDetailWorker(id: String) -> Promise<WorkerModel?> {
        return Promise { resolver in
            let databaseRef = Database.database().reference()
            let customerRef = databaseRef.child("Worker")
            
            customerRef.child(id).observeSingleEvent(of: .value, with: { snapshot in
                guard snapshot.exists() else { return resolver.fulfill( nil) }
                guard let data = snapshot.value as? [String: Any] else { return resolver.fulfill(nil)}
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data)
                    let worker = try JSONDecoder().decode(WorkerModel.self, from: jsonData)
                    resolver.fulfill(worker)
                } catch {
                    resolver.reject(error)
                }
            }){ (error) in
                resolver.reject(error)
            }
        }
    }
    
    func getDetailDegree(id: String) -> Promise<[AccountDegreeModel]> {
        return Promise { resolver in
            let databaseRef = Database.database().reference()
            let degreeRef = databaseRef.child("DegreeWorker")
            
            degreeRef.child(id).observeSingleEvent(of: .value, with: { snapshot in
                guard snapshot.exists() else { return resolver.fulfill([])}
                guard let datas = snapshot.value as? [[String: Any]] else { return resolver.fulfill([])}
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: datas, options: [])
                    let decoder = JSONDecoder()
                    let degrees = try decoder.decode([AccountDegreeModel].self, from: jsonData)
                    resolver.fulfill(degrees)
                } catch {
                    resolver.reject(error)
                }
                
            }){ (error) in
                resolver.reject(error)
            }
        }
    }
    
    func setStatusWorker(model: WorkerModel) -> Promise<Void> {
        Promise { resolver in
            let databaseRef = Database.database().reference()
            let workerRef = databaseRef.child("Worker").child(model.id ?? "")
            
            let updateData: [String: Any] = ["status": model.status as Any]
            
            workerRef.updateChildValues(updateData) { error, _ in
                guard let error = error else { return resolver.fulfill_()}
                resolver.reject(error)
            }
        }
    }
    
    
    /// Order
    ///
    func getListOrder(id: String) -> Promise<[OrderModel]> {
        Promise { resolver in
            let ref = Database.database().reference()
            let orderRef = ref.child("Order")
            let query = orderRef.queryOrdered(byChild: "worker_id").queryEqual(toValue: id)
            query.observe(.value, with: { snapshot in
                guard snapshot.exists() else { return resolver.fulfill( []) }
                guard let datas = snapshot.value as? [String: [String: Any]] else { return resolver.fulfill([]) }
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: datas)
                    let orders = try JSONDecoder().decode([String: OrderModel].self, from: jsonData)
                    resolver.fulfill(orders.map({ $0.value}))
                    NotificationCenter.default.post(name: Notification.Name("orderCustomerList"), object: orders.map({ $0.value.toDomain()}))
                } catch {
                    resolver.reject(error)
                }
            }) { error in
                resolver.reject(error)
            }
        }
    }
    
    func getOrderDetail(orderId: String) -> Promise<OrderModel?> {
        Promise { resolver in
            let ref = Database.database().reference()
            let orderRef = ref.child("Order").child(orderId)
            
            orderRef.observe(.value, with: { snapshot in
                guard snapshot.exists() else { return resolver.fulfill(nil) }
                guard let data = snapshot.value as? [String: Any] else {return resolver.fulfill(nil)}
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data)
                    let order = try JSONDecoder().decode(OrderModel.self, from: jsonData)
                    resolver.fulfill(order)
                    NotificationCenter.default.post(name: Notification.Name("orderDetail"), object: order.toDomain())
                } catch {
                    resolver.reject(error)
                }
            }) { error in
                resolver.reject(error)
            }
        }
    }
    
    func updateStatusOrder(status: String,
                           orderId: String) -> Promise<Void> {
        Promise { resolver in
            let databaseRef = Database.database().reference()
            let orderRef = databaseRef.child("Order").child(orderId)
            
            var updateData: [String: Any] = [:]
            
            if status == "cancel" {
                updateData = ["status": status as Any,
                              "cancel_on": Date().timeIntervalSince1970 as Any]
            } else if status == "complete" {
                updateData = ["status": status as Any,
                              "end_time": Date().timeIntervalSince1970 as Any]
            } else {
                updateData = ["status": status as Any]
            }
            
            orderRef.updateChildValues(updateData) { error, _ in
                guard let error = error else { return resolver.fulfill_()}
                resolver.reject(error)
            }
        }
    }
    
    func updateMaterialOrder(orderId: String, lineItems: [LineItemModel]) -> Promise<Void> {
        Promise { resolver in
            let databaseRef = Database.database().reference()
            let orderRef = databaseRef.child("Order").child(orderId)
            
            do {
                let jsonData = try JSONEncoder().encode(lineItems)
                if let json = try JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] {
                    let updateData: [String: Any] = ["line_item": json as Any]
                    orderRef.updateChildValues(updateData) { error, _ in
                        guard let error = error else { return resolver.fulfill_()}
                        resolver.reject(error)
                    }
                }
            } catch {
                resolver.reject(error)
            }
        }
    }
    
    func getListRate(workerId: String) -> Promise<[RateModel]> {
        Promise { resolver in
            let ref = Database.database().reference()
            let rateRef = ref.child("Rate")
            let query = rateRef.queryOrdered(byChild: "worker_id").queryEqual(toValue: workerId)
            query.observe(.value, with: { snapshot in
                guard snapshot.exists() else { return resolver.fulfill( []) }
                guard let datas = snapshot.value as? [String: [String: Any]] else { return resolver.fulfill([]) }
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: datas)
                    let orders = try JSONDecoder().decode([String: RateModel].self, from: jsonData)
                    resolver.fulfill(orders.map({ $0.value}))
                    NotificationCenter.default.post(name: Notification.Name("rateList"), object: orders.map({ $0.value.toDomain()}))
                } catch {
                    resolver.reject(error)
                }
            }) { error in
                resolver.reject(error)
            }
        }
    }
    
}
