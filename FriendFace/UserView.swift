//
//  UserView.swift
//  FriendFace
//
//  Created by Hubert Wojtowicz on 25/07/2023.
//

import SwiftUI
import CoreData



struct UserView: View {
//    @FetchRequest var user: FetchedResults<CachedUser>
//    let user: @FetchRequest(sortDescriptors: [])
//    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "id CONTAINS %@", self.userID)) var user: FetchedResults<CachedUser>
    
    let userName: String
    let userAbout: String
    let userEmail: String
    let userCompany: String
    let userTags: [String]
    let userFriends: [Friendss]
    let registeredDate: Date
    
    var body: some View {
        NavigationView {
            Form {
                AsyncImage(url: URL(string:"https://thispersondoesnotexist.com")){ phase in switch phase { case
                        .failure: Image(systemName: "photo")
                        .font(.largeTitle) case
                        .success(let image): image
                        .resizable() default: ProgressView() } }
                    .frame(height: 350)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                
                Text(userAbout)
                    .padding()
                
                Text("\(userEmail) || \(userCompany)")
                
                Section("Tags"){
                ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ForEach(0..<userTags.count){
//                            for tag in userTags.components(separatedBy: ",") {
                                Text(userTags[$0])
                                    .fixedSize(horizontal: false, vertical: true)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                        .frame(height: 20)
                                        .background(Rectangle().fill(Color.yellow).cornerRadius(10))
                            }
                        }
                    }
                }
                
                Section("Friends"){
                    ForEach(userFriends) { friend in
                        Text(friend.name)
                    }
                }
                
                Section("Registered date"){
                    Text(registeredDate.formatted(date: .abbreviated, time: .omitted))
                }
            }
        }
    }
    init(userName: String, userAbout: String, userEmail: String, userCompany: String, userTags: String, userFriends: [Friendss], registeredDate: Date) {
        self.userName = userName
        self.userAbout = userAbout
        self.userEmail = userEmail
        self.userCompany = userCompany
        self.userTags = userTags.components(separatedBy: ",")
        self.userFriends = userFriends
        self.registeredDate = registeredDate
    }
    
}

//struct UserView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserView(userID: "Unknown ID")
//    }
//}
