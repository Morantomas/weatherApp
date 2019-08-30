# Clima

## What does the app do

Its a weather Informer for your Location, and some more cities

## What I implemente
I implement for the Network Layer: Alamofire. I have used protocols, enums, delegates and PODS.

## PODS: 
Open Console, and only write  ```pod install```  in the path of the Project 

```
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'WeatherTest' do
# Comment the next line if you don't want to use dynamic frameworks
use_frameworks!

# Pods for WeatherTest
pod 'Alamofire', '~> 4.5'
pod 'SwiftyJSON'
pod 'SVProgressHUD'

target 'WeatherTestTests' do
inherit! :search_paths
# Pods for testing
end

target 'WeatherTestUITests' do
inherit! :search_paths
# Pods for testing
end

end
```


