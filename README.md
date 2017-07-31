# thread-genius-swift
A Swift client for the Thread Genius API.

## Features

## Requirements
* iOS 9.0+ / macOS 10.0+ / watchOS 3.0+
* Xcode 8+
* Swift 3.0+

## Communication
* If you need help, ask a question on Stack Overflow
* If you found a bug, open an issue.
* If you have a feature request, open an issue.
* If you want to contribute, submit a pull request.

## Installation

### Cocoapods
Cocoapods is a dependency manager for Cocoa projects. You can install it with the following command:
```
$ gem install cocoapods
```
To integrate TGClient into your Xcode project using CocoaPods, specify it in your `Podfile`:
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!


target '<Your Target Name>' do
    pod 'TGClient', '~> 4.4'
end
```

Then, run the following command:
```
$ pod install
```

## Usage
With TGClient, you can interact with Thread Genius’ API in the following ways:
First, start by creating an instance of the class ThreadGenius in your ViewController. To use the Thread Genius API, you will need a key that is provided to you. Once you have acquired one, you can initialize the class like this:
```
let tg = ThreadGenius(key: “myKey”)
```
From there, you can interact with every function the API has to offer.

### Catalogs

#### Create a new empty catalog:
First, create an instance of the `TGCatalog` struct. You can either initialize `TGCatalog` with a name, or a GID.
```swift
let catalogInstance = TGCatalog(name: “myFirstCatalog”)
```
Or
```swift

let catalogInstance = TGCatalog(gid: “catalog1”)
```
Then, you can create the catalog and submit a request by using:
```swift
tg.createCatalog(catalogInstance)
```

#### List all catalogs:
To list all catalogs use the function:
```swift
tg.listAllCatalogs()
```

#### Get a catalog:
To get a catalog you can use the `getCatalog()` function with the name or GID of your catalog as the paramter as such:
```swift
tg.getCatalog(name: “myFirstCatalog”)
```

#### Delete a catalog:
Simply use the delete function with the name or GID of your catalog like below:
```swift
tg.deleteCatalog(name: “myFirstCatalog”)
```

#### Add objects to a catalog:
First create an object using an instance of the `TGObject` struct provided.
```swift
let object = TGObject(image: imageInstance, metadata: yourMetadata)
```
You’ll notice that the image the object requires is a `TGImage`. You can easily create one with an instance of the `TGImage` struct. There are two initializations of `TGImage` for your convenience. Both require you to provide a crop which can be given as a `CGRect`, but then you have your choice if you want to provide a URL to your image or the `UIImage` itself. You can create the instance like below:
```swift
let imageInstance = TGImage(image: “http://yourdomain.com/image.jpg”, crop: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height) 
```
You’ll also notice that you can supply optional metadata per object, which you provide in the form of a dictionary.:
```swift
let metadataInstance = {brand: "Gucci", hashtags: ["bad", "boujee"]}
```

#### Delete an object from a catalog:
Deleting an object from a catalog is just as easy as creating one. Just use the function below:
```swift
tg.delete(object: object, from catalog: catalog)
```

### Search
Another way to interact with catalogs is by searching within them. 

#### Search a catalog by image:
You can search for an image in a catalog by using a `TGImage` instance as such:
```swift
tg.searchFor(image: imageInstace, in catalog: catalog) 
```

#### Search a catalog by keyword:
You can also search for images in a catalog by using a keyword(s). This returns many images all with the keyword you provide.
```swift
tg.searchFor(keywords: keywordsInstance)
```

To provide keywords, one needs to provide an instance of the `TGKeywords` struct. A `TGKeywords` struct is made up of an array of strings. To create one, follow the example below:
```swift
let keywordsInstace = TGKeywords(keywords: [“red”, “dress”, “stripes])
```

### Prediction:

#### Predict tags via image URL or `UIImage`:
To predict tags all you need is to call the tagImage() function.

```swift
tg.tagImage(image: imageInstance, completionHandler: yourCompletionHandlerHere)
```
The image the function calls for is a `TGImage`. You can easily create one with an instance of the `TGImage` struct. There are two initializations of `TGImage` for your convenience. Both require you to provide a crop which can be given as a `CGRect`, but then you have your choice if you want to provide a URL to your image or the `UIImage` itself. You can create the instance like below:
```swift
let imageInstance = TGImage(image: “http://yourdomain.com/image.jpg”, crop: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height) 
```
Or
```swift
let imageInstance = TGImage(image: UIImage(named: “image”, crop: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
```
After calling the function, it will return an array of `TGTag` structs which have two properties: name and confidence. Name is a string that describes what the tag is of and confidence is a float that tells you the accuracy of the tag. 

#### Detect bounding boxes via image URL or UIImage:
To detect bounding boxes in an image, you can use the function below:
```swift
tg.detectBoxes(image: imageInstance, completionHandler: yourCompletionHandlerHere)
```
The image the function calls for is a `TGImage`. You can easily create one with an instance of the `TGImage` struct. There are two initializations of `TGImage` for your convenience. Both require you to provide a crop which can be given as a `CGRect`, but then you have your choice if you want to provide a URL to your image or the `UIImage` itself. You can create the instance like below:
```swift
let imageInstance = TGImage(image: “http://yourdomain.com/image.jpg”, crop: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height) 
```
Or
```swift
let imageInstance = TGImage(image: UIImage(named: “image”, crop: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
```
The function returns a `TGBox` struct which is made up of an array of `CGRect`'s. The `CGRect` tells you the coordinates and size of the box for you to interact with. 
