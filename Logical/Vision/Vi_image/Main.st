PROGRAM _INIT
	// This sample-task loads the image from a camera and shows it on a Paper-Widget in mappView
	// A sample with much more functions can also be found here (branch "basic"): https://github.com/br-automation-com/mappVision-Demo/blob/basic/Logical/Vision/Vi_image/Main.st
	
	// Calculation of buffer-sizes
	// Max image size: 5MP sensor resolution is 2592x2048 Pixel --> 5.308.416 raw Pixels + ~10.000 Byte Overhead --> 5.320.000 Bytes
	// Base 64 is alwas 1/3 bigger: 7.078.000 Bytes
	// The SVG Header is again bigger --> 7.080.000 Bytes
	// Notes:
		// Linesensor: The image could be bigger, depending on used number of lines
		// A jpg-image is compressed, so the buffer can be much smaller. See AS Help.
		// The here saved image with default values (1,3MP, jpg with 80% quality) needs about 350.000 Bytes (0,35 MB)
		
	// Note: Adapt the constants "IMG_PIXEL_WIDTH/HEIGHT" to the cameras resolutin
END_PROGRAM
PROGRAM _CYCLIC
	CASE Step OF
	
		0: // Wait
			IF CmdShowImageMappView THEN
				CmdShowImageMappView := FALSE;
				ViBaseGetImage_0(Execute := FALSE);
				httpEncodeBase64_0(enable := FALSE);
				// Delete buffers, because of the compressed image (jpg) could be smaller than the last loaded image
				brsmemset(ADR(BufferForBinaryImageData), 0, SIZEOF(BufferForBinaryImageData));
				brsmemset(ADR(BufferForBase64EncodedImageData), 0, SIZEOF(BufferForBase64EncodedImageData));
				brsmemset(ADR(BufferForSvgCameraImage), 0, SIZEOF(BufferForSvgCameraImage));
				Step := 10;
			ELSIF CmdSaveFile THEN
				CmdSaveFile := FALSE;
				Step := 20;
			END_IF
		10:  // Load image from camera into variable (internal buffer)
			ViBaseGetImage_0.MpLink := ADR(VCMyCam);
			ViBaseGetImage_0.Execute := TRUE;
			ViBaseGetImage_0.Type := viBASE_IMAGE_TYPE_JPG; // For mappView the compressed jpg is besser for reduced image size
			ViBaseGetImage_0.QualityLevel := 80; // Image is still very good for mappView, but the size is reduced by about 70%
			ViBaseGetImage_0.Timeout := T#5s;
			ViBaseGetImage_0.Buffer := ADR(BufferForBinaryImageData);
			ViBaseGetImage_0.BufferSize := SIZEOF(BufferForBinaryImageData);
			ViBaseGetImage_0();
			IF ViBaseGetImage_0.Done THEN
					Step := 11;
			ELSIF ViBaseGetImage_0.Error THEN
				Status := ViBaseGetImage_0.StatusID;
				IF ViBaseGetImage_0.StatusID = viBASE_ERR_NO_IMG_AVAILABLE THEN // No image --> could happen after startup before first trigger.
					Step := 0;
				ELSE
					Status := ViBaseGetImage_0.StatusID;
					Step := 100;
				END_IF
			END_IF
		11: // Transform image from binary-data to ASCII-data for SVG
			httpEncodeBase64_0.enable := TRUE;
			httpEncodeBase64_0.pSrc := ADR(BufferForBinaryImageData);
			httpEncodeBase64_0.srcLen := ViBaseGetImage_0.BufferLen; // Use the exact length of the image, not the whole buffer
			httpEncodeBase64_0.pDest := ADR(BufferForBase64EncodedImageData);
			httpEncodeBase64_0.destSize := SIZEOF(BufferForBase64EncodedImageData);
			httpEncodeBase64_0();
			IF httpEncodeBase64_0.status = 0 THEN
				Step := 12;
			ELSIF httpEncodeBase64_0.status <> ERR_FUB_BUSY THEN
				Status := httpEncodeBase64_0.status;
				Step := 100;
			END_IF
		12:	
			BufferForSvgCameraImage := '<svg xmlns="http://www.w3.org/2000/svg" width="1280px" height="1024px" viewBox="0 0 ';	
			brsitoa(IMG_PIXEL_WIDTH, ADR(tmpStr));
			brsstrcat(ADR(BufferForSvgCameraImage), ADR(tmpStr));
			brsstrcat(ADR(BufferForSvgCameraImage), ADR(' '));
			brsitoa(IMG_PIXEL_HEIGHT, ADR(tmpStr));
			brsstrcat(ADR(BufferForSvgCameraImage), ADR(tmpStr));
			brsstrcat(ADR(BufferForSvgCameraImage), ADR('" xmlns:xlink="http://www.w3.org/1999/xlink"><image xlink:href="data:image/'));
			brsstrcat(ADR(BufferForSvgCameraImage), ADR('jpeg'));
			brsstrcat(ADR(BufferForSvgCameraImage), ADR(';base64,'));
			brsstrcat(ADR(BufferForSvgCameraImage), ADR(BufferForBase64EncodedImageData));
			brsstrcat(ADR(BufferForSvgCameraImage), ADR('"/>'));
			brsstrcat(ADR(BufferForSvgCameraImage), ADR('</svg>'));
			Step := 0;
		
		// Save svg or jpg file, also bmp is possible
		20:
			FileDelete_0.enable := TRUE;
			FileDelete_0.pDevice := ADR('CF');
			FileDelete_0.pName := ADR('Image.jpg'); // Choose: Save the jpg-file
			//FileDelete_0.pName := ADR('Image.svg'); // Choose: Save the svg-file
			FileDelete_0();
			IF FileDelete_0.status = 0 OR FileDelete_0.status = fiERR_FILE_NOT_FOUND THEN
				Step := 21;
			ELSIF FileDelete_0.status <> ERR_FUB_BUSY THEN
				Status := FileDelete_0.status;
				Step := 100;
			END_IF
		21:
			FileCreate_0.enable := TRUE;
			FileCreate_0.pDevice := FileDelete_0.pDevice;
			FileCreate_0.pFile := FileDelete_0.pName;
			FileCreate_0();
			IF FileCreate_0.status = 0 THEN
				Step := 22;
			ELSIF FileCreate_0.status <> ERR_FUB_BUSY THEN
				Status := FileCreate_0.status;
				Step := 100;
			END_IF
		22:
			FileWrite_0.enable := TRUE;
			FileWrite_0.ident := FileCreate_0.ident;
			FileWrite_0.pSrc := ADR(BufferForBinaryImageData); // Choose: Save the jpg-file
			FileWrite_0.len := ViBaseGetImage_0.BufferLen; // Choose: Save the jpg-file
			//FileWrite_0.pSrc := ADR(BufferForSvgCameraImage); // Choose: Save the svg-file
			//FileWrite_0.len := brsstrlen(ADR(BufferForSvgCameraImage)); // Choose: Save the scg-file
			FileWrite_0();
			IF FileWrite_0.status = 0 THEN
				Step := 23;
			ELSIF FileWrite_0.status <> ERR_FUB_BUSY THEN
				Status := FileWrite_0.status;
				Step := 100;
			END_IF
		23:
			FileClose_0.enable := TRUE;
			FileClose_0.ident := FileCreate_0.ident;
			FileClose_0();
			IF FileClose_0.status = 0 THEN
				Step := 0;
			ELSIF FileClose_0.status <> ERR_FUB_BUSY THEN
				Status := FileClose_0.status;
				Step := 0;
			END_IF

		100: // Error
			// ToDo: Implement some errorhandling here
	END_CASE
END_PROGRAM