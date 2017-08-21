# Cognitive_Search

## Overview
Cognitive Search is an iOS application used to search Facebook entities, such as users, pages, events, places and groups. 
It combined IBM Watson API with Facebook Graph API to enable the app to search and present cognitive features.

## API

#### Links for API in the app:
* IBM Watson API: https://github.com/watson-developer-cloud/swift-sdk
* Facebook Graph API: https://developers.facebook.com/docs/graph-api

#### IBM Watson API usage and corresponding features in the app:
|IBM Watson API|Features|
|----|-----|
|Visual Recognition|Turns pictures into text for searching|
|Speech to Text| Turns voice messages into text to search|
|Text to Speech|Reads searching results|

#### Facebook Graph API
search Facebook entities and corresponding Albums and Posts

## Detail
#### Home interface(Figure 1)
<p align="center">
 <img src="https://github.com/freezaku/Cognitive_Search/blob/master/img_folder/figure_1.png" width="30%" height="30%" />
 <br />
 Figure 1
</p>

* Click on/off picture to transfer voice into text shown on search field(Figure 2) by using Speech to Text in IBM Watson API
<p align="center">
 <img src="https://github.com/freezaku/Cognitive_Search/blob/master/img_folder/figure_2.png" width="30%" height="30%" />
 <br />
 Figure 2
</p>

* Click camera picture(Figuer 3) to take a picture or select from library to tranfer picture(Figuer 4) into text shown on search field by using Vicual Recognition in IBM Watson API. Users can choice through clicking among the possible recognition results shown below(Figure 5).
<p align="center">
 <img src="https://github.com/freezaku/Cognitive_Search/blob/master/img_folder/figure_3.png" width="30%" height="30%" />
 <br />
 Figure 3
 <br />
 <img src="https://github.com/freezaku/Cognitive_Search/blob/master/img_folder/figure_4.png" width="30%" height="30%" />
 <br />
 Figure 4
 <br />
 <img src="https://github.com/freezaku/Cognitive_Search/blob/master/img_folder/figure_5.png" width="30%" height="30%" />
 <br />
 Figure 5
</p>

* Side bar is used to navigate back to home interface and favorites(Figure 6)
<p align="center">
 <img src="https://github.com/freezaku/Cognitive_Search/blob/master/img_folder/figure_6.png" width="30%" height="30%" />
 <br />
 Figure 6
</p>

#### Search results interface(Figure 7, Figure 8)
<p align="center">
 <img src="https://github.com/freezaku/Cognitive_Search/blob/master/img_folder/figure_7.png" width="30%" height="30%" />
 &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
 <img src="https://github.com/freezaku/Cognitive_Search/blob/master/img_folder/figure_8.png" width="30%" height="30%" />
 <br />
</p>
<p>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp Figure 7  &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp Figure 8</p>

#### Details - Albums interface(Figure 9)
<p align="center">
 <img src="https://github.com/freezaku/Cognitive_Search/blob/master/img_folder/figure_9.png" width="30%" height="30%" />
 <br />
 Figure 9
</p>

#### Details - Posts interface(Figure 10)
<p align="center">
 <img src="https://github.com/freezaku/Cognitive_Search/blob/master/img_folder/figure_10.png" width="30%" height="30%" />
 <br />
 Figure 10
</p>

* Click top right corner
  * make changes in favorite, which is able to find in home interface’s side bar(Figure 11)
<p align="center">
 <img src="https://github.com/freezaku/Cognitive_Search/blob/master/img_folder/figure_11.png" width="30%" height="30%" />
 <br />
 Figure 11
</p>

  * share in Facebook realized through Facebook API
* Click play button to read message realized through Text to Speech in IBM Watson API
