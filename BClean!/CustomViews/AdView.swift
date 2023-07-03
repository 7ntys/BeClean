import SwiftUI
import GoogleMobileAds

struct AdBannerView: UIViewControllerRepresentable {
    @State var bannerId:String
    func makeUIViewController(context: Context) -> UIViewController {
        let bannerView = GADBannerView(adSize: GADAdSize(size: CGSize(width: 320, height: 50), flags: 0))
        let viewController = UIViewController()
        bannerView.adUnitID = bannerId
        bannerView.rootViewController = viewController
        viewController.view.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bannerView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            bannerView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
            bannerView.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        bannerView.load(GADRequest())
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
