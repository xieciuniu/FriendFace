//
//  FriendList.swift
//  FriendFace
//
//  Created by Hubert Wojtowicz on 25/07/2023.
//

import SwiftUI
import CoreData


enum SearchBool {
    case search
    case notSearch
    
    func toString() -> String {
        switch self {
        case.search:
            return " && name BEGINSWITH[c] %@"
        case .notSearch:
            return ""
        }
    }
}

enum Predicate {
    case show
    case notShow
    
    func toString() -> String {
        switch self {
        case .show:
            return "isActive != nil"
        case .notShow:
            return "isActive = true"
        }
    }
}

struct Friendss: Identifiable {
    var name: String
    var id: String
    let iD = UUID()
}

class FriendListClass: ObservableObject {
    @Published var group = [Friendss]()
    
    init(user: FetchedResults<CachedUser>.Element) {
        for friend in user.friendArray {
            let oneFriend = Friendss(name: friend.wrappedName, id: friend.wrappedId)
            
            group.append(oneFriend)
            
        }
    }
    init(){}
}

struct FriendList<T: NSManagedObject, Content: View>: View {
    //    let user: User
    
    @StateObject var listClass = FriendListClass()
    
    let content: (T) -> Content
    
    @FetchRequest var fetchRequest: FetchedResults<CachedUser>
    
    //var frien: [String]
    
    var body: some View {
        
        ForEach(fetchRequest) { user in
            Group{
                NavigationLink{
                    UserView(userName: user.wrappedName, userAbout: user.wrappedAbout, userEmail: user.wrappedEmail, userCompany: user.wrappedCompany, userTags: user.wrappedTags, userFriends: FriendListClass(user: user).group, registeredDate: user.registered ?? Date.now)
                        .navigationTitle(user.wrappedName)
                } label: {
                    HStack{
                        Text(user.wrappedName)
                            .foregroundColor(user.isActive ? .primary : .red)
                        
                        Spacer()
                        
                        Image(systemName: user.isActive ? "person.fill.checkmark" : "person.fill.xmark")
                    }
                }
            }
            
        }
    }
    
//    func returnFriends(user: FetchedResults<CachedUser>.Element) -> Friendss {
//        var arr: Friendss
//
//        for friend in user.friendArray {
//            arr = Friendss(name: friend.wrappedName, id: friend.wrappedId)
//        }
//        return arr
//    }
    
    init(isActive: Predicate,search: String, isSearch: SearchBool, @ViewBuilder content: @escaping (T) -> Content) {
        _fetchRequest = FetchRequest<CachedUser>(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)], predicate: NSPredicate(format: "\(isActive.toString()) \(isSearch.toString())", search  ))
        self.content = content

    }
}

//struct FriendList_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendList(user: User.example)
//    }
//}
