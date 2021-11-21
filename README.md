CONTENTS OF THIS FILE
---------------------
 * Introduction
 * Installation
 * Design

## Minimum OS support - iOS 13

INTRODUCTION
------------

This App is build to demonstrate iOS Coding Skills with Reactive programming

* Features

* This app displays a list of Gist provided by Github API. Once the list is displayed the app again queries each user in the list to fetch their gist shares details.

* Once the user detail is fetched and if this particular user has shares count more than or equal to 5 a new row is added below his initial row with his share count and name.

* On the tap of am item  a detail page is loaded onto screen with detail of that item and you can mark that gist as favorite
Note: The new row added to display username and share count cannot be selected.

INSTALLATION
------------
This app is built using RxSwift and Alamofire which are 3rd party library.
To install these dependencies a dependency manager is used i.e. CocoaPods. 
The dependecies are listed in podfile.

To successfully built the project Run Pod Install from root directory of project on your commandline 
Once the pods are installed open .xcworkspace file and you are ready to go now!!!


Design
-----------

MVVM design is used to built this app with BlackBox Technique

*  ViewModel BlackBox - ViewModel can only be accessed via input and output variable which means you can send input to viewModel and listen to its output from Viewcontroller assuring that your viewmodel's internal members are not touched.

 Project layering is in following order
 *  ViewController(UI Layer) 
 *  ViewModel (Presentation layer)
 *  ViewModelDataManager(Data controller Layer) 
 *  ApiClient (Networking layer) 
    
* Note: The api used to consume data in this app is free hence, it exceeds the limit after certain amount of queries to the server. So please wait and try it later to get it working.
