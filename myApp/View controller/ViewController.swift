//
//  ViewController.swift
//  SwitchMenu
//
//  Created by Gleb on 17.01.2021.
//  Copyright © 2021 Gleb. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let urlString = "https://raw.githubusercontent.com/avito-tech/internship/main/result.json"
    var collectionView: UICollectionView?
    var button: UIButton?
    var arr: data?
    
    // weak var collectionView: UICollectionView!
    //var result: Array<Dictionary<String,Any>> = []
    
    private func loadJson(fromURLString urlString: String,
                          completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                }
                
                if let data = data {
                    completion(.success(data))
                }
            }
            
            urlSession.resume()
        }
    }
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf16) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    private func parse(jsonData: Data)->data? {
        do {
            let decodedData = try JSONDecoder().decode(data.self,
                                                       from: jsonData)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
    
    fileprivate func setupViewCollectionView() {
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 190,
                                                        width: view.bounds.width, height: view.bounds.height - 300),
                                                        collectionViewLayout: UICollectionViewFlowLayout())
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .white
        
        collectionView?.register(UINib(nibName: "ViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        view.addSubview(collectionView!)
        
//        collectionView?.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
//        collectionView?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
//        collectionView?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
//        collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    fileprivate func setupViewController() {
        
        button = UIButton(frame: CGRect(x: 25, y: view.bounds.height - 80, width: view.bounds.width - 40, height: 50))
        button?.backgroundColor = .blue
        button?.setTitle(arr?.result.actionTitle, for: .normal)
        button?.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button?.layer.cornerRadius = 7
        button?.backgroundColor = #colorLiteral(red: 0.2392938435, green: 0.6638772488, blue: 0.9710217118, alpha: 1)
        self.view.addSubview(button!)
        
        let buttonClose = UIButton(frame: CGRect(x: 20, y: 30, width:25, height: 25))
        buttonClose.setImage(UIImage(named: "CloseIconTemplate"), for: .normal)
        buttonClose.imageEdgeInsets = UIEdgeInsets(top: 25,left: 25,bottom: 25,right: 25)
        buttonClose.contentMode = .scaleAspectFit
        self.view.addSubview(buttonClose)
        
        let title = UILabel(frame: CGRect(x: 20, y: 70, width: view.bounds.width - 40, height: 75))
        title.text = arr?.result.title
        title.numberOfLines = 0
        title.font = UIFont(name: "Helvetica Neue", size: 19)
        self.view.addSubview(title)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
//        let json = loadJson(fromURLString: urlString) { (result) in
//        switch result {
//        case .success(let json):
//            self.parse(jsonData: json)
//        case .failure(let error):
//            print(error)
//            }
//        }
//
        
        let json = readLocalFile(forName: "result")!
        arr = parse(jsonData: json)
        
        setupViewController()
        setupViewCollectionView()
    }

    //var result: Array<list> = []

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr!.result.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ViewCollectionViewCell
        cell.layer.cornerRadius = 7
        cell.name.text = arr?.result.list[indexPath.row].title
        if arr!.result.list[indexPath.row].description == nil{
            cell.descript.isHidden = true
        } else {
            cell.descript.text = arr!.result.list[indexPath.row].description

        }
        cell.price.text = arr!.result.list[indexPath.row].price
        cell.checkmark.isHidden=true
        
        let url = NSURL(string:  arr!.result.list[indexPath.row].icon["52x52"]!)
        let data = try? Data(contentsOf: url! as URL)
        cell.icon.image = UIImage(data: data!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? ViewCollectionViewCell {
            cell.checkmark.isHidden = !(cell.checkmark.isHidden)
            if !(cell.checkmark.isHidden){
                button?.setTitle(arr!.result.selectedActionTitle, for: .normal)
            } else {
                button?.setTitle(arr!.result.actionTitle, for: .normal)
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ViewCollectionViewCell {
            cell.checkmark.isHidden = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                                                                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: Int(view.bounds.width) - 40, height: h(title: arr!.result.list[indexPath.row].title,
                                                                                description: arr!.result.list[indexPath.row].description ?? "",
                                                                                price: arr!.result.list[indexPath.row].price))
    }

    func h(title: String, description: String, price: String) -> Int {
        
        var hTitle = (title.count / 21)
        if title.count%21 > 0{
            hTitle += 1
        }
        
        var hDescription = (description.count / 42)
        if description.count%42 > 0{
            hDescription += 1
        }
        
        return hTitle*25 + hDescription*17 + 70
    }

    @objc func buttonAction(sender: UIButton!) {
        
        for cell in collectionView!.visibleCells {
            let cellCopy = cell as! ViewCollectionViewCell
            if !(cellCopy.checkmark.isHidden) {
                
                let alert = UIAlertController(
                    title: "Услуга:",
                    message: "Название услуги:" + cellCopy.name.text!,
                    preferredStyle: .alert)
                
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
                break
            }
        }
        
        let alert = UIAlertController(
            title: "Услуга не выбрана",
            message: "Продолжить без изменений",
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}


    
    

//class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
//
//    var collectionView: UICollectionView?
//    var button: UIButton?
//    var product: data?
//
//    private func readLocalFile(forName name: String) -> Data? {
//        do {
//            if let bundlePath = Bundle.main.path(forResource: name,
//                                                 ofType: "json"),
//                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
//                return jsonData
//            }
//        } catch {
//            print(error)
//        }
//
//        return nil
//    }
//
//    private func parse(jsonData: Data)->data? {
//        do {
//            let decodedData = try JSONDecoder().decode(data.self,
//                                                       from: jsonData)
//            return decodedData
//        } catch {
//            print(error)
//            return nil
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        if let localData = self.readLocalFile(forName: "result") {
//            self.parse(jsonData: localData)
//        }
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath) as! CollectionViewCell
//
//        cell.layer.cornerRadius = 5
//        cell.title.text = product!.result.list[indexPath.row].title
//
//        if product!.result.list[indexPath.row].description == nil{
//            cell.descript.isHidden = true
//        } else {
//            cell.descript.text = product!.result.list[indexPath.row].description
//
//        }
//        cell.price.text = product!.result.list[indexPath.row].price
//        cell.checkmark.isHidden=true
//        let url = NSURL(string:  product!.result.list[indexPath.row].icon["52x52"]!)
//        let data = try? Data(contentsOf: url! as URL)
//        cell.icon.image = UIImage(data: data!)
//        return cell
//    }
//
//
//}
//
