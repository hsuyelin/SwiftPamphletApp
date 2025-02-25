//
//  UnCategoryInfosView.swift
//  SwiftPamphletApp
//
//  Created by Ming on 2024/5/1.
//

import SwiftUI
import SwiftData
import InfoOrganizer

struct UnCategoryInfosView: View {
    @Query var infos: [IOInfo]
    @Binding var selectInfo: IOInfo?
    @Binding var limit: Int
    
    init(selectInfo: Binding<IOInfo?>, limit: Binding<Int>) {
        var fd = FetchDescriptor<IOInfo>(predicate: #Predicate { info in
            info.category == nil && info.isArchived == false
        }, sortBy: [SortDescriptor(\IOInfo.updateDate, order: .reverse)])
        fd.fetchLimit = limit.wrappedValue
        _infos = Query(fd)
        self._selectInfo = selectInfo
        self._limit = limit
    }
    
    var body: some View {
        List(selection: $selectInfo) {
            ForEach(infos) { info in
                InfoRowView(info: info)
                    .tag(info)
                    .onAppear {
                        if info == infos.last {
                            if limit <= infos.count {
                                limit += 50
                            }
                        }
                    }
            } // endforeach
        } // end list
    }
}

