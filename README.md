# BOA ML-Interview App
Bank of America (Merill Lynch) App (For interview purposes only.)

<div align="center">
    <img src="https://github.com/dlr4life/BOA-Interview/blob/master/BOA%20Interview/Assets.xcassets/1-URLSession.imageset/1-URLSession.png" width="300px"</img> 
    <img src="https://github.com/dlr4life/BOA-Interview/blob/master/BOA%20Interview/Assets.xcassets/2-Decodable.imageset/2-Decodable.png" width="300px"</img>
    <img src="https://github.com/dlr4life/BOA-Interview/blob/master/BOA%20Interview/Assets.xcassets/3-Programmatic%20UI.imageset/3-Programmatic%20UI.png" width="300px"</img> 
</div>

# Purpose:
This app is to meant to display my development skills for interview purposes. I will be tying a table view to an REST API call returning an array of items. I will need to make a GET API call, parse the returned JSON data (with URLSession), and set up a table view to display it. Since some/most API's return paginated data I will also implement loading the next page of results as the user scrolls downward.

# Explanation:
The tabs across the top of the view are set inside a UICollectionView that is set inside a UIView. The UIView is pinned to the top of the UIViewController to allow for a swappable navigation menu. 

The first Tab of the UICollectionView is meant to show the parsed JSON data through the URLSession method.

The second Tab of the UICollectionView is meant to display the arsed JSON via the Decodable method.

The Last tab of the UICollectionView is meant to show a programmatic UI with a Map view, populated by annotations that originate from a plist file that has been parsed into an NSDictionary, and then added to the map. There are also separate images for every country that have been added to a UIPickerView, which has been rotated 180 degrees to allow for horizontal swiping in order to select a country flag. Once a country's flag is selected (via swiping from left or right), the map view moves to the annotation for the selected country, triggering the label to update with the selected country name.
