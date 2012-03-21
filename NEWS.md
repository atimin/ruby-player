## Next 0.5.0

* Log level by default :notice is removed. Use :info. 
* Added ActArray#power? method.
* Added #beams and #stored attributes for Gripper class.
* Added #position, #speed, #acceleration and #current attributes for Actor class.
* Added #px, #py, #pa, #vx, #vy, #va and #power? attributes for Position2d class. Method #power is deprecated.
* Added #volts, #percent, #joules and #watts attributes for Power class.
* Added blobfinder interface

## 2012-03-06 0.4.1

* Fixed bug in logging of warn and error messages

## 2012-02-21 0.4.0

* Changed API for Ranger. Now ranger[0].geom intead of ranger.geom[:sensors][0]! Methods #ranger, #intenities is depricated.
* Added actarray interface
* Methods #turn_on! ans #turn_off! are renamed to #power_on! and #power_off!. #turn_on! and #turn_off! is deprecated
* Method Position2d::position is renamed to Position2d::state. Position2d::position is deprecated

## 2012-02-17 0.3.0

* Added gripper interface

## 2012-02-16 0.2.0

* Added power interface

## 2012-02-13 version 0.1.0

Code is rewrited in pure ruby! 
