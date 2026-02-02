//
//  RelationshipMatrixView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 28/1/26.
//

import SwiftUI

struct RelationshipMatrixView: View {
    
    @StateObject var cctvViewModelObject = CCTVViewModel()
    @Environment(\.modelContext) private var context
    
    // Size to ensure alignment
    let headerWidth: CGFloat = 100
    let cellWidth: CGFloat = 100
    let cellHeight: CGFloat = 50
    
    var body: some View {
        VStack(alignment: .leading){
            
            // 1. Header
            Text("Status")
                .padding()
                .bold()
                .font(.body)
                .padding(.top, 40)
            
            HStack{
                Image(systemName: "x.circle.fill")
                    .foregroundStyle(Color.red)
                    .bold()
                Text("No Direct Path")
                    .font(.footnote)
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(Color.green)
                    .bold()
                Text("Direct Path")
                    .font(.footnote)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
            
            // 2. The 2D Matrix
            GeometryReader { geometry in
                ScrollView([.horizontal, .vertical], showsIndicators: false) {
                    
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            
                            // --- THE TABLE ---
                            VStack(alignment: .leading, spacing: 0) {
                                
                                // Header Row (Column Names)
                                HStack(spacing: 0) {
                                    Color.clear
                                        .frame(width: headerWidth, height: 50)
                                    ForEach(cctvViewModelObject.cctvlist.indices, id: \.self) { index in
                                        Text(cctvViewModelObject.cctvlist[index].name)
                                            .font(.caption.bold())
                                            .frame(width: cellWidth, height: cellHeight)
                                            .multilineTextAlignment(.center)
                                    }
                                }
                                
                                // Data Rows
                                ForEach(cctvViewModelObject.cctvlist.indices, id: \.self) { rowIndex in
                                    HStack(spacing: 0) {
                                        // Row Header (Camera Name)
                                        Text(cctvViewModelObject.cctvlist[rowIndex].name)
                                            .font(.caption.bold())
                                            .frame(width: headerWidth, height: cellHeight)
                                            .padding(.horizontal, 4)
                                        
                                        // Cells
                                        ForEach(cctvViewModelObject.cctvlist.indices, id: \.self) { colIndex in
                                            
                                            // LOGIC: Pass the Name and the Column Index
                                            matrixCell(
                                                rowName: cctvViewModelObject.cctvlist[rowIndex].name,
                                                colIndex: colIndex,
                                                rowIndex: rowIndex // Needed for diagonal check
                                            )
                                            .frame(width: cellWidth, height: cellHeight)
                                        }
                                    }
                                }
                            }
                            Spacer()
                        }
                        Spacer()
                    }
                    .frame(minWidth: geometry.size.width, minHeight: geometry.size.height, alignment: .topLeading)
                }
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
            }
            .padding()
            
            // Footer Stats
            HStack {
                Spacer()
                Text("Total Cameras: \(cctvViewModelObject.cctvlist.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }
        .padding(.horizontal)
        .onAppear {
            Task {
                await cctvViewModelObject.fetchCCTVlist(context: context)
                await cctvViewModelObject.fetchCameraGraph()
            }
        }
    }
    
    // MARK: - Logic Helper
    @ViewBuilder
    func matrixCell(rowName: String, colIndex: Int, rowIndex: Int) -> some View {
        
        // 1. Diagonal Check (Same Camera)
        if rowIndex == colIndex {
            Image(systemName: "minus.circle.fill")
                .foregroundStyle(.gray)
                .font(.title3)
                .bold()
            
        } else {
            // 2. FETCH THE BOOLEAN ARRAY
            let booleanList = cctvViewModelObject.cameraGraph?.connections[rowName] ?? []
            
            // 3. Safe Access: Check if colIndex is valid
            if colIndex < booleanList.count {
                let isConnected = booleanList[colIndex]
                
                if isConnected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.title3)
                        .bold()
                } else {
                    Image(systemName: "x.circle.fill")
                        .foregroundStyle(.red)
                        .font(.title3)
                        .bold()
                }
            } else {
                // Fallback if API array is shorter/empty
                Image(systemName: "questionmark.circle")
                    .foregroundStyle(.gray.opacity(0.3))
            }
        }
    }
}

#Preview {
    RelationshipMatrixView()
}
