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
		Enable : BOOL;
	END_STRUCT;
	VisionCtrlParType : 	STRUCT 
		FlashColor : USINT;
		FlashSegment : USINT;
		SetFocus : UINT;
		ExposureTime : UDINT;
		SetNettime : DINT;
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
		SetAngle : UINT;
		ExposureTime : UDINT;
		FlashColor : USINT;
		SetNettime : DINT;
	END_STRUCT;
	LightCtrlStatusType : 	STRUCT 
		LightReady : BOOL;
	END_STRUCT;
END_TYPE
