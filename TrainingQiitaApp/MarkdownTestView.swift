//
//  MarkdownTestView.swift
//  TrainingQiitaApp
//
//  Created by  hayato on 2025/04/16.
//

import SwiftUI

struct MarkdownTestView: View {
    let qiitaTestBody = testBody
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 4) {
                let cleanedBody = qiitaTestBody.replacingOccurrences(of: "<br>", with: "")
                let lines = cleanedBody.components(separatedBy: "\n")
                
                ForEach(lines, id: \.self) { line in
                    if line.starts(with: "## ") {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(line.replacingOccurrences(of: "## ", with: ""))
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.vertical,4)
                            Divider()
                                .padding(.bottom, 12)
                        }
                    }
                    else if line.starts(with: "#### ") {
                        Text(line.replacingOccurrences(of: "#### ", with: ""))
                            .font(.title2)
                            .padding(.bottom, 8)
                    }
                    else if line.contains("<img src=") {
                        // 正規表現 or シンプルな分割でURLを取り出す
                        if let urlStart = line.range(of: "src=\"")?.upperBound,
                           let urlEnd = line[urlStart...].range(of: "\"")?.lowerBound {
                            
                            let urlString = String(line[urlStart..<urlEnd])
                            
                            if let url = URL(string: urlString) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(8)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                    }
                    else {
                        Text(line)
                            .font(.body)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    MarkdownTestView()
}

let testBody = """
## ⭐️ はじめに
SwiftUIのMapKitを使ってマップを実装している途中、
病院や飲食店、公園などのあらゆる情報がデフォルトに地図上に表示されていて、
ごちゃごちゃしていると感じました。

<img src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4050491/a090e79d-360a-4baf-a0ea-06e0b224cc26.png" width=40%>

(なんか汚くないですか？笑)

<br>

もし最小対応バージョンが17.0以上なら、
以下のコードで対応できます。

```swift
Map(
// 省略
)
.mapStyle(.standard(pointsOfInterest: .excludingAll))
/*
マップにカフェは表示したいなら、以下のコード
.mapStyle(.standard(pointsOfInterest: .including([.cafe])))
*/
```

上記のコードの結果
<img src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4050491/fcc30f62-9bb9-4d56-9e7d-fee1ed8a2878.png" width=40%>
（綺麗になりましたねー）

<br>

しかし、私のプロジェクトの最小対応バージョンは16で、
iOS16ではSwiftUIのMapKitを使ってpointsOfInterestをカスタマイズする方法はなさそうです。
（🙋もし、方法ご存知の方いらっしゃいましたら、コメントお願いします！）

そのため、マップViewはUIViewRepresentableを使ってUIKitで実装し、
SwiftUIのViewで使う方法を採用することにしました。

## 👨‍💻 詳細
#### ⭐️UIViewRepresentableとは？
UIViewRepresentableは、SwiftUIでUIKitのUIViewを使うためのプロトコルです。
これを使うことで、UIKitの機能をSwiftUIのViewに統合でき、SwiftUIでは実現が難しい部分を解決できます。

UIViewRepresentableプロトコルに準拠すると、makeUIViewとupdateUIViewという2つのメソッドを必ず実装する必要があります。

#### ⭐️makeUIView(context:)
このメソッドはSwiftUIのViewが初めて表示されるときに一度だけ呼ばれます。
ここではUIKitのView（今回の場合はMKMapView）を初期化や設定します。

```Swift
 struct CustomMapView: UIViewRepresentable {
    // 省略
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        
        //これのためにUIViewRepresentableを使いました！
        mapView.pointOfInterestFilter = MKPointOfInterestFilter(including: [.publicTransport])
        mapView.showsUserLocation = true
        mapView.setRegion(region, animated: true)
        
        return mapView
    }
    // 省略
}
```

#### ⭐️updateUIView(_:context:)

このメソッドはSwiftUI側の状態が更新されるたびに呼び出されます。
＠State、＠Binding、＠ObservedObject、＠StateObject などの状態変数が変更されると、SwiftUIがViewを再レンダリングし、updateUIView が呼ばれます。

例えば、ユーザーが地図上で位置を移動し、その新しい位置を基準にデータを取得する場合、SwiftUI側の状態が変わることでupdateUIViewが呼ばれます。

```Swift
  struct CustomMapView: UIViewRepresentable {
    // 省略
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeAnnotations(mapView.annotations)
        
        let annotations = places.map { place in
            let annotation = CustomAnnotation(place: place)
            annotation.coordinate = place.coordinate
            annotation.title = place.displayName
            return annotation
        }
        
        mapView.addAnnotations(annotations)
    }
    // 省略
}
```

上記の二つのメソッドだけを実装すれば十分な場合もありますが、
私の場合はMKMapViewのdelegateを使う必要があったため、Coordinatorを定義して対応しました。

#### ⭐️Coordinatorとは？
SwiftUIでは、UIKitのdelegateやdataSourceのような仕組みを直接使うことができません。
そのため、UIViewRepresentableではmakeCoordinator()メソッドを使って、SwiftUIとUIKitの橋渡しをするCoordinatorクラスを定義する必要があります

Coordinatorの中でMKMapViewDelegateを実装することで
- ピン（アノテーション）をタップしたときの処理
- 地図が移動されたときの処理
- ピンの見た目をカスタマイズする処理

などのことができます。

<br>

⭐️フルコード
```Swift
struct CustomMapView: UIViewRepresentable {
     func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        // 省略
        mapView.delegate = context.coordinator // delegateコード追加
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        // 省略
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: CustomMapView

        init(_ parent: CustomMapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            // ピン（アノテーション）をタップしたときの処理
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            // 地図が移動されたときの処理
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // ピンの見た目をカスタマイズする処理
        }
    }
}
```
上記で実装したCustomMapViewを以下のような形でSwiftUIで使用できます！


```Swift
struct HomeView: View {
    var body: some View {
        CustomMapView()
    }
}
```



## 💬 まとめ 
SwiftUIはどんどんアップデートされていますが、
企業の事情によりプロジェクトの最小対応バージョンを引き上げるのが難しい場合もあります。

そのため、SwiftUIだけで対応できない部分は
UIViewRepresentableを用いてUIKitの機能を活用することで解決できます。

"""
