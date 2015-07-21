From: Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC ebeam PATCH 2/2] input: misc: New USB eBeam input driver
Date: Tue, 21 Jul 2015 10:19:23 +0200
Message-ID: <1437466763.3823.1.camel@suse.com>
References: <1437426199-29866-1-git-send-email-yann.cantin@laposte.net>
	 <1437426199-29866-3-git-send-email-yann.cantin@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437426199-29866-3-git-send-email-yann.cantin-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Cantin <yann.cantin-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Cc: linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 2015-07-20 at 23:03 +0200, Yann Cantin wrote:
> Signed-off-by: Yann Cantin <yann.cantin-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
> ---
>  Documentation/ABI/testing/sysfs-driver-ebeam |  53 ++
>  drivers/input/misc/Kconfig                   |  22 +
>  drivers/input/misc/Makefile                  |   1 +
>  drivers/input/misc/ebeam.c                   | 777 +++++++++++++++++++++++++++
>  4 files changed, 853 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-driver-ebeam
>  create mode 100644 drivers/input/misc/ebeam.c
> 
> diff --git a/Documentation/ABI/testing/sysfs-driver-ebeam b/Documentation/ABI/testing/sysfs-driver-ebeam
> new file mode 100644
> index 0000000..6873db5
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-driver-ebeam
> @@ -0,0 +1,53 @@
> +What:		/sys/class/input/inputXX/device/min_x
> +		/sys/class/input/inputXX/device/min_y
> +		/sys/class/input/inputXX/device/max_x
> +		/sys/class/input/inputXX/device/max_y
> +Date:		Jul 2015
> +Kernel Version:	4.1
> +Contact:	yann.cantin-QFKgK+z4sOrR7s880joybQ@public.gmane.org
> +		linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> +Description:
> +		Reading from these files return the actually used range values of
> +		the reported coordinates.
> +		Writing to these files preset these range values.
> +		See below for the calibration procedure.
> +
> +What:		/sys/class/input/inputXX/device/h[1..9]
> +Date:		Jul 2015
> +Kernel Version:	4.1
> +Contact:	yann.cantin-QFKgK+z4sOrR7s880joybQ@public.gmane.org
> +		linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> +Description:
> +		Reading from these files return the 3x3 transformation matrix elements
> +		actually used, in row-major.
> +		Writing to these files preset these elements values.
> +		See below for the calibration procedure.
> +
> +What:		/sys/class/input/inputXX/device/calibrated
> +Date:		Jul 2015
> +Kernel Version:	4.1
> +Contact:	yann.cantin-QFKgK+z4sOrR7s880joybQ@public.gmane.org
> +		linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> +Description:
> +		Reading from this file :
> +		- Return 0 if the driver is in "un-calibrated" mode : it actually send
> +		  raw coordinates in the device's internal coordinates system.
> +		- Return 1 if the driver is in "calibrated" mode : it send computed coordinates
> +		  that (hopefully) matches the screen's coordinates system.
> +		Writing 1 to this file enable the "calibrated" mode, 0 reset the driver in
> +		"un-calibrated" mode.
> +
> +Calibration procedure :
> +
> +When loaded, the driver is in "un-calibrated" mode : it send device's raw coordinates
> +in the [0..65535]x[0..65535] range, the transformation matrix is the identity.
> +
> +A calibration program have to compute a homography transformation matrix that convert
> +the device's raw coordinates to the matching screen's ones.
> +It then write to the appropriate sysfs files the computed values, pre-setting the
> +driver's parameters : xy range, and the matrix's elements.
> +When all values are passed, it write 1 to the calibrated sysfs file to enable the "calibrated" mode.
> +
> +Warning : The parameters aren't used until 1 is writen to the calibrated sysfs file.
> +
> +Writing 0 to the calibrated sysfs file reset the driver in "un-calibrated" mode.
> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> index d4f0a81..22c46a4 100644
> --- a/drivers/input/misc/Kconfig
> +++ b/drivers/input/misc/Kconfig
> @@ -103,6 +103,28 @@ config INPUT_E3X0_BUTTON
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called e3x0_button.
>  
> +config INPUT_EBEAM_USB
> +	tristate "USB eBeam driver"
> +	depends on USB_ARCH_HAS_HCD
> +	select USB
> +	help
> +	  Say Y here if you have a USB eBeam pointing device and want to
> +	  use it without any proprietary user space tools.
> +
> +	  Have a look at <http://ebeam.tuxfamily.org/> for
> +	  a usage description and the required user-space tools.
> +
> +	  Supported devices :
> +	    - Luidia eBeam Classic Projection and eBeam Edge Projection
> +	    - Nec NP01Wi1 & NP01Wi2 interactive solution
> +
> +	  Supposed working devices, need test, may lack functionality :
> +	    - Luidia eBeam Edge Whiteboard and eBeam Engage
> +	    - Hitachi Starboard FX-63, FX-77, FX-82, FX-77GII
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called ebeam.
> +
>  config INPUT_PCSPKR
>  	tristate "PC Speaker support"
>  	depends on PCSPKR_PLATFORM
> diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
> index 53df07d..125f8a9 100644
> --- a/drivers/input/misc/Makefile
> +++ b/drivers/input/misc/Makefile
> @@ -28,6 +28,7 @@ obj-$(CONFIG_INPUT_DA9055_ONKEY)	+= da9055_onkey.o
>  obj-$(CONFIG_INPUT_DA9063_ONKEY)	+= da9063_onkey.o
>  obj-$(CONFIG_INPUT_DM355EVM)		+= dm355evm_keys.o
>  obj-$(CONFIG_INPUT_E3X0_BUTTON)		+= e3x0-button.o
> +obj-$(CONFIG_INPUT_EBEAM_USB)		+= ebeam.o
>  obj-$(CONFIG_INPUT_DRV260X_HAPTICS)	+= drv260x.o
>  obj-$(CONFIG_INPUT_DRV2665_HAPTICS)	+= drv2665.o
>  obj-$(CONFIG_INPUT_DRV2667_HAPTICS)	+= drv2667.o
> diff --git a/drivers/input/misc/ebeam.c b/drivers/input/misc/ebeam.c
> new file mode 100644
> index 0000000..79cac51
> --- /dev/null
> +++ b/drivers/input/misc/ebeam.c
> @@ -0,0 +1,777 @@
> +/******************************************************************************
> + *
> + * eBeam driver
> + *
> + * Copyright (C) 2012-2015 Yann Cantin (yann.cantin-QFKgK+z4sOrR7s880joybQ@public.gmane.org)
> + *
> + *	This program is free software; you can redistribute it and/or
> + *	modify it under the terms of the GNU General Public License as
> + *	published by the Free Software Foundation; either version 2 of the
> + *	License, or (at your option) any later version.
> + *
> + *  based on
> + *
> + *	usbtouchscreen.c by Daniel Ritz <daniel.ritz-OI3hZJvNYWs@public.gmane.org>
> + *	aiptek.c (sysfs/settings) by Chris Atenasio <chris-v4AJ0sPprEc@public.gmane.org>
> + *				     Bryan W. Headley <bwheadley-ihVZJaRskl1bRRN4PJnoQQ@public.gmane.org>
> + *
> + *****************************************************************************/
> +
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/math64.h>
> +#include <linux/input.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/usb.h>
> +#include <linux/usb/input.h>
> +#include <asm/unaligned.h>
> +
> +#define DRIVER_AUTHOR	"Yann Cantin <yann.cantin-QFKgK+z4sOrR7s880joybQ@public.gmane.org>"
> +#define DRIVER_DESC	"USB eBeam Driver"
> +
> +/* Common values for eBeam devices */
> +#define REPT_SIZE	8	/* packet size            */
> +#define MIN_RAW_X	0	/* raw coordinates ranges */
> +#define MAX_RAW_X	0xFFFF
> +#define MIN_RAW_Y	0
> +#define MAX_RAW_Y	0xFFFF
> +
> +/* Electronics For Imaging, Inc */
> +#define USB_VENDOR_ID_EFI	0x2650

You are defining these IDs twice. That is not good.

	Regards
		Oliver
