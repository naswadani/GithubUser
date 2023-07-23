import SwiftUI


struct MainView: View {
    @State private var githubUsername: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Image("github-mark")
                TextField("Search Github Username", text: $githubUsername)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(50)
                Spacer()
                NavigationLink(destination: DestinationPage(username: githubUsername), label: {
                    Text("Search")
                        .bold()
                        .foregroundColor(.black)
                        .frame(width: 150, height: 50)
                        .background(Color.yellow)
                        .cornerRadius(20)
                        .padding()
                }).disabled(githubUsername.isEmpty)
                .padding()
                
            }
            .navigationTitle("Main View")
            .navigationBarTitleDisplayMode(.inline)
        }.accentColor(Color(.label))
    }

    
    
}

struct DestinationPage: View {
    var username: String
    @State private var userData : User?
    
    var body: some View {
        ScrollView{
            VStack{
                ZStack {
                    Rectangle()
                        .frame(height: 300)
                        .cornerRadius(30)
                        .padding()
                        .foregroundColor(.yellow)
                    VStack{
                        if userData == nil {
                            Text("Loading...")
                        } else if let userData = userData {
                            AsyncImage(url: URL(string: "\(userData.avatar_url)")){image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 190, height: 190).cornerRadius(30)
                            Text(userData.login).font(.system(size: 30,weight: .bold)).foregroundColor(.white)
                        }
                        
                    }
                }.padding()
                Button("Github", action: openLink).frame(width: 250, height: 50).background(.black).foregroundColor(.white).cornerRadius(25).padding().animation(.easeIn(duration: 0.8))
            }.onAppear(perform: {
                loadData()
            })
        }
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

extension UIImageView {
    func makeRounded() {
        let radius = self.frame.width/2.0
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
 }


struct Previews_MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
