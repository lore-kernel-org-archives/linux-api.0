From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [RFC] Input: Add ps2emu module
Date: Tue, 21 Jul 2015 12:16:06 -0700
Message-ID: <20150721191606.GC21710@kroah.com>
References: <1437505634-8633-1-git-send-email-cpaul@redhat.com>
 <1437505634-8633-2-git-send-email-cpaul@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1437505634-8633-2-git-send-email-cpaul@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Chandler Paul <cpaul@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>, Vishnu Patekar <vishnupatekar0510@gmail.com>, Sebastian Ott <sebott@linux.vnet.ibm.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-input@vger.kernel.org, linux-api@vger.kernel.org, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Hans de Goede <hdegoede@redhat.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 21, 2015 at 03:07:14PM -0400, Stephen Chandler Paul wrote:
> Debugging input devices, specifically laptop touchpads, can be tricky
> without having the physical device handy. Here we try to remedy that
> with ps2emu. This module allows an application to connect to a character
> device provided by the kernel, and simulate any PS/2 device. In
> combination with userspace programs that can record PS/2 devices and
> replay them through the /dev/ps2emu device, this allows developers to
> debug driver issues on the PS/2 level with devices simply by requesting
> a recording from the user experiencing the issue without having to have
> the physical hardware in front of them.
> 
> Signed-off-by: Stephen Chandler Paul <cpaul@redhat.com>
> Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>  Documentation/input/ps2emu.txt |  72 ++++++++++++
>  MAINTAINERS                    |   6 +
>  drivers/input/serio/Kconfig    |  10 ++
>  drivers/input/serio/Makefile   |   1 +
>  drivers/input/serio/ps2emu.c   | 253 +++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/ps2emu.h    |  42 +++++++
>  6 files changed, 384 insertions(+)
>  create mode 100644 Documentation/input/ps2emu.txt
>  create mode 100644 drivers/input/serio/ps2emu.c
>  create mode 100644 include/uapi/linux/ps2emu.h
> 
> diff --git a/Documentation/input/ps2emu.txt b/Documentation/input/ps2emu.txt
> new file mode 100644
> index 0000000..560298c
> --- /dev/null
> +++ b/Documentation/input/ps2emu.txt
> @@ -0,0 +1,72 @@
> +			      The ps2emu Protocol
> +	     (c) 2015 Stephen Chandler Paul <thatslyude@gmail.com>
> +			      Sponsored by Red Hat
> +--------------------------------------------------------------------------------
> +
> +1. Introduction
> +~~~~~~~~~~~~~~~
> +  This module is intended to try to make the lives of input driver developers
> +easier by allowing them to test various PS/2 devices (mainly the various
> +touchpads found on laptops) without having to have the physical device in front
> +of them. ps2emu accomplishes this by allowing any privileged userspace program
> +to directly interact with the kernel's serio driver and pretend to be a PS/2
> +device.
> +
> +2. Usage overview
> +~~~~~~~~~~~~~~~~~
> +  In order to interact with the ps2emu kernel module, one simply opens the
> +/dev/ps2emu character device in their applications. Commands are sent to the
> +kernel module by writing to the device, and any data received from the serio
> +driver is read as-is from the /dev/ps2emu device. All of the structures and
> +macros you need to interact with the device are defined in <linux/ps2emu.h>.
> +
> +3. Command Structure
> +~~~~~~~~~~~~~~~~~~~~
> +  The struct used for sending commands to /dev/ps2emu is as follows:
> +
> +	struct ps2emu_cmd {
> +		__u8 type;
> +		__u8 data;
> +	};
> +
> +  "type" describes the type of command that is being sent. This can be any one
> +of the PS2EMU_CMD macros defined in <linux/ps2emu.h>. "data" is the argument
> +that goes along with the command. In the event that the command doesn't have an
> +argument, this field can be left untouched and will be ignored by the kernel.
> +Each command should be sent by writing the struct directly to the character
> +device. In the event that the command you send is invalid, an error will be
> +returned by the character device and a more descriptive error will be printed
> +to the kernel log. Only one command can be sent at a time, any additional data
> +written to the character device after the initial command will be ignored.
> +  To close the virtual PS/2 port, just close /dev/ps2emu.
> +
> +4. Commands
> +~~~~~~~~~~~
> +
> +4.1 PS2EMU_CMD_REGISTER
> +~~~~~~~~~~~~~~~~~~~~~~~
> +  Registers the port with the serio driver and begins transmitting data back and
> +forth. Registration can only be performed once a port type is set with
> +PS2EMU_CMD_SET_PORT_TYPE. Has no argument.
> +
> +4.2 PS2EMU_CMD_SET_PORT_TYPE
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +  Sets the type of port we're emulating, where "data" is the port type being
> +set. Can be any of the following macros from <linux/serio.h>:
> +
> +	SERIO_8042
> +	SERIO_8042_XL
> +	SERIO_PS_PSTHRU
> +
> +4.3 PS2EMU_CMD_SEND_INTERRUPT
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +  Sends an interrupt through the virtual PS/2 port to the serio driver, where
> +"data" is the interrupt data being sent.
> +
> +5. Userspace tools
> +~~~~~~~~~~~~~~~~~~
> +  The ps2emu userspace tools are able to record PS/2 devices using some of the
> +debugging information from i8042, and play back the devices on /dev/ps2emu. The
> +latest version of these tools can be found at:
> +
> +	https://github.com/Lyude/ps2emu
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a226416..68a0977 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10877,6 +10877,12 @@ S:	Maintained
>  F:	drivers/media/v4l2-core/videobuf2-*
>  F:	include/media/videobuf2-*
>  
> +VIRTUAL PS/2 DEVICE DRIVER
> +M:	Stephen Chandler Paul <thatslyude@gmail.com>
> +S:	Maintained
> +F:	drivers/input/serio/ps2emu.c
> +F:	include/uapi/linux/ps2emu.h
> +
>  VIRTIO CONSOLE DRIVER
>  M:	Amit Shah <amit.shah@redhat.com>
>  L:	virtualization@lists.linux-foundation.org
> diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
> index 200841b..cc3563f 100644
> --- a/drivers/input/serio/Kconfig
> +++ b/drivers/input/serio/Kconfig
> @@ -292,4 +292,14 @@ config SERIO_SUN4I_PS2
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called sun4i-ps2.
>  
> +config PS2EMU
> +	tristate "Virtual PS/2 device support"
> +	help
> +	  Say Y here if you want to emulate PS/2 devices using the ps2emu tools.
> +
> +	  To compile this driver as a module, choose M here: the module will be
> +	  called ps2emu.
> +
> +	  If you are unsure, say N.
> +
>  endif
> diff --git a/drivers/input/serio/Makefile b/drivers/input/serio/Makefile
> index c600089..7b20936 100644
> --- a/drivers/input/serio/Makefile
> +++ b/drivers/input/serio/Makefile
> @@ -30,3 +30,4 @@ obj-$(CONFIG_SERIO_APBPS2)	+= apbps2.o
>  obj-$(CONFIG_SERIO_OLPC_APSP)	+= olpc_apsp.o
>  obj-$(CONFIG_HYPERV_KEYBOARD)	+= hyperv-keyboard.o
>  obj-$(CONFIG_SERIO_SUN4I_PS2)	+= sun4i-ps2.o
> +obj-$(CONFIG_PS2EMU)		+= ps2emu.o
> diff --git a/drivers/input/serio/ps2emu.c b/drivers/input/serio/ps2emu.c
> new file mode 100644
> index 0000000..77b5ca8
> --- /dev/null
> +++ b/drivers/input/serio/ps2emu.c
> @@ -0,0 +1,253 @@
> +/*
> + * ps2emu kernel PS/2 device emulation module
> + * Copyright (C) 2015 Red Hat
> + * Copyright (C) 2015 Stephen Chandler Paul <thatslyude@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU Lesser General Public License as published by the
> + * Free Software Foundation; either version 2 of the License, or (at your
> + * option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
> + * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
> + * details.
> + */
> +#include <linux/circ_buf.h>
> +#include <linux/mutex.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/serio.h>
> +#include <linux/libps2.h>
> +#include <linux/slab.h>
> +#include <linux/fs.h>
> +#include <linux/miscdevice.h>
> +#include <linux/sched.h>
> +#include <linux/poll.h>
> +#include <uapi/linux/ps2emu.h>
> +
> +#define PS2EMU_NAME "ps2emu"
> +#define PS2EMU_MINOR MISC_DYNAMIC_MINOR

Don't redefine existing values like this, it makes it hard to review,
just use MISC_DYNAMIC_MINOR.

thanks,

greg k-h
