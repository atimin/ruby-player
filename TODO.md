
For supported devices
-------------------------------------
**ranger** - The ranger proxy provides an interface to ranger sensor devices.

1. Get geometry of device and sensors
2. Get 3d scan points (x,y,z)

**position2d** - The position2d proxy provides an interface to a mobile robot base, such as the ActiveMedia Pioneer series.

1. Set speed and heading - wrap C `func playerc_position2d_set_cmd_vel_head`
2. Move to point - wrap C funcs `playerc_position2d_set_cmd_pose_with_vel` and `playerc_position2d_set_cmd_pose`

Candidates for support
--------------------------------------

**actarray** - The actarray proxy provides an interface to actuator arrays such as the ActivMedia Pioneer Arm.

**blobfinder** - The blobfinder proxy provides an interface to color blob detectors such as the ACTS vision system.

**graphics2d** - The graphics2d proxy provides an interface to the graphics2d.

**graphics3d** - The graphics3d proxy provides an interface to the graphics3d.

**gripper** - The gripper proxy provides an interface to the gripper.

**simulation** - The simulation proxy is used to interact with objects in a simulation.

Device proxies are not started to develop
--------------------------------------

**aio** - The aio proxy provides an interface to the analog input/output sensors.

**audio** - The audio proxy provides access to drivers supporting the audio_interface.

**blinkenlight** - The blinkenlight proxy provides an interface to a (possibly colored and/or blinking) indicator light.

**bumper** - The bumper proxy provides an interface to the bumper sensors built into robots such as the RWI B21R.

**camera** - The camera proxy can be used to get images from a camera.

**dio** - The dio proxy provides an interface to the digital input/output sensors.

**fiducial** - The fiducial proxy provides an interface to a fiducial detector.

**health** - The health proxy provides an interface to the HEALTH Module.

**ir** - The ir proxy provides an interface to the ir sensors built into robots such as the RWI B21R.

**joystick** - The joystick proxy can be used to get images from a joystick.

**laser** - The laser proxy provides an interface to scanning laser range finders such as the sicklms200.

**limb** - The limb proxy provides an interface to limbs using forward/inverse kinematics, such as the ActivMedia Pioneer Arm.

**localize** - The localize proxy provides an interface to localization drivers.

**log** - The log proxy provides start/stop control of data logging.

**map** - The map proxy provides an interface to a map.

**vectormap** - The vectormap proxy provides an interface to a map of geometric features.

**opaque** - The opaque proxy provides an interface for generic messages to drivers.

**planner** - The planner proxy provides an interface to a 2D motion planner.

**position1d** - The position1d proxy provides an interface to 1 DOF actuator such as a linear or rotational actuator.

**position3d** - The position3d proxy provides an interface to a mobile robot base, such as the Segway RMP series.

**power** - The power proxy provides an interface through which battery levels can be monitored.

**ptz** - The ptz proxy provides an interface to pan-tilt units such as the Sony PTZ camera.

**sonar** - The sonar proxy provides an interface to the sonar range sensors built into robots such as the ActiveMedia Pioneer series.

**wifi** - The wifi proxy is used to query the state of a wireless network.

**speech** - The speech proxy provides an interface to a speech synthesis system.

**speech recognition** - The speech recognition proxy provides an interface to a speech recognition system.

**rfid** - The rfid proxy provides an interface to a RFID reader.

**pointcloud3d** - The pointcloud3d proxy provides an interface to a pointcloud3d device.

**stereo** - The stereo proxy provides an interface to a stereo device.

**imu** - The imu proxy provides an interface to an Inertial Measurement Unit.

**wsn** - The wsn proxy provides an interface to a Wireless Sensor Network.
