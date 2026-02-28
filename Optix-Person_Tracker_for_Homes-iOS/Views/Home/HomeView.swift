import SwiftUI
import Combine
import SwiftData

struct HomeView: View {
    
    //Geting Access to Database
    @Environment(\.modelContext) private var context
    
    @StateObject var homeViewModelObject = HomeViewModel()
    
    @State var familyLogObjectForDetails: Logs?
    @State var unwantedLogObjectForDetails: Logs?
    
    var currentDateString: String {
                let formatter = DateFormatter()
                formatter.dateFormat = "EEEE, d MMM YYY"
                return formatter.string(from: Date())
            }
    // Settings for the columns in grid
    let autoColumns = Array(repeating: GridItem(.flexible()), count: 2)
    
    // Creating the greeting Message
    var greetingMessage: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return "Good Morning!" }
        if hour < 18 { return "Good Afternoon!" }
        return "Good Evening!"
    }

    var body: some View {
        ZStack(alignment: .top) {
            
            // checking do we have the data
            if let dashboard = homeViewModelObject.dashboardResponse {
                ScrollView {
                    Color.clear.frame(height: 160)
                    LazyVGrid(columns: autoColumns, spacing: 15) {
                        
                        HomeCard(cardType: .icon, upperCardText: "", cardButtonColor: "", cardButtonArrowColor: .black, lowerCardText: "", cardTextColor: .black, cardColor: "custom_yellow") {
                            print("Shield tapped")
                        }
                        .padding(.top)
                        
                        HomeCard(cardType: .normal, upperCardText: "\(dashboard.cameraCount)", cardButtonColor: "custom_yellow", cardButtonArrowColor: .black, lowerCardText: "Total CCTV cameras", cardTextColor: .primary, cardColor: "custom_color") {
                            print("")
                        }
                        .padding(.top)
                        
                        HomeCard(cardType: .normal, upperCardText: "\(dashboard.familyCount)", cardButtonColor: "custom_yellow", cardButtonArrowColor: .black, lowerCardText: "Total family members", cardTextColor: .primary, cardColor: "custom_light_blue") {
                            print("")
                        }
                        
                        HomeCard(cardType: .normal, upperCardText: "\(dashboard.todayEventCount)", cardButtonColor: "custom_yellow", cardButtonArrowColor: .black, lowerCardText: "Total today's alert", cardTextColor: .white, cardColor: "custom_blue") {
                            print("")
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
                    
                    HStack {
                        Text("Recent Activity")
                        Spacer()
                    }
                    .padding(.horizontal, 35)
                    
                    // Family Log (Safe Unwrap)
                    if let familyLog = dashboard.recentFamilyLog {
                        InfoCard(
                            cardType: .familylog,
                            id: familyLog.id,
                            name: familyLog.name,
                            roomName: familyLog.roomName,
                            floorName: familyLog.floorTitle,
                            description: "",
                            // FIX: Use AppFormatter correctly (static calls)
                            detected_date: AppFormatter.shared.getFormattedDate(from: familyLog.detectedAt),
                            detected_time: AppFormatter.shared.getFormattedTime(from: familyLog.detectedAt),
                            photo: familyLog.personPhoto, relationship: ""
                        ) {
                            familyLogObjectForDetails = familyLog
                            print(familyLog)
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 7)
                    }
                    
                    // Unwanted Log (Safe Unwrap)
                    if let unwantedLog = dashboard.recentUnwantedLog {
                        InfoCard(
                            cardType: .alert,
                            id: unwantedLog.id,
                            name: unwantedLog.name,
                            roomName: unwantedLog.roomName,
                            floorName: unwantedLog.floorTitle,
                            description: "",
                            detected_date: AppFormatter.shared.getFormattedDate(from: unwantedLog.detectedAt),
                            detected_time: AppFormatter.shared.getFormattedTime(from: unwantedLog.detectedAt),
                            photo: unwantedLog.personPhoto, relationship: ""
                        ) {
                            print("")
                        }
                        .padding(.horizontal, 30)
                    }
                    
                    // Add Buttons
                    HStack {
                        Text("Add new")
                        Spacer()
                    }
                    .padding(.horizontal, 35)
                    .padding(.top, 20)
                    
                    LazyVGrid(columns: autoColumns, spacing: 15) {
                        HomeCard(cardType: .add, upperCardText: "New", cardButtonColor: "custom_yellow", cardButtonArrowColor: .black, lowerCardText: "Family Member", cardTextColor: .primary, cardColor: "custom_light_blue") {
                            print("")
                        }
                        
                        HomeCard(cardType: .add, upperCardText: "New", cardButtonColor: "custom_yellow", cardButtonArrowColor: .black, lowerCardText: "CCTV Camera", cardTextColor: .primary, cardColor: "custom_color") {
                            print("")
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 100)
                }
                .ignoresSafeArea()
                .scrollIndicators(.hidden)
                
            }
            VStack{
                // Floating on top
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(greetingMessage)")
                            .font(.title)
                            .bold()
                        Spacer()
                    }
                    HStack {
                        Text(currentDateString)
                    }
                }
                .padding(.top, 60)
                .padding(.bottom, 20)
                .padding(.horizontal, 30)
                .background(.ultraThinMaterial)
                .ignoresSafeArea(edges: .top)
                
                if homeViewModelObject.isLoading {
                    HStack{
                        ProgressView()
                        Text("Connecting...")
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                    .padding(2)
                    .frame(width: 130, height: 30)
                    .glassEffect()
                    Spacer()
                }
                Spacer()
            }
        }
        .onAppear {
            Task
            {
                await homeViewModelObject.getDashboardStats(context: context)
            }
        }
        .refreshable {
            Task
            {
                await homeViewModelObject.getDashboardStats(context: context)
            }
        }
        .sheet(item: $familyLogObjectForDetails) { LogObject in
            FamilyLogDetailsView(member: LogObject)
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    HomeView()
}
