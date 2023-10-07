//
//  Test.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import Foundation
import SwiftUI
import Kanna

final class Test: ObservableObject {
    
    func displayURL() {
        let mainURLAdress = "https://www.sgu.ru/schedule/knt/do/141"
        let mainURL = URL(string: mainURLAdress)
        
        let URLTask = URLSession.shared.dataTask(with: mainURL! as URL) { data, _, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            do {
                let html = try String(contentsOf: mainURL!, encoding: .utf8)
                
                if let doc = try? HTML(html: html, encoding: .utf8) {
                    //                print(doc.title)
                    
                    //                for link in doc.xpath("//div[@class='last-update']") {
                    //                    print(link.text)
                    //                }
                    
                    for link in doc.xpath("//div[@id='schedule_page']/div[@class='panes']/div[1]/table[@id='schedule']/tbody/tr[3]/td[@id='2_1']") {
                        print(link.text ?? "Unknown error")
                    }
                }
            }
            catch {
                
            }
        }
        URLTask.resume()
    }
}
