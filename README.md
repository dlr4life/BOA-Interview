# BOA ML-Interview App
Bank of America (Merill Lynch) App (For interview purposes only.)

<div align="center">
    <img src="https://github.com/dlr4life/BOA-Interview/blob/master/BOA%20Interview/Assets.xcassets/1-URLSession.imageset/1-URLSession.png" width="300px"</img> 
    <img src="https://github.com/dlr4life/BOA-Interview/blob/master/BOA%20Interview/Assets.xcassets/2-Decodable.imageset/2-Decodable.png" width="300px"</img>
    <img src="https://github.com/dlr4life/BOA-Interview/blob/master/BOA%20Interview/Assets.xcassets/3-Programmatic%20UI.imageset/3-Programmatic%20UI.png" width="300px"</img> 
</div>

# Purpose:
This app is to meant to display some of my development skills for interview purposes. I will be adding data from REST API calls that return arrays of items, listed within UITableView. There is also a MapKit view, populated with countries, and capitals from a plist file.

# Explanation:
The tabs across the top of the view are set inside a UICollectionView that is set inside a UIView. The UIView is pinned to the top of the UIViewController (ViewController) to act as a horizontal navigation menu. 

- The first Tab of the UICollectionView (OrangeViewController) is meant to show the parsed JSON data through the URLSession method. I will need to make a GET call, parse the returned JSON data (with URLSession), and set up a UITableView to display it. Since some/most API's return paginated data I will also implement loading the next page of results as the user scrolls downward.

- The second Tab of the UICollectionView (RedViewController) is meant to display the parsed JSON data via the Decodable method.I will need to make a GET call, parse the returned JSON data (with JSON Decodable), and set up a UITableView to display it. Since some/most API's return paginated data I will also implement loading the next page of results as the user scrolls downward.

- The Last tab of the UICollectionView (YellowViewController) is is meant to show a programmatic UI with a MapKit view, populated by annotations that originate from a plist file that has been parsed into an NSDictionary. The data is added to the MapKit view, in the form of pins with clickable annotations. To better navigate the MapKit view, there is a UIPickerView, which has been rotated 180 degrees to allow for horizontal swiping in order to select a country flag. There are separate images for every country that have been added to the project to be used as a left element of the annotation callout. Once a country's flag is selected (via swiping from left or right in the UIPickerView), the MapKit view moves and centers on the annotation for the selected country, triggering the label below to update with the selected country name (after a one second delay), just in case the user changes their mind. There is an addded feature, for the background of the UIView to randomly change colors depending on the country selected via swipe.
