//
//  CountryCodesTableVController.swift
//  Trendin
//
//  Created by Rockson on 8/1/16.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit

class CountryCodesTableVController: UITableViewController {
    
    var countries = [String]()
    var countryCodes = [String]()
    
    private var  identifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        
        let lefttBarItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleLeftBarButton))
        navigationItem.leftBarButtonItem = lefttBarItem
        
        setUpCountryCodes()
  
        tableView.backgroundColor = UIColor.groupTableViewBackground
        navigationItem.title = "Country codes"

        
        tableView.register(CountryCodesTableVCell.self, forCellReuseIdentifier: identifier)
        
    }
    
    func populateTableView(){
        
        if self.countryCodes.count == self.countries.count  {
            
                self.tableView.reloadData()
            
            
        }
    }
    
    
    
    func handleLeftBarButton(){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpCountryCodes(){
        
        
        self.countries = ["Afghanistan","Albania", "Algeria", "American Samoa","Andorra","Angola","Anguilla", "Antartica","Antigua and Barbuda","Argentina","Armenia","Aruba","Australia","Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium", "Belize","Benin","Bermuda","Bhutan","Bolivia", "Bosnia and Herzegovina","Botswana","Brazil","British Virgin Islands","Brunei","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Canada","Cape Verde","Cayman Islands" ,"Côte d'Ivoire","Central African Republic","Chad","Chile","China","Christmas Island","Cocos (Keeling) Islands","Colombia","Comoros","Congo - Brazzaville", "Congo - Kinshasa", "Cook Islands","Costa Rica","Croatia","Cuba","Cyprus","Czech Republic","Denmark","Djibouti","Dominica","Dominican Republic","Ecuador","Egypt","El Salvador","Equatorial Guinea","Eritrea","Estonia","Ethiopia","Falkland Islands","Faroe Islands","Fiji","Finland","France","French Polynesia","Gabon","Gambia","Georgia","Germany","Ghana","Gibraltar","Greece","Greenland","Grenada","Guam","Guatemala","Guinea","Guinea-Bissau","Guyana","Haiti","Honduras","Hong Kong SAR China","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Isle of Man","Israel","Italy","Jamaica","Japan","Jordan","Kazakhstan","Kenya","Kiribati","Kuwait","Kyrgyztan","Laos","Latvia","Lebanon","Lesotho","Liberia","Libya","Liechtenstein","Lithuania","Luxembourg","Macau SAR China","Macedonia","Madagascar","Malawi","Malaysia","Maldives","Mali","Malta","Marshall Islands","Mauritania","Mauritius","Mayotte","Mexico","Micronesia","Moldova","Monaco","Mongolia","Montenegro","Montserrat","Morocco","Mozambique","Myanmar(Burma)","Namibia","Nauru","Nepal","Netherlands","Netherlands Antilles","New Caledonia","New Zealand","Nicaragua","Niger","Nigeria","Niue","North Korea","Northern Marian Islands","Norway", "Oman","Pakistan","Palau","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Pitcairn Islands","Poland","Portugal","Puerto Rico","Qatar","Romania","Russia","Rwanda","Samoa","San Marino","Saudi Arabia","Sao Tome & Principle","Senegal","Serbia","Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia","Solomon Islands","Somalia","South Africa","South Korea","Spain","Sri Lanka","St. Barthelemy", "St. Helena", "St. Kitts & Nevis" , "St. Lucia", "St. Martin", "St. Peirre & Miquelon", "St. Vincent & Grenadines","Sudan","Suriname","Swaziland","Sweden","Switzerland","Syria","Taiwan","Tajikistan","Tanzania","Thailand","Timor-Leste","Togo","Tokelau","Tonga","Trinidad and Tobago","Tunisia","Turkey","Turkmenistan","Turks and Caicos Islands","Tuvalu","U.S. Virgin Islands","Uganda","Ukraine","United Arab Emirates","United Kingdom","United States of America","Uruguay","Uzbekistan","Vanuatu","Vatican City","Venezuela","Vietnam","Wallis and Futuna","Yemen","Zambia","Zimbabwe"]
        
        
        
        
        
        self.countryCodes =
            ["+93","+355","+213","+1684","+376","+244","+1264","+672","+1268","+54","+374","+297","+61","+43","+994","+1242","+973","+880","+1246","+375","+32","+501","+229","+1441","+975","+591","+387","+267","+55","+1284","+673","+359","+226","+257","+855","+273","+1","+238","+1345","+225","+236","+235","+56","+86","+61","+61","+57","+269","+242","+243","+682","+506","+385","+53","+357","+420","+45","+253","+1767","+1809","+593","+20","+503","+240","+291","+372","+251","+500","+298","+679","+358","+33","+689","+241","+220","+995","+49","+233","+350","+30","+299","+1473","+1671","+502","+224","+245","+592","+509","+504","+852","+36","+354","+91","+62","+98","+964","+353","+44","+972","+39","+1876","+81","+962","+7","+254","+686","+965","+996","+856","+371","+961","+266","+231","+218","+423","+370","+352","+853","+389","+261","+265","+60","+960","+223","+356","+692","+222","+230","+262","+52","+691","+373","+377","+976","+382","+1664","+212","+258","+95","+264","+674","+977","+31","+599","+687","+64","+505","+227","+234","+683","+850","+1670","+47","+968","+92","+680","+507","+675","+595","+51","+63","+870","+48","+351","+1","+974","+40","+7","+250","+685","+378","+966","+239","+221","+381","+248","+232","+65","+421","+386","+677","+252","+27","+82","+34","+94","+590","+290","+1869","+1758","+1599","+508","+1784","+249","+597","+268","+46","+41","+963","+886","+992","+255","+66","+670","+228","+690","+676","+1868","+216","+90","+993","+1649","+688","+1340","+256","+380","+971","+44","+1","+598","+998","+678","+379","+58","+84","+681","+967","+260","+263"]
        
        
        
        self.populateTableView()
    }
    
    
    
    
    // MARK: - Table view data source
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countryCodes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CountryCodesTableVCell
        
        cell.countries.text = self.countries[indexPath.row]
        cell.countryCode.text = self.countryCodes[indexPath.row]
        
        cell.backgroundColor = UIColor.groupTableViewBackground
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
                let selectedCode = self.countryCodes[indexPath.row]
                let country = self.countries[indexPath.row]
                print(selectedCode, country)
        
                UserDefaults.standard.setValue(selectedCode, forKey: "countryCode")
                UserDefaults.standard.setValue(country, forKey: "country")
        
        
                self.dismiss(animated: true, completion: nil)
    }
    
//     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        let selectedCode = self.countryCodes[indexPath.row]
//        let country = self.countries[indexPath.row]
//        print(selectedCode, country)
//        
//        UserDefaults.standard.setValue(selectedCode, forKey: "countryCode")
//        UserDefaults.standard.setValue(country, forKey: "country")
//
//
//        self.dismiss(animated: true, completion: nil)
//    }

}
