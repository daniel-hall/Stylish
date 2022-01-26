// swift-tools-version:5.5
import PackageDescription

let package = Package(
	name: "Stylish",
	platforms: [
		.macOS(.v10_15),
		.iOS(.v9)
	],
	products: [
		.library(name: "Stylish", targets: ["Stylish"])
	],
	targets: [
		.target(
			name: "Stylish",
			path: "Stylish",
			exclude: ["Info.plist", "Media.xcassets", "Stylish.h"]
		)
	],
	swiftLanguageVersions: [.v5]
)
