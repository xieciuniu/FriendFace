//
//  ContentView.swift
//  FriendFace
//
//  Created by Hubert Wojtowicz on 25/07/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var search = ""
    @State private var unActive = true
    
    @State private var users = [User]()
    
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(sortDescriptors: []) var cachedUser: FetchedResults<CachedUser>
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Search", text: $search)
                    Toggle("Show unactive", isOn: $unActive)
                }
                
                Section {
                    Button("Download data from server"){
                        Task {
                            await loadData()
                        }
                    }
                    
                    Button("Delete data"){
                        for user in cachedUser {
                            moc.delete(user)
                        }
                    }
                }
                
                
                Section{
                    FriendList(isActive: unActive ? Predicate.show : Predicate.notShow, search: search, isSearch: search == "" ? SearchBool.notSearch : SearchBool.search){(cachedUser: CachedUser) in
                    }
                }
//                ForEach(cachedUser){ user in
//                    Text(user.wrappedName)
//                }
//
//                ForEach(users) { user in
//                    FriendList(user: user)
//                }
            }
            .navigationTitle("FriendFace")
        }
    }
    
    func loadData() async {
        guard cachedUser.isEmpty else { print("data exist"); return }
        
        do {
            let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            users = try decoder.decode([User].self, from: data)
            
            
            
            await MainActor.run{
                for user in users {
                    let newRecord = CachedUser(context: moc)
                    
                    newRecord.id = user.id
                    newRecord.about = user.about
                    newRecord.address = user.address
                    newRecord.age = Int16(user.age)
                    newRecord.company = user.company
                    newRecord.email = user.email
                    newRecord.isActive = user.isActive
                    newRecord.name = user.name
                    newRecord.registered = user.registered
                    newRecord.tags = user.tags.joined(separator: ",")
                    
                    for friend in user.friends {
                        let friends = CachedFriend(context: moc)
                        friends.id = friend.id
                        friends.name = friend.name
                        newRecord.addToFriend(friends)
                    }
                }
                
                try? moc.save()
            }
            
        } catch {
            print("Invalid Data")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
