module Player
  PLAYERXDR_DEVADDR_SIZE  = 16
  PLAYERXDR_MSGHDR_SIZE = PLAYERXDR_DEVADDR_SIZE + 24
  # The player message types (see player.h)

  # A data message.  Such messages are asynchronously published from
  # devices, and are usually used to reflect some part of the device's
   
  PLAYER_MSGTYPE_DATA           = 1
   
  # A command message.  Such messages are asynchronously published to
  # devices, and are usually used to change some aspect of the device's
  # state.
  
  PLAYER_MSGTYPE_CMD            = 2

  # A request message.  Such messages are published synchronously to
  # devices, usually to get or set some aspect of the device's state that is
  # not available in data or command messages.  Every request message gets
  # a response message (either PLAYER_MSGTYPE_RESP_ACK or
  # PLAYER_MSGTYPE_RESP_NACK).
  
  PLAYER_MSGTYPE_REQ            = 3

  # A positive response message.  Such messages are published in response
  # to a PLAYER_MSGTYPE_REQ.  This message indicates that the underlying
  # driver received, interpreted, and processed the request.  Any requested
  #data is in the body of this response message.
   
  PLAYER_MSGTYPE_RESP_ACK       = 4

  # A synch message.  @todo Deprecate this message type? */
  PLAYER_MSGTYPE_SYNCH          = 5

  # A negative response message.  Such messages are published in response
  # to a PLAYER_MSGTYPE_REQ.  This messages indicates that the underlying
  # driver did not process the message.  Possible causes include: the
  # driver's message queue was full, the driver failed to interpret the
  # request, or the driver does not support the request. This message will
  #have no data in the body.
   
  PLAYER_MSGTYPE_RESP_NACK      = 6


  # The request subtypes (see player.h)

  PLAYER_PLAYER_REQ_DEVLIST     = 1
  PLAYER_PLAYER_REQ_DRIVERINFO  = 2
  PLAYER_PLAYER_REQ_DEV         = 3
  PLAYER_PLAYER_REQ_DATA        = 4
  PLAYER_PLAYER_REQ_DATAMODE    = 5
  PLAYER_PLAYER_REQ_DATAFREQ    = 6
  PLAYER_PLAYER_REQ_AUTH        = 7
  PLAYER_PLAYER_REQ_NAMESERVICE = 8
  PLAYER_PLAYER_REQ_IDENT       = 9
  PLAYER_PLAYER_REQ_ADD_REPLACE_RULE = 10


  PLAYER_NULL_CODE         = 256 # /dev/null analogue
  PLAYER_PLAYER_CODE       = 1   # the server itself
  PLAYER_POWER_CODE        = 2   # power subsystem
  PLAYER_GRIPPER_CODE      = 3   # gripper
  PLAYER_POSITION2D_CODE   = 4   # device that moves
  PLAYER_SONAR_CODE        = 5   # Ultra-sound range-finder
  PLAYER_LASER_CODE        = 6   # scanning range-finder
  PLAYER_BLOBFINDER_CODE   = 7   # visual blobfinder
  PLAYER_PTZ_CODE          = 8   # pan-tilt-zoom unit
  PLAYER_AUDIO_CODE        = 9   # audio system
  PLAYER_FIDUCIAL_CODE     = 10  # fiducial detector
  PLAYER_SPEECH_CODE       = 12  # speech I/O
  PLAYER_GPS_CODE          = 13  # GPS unit
  PLAYER_BUMPER_CODE       = 14  # bumper array
  PLAYER_TRUTH_CODE        = 15  # ground-truth (Stage)
  PLAYER_DIO_CODE          = 20  # digital I/O
  PLAYER_AIO_CODE          = 21  # analog I/O
  PLAYER_IR_CODE           = 22  # IR array
  PLAYER_WIFI_CODE         = 23  # wifi card status
  PLAYER_WAVEFORM_CODE     = 24  # fetch raw waveforms
  PLAYER_LOCALIZE_CODE     = 25  # localization
  PLAYER_MCOM_CODE         = 26  # multicoms
  PLAYER_SOUND_CODE        = 27  # sound file playback
  PLAYER_AUDIODSP_CODE     = 28  # audio dsp I/O
  PLAYER_AUDIOMIXER_CODE   = 29  # audio I/O
  PLAYER_POSITION3D_CODE   = 30  # 3-D position
  PLAYER_SIMULATION_CODE   = 31  # simulators
  PLAYER_SERVICE_ADV_CODE  = 32  # LAN advertisement
  PLAYER_BLINKENLIGHT_CODE = 33  # blinking lights
  PLAYER_NOMAD_CODE        = 34  # Nomad robot
  PLAYER_CAMERA_CODE       = 40  # camera device
  PLAYER_MAP_CODE          = 42  # get a map
  PLAYER_PLANNER_CODE      = 44  # 2D motion planner
  PLAYER_LOG_CODE          = 45  # log R/W control
  PLAYER_ENERGY_CODE       = 46  # energy charging
  PLAYER_JOYSTICK_CODE     = 49  # Joystick
  PLAYER_SPEECH_RECOGNITION_CODE = 50  # speech I/O
  PLAYER_OPAQUE_CODE       = 51  # user-defined messages
  PLAYER_POSITION1D_CODE   = 52  # 1-D position
  PLAYER_ACTARRAY_CODE     = 53  # Actuators array interface
  PLAYER_LIMB_CODE         = 54  # Limb interface
  PLAYER_GRAPHICS2D_CODE   = 55  # Graphics2D interface
  PLAYER_RFID_CODE         = 56  # RFID reader interface
  PLAYER_WSN_CODE          = 57  # WSN interface
  PLAYER_GRAPHICS3D_CODE   = 58  # Graphics3D interface
  PLAYER_HEALTH_CODE       = 59  # Statgrab Health interface
  PLAYER_IMU_CODE          = 60  # Inertial Measurement Unit
  PLAYER_POINTCLOUD3D_CODE = 61  # 3-D point cloud
  PLAYER_RANGER_CODE       = 62  # Generic range-finders array
  PLAYER_STEREO_CODE       = 65  # Stereo imagery



  # Device access mode: open.
  PLAYER_OPEN_MODE   = 1

  # Device access mode: close.
  PLAYER_CLOSE_MODE  = 2

  # Device access mode: error.
  PLAYER_ERROR_MODE  = 3


  # Data delivery modes

  # Data delivery mode: Send data from all subscribed devices all the time
  # (i.e. when it's ready on the server).
  PLAYER_DATAMODE_PUSH  = 1

  # Data delivery mode: Only on request, send data from all subscribed
  # devices. A PLAYER_MSGTYPE_SYNCH packet follows each set of data.
  # Request should be made automatically by client libraries when they
  # begin reading.
  PLAYER_DATAMODE_PULL  = 2


  # Generic constants

  # The largest possible message 
  PLAYER_MAX_MESSAGE_SIZE            = 8388608 # 8MB

  # Maximum length for a driver name 
  PLAYER_MAX_DRIVER_STRING_LEN     = 64

  # The maximum number of devices the server will support.
  PLAYER_MAX_DEVICES                 = 10

  # Default maximum length for a message queue
  PLAYER_MSGQUEUE_DEFAULT_MAXLEN     = 32

  # Length of string that is spit back as a banner on connection
  PLAYER_IDENT_STRLEN                = 32

  # Length of authentication
  PLAYER_KEYLEN                      = 32

  # Maximum size for request/reply.
  # this is a convenience so that the PlayerQueue can used fixed size elements.
  PLAYER_MAX_REQREP_SIZE = 4096 # 4KB 


  # Interface-specific constants

  PLAYER_ACTARRAY_REQ_POWER         = 1
  PLAYER_ACTARRAY_REQ_BRAKES        = 2
  PLAYER_ACTARRAY_REQ_GET_GEOM      = 3
  PLAYER_ACTARRAY_REQ_SPEED         = 4
  PLAYER_ACTARRAY_REQ_ACCEL         = 5
  PLAYER_ACTARRAY_CMD_POS           = 1
  PLAYER_ACTARRAY_CMD_MULTI_POS     = 2
  PLAYER_ACTARRAY_CMD_SPEED         = 3
  PLAYER_ACTARRAY_CMD_MULTI_SPEED   = 4
  PLAYER_ACTARRAY_CMD_HOME          = 5
  PLAYER_ACTARRAY_CMD_CURRENT       = 6
  PLAYER_ACTARRAY_CMD_MULTI_CURRENT = 7
  PLAYER_ACTARRAY_DATA_STATE        = 1
  PLAYER_ACTARRAY_ACTSTATE_IDLE     = 1
  PLAYER_ACTARRAY_ACTSTATE_MOVING   = 2
  PLAYER_ACTARRAY_ACTSTATE_BRAKED   = 5
  PLAYER_ACTARRAY_ACTSTATE_STALLED  = 8
  PLAYER_ACTARRAY_TYPE_LINEAR       = 1
  PLAYER_ACTARRAY_TYPE_ROTARY       = 2

  PLAYER_AIO_MAX_INPUTS  = 8
  PLAYER_AIO_MAX_OUTPUTS = 8
  PLAYER_AIO_CMD_STATE   = 1
   PLAYER_AIO_DATA_STATE  = 1

  # Driver states 
  PLAYER_AUDIO_STATE_STOPPED      = 0x00
  PLAYER_AUDIO_STATE_PLAYING      = 0x01
  PLAYER_AUDIO_STATE_RECORDING    = 0x02

  # Audio formats

  # Raw Audio bit flags
  PLAYER_AUDIO_DESCRIPTION_BITS   = 0xFF
  PLAYER_AUDIO_BITS               = 0x03
  # 8 bit
  PLAYER_AUDIO_8BIT               = 0
  # 16 bit
  PLAYER_AUDIO_16BIT              = 1
  # 24 bit 
  PLAYER_AUDIO_24BIT              = 2
  # Mono
  PLAYER_AUDIO_MONO               = 0
  # Stereo
  PLAYER_AUDIO_STEREO             = 4
  # Frequency
  PLAYER_AUDIO_FREQ               = 18
  PLAYER_AUDIO_FREQ_44k           = 0
  PLAYER_AUDIO_FREQ_11k           = 8
  PLAYER_AUDIO_FREQ_22k           = 16
  PLAYER_AUDIO_FREQ_48k           = 24

  # AUDIO format */
  PLAYER_AUDIO_FORMAT_BITS        = 0xFF00

  PLAYER_AUDIO_FORMAT_NULL        = 0x0000
  PLAYER_AUDIO_FORMAT_RAW         = 0x0100
  PLAYER_AUDIO_FORMAT_MP3         = 0x0200
  PLAYER_AUDIO_FORMAT_OGG         = 0x0300
  PLAYER_AUDIO_FORMAT_FLAC        = 0x0400
  PLAYER_AUDIO_FORMAT_AAC         = 0x0500


  PLAYER_AUDIO_DATA_WAV_REC            = 1
  PLAYER_AUDIO_DATA_SEQ                = 2
  PLAYER_AUDIO_DATA_MIXER_CHANNEL      = 3
  PLAYER_AUDIO_DATA_STATE              = 4
  PLAYER_AUDIO_CMD_WAV_PLAY            = 1
  PLAYER_AUDIO_CMD_WAV_STREAM_REC      = 2
  PLAYER_AUDIO_CMD_SAMPLE_PLAY         = 3
  PLAYER_AUDIO_CMD_SEQ_PLAY            = 4
  PLAYER_AUDIO_CMD_MIXER_CHANNEL       = 5
  PLAYER_AUDIO_REQ_WAV_REC             = 1
  PLAYER_AUDIO_REQ_SAMPLE_LOAD         = 2
  PLAYER_AUDIO_REQ_SAMPLE_RETRIEVE     = 3
  PLAYER_AUDIO_REQ_SAMPLE_REC          = 4
  PLAYER_AUDIO_REQ_MIXER_CHANNEL_LIST  = 5
  PLAYER_AUDIO_REQ_MIXER_CHANNEL_LEVEL = 6



  PLAYER_AUDIO_DATA_BUFFER_SIZE    = 20
  PLAYER_AUDIO_COMMAND_BUFFER_SIZE = 6
  PLAYER_AUDIO_PAIRS               = 5

  PLAYER_AUDIODSP_MAX_FREQS         = 8
  PLAYER_AUDIODSP_MAX_BITSTRING_LEN = 64
  PLAYER_AUDIODSP_SET_CONFIG        = 1
  PLAYER_AUDIODSP_GET_CONFIG        = 2
  PLAYER_AUDIODSP_PLAY_TONE         = 1
  PLAYER_AUDIODSP_PLAY_CHIRP        = 2
  PLAYER_AUDIODSP_REPLAY            = 3
  PLAYER_AUDIODSP_DATA_TONES        = 1

  PLAYER_AUDIOMIXER_SET_MASTER = 1
  PLAYER_AUDIOMIXER_SET_PCM    = 2
  PLAYER_AUDIOMIXER_SET_LINE   = 3
  PLAYER_AUDIOMIXER_SET_MIC    = 4
  PLAYER_AUDIOMIXER_SET_IGAIN  = 5
  PLAYER_AUDIOMIXER_SET_OGAIN  = 6
  PLAYER_AUDIOMIXER_GET_LEVELS = 1

  PLAYER_WAVEFORM_DATA_MAX    = 4096
  PLAYER_WAVEFORM_DATA_SAMPLE = 1


  PLAYER_SOUND_CMD_IDX = 1



  PLAYER_BLINKENLIGHT_DATA_STATE    = 1
  PLAYER_BLINKENLIGHT_CMD_STATE     = 1
  PLAYER_BLINKENLIGHT_CMD_POWER     = 2
  PLAYER_BLINKENLIGHT_CMD_COLOR     = 3
  PLAYER_BLINKENLIGHT_CMD_PERIOD    = 4
  PLAYER_BLINKENLIGHT_CMD_DUTYCYCLE = 5

  PLAYER_BLOBFINDER_REQ_SET_COLOR         = 1
  PLAYER_BLOBFINDER_REQ_SET_IMAGER_PARAMS = 2
  PLAYER_BLOBFINDER_DATA_BLOBS            = 1

  PLAYER_BUMPER_REQ_GET_GEOM = 1
  PLAYER_BUMPER_DATA_STATE   = 1
  PLAYER_BUMPER_DATA_GEOM    = 2

  PLAYER_CAMERA_DATA_STATE     = 1
  PLAYER_CAMERA_REQ_GET_SOURCE = 1
  PLAYER_CAMERA_REQ_SET_SOURCE = 2
  PLAYER_CAMERA_REQ_GET_IMAGE  = 3
  PLAYER_CAMERA_FORMAT_MONO8   = 1
  PLAYER_CAMERA_FORMAT_MONO16  = 2
  PLAYER_CAMERA_FORMAT_RGB565  = 4
  PLAYER_CAMERA_FORMAT_RGB888  = 5
  PLAYER_CAMERA_COMPRESS_RAW   = 0
  PLAYER_CAMERA_COMPRESS_JPEG  = 1

  PLAYER_DIO_DATA_VALUES = 1
  PLAYER_DIO_CMD_VALUES  = 1

  PLAYER_ENERGY_DATA_STATE              = 1
  PLAYER_ENERGY_SET_CHARGING_POLICY_REQ = 1

  PLAYER_FIDUCIAL_MAX_SAMPLES  = 32
  PLAYER_FIDUCIAL_DATA_SCAN    = 1
  PLAYER_FIDUCIAL_REQ_GET_GEOM = 1
  PLAYER_FIDUCIAL_REQ_GET_FOV  = 2
  PLAYER_FIDUCIAL_REQ_SET_FOV  = 3
  PLAYER_FIDUCIAL_REQ_GET_ID   = 7
  PLAYER_FIDUCIAL_REQ_SET_ID   = 8

  PLAYER_GPS_DATA_STATE = 1

  PLAYER_GRIPPER_STATE_OPEN   = 1
  PLAYER_GRIPPER_STATE_CLOSED = 2
  PLAYER_GRIPPER_STATE_MOVING = 3
  PLAYER_GRIPPER_STATE_ERROR  = 4
  PLAYER_GRIPPER_DATA_STATE   = 1
  PLAYER_GRIPPER_REQ_GET_GEOM = 1
  PLAYER_GRIPPER_CMD_OPEN     = 1
  PLAYER_GRIPPER_CMD_CLOSE    = 2
  PLAYER_GRIPPER_CMD_STOP     = 3
  PLAYER_GRIPPER_CMD_STORE    = 4
  PLAYER_GRIPPER_CMD_RETRIEVE = 5

  PLAYER_IR_REQ_POSE    = 1
  PLAYER_IR_REQ_POWER   = 2
  PLAYER_IR_DATA_RANGES = 1

  PLAYER_JOYSTICK_X_AXIS     = 0
  PLAYER_JOYSTICK_Y_AXIS     = 1
  PLAYER_JOYSTICK_MAX_AXES   = 8
  PLAYER_JOYSTICK_DATA_STATE = 1

  PLAYER_LASER_MAX_SAMPLES    = 1024
  PLAYER_LASER_DATA_SCAN      = 1
  PLAYER_LASER_DATA_SCANPOSE  = 2
  PLAYER_LASER_REQ_GET_GEOM   = 1
  PLAYER_LASER_REQ_SET_CONFIG = 2
  PLAYER_LASER_REQ_GET_CONFIG = 3
  PLAYER_LASER_REQ_POWER      = 4

  PLAYER_LIMB_STATE_IDLE      = 1
  PLAYER_LIMB_STATE_BRAKED    = 2
  PLAYER_LIMB_STATE_MOVING    = 3
  PLAYER_LIMB_STATE_OOR       = 4
  PLAYER_LIMB_STATE_COLL      = 5
  PLAYER_LIMB_DATA_STATE      = 1
  PLAYER_LIMB_CMD_HOME        = 1
  PLAYER_LIMB_CMD_STOP        = 2
  PLAYER_LIMB_CMD_SETPOSE     = 3
  PLAYER_LIMB_CMD_SETPOSITION = 4
  PLAYER_LIMB_CMD_VECMOVE     = 5
  PLAYER_LIMB_REQ_POWER       = 1
  PLAYER_LIMB_REQ_BRAKES      = 2
  PLAYER_LIMB_REQ_GEOM        = 3
  PLAYER_LIMB_REQ_SPEED       = 4

  PLAYER_LOCALIZE_DATA_HYPOTHS      = 1
  PLAYER_LOCALIZE_REQ_SET_POSE      = 1
  PLAYER_LOCALIZE_REQ_GET_PARTICLES = 2
  PLAYER_LOG_TYPE_READ           = 1
  PLAYER_LOG_TYPE_WRITE          = 2
  PLAYER_LOG_REQ_SET_WRITE_STATE = 1
  PLAYER_LOG_REQ_SET_READ_STATE  = 2
  PLAYER_LOG_REQ_GET_STATE       = 3
  PLAYER_LOG_REQ_SET_READ_REWIND = 4
  PLAYER_LOG_REQ_SET_FILENAME    = 5
  PLAYER_MAP_DATA_INFO      = 1
  PLAYER_MAP_REQ_GET_INFO   = 1
  PLAYER_MAP_REQ_GET_DATA   = 2
  PLAYER_MAP_REQ_GET_VECTOR = 3
  MCOM_DATA_LEN            = 128
  MCOM_DATA_BUFFER_SIZE    = 0
  MCOM_N_BUFS              = 10
  MCOM_CHANNEL_LEN         = 8
  PLAYER_MCOM_PUSH         = 0
  PLAYER_MCOM_POP          = 1
  PLAYER_MCOM_READ         = 2
  PLAYER_MCOM_CLEAR        = 3
  PLAYER_MCOM_SET_CAPACITY = 4

  PLAYER_OPAQUE_DATA_STATE = 1
  PLAYER_OPAQUE_CMD_DATA   = 1
  PLAYER_OPAQUE_REQ_DATA   = 1

  PLAYER_PLANNER_DATA_STATE        = 1
  PLAYER_PLANNER_CMD_GOAL          = 1
  PLAYER_PLANNER_REQ_GET_WAYPOINTS = 1
  PLAYER_PLANNER_REQ_ENABLE        = 2
  PLAYER_POSITION1D_REQ_GET_GEOM      = 1
  PLAYER_POSITION1D_REQ_MOTOR_POWER   = 2
  PLAYER_POSITION1D_REQ_VELOCITY_MODE = 3
  PLAYER_POSITION1D_REQ_POSITION_MODE = 4
  PLAYER_POSITION1D_REQ_SET_ODOM      = 5
  PLAYER_POSITION1D_REQ_RESET_ODOM    = 6
  PLAYER_POSITION1D_REQ_SPEED_PID     = 7
  PLAYER_POSITION1D_REQ_POSITION_PID  = 8
  PLAYER_POSITION1D_REQ_SPEED_PROF    = 9
  PLAYER_POSITION1D_DATA_STATE        = 1
  PLAYER_POSITION1D_DATA_GEOM         = 2
  PLAYER_POSITION1D_CMD_VEL           = 1
  PLAYER_POSITION1D_CMD_POS           = 2
  # Status byte: limit min
  PLAYER_POSITION1D_STATUS_LIMIT_MIN  = 0
  # Status byte: limit center
  PLAYER_POSITION1D_STATUS_LIMIT_CEN  = 1
  # Status byte: limit max
  PLAYER_POSITION1D_STATUS_LIMIT_MAX  = 2
  # Status byte: limit over current
  PLAYER_POSITION1D_STATUS_OC         = 3
  # Status byte: limit trajectory complete
  PLAYER_POSITION1D_STATUS_TRAJ_COMPLETE = 4
  # Status byte: enabled
  PLAYER_POSITION1D_STATUS_ENABLED    = 5


  PLAYER_POSITION2D_REQ_GET_GEOM      = 1
  PLAYER_POSITION2D_REQ_MOTOR_POWER   = 2
  PLAYER_POSITION2D_REQ_VELOCITY_MODE = 3
  PLAYER_POSITION2D_REQ_POSITION_MODE = 4
  PLAYER_POSITION2D_REQ_SET_ODOM      = 5
  PLAYER_POSITION2D_REQ_RESET_ODOM    = 6
  PLAYER_POSITION2D_REQ_SPEED_PID     = 7
  PLAYER_POSITION2D_REQ_POSITION_PID  = 8
  PLAYER_POSITION2D_REQ_SPEED_PROF    = 9
  PLAYER_POSITION2D_DATA_STATE        = 1
  PLAYER_POSITION2D_DATA_GEOM         = 2
  PLAYER_POSITION2D_CMD_VEL           = 1
  PLAYER_POSITION2D_CMD_POS           = 2
  PLAYER_POSITION2D_CMD_CAR           = 3
  PLAYER_POSITION2D_CMD_VEL_HEAD      = 4

  PLAYER_POSITION3D_DATA_STATE    = 1
  PLAYER_POSITION3D_DATA_GEOMETRY = 2
  PLAYER_POSITION3D_CMD_SET_VEL   = 1
  PLAYER_POSITION3D_CMD_SET_POS   = 2
  PLAYER_POSITION3D_GET_GEOM      = 1
  PLAYER_POSITION3D_MOTOR_POWER   = 2
  PLAYER_POSITION3D_VELOCITY_MODE = 3
  PLAYER_POSITION3D_POSITION_MODE = 4
  PLAYER_POSITION3D_RESET_ODOM    = 5
  PLAYER_POSITION3D_SET_ODOM      = 6
  PLAYER_POSITION3D_SPEED_PID     = 7
  PLAYER_POSITION3D_POSITION_PID  = 8
  PLAYER_POSITION3D_SPEED_PROF    = 9

  PLAYER_POWER_DATA_STATE              = 1
  PLAYER_POWER_SET_CHARGING_POLICY_REQ = 1
  PLAYER_POWER_MASK_VOLTS              = 1
  PLAYER_POWER_MASK_WATTS              = 2
  PLAYER_POWER_MASK_JOULES             = 4
  PLAYER_POWER_MASK_PERCENT            = 8
  PLAYER_POWER_MASK_CHARGING           = 16

  PLAYER_PTZ_MAX_CONFIG_LEN   = 32
  PLAYER_PTZ_VELOCITY_CONTROL = 0
  PLAYER_PTZ_POSITION_CONTROL = 1
  PLAYER_PTZ_REQ_GENERIC      = 1
  PLAYER_PTZ_REQ_CONTROL_MODE = 2
  PLAYER_PTZ_REQ_GEOM         = 4
  PLAYER_PTZ_REQ_STATUS       = 5
  PLAYER_PTZ_DATA_STATE       = 1
  PLAYER_PTZ_DATA_GEOM        = 2
  PLAYER_PTZ_CMD_STATE        = 1

  PLAYER_RANGER_REQ_GET_GEOM   = 1
  PLAYER_RANGER_REQ_POWER      = 2
  PLAYER_RANGER_REQ_INTNS      = 3
  PLAYER_RANGER_REQ_SET_CONFIG = 4
  PLAYER_RANGER_REQ_GET_CONFIG = 5
  PLAYER_RANGER_DATA_RANGE     = 1
  PLAYER_RANGER_DATA_RANGESTAMPED = 2
  PLAYER_RANGER_DATA_INTNS     = 3
  PLAYER_RANGER_DATA_INTNSSTAMPED = 4
  PLAYER_RANGER_DATA_GEOM      = 5

  PLAYER_SIMULATION_IDENTIFIER_MAXLEN = 64
  PLAYER_SIMULATION_PROP_VALUE_MAXLEN = 64
  PLAYER_SIMULATION_REQ_GET_POSE2D    = 1
  PLAYER_SIMULATION_REQ_SET_POSE2D    = 2
  PLAYER_SIMULATION_REQ_GET_POSE3D    = 3
  PLAYER_SIMULATION_REQ_SET_POSE3D    = 4
  PLAYER_SIMULATION_REQ_GET_PROPERTY  = 5
  PLAYER_SIMULATION_REQ_SET_PROPERTY  = 6
  PLAYER_SIMULATION_CMD_PAUSE         = 1
  PLAYER_SIMULATION_CMD_RESET         = 2
  PLAYER_SIMULATION_CMD_SAVE          = 3

  PLAYER_SONAR_REQ_GET_GEOM = 1
  PLAYER_SONAR_REQ_POWER    = 2
  PLAYER_SONAR_DATA_RANGES  = 1
  PLAYER_SONAR_DATA_GEOM    = 2

  PLAYER_SPEECH_MAX_STRING_LEN = 256
  PLAYER_SPEECH_CMD_SAY        = 1

  SPEECH_RECOGNITION_TEXT_LEN    = 256
  SPEECH_RECOGNITION_DATA_STRING = 1

  PLAYER_STEREO_DATA_STATE      = 1

  PLAYER_TRUTH_DATA_POSE           = 0x01
  PLAYER_TRUTH_DATA_FIDUCIAL_ID    = 0x02
  PLAYER_TRUTH_REQ_SET_POSE        = 0x03
  PLAYER_TRUTH_REQ_SET_FIDUCIAL_ID = 0x04
  PLAYER_TRUTH_REQ_GET_FIDUCIAL_ID = 0x05

  PLAYER_WIFI_MAX_LINKS      = 32
  PLAYER_WIFI_QUAL_DBM       = 1
  PLAYER_WIFI_QUAL_REL       = 2
  PLAYER_WIFI_QUAL_UNKNOWN   = 3
  PLAYER_WIFI_MODE_UNKNOWN   = 0
  PLAYER_WIFI_MODE_AUTO      = 1
  PLAYER_WIFI_MODE_ADHOC     = 2
  PLAYER_WIFI_MODE_INFRA     = 3
  PLAYER_WIFI_MODE_MASTER    = 4
  PLAYER_WIFI_MODE_REPEAT    = 5
  PLAYER_WIFI_MODE_SECOND    = 6
  PLAYER_WIFI_REQ_MAC        = 1
  PLAYER_WIFI_REQ_IWSPY_ADD  = 2
  PLAYER_WIFI_REQ_IWSPY_DEL  = 3
  PLAYER_WIFI_REQ_IWSPY_PING = 4
  PLAYER_WIFI_DATA_STATE     = 1

  PLAYER_RFID_DATA_TAGS    = 1
  PLAYER_RFID_REQ_POWER    = 1
  PLAYER_RFID_REQ_READTAG  = 2
  PLAYER_RFID_REQ_WRITETAG = 3
  PLAYER_RFID_REQ_LOCKTAG  = 4

  # The maximum number of points that can be described in a packet
  PLAYER_GRAPHICS2D_MAX_POINTS   = 64
  # Command subtype: clear the drawing area (send an empty message)
  PLAYER_GRAPHICS2D_CMD_CLEAR    = 1
  # Command subtype: draw points
  PLAYER_GRAPHICS2D_CMD_POINTS   = 2
  # Command subtype: draw a polyline
  PLAYER_GRAPHICS2D_CMD_POLYLINE = 3
  # Command subtype: draw a polygon
  PLAYER_GRAPHICS2D_CMD_POLYGON  = 4

  # The maximum number of nodes that can work together in the WSN.
  PLAYER_WSN_MAX_NODES    = 100
  PLAYER_WSN_DATA_STATE   = 1
  PLAYER_WSN_CMD_DEVSTATE = 1

  # Request/reply: put the reader in sleep mode (0) or wake it up (1).
  PLAYER_WSN_REQ_POWER    = 1
  # Request/reply: change the data type to RAW or converted engineering units
  PLAYER_WSN_REQ_DATATYPE = 2
  # Request/reply: change the receiving data frequency
  PLAYER_WSN_REQ_DATAFREQ = 3

  # The maximum number of points that can be described in a packet
  PLAYER_GRAPHICS3D_MAX_POINTS = 1024
  # Command subtype: clear the drawing area (send an empty message)
  PLAYER_GRAPHICS3D_CMD_CLEAR  = 1
  # Command subtype: draw subitems
  PLAYER_GRAPHICS2D_CMD_DRAW   = 2

  # Data subtype: Health's data packet
  PLAYER_HEALTH_DATA_STATE = 1

  # Data subtype: IMU position/orientation data
  PLAYER_IMU_DATA_STATE            = 1
  # Data subtype: Calibrated IMU data
  PLAYER_IMU_DATA_CALIB            = 2
  # Data subtype: Quaternions orientation data
  PLAYER_IMU_DATA_QUAT             = 3
  # Data subtype: Euler orientation data
  PLAYER_IMU_DATA_EULER            = 4
  # Data subtype: All the calibrated IMU data
  PLAYER_IMU_DATA_FULLSTATE        = 5
  # Request/reply subtype: set data type
  PLAYER_IMU_REQ_SET_DATATYPE      = 1
  # Request/reply subtype: reset orientation
  PLAYER_IMU_REQ_RESET_ORIENTATION = 2

  # Maximum number of points that can be included in a data packet
  PLAYER_POINTCLOUD3D_MAX_POINTS = 8192
  # Data subtype: state
  PLAYER_POINTCLOUD3D_DATA_STATE = 1
end
