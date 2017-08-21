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
* Click on/off picture to transfer voice into text shown on search field(Figure 2) by using Speech to Text in IBM Watson API
* Click camera picture(Figuer 3) to take a picture or select from library to tranfer picture(Figuer 4) into text shown on search field by using Vicual Recognition in IBM Watson API. Users can choice through clicking among the possible recognition results shown below(Figure 5).
* Side bar is used to navigate back to home interface and favorites(Figure 6)

#### Search results interface(Figure 7, Figure 8)

#### Details - Albums interface(Figure 9)

#### Details - Posts interface(Figure 10)
* Click top right corner
  * make changes in favorite, which is able to find in home interface’s side bar(Figure 11)
  * share in Facebook realized through Facebook API
* Click play button to read message realized through Text to Speech in IBM Watson API
