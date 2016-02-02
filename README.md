##TODO:
###Guest:

* Index
  * [ ] Logout button top
  * [ ] Carousel
  * [ ] Link back to PCCI
  * [ ] Pictures - DB

* Login/Register
  * [ ] Small style changes

* Event Signup
  * [ ] Styling
  * [ ] Map / Picking seats
  * [ ] DB insert seats

###Request / Response:
* [ ] Only let group leader add people
* [ ] Dont worry about accept reject, just accept after a few seconds

###DB Changes:
* [X] Group table
  * Group ID
  * Group Leader ID
  * Number of tickets
* [X] Group Request table
  * Group ID
  * Requested ID
  * Has Accepted

###Student:
Same as guest, but with request / response  
If request at same time, first gets it other gets error
Someone can be requested more than once

###Faculty/ Staff:
Same as student

###Maps:
  * Add DHA map
    * [ ] Create DHA SVG
    * [ ] Create DHA GeoJSON
    * [ ] Add all DHA data to SEATS table in DB
