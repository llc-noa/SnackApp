//
//  SnackData.swift
//  SnackApp
//
//  Created by 菅谷亮太 on 2023/03/20.
//

import Foundation

struct SnackItem:Identifiable{
    let id = UUID()
    let name :String
    let url :URL
    let image :URL
}

class SnackData:ObservableObject{
    
    struct ResultJson:Codable{
        struct Item:Codable{
            let name:String?
            let url:URL?
            let image:URL?
        }
        let item:[Item]?
    }
    @Published var snackList:[SnackItem] = []
    
    var snackLink: URL?
    
    func getSnack(keyword:String){
        print("keyword:\(keyword)")
        
        Task{
            await search(keyword:keyword)
        }
    }
    
    @MainActor
    private func search (keyword:String) async{
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else{
            return
        }
        
        guard let req_url = URL(string: "https://sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keyword_encode)&max=10&order=r")
        else{
            return
        }
        print(req_url)
        
        do{
            let (data , _) = try await URLSession.shared.data(from: req_url)
            let decorder = JSONDecoder()
            let json = try decorder.decode(ResultJson.self, from: data)
            
            guard let items = json.item else { return }
            self.snackList.removeAll()
            
            for item in items {
                if let name = item.name,
                   let link = item.url,
                   let image = item.image {
                    let snack = SnackItem(name: name, url: link, image: image)
                    self.snackList.append(snack)
                }
            }
            print(self.snackList)
        }catch{
            print("エラー")
        }
    }
}
