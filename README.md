##TODO:
###Guest:
* Master
  * [ ] Link in picture header

* Index
  * [ ] Logout button top
  * [ ] Carousel
  * [ ] Link back to PCCI
  * [ ] Pictures - DB

* Login/Register
  * [ ] Small style changes

* Event Signup
  * [ ] Styling
  * [X] Map / Picking seats
  * [X] DB insert seats
  * [ ] Move picking seats to after confirmation

###Event Creation:
* [ ] Event page to see/delete created events
* [ ] Ability to remove dates
* [ ] Style upload image

###Request / Response:
* [ ] Only let group leader add people
* [ ] Dont worry about accept reject, just accept after a few seconds

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
