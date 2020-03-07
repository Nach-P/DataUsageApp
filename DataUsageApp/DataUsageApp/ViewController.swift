//
//  ViewController.swift
//  DataUsageApp
//
//  Created by Nach on 7/3/20.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var yearPicker: UIPickerView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    var imageTap = UITapGestureRecognizer()
    var yearArray:[Int] = Array()
    var yearSelected = Constants.defaultValues.baseYear
    var responseDict:[[String: Any]] = Array()
    var previousQuarterVolume = 0.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupInterface()
    }
    
    func setupInterface() {
        let currentYear = Calendar.current.component(.year, from: Date())
        for i in Constants.defaultValues.baseYear...currentYear {
            yearArray.append(i)
        }
        yearPicker.reloadAllComponents()
        let screen = UIScreen.main.bounds
        collectionViewLayout.itemSize = CGSize(width: screen.width - 30, height: 100)
    }

    @IBAction func fetchDataForSelectedYear(_ sender: UIButton) {
        var offSetNumber = ((yearSelected - Constants.defaultValues.baseYear) * Constants.defaultValues.numberOfQuarters) - Constants.defaultValues.quartersOffset
        if(offSetNumber < 0) {
            offSetNumber = 0
        }
        clearData()
        let urlString = "\(Constants.link.baseUrl)\(Constants.link.apiUrl)\(Constants.link.offset)\(offSetNumber)\(Constants.link.limit)\(Constants.link.numberOfLimits)\(Constants.link.resourceid)"
        WebserviceManager.fetchData(urlString: urlString, completion: {
            dict,error in
            if(dict?["success"] as! Bool) {
                let responseJSON : [String : Any] = dict!["result"]! as! Dictionary
                self.responseDict = responseJSON["records"] as! [[String : Any]]
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.createCache()
                }
            }
        })
        
        if(responseDict.isEmpty) {
            let userDefaults = UserDefaults.standard
            if(userDefaults.value(forKey: "\(self.yearSelected)") != nil) {
                self.responseDict = userDefaults.value(forKey: "\(self.yearSelected)") as! [[String : Any]]
            }
            self.collectionView.reloadData()
        }
    }
    
    func createCache() {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(self.responseDict, forKey: "\(yearSelected)")
    }
    
    @IBAction func imageTapGesture(_ sender: Any) {
        let alertController = UIAlertController(title: "Alert", message:
               "Decrease Image Tapped", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

        self.present(alertController, animated: true, completion: nil)
    }

    func clearData() {
        responseDict = []
        collectionView.reloadData()
    }
    
    //Picker methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yearArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return String(yearArray[row])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        yearSelected = yearArray[row]
    }
    
    //Collection View
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(responseDict.isEmpty) {
            return 0
        } else {
            return self.responseDict.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView .dequeueReusableCell(withReuseIdentifier: "DataUsageForAQuarterCell", for: indexPath) as! DataUsageForAQuarterCell
        let cellData = self.responseDict[indexPath.row]
        
        cell.headerLabel.text = "\(yearSelected) - Q\(indexPath.row + 1)"
        cell.headerLabel.font = UIFont.boldSystemFont(ofSize: 18)
        cell.headerLabel.textColor = UIColor(red: 0, green: 114/255, blue: 206/255, alpha: 1)
        
        cell.amountOfDataUsedLabel.text = cellData["volume_of_mobile_data"] as? String
        cell.amountOfDataUsedLabel.font = UIFont.systemFont(ofSize: 16)
        cell.amountOfDataUsedLabel.textColor = UIColor.darkGray
        
        cell.layer.borderColor = UIColor(red: 0, green: 114/255, blue: 206/255, alpha: 1).cgColor
        cell.layer.borderWidth = 1.0
        
        let currentVolume =  Double( cellData["volume_of_mobile_data"] as! String)!
        if(self.previousQuarterVolume > 0 && previousQuarterVolume > currentVolume) {
            cell.dataUsageImageView.image = UIImage(named: "DataDecreaseIcon")
            cell.dataUsageImageView.isUserInteractionEnabled = true
        } else {
            cell.dataUsageImageView.image = UIImage(named: "DataUsageIcon")
            cell.dataUsageImageView.isUserInteractionEnabled = false
        }
        self.previousQuarterVolume = currentVolume
        
        return cell
    }
    
}

class DataUsageForAQuarterCell : UICollectionViewCell {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var amountOfDataUsedLabel: UILabel!
    @IBOutlet weak var dataUsageImageView: UIImageView!
    
}

