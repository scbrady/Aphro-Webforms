##TODO:
###Guest:
* Master
  * [X] Link in picture header

* Index
  * [X] Logout button top
  * [X] Carousel
  * [ ] Link back to PCCI
  * [X] Pictures - DB
  * [ ] Allow Purchase Of Season Tickets

* Login/Register
  * [X] Small style changes

* Event Signup
  * [X] Styling
  * [X] Map / Picking seats
  * [X] DB insert seats
  * [X] Move picking seats to after confirmation

###Event Creation:
* [X] Event page to see/delete created events
* [X] Ability to remove dates
* [X] Style upload image
* [ ] Add Seasons

###Request / Response:
* [X] Only let group leader add people
* [X] Dont worry about accept reject, just accept after a few seconds

###DB Changes:
* [X] Group table
  * Group ID
  * Event ID
  * Group Leader ID
  * Number of tickets
* [X] Group Request table
  * Group ID
  * Requested ID
  * Has Accepted
* [X] Season Tickets table
  * Season ID
  * Person ID

###Student:
Same as guest, but with request / response  
If request at same time, first gets it other gets error
Someone can be requested more than once

###Faculty/ Staff:
Same as student

###Maps:
  * Add DHA map
    * [X] Create DHA SVG
    * [X] Create DHA GeoJSON
    * [X] Add all DHA data to SEATS table in DB
