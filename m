From: Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 2/5] Documentation/ABI: Add file describing the sysfs
 entries for toshiba_acpi
Date: Wed, 11 Feb 2015 21:38:07 -0800
Message-ID: <20150212053807.GD30527@fury.dvhart.com>
References: <1423637040-6813-1-git-send-email-coproscefalo@gmail.com>
 <1423637040-6813-3-git-send-email-coproscefalo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1423637040-6813-3-git-send-email-coproscefalo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Azael Avalos <coproscefalo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: platform-driver-x86-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Feb 10, 2015 at 11:43:57PM -0700, Azael Avalos wrote:
> This patch adds a new file describing the sysfs entries for the
> toshiba_acpi driver.
> 

+linux-api list

I've queued this for 3.20 through platform-drivers-x86. Any objections?


> Signed-off-by: Azael Avalos <coproscefalo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  .../ABI/testing/sysfs-driver-toshiba_acpi          | 114 +++++++++++++++++++++
>  1 file changed, 114 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-driver-toshiba_acpi
> 
> diff --git a/Documentation/ABI/testing/sysfs-driver-toshiba_acpi b/Documentation/ABI/testing/sysfs-driver-toshiba_acpi
> new file mode 100644
> index 0000000..ca9c71a
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-driver-toshiba_acpi
> @@ -0,0 +1,114 @@
> +What:		/sys/devices/LNXSYSTM:00/LNXSYBUS:00/TOS{1900,620{0,7,8}}:00/kbd_backlight_mode
> +Date:		June 8, 2014
> +KernelVersion:	3.15
> +Contact:	Azael Avalos <coproscefalo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> +Description:	This file controls the keyboard backlight operation mode, valid
> +		values are:
> +			* 0x1  -> FN-Z
> +			* 0x2  -> AUTO (also called TIMER)
> +			* 0x8  -> ON
> +			* 0x10 -> OFF
> +		Note that the kernel 3.16 onwards this file accepts all listed
> +		parameters, kernel 3.15 only accepts the first two (FN-Z and
> +		AUTO).
> +Users:		KToshiba
> +
> +What:		/sys/devices/LNXSYSTM:00/LNXSYBUS:00/TOS{1900,620{0,7,8}}:00/kbd_backlight_timeout
> +Date:		June 8, 2014
> +KernelVersion:	3.15
> +Contact:	Azael Avalos <coproscefalo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> +Description:	This file controls the timeout of the keyboard backlight
> +		whenever the operation mode is set to AUTO (or TIMER),
> +		valid values range from 0-60.
> +		Note that the kernel 3.15 only had support for the first
> +		keyboard type, the kernel 3.16 added support for the second
> +		type and the range accepted for type 2 is 1-60.
> +		See the entry named "kbd_type"
> +Users:		KToshiba
> +
> +What:		/sys/devices/LNXSYSTM:00/LNXSYBUS:00/TOS{1900,620{0,7,8}}:00/position
> +Date:		June 8, 2014
> +KernelVersion:	3.15
> +Contact:	Azael Avalos <coproscefalo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> +Description:	This file shows the absolute position of the built-in
> +		accelereometer.
> +
> +What:		/sys/devices/LNXSYSTM:00/LNXSYBUS:00/TOS{1900,620{0,7,8}}:00/touchpad
> +Date:		June 8, 2014
> +KernelVersion:	3.15
> +Contact:	Azael Avalos <coproscefalo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> +Description:	This files controls the status of the touchpad and pointing
> +		stick (if available), valid values are:
> +			* 0 -> OFF
> +			* 1 -> ON
> +Users:		KToshiba
> +
> +What:		/sys/devices/LNXSYSTM:00/LNXSYBUS:00/TOS{1900,620{0,7,8}}:00/available_kbd_modes
> +Date:		August 3, 2014
> +KernelVersion:	3.16
> +Contact:	Azael Avalos <coproscefalo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> +Description:	This file shows the supported keyboard backlight modes
> +		the system supports, which can be:
> +			* 0x1  -> FN-Z
> +			* 0x2  -> AUTO (also called TIMER)
> +			* 0x8  -> ON
> +			* 0x10 -> OFF
> +		Note that not all keyboard types support the listed modes.
> +		See the entry named "available_kbd_modes"
> +Users:		KToshiba
> +
> +What:		/sys/devices/LNXSYSTM:00/LNXSYBUS:00/TOS{1900,620{0,7,8}}:00/kbd_type
> +Date:		August 3, 2014
> +KernelVersion:	3.16
> +Contact:	Azael Avalos <coproscefalo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> +Description:	This file shows the current keyboard backlight type,
> +		which can be:
> +			* 1 -> Type 1, supporting modes FN-Z and AUTO
> +			* 2 -> Type 2, supporting modes TIMER, ON and OFF
> +Users:		KToshiba
> +
> +What:		/sys/devices/LNXSYSTM:00/LNXSYBUS:00/TOS{1900,620{0,7,8}}:00/version
> +Date:		February, 2015
> +KernelVersion:	3.20
> +Contact:	Azael Avalos <coproscefalo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> +Description:	This file shows the current version of the driver
> +
> +What:		/sys/devices/LNXSYSTM:00/LNXSYBUS:00/TOS{1900,620{0,7,8}}:00/fan
> +Date:		February, 2015
> +KernelVersion:	3.20
> +Contact:	Azael Avalos <coproscefalo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> +Description:	This file controls the state of the internal fan, valid
> +		values are:
> +			* 0 -> OFF
> +			* 1 -> ON
> +
> +What:		/sys/devices/LNXSYSTM:00/LNXSYBUS:00/TOS{1900,620{0,7,8}}:00/kbd_function_keys
> +Date:		February, 2015
> +KernelVersion:	3.20
> +Contact:	Azael Avalos <coproscefalo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> +Description:	This file controls the Special Functions (hotkeys) operation
> +		mode, valid values are:
> +			* 0 -> Normal Operation
> +			* 1 -> Special Functions
> +		In the "Normal Operation" mode, the F{1-12} keys are as usual
> +		and the hotkeys are accessed via FN-F{1-12}.
> +		In the "Special Functions" mode, the F{1-12} keys trigger the
> +		hotkey and the F{1-12} keys are accessed via FN-F{1-12}.
> +
> +What:		/sys/devices/LNXSYSTM:00/LNXSYBUS:00/TOS{1900,620{0,7,8}}:00/panel_power_on
> +Date:		February, 2015
> +KernelVersion:	3.20
> +Contact:	Azael Avalos <coproscefalo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> +Description:	This file controls whether the laptop should turn ON whenever
> +		the LID is opened, valid values are:
> +			* 0 -> Disabled
> +			* 1 -> Enabled
> +
> +What:		/sys/devices/LNXSYSTM:00/LNXSYBUS:00/TOS{1900,620{0,7,8}}:00/usb_three
> +Date:		February, 2015
> +KernelVersion:	3.20
> +Contact:	Azael Avalos <coproscefalo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> +Description:	This file controls whether the USB 3 functionality, valid
> +		values are:
> +			* 0 -> Disabled (Acts as a regular USB 2)
> +			* 1 -> Enabled (Full USB 3 functionality)
> -- 
> 2.2.2
> 
> 

-- 
Darren Hart
Intel Open Source Technology Center
