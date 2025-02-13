(*Camera*)

TYPE
	VisionCtrlType : 	STRUCT 
		Cmd : VisionCtrlCmdType;
		Parameters : VisionCtrlParType;
		Status : VisionCtrlStatusType;
	END_STRUCT;
	VisionCtrlCmdType : 	STRUCT 
		AcquireImage : BOOL;
		SearchAcquisitionSettings : BOOL;
		EnableVisionFunction : BOOL;
	END_STRUCT;
	VisionCtrlParType : 	STRUCT 
		SetFocus : UINT;
		ExposureTime : UDINT;
		SetNettime : DINT;
		FlashColor : USINT;
		FlashSegment : USINT;
	END_STRUCT;
	VisionCtrlStatusType : 	STRUCT 
		CameraReady : BOOL;
		ImageProcessingActive : BOOL;
		AcceptedAcquisitionCnt : USINT;
		CompletedAcquisitionCnt : USINT;
	END_STRUCT;
END_TYPE

(**)
(*Light*)

TYPE
	LightCtrlType : 	STRUCT 
		Cmd : LightCtrlCmdType;
		Parameters : LightCtrlParType;
		Status : LightCtrlStatusType;
	END_STRUCT;
	LightCtrlCmdType : 	STRUCT 
		FlashTrigger : BOOL;
	END_STRUCT;
	LightCtrlParType : 	STRUCT 
		SetNettime : DINT;
		ExposureTime : UDINT;
		FlashColor : USINT;
		SetAngle : UINT;
	END_STRUCT;
	LightCtrlStatusType : 	STRUCT 
		LightReady : BOOL;
	END_STRUCT;
END_TYPE
