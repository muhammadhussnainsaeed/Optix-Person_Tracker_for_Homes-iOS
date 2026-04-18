//
//  AddUpdateFamilyMemberView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 14/2/26.
//

import SwiftUI
import PhotosUI

struct AddUpdateFamilyMemberView: View {
    
    let isUpdate: Bool
    let member: Family?
    
    @State var alertMessage: String = ""
    @State var isPresentAlert: Bool = false
    @State var error: Bool = false
    
    @State private var name: String = ""
    @State private var selectedRelationship: RelationshipType = .other
    
    // Image pickers
    @State private var pickerItem1: PhotosPickerItem?
    @State private var pickerItem2: PhotosPickerItem?
    @State private var pickerItem3: PhotosPickerItem?
    
    // Stores NEWLY picked images (Index 0 = Slot 1, etc.)
    // If nil, it means the user hasn't changed this specific slot.
    @State private var newLocalImages: [UIImage?] = [nil, nil, nil]
    
    @Environment(\.dismiss) var dismiss
    @StateObject var familyViewModelObject = FamilyViewModel()
    
    init(isUpdate: Bool, member: Family?) {
        self.isUpdate = isUpdate
        self.member = member
        
        _name = State(initialValue: member?.name ?? "")
        
        let startingRelationship = RelationshipType(rawValue: member?.relationship ?? "") ?? .other
        _selectedRelationship = State(initialValue: startingRelationship)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                
                // 1. Photos Section
                HStack(spacing: 15) {
                    // Slot 1
                    photoSlotView(
                        index: 0,
                        serverURL: getPhotoURL(at: 0),
                        pickerItem: $pickerItem1
                    )
                    
                    // Slot 2
                    photoSlotView(
                        index: 1,
                        serverURL: getPhotoURL(at: 1),
                        pickerItem: $pickerItem2
                    )
                    
                    // Slot 3
                    photoSlotView(
                        index: 2,
                        serverURL: getPhotoURL(at: 2),
                        pickerItem: $pickerItem3
                    )
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
                
                VStack(alignment: .leading){
                    
                    // Name Textfield
                    Text("Name:")
                        .bold()
                        .padding(.horizontal, 14)
                    TextField("Enter Family Member name", text: $name)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .frame(height: 50)
                        .glassEffect()
                        .padding(.bottom, 30)
                    
                    // Relationship Picker
                    Text("Relationship:")
                        .bold()
                        .padding(.horizontal, 14)
                    Picker("Relationship", selection: $selectedRelationship) {
                        ForEach(RelationshipType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                        .font(.subheadline)
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 130)
                }
                .padding(.top, 50)
                
                Spacer()
                
                // 2. Action Button
                PrimaryButton(buttonText: isUpdate ? "Update" : "Save", buttonTextColor: .black, buttonColor: "custom_yellow", action: {
                    Task{
                        await saveAction()
                    }
                }, isLoading: familyViewModelObject.isLoading)
            }
            .padding(30)
            .navigationTitle(isUpdate ? "Edit Member" : "Add Member")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // Generates a Photo Slot (Picker + Image Display)
    @ViewBuilder
    func photoSlotView(index: Int, serverURL: String?, pickerItem: Binding<PhotosPickerItem?>) -> some View {
        PhotosPicker(selection: pickerItem, matching: .images) {
            
            // LAYER 1: The Image Logic
            ZStack {
                // Priority 1: User just picked a new photo
                if let localImage = newLocalImages[index] {
                    Image(uiImage: localImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 90, height: 90)
                        .cornerRadius(15)
                        .clipped()
                }
                // Priority 2: Existing Server Photo (Update Mode)
                else if let serverURL = serverURL, !serverURL.isEmpty {
                    ImageView(urlString: serverURL, localImage: nil)
                        .frame(width: 90, height: 90)
                        .cornerRadius(15)
                        .clipped()
                }
                // Priority 3: Empty Placeholder (Add Mode)
                else {
                    ImageView(urlString: nil, localImage: nil)
                        .frame(width: 90, height: 90)
                        .cornerRadius(15)
                        .clipped()
                }
            }
            .overlay {
                VStack{
                    Spacer()
                    Image(systemName: "plus.circle.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, Color("custom_blue"))
                        .font(.title)
                        .offset(y: 12)
                        .shadow(radius: 2)
                }
            }
        }
        .alert(error ? "Error" : "Success", isPresented: $isPresentAlert) {
            Button("OK", role: .cancel) {
                if !error {
                    dismiss()
                }
                else{
                    error.toggle()
                }
            }
        } message: {
            Text(alertMessage)
        }
        .onChange(of: pickerItem.wrappedValue) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        newLocalImages[index] = uiImage
                    }
                }
            }
        }
    }
    
    /// Safely gets the Server URL for a specific index
    func getPhotoURL(at index: Int) -> String? {
        guard isUpdate, let member = member else { return nil }
        if member.photos.indices.contains(index) {
            return member.photos[index].photo
        }
        return nil
    }
    
    // MARK: - Save/Update Logic
    func saveAction() async {
        
        let images = await gatherAllImagesForUpload()
        
        if name == "" || images.count != 3 {
            alertMessage = "Check your family member details and try again."
            error.toggle()
            isPresentAlert.toggle()
            return
        }
        
        if isUpdate{
            Task{
                await familyViewModelObject.updateFamilyMember(memberId: member?.id ?? UUID(), name: name, relationship: RelationshipType(rawValue: selectedRelationship.rawValue)?.rawValue ?? "", photos: images)
                if (familyViewModelObject.errorMessage != nil){
                    alertMessage = familyViewModelObject.errorMessage ?? ""
                    error.toggle()
                    isPresentAlert.toggle()
                }
                else{
                    alertMessage = familyViewModelObject.addUpdateDeleteMemberResponse? .message ?? ""
                    isPresentAlert.toggle()
                 }
            }
        }else{
            Task{
                await familyViewModelObject.addFamilyMember(name: name, relationship: RelationshipType(rawValue: selectedRelationship.rawValue)?.rawValue ?? "", photos: gatherAllImagesForUpload())
                if (familyViewModelObject.errorMessage != nil){
                    alertMessage = familyViewModelObject.errorMessage ?? ""
                    error.toggle()
                    isPresentAlert.toggle()
                }
                else{
                    alertMessage = familyViewModelObject.addUpdateDeleteMemberResponse? .message ?? "sample text7000"
                    isPresentAlert.toggle()
                 }
            }
        }
    }
    
    /// Optimized function to gather images from both Local (Picker) and Server (URL)
    func gatherAllImagesForUpload() async -> [Data] {
        
        // Use 'withTaskGroup' to process all 3 slots in parallel (Optimization)
        return await withTaskGroup(of: (Int, Data?).self) { group in
            
            // Loop through all 3 slots
            for i in 0..<3 {
                group.addTask {
                    return await self.processImageSlot(index: i)
                }
            }
            
            // Collect results and sort them back into order (Slot 1, 2, 3)
            var results: [(Int, Data?)] = []
            for await result in group {
                results.append(result)
            }
            
            // Filter out nils and return just the Data, sorted by slot index
            return results
                .sorted(by: { $0.0 < $1.0 }) // Ensure Slot 1 data comes before Slot 2
                .compactMap { $0.1 }         // Remove empty slots
        }
    }
    
    /// Logic to resolve a specific slot to Data
    func processImageSlot(index: Int) async -> (Int, Data?) {
        
        // CASE A: User picked a NEW photo from gallery
        if let localImage = newLocalImages[index] {
            // Compress to JPEG (0.7 quality is a good optimization for upload speed)
            let data = localImage.jpegData(compressionQuality: 0.7)
            return (index, data)
        }
        
        // CASE B: User kept the EXISTING Server photo (Update Mode)
        // Since the API deletes the old record, we MUST download and re-upload this image.
        if isUpdate, let serverPath = getPhotoURL(at: index) {
            
            // Construct full URL (Ensure this matches your baseURL logic)
            let baseURL = "http://192.168.100.221:8888/"
            guard let url = URL(string: baseURL + serverPath) else { return (index, nil) }
            
            do {
                // Download the image data
                let (data, _) = try await URLSession.shared.data(from: url)
                return (index, data)
            } catch {
                print("Failed to download existing image for re-upload: \(error)")
                return (index, nil)
            }
        }
        
        // CASE C: Slot is empty
        return (index, nil)
    }
}

// MARK: - Preview

#Preview {
    AddUpdateFamilyMemberView(isUpdate: true, member: Family(id: UUID(), name: "ali", relationship: "Father", photos: [FamilyPhotos(photo: "media/persons/4f9e6836-cd16-4ae3-9206-fea37dff3520_1.jpg"), FamilyPhotos(photo: "media/persons/4f9e6836-cd16-4ae3-9206-fea37dff3520_1.jpg"), FamilyPhotos(photo: "media/persons/4f9e6836-cd16-4ae3-9206-fea37dff3520_1.jpg")]))
}
