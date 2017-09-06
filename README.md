R502
======

R502 have two model, one sigle contactless reader and another one is dual interface (contact + contactless), for more information, please check feitian website:

	http://ftsafe.com/products/reader/Contactless
	http://ftsafe.com/products/reader/Dual_Interface

The PCSC sample code also can found in below link:
	https://github.com/FeitianSmartcardReader/R301/tree/master/Sample%20Code

Product Overview
==
R502 is a dual-interface smart card reader developed by Feitian Technologies. It is based on CCID driver. It supports not only contact cards compliant with ISO 7816 but also contactless cards compliant with ISO 14443 and contactless cards following Mifare standard. It also provides SIM card slots for many kinds of smart card applications. Moreover R502 comes with the SAM slot suitable for GSM 11.11 cards.

R502 is a terminal interface device for smart card applications and system integrations. With support for smart cards using different interfaces, R502 can be widely used in industries or applications requiring electronic payment and authentication, especially suitable for the high security fields. It is an optimal solution for authentication, e-commerce, financial organizations, access control etc.

Hardware configuration
==
To help users have better experience for using R502, we provided lights for R502 product. The light will help customer to understand the reader status and to save time to easy use.
We provided three indicators (Red/Blue/Green) to inform the status of reader. It included below status of reader (USB data transfer/contact card/contactless card working status)

	USB data transfer – red color
		No		explanation				 Status
		1	  USB enumerating 				1Hz flashing
		2	  USB enumerated				 Turn on
		3	  Firmware checksum failure		4Hz flashing
	
	Contact card – Blue color
		No		explanation				 Status
		1	    No card 					Turn off
		2	  Card inserted					Turn on
		3	  Data transfer 				flashing

	Contactless card－Green color
		No		explanation				Status
		1	    No card 					Turn off
		2	  Card inserted					Turn on
		3	  Data transfer 				flashing



Features
==
	Full speed USB 2.0 standard, also can do OEM RS 232 and DB-9 interface
	Power supply by USB, the usb interface must be provided 120mA current when insert card
	The maximum current less than 100mA (no smartcard insert)
	Accordance with CCID standard to do develop
	Contact card：
		Support 1x full size card
		Support T0 and T1, in accordance with ISO 7816
		The card clock frequency 4MHz
		Support Class A, B, C, AB, BC, ABC
		Smart card communication speed: 10753bps – 344086bps
		Card slot: ISO/IEC standard using 8 contacts, 100,000 plug time
		Support 1x GSM11.11 standard SIM card
	Contactless card:
		Build-in antenna
		Accordance with ISO/IEC 14443 (A and B) standard
		Support Mifare S50/S70/Ultralight C cards
		Operating distance (0-30mm), Mifare card(0-45mm), it depends on cards
		Card clock Frequency: 13.56MHz
		Smart card communication speed: 106kbps
	Open UID(User ID) function
	Support upgrade firmware (encrypted)

	OS: 
		Windows 2000/XP/2003/Vista/2008/7/8/10
		Linux Kernel 2.6+ (FC14 X64，ubuntu9.10，ubuntu10.04，ubuntu11.10，openSUSE11.3 X64)
		Mac OS X (10.6+)
Driver
==

	For Windows 7/8/8.1/10, driver already integrated into Windows system, except for Windows XP
	For Windows XP, driver is below:
	http://download.ftsafe.com/files/iReader/WinXp_ccid_Driver.zip

	For Linux and Mac platform:
	The R502 CL and Dual already added into CCID support list. Please using latest CCID driver or CCID(1.4.21+), 
	the driver link is http://pcsclite.alioth.debian.org/ccid.html
	
Support
==
	Any questions, please contact hongbin@ftsafe.com, thanks
FAQ
==
	Read UID through R502
	Some customer wants read UID from CPU card, to support this, please follow below step:
	
	Please make sure your reader firmware, we had two R502 hardware, R502 and R502B, the R502B is new hardware 
	which follow PCSC standard implement, it has best compitable with PCSC standard, and in future, we will only 
	sale this mode. 
	
	The R502 latest firmware is 1.67, if you want reader support get UID, please update your firmware to 1.67, 
	the update tool can find in Tool folder.
	
	To distinguish both of them, you can through check firmware version, the R502 version start from 1.xx, 
	and R502B firmware version start from 3.xx, so if your reader is 3.47, we suggestion you can update to 3.50, 
	then you can using get UID command
	
	Check firmware version through device manager, check below:
	Insert reader and open "device manager", find "Smart card readers", choose
	"Microsoft USBccid Smartcard Reader (WUDF)", right click, switch "Details" section, choose "Property", 
	select "Hardware Ids", you will find the right version, which is REV_0347&M1 something.
