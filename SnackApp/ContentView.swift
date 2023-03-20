//
//  ContentView.swift
//  SnackApp
//
//  Created by 菅谷亮太 on 2023/03/20.
//

import SwiftUI

struct ContentView: View {
    @StateObject var snackDataList = SnackData()
    @State var inputText = ""
    @State var showSafari = false
    var body: some View {
        VStack {
            TextField("キーワード",text: $inputText, prompt: Text("キーワードを入力してください"))
                .onSubmit {
                    snackDataList.getSnack(keyword: inputText)
                }
                .submitLabel(.search)
                .padding()
            
            List(snackDataList.snackList){ snack in
                Button {
                    snackDataList.snackLink = snack.url
                    showSafari.toggle()
                } label: {
                    HStack {
                        AsyncImage(url: snack.image){ image in
                            image.resizable()
                                .scaledToFit()
                                .frame(height:40)
                        } placeholder: {
                            ProgressView()
                        }
                        Text(snack.name)
                    }
                }
            }
            .sheet(isPresented: $showSafari, content: {
                SafariView(url: snackDataList.snackLink!)
                    .ignoresSafeArea(edges: [.bottom])
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
