//
//  Top10.swift
//  FredGame
//
//  Created by user188455 on 3/15/21.
//

import Foundation

class Top10 {
    private var top10List : [Score] = []
    let service = FredScoreService()
       
    func add(newScore : Score) {
        top10List.append(newScore)
        service.makePostCall(newScore: newScore)
        if top10List.count > 10 {
            top10List = Array(top10List[0...9])
        }
    }
    
    func getList() -> [Score] {
        return top10List
    }
    
    func loadData(_ handler: @escaping () -> Void) {
        
        }
    }

