import SwiftUI

struct MainView: View {
    @State private var githubUsername: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                TextField("Search Github Username", text: $githubUsername)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Image(systemName: "heart.fill")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                Spacer()
                NavigationLink(destination: DestinationPage(username: githubUsername), label: {
                    Text("Next Screen")
                        .bold()
                        .foregroundColor(.red)
                        .frame(width: 150, height: 50)
                        .background(Color.yellow)
                        .cornerRadius(20)
                        .padding()
                }).disabled(githubUsername.isEmpty)
                .padding()
                
            }
            .navigationTitle("Main View")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    
}

struct DestinationPage: View {
    var username: String
    @State private var userData : User?
    
    var body: some View {
        VStack{
            ZStack {
                Rectangle()
                    .frame(height: 400)
                    .cornerRadius(30)
                    .padding()
                    .foregroundColor(.red)
                
                if userData == nil {
                    Text("Loading...")
                } else if let userData = userData {
                    Text(userData.login).font(.system(size: 30,weight: .bold)).foregroundColor(.white)
                }
            }
            Button("Github", action: openLink)
        }.onAppear(perform: {
            loadData()
        })
    }
    
    private func loadData() {
        let urlString = "https://api.github.com/users/\(username)"
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(User.self, from: data)
                DispatchQueue.main.async {
                    self.userData = decodedData
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }.resume()
    }

    
    private func openLink() {
       
        if let userData = userData, !userData.login.isEmpty {
                let urlString = "https://github.com/\(userData.login)"
                if let url = URL(string: urlString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
        }else{
            print("user not found")
        }
    }
}


struct Previews_MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
