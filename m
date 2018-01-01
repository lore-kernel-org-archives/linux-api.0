From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] rtc: sysfs: move sysfs & ioctl interface to
 Documentation/ABI
Date: Mon, 1 Jan 2018 13:13:25 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1801011310020.2700@hadrien>
References: <20180101115726.GA4519@mordor.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180101115726.GA4519@mordor.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Aishwarya Pant <aishpant@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@free-electrons.com>, Jonathan Corbet <corbet@lwn.net>, linux-rtc@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>, gregkh@linuxfoundation.org
List-Id: linux-api@vger.kernel.org



On Mon, 1 Jan 2018, Aishwarya Pant wrote:

> Right now, the decription of the rtc and sysfs interfaces is in
> Documentation/rtc.txt. Since these are a part of the ABI, they should be
> in Documentation/ABI along with the rest.
>
> Signed-off-by: Aishwarya Pant <aishpant@gmail.com>
> ---
> Let me know if the contact information should be different. I picked up the
> module author of drivers/rtc/rtc-sysfs.c as the primary contact of the
> interfaces.
>
> Documentation/ABI/stable/rtc | 135 +++++++++++++++++++++++++++++++++++++++++++
>  Documentation/rtc.txt        |  80 +------------------------
>  2 files changed, 136 insertions(+), 79 deletions(-)
>  create mode 100644 Documentation/ABI/stable/rtc
>
> diff --git a/Documentation/ABI/stable/rtc b/Documentation/ABI/stable/rtc
> new file mode 100644
> index 000000000000..799003dfb86e
> --- /dev/null
> +++ b/Documentation/ABI/stable/rtc
> @@ -0,0 +1,135 @@
> +SYSFS interface
> +---------------
> +
> +The sysfs interface provides access to various
> +rtc attributes without requiring the use of ioctls. All dates and times
> +are in the RTC's timezone, rather than in system time.

The above paragraph could be formatted with lines of more even length.

> +
> +What:		/sys/class/rtc/rtc[0-*]/date
> +Date:		March 2006
> +KernelVersion:	2.6.17
> +Contact:	Alexandre Belloni <alexandre.belloni@free-electrons.com>
> +Description:	(RO) RTC-provided date
> +
> +What:		/sys/class/rtc/rtc[0-*]/name
> +Date:		March 2006
> +KernelVersion:	2.6.17
> +Contact:	Alexandre Belloni <alexandre.belloni@free-electrons.com>
> +Description:	(RO) The name of the RTC corresponding to this sysfs directory.

Things don't look quite aligned, which suggests that some things are done
with spaces and some things with tabs.

julia

> +
> +What:		/sys/class/rtc/rtc[0-*]/time
> +Date:		March 2006
> +KernelVersion:	2.6.17
> +Contact:	Alexandre Belloni <alexandre.belloni@free-electrons.com>
> +Description:	(RO) RTC-provided time
> +
> +What:		/sys/class/rtc/rtc[0-*]/since_epoch
> +Date:		March 2006
> +KernelVersion:	2.6.17
> +Contact:	Alexandre Belloni <alexandre.belloni@free-electrons.com>
> +Description:	(RO) The number of seconds since the epoch according to the RTC.
> +
> +What:		/sys/class/rtc/rtc[0-*]/wakealarm
> +Date:		February 2007
> +KernelVersion:	2.6.21
> +Contact:	Alexandre Belloni <alexandre.belloni@free-electrons.com>
> +Description:	(RW) The time at which the clock will generate a system wakeup
> +		 event. This is a one shot wakeup event, so must be reset
> +		 after wake if a daily wakeup is required. Format is seconds
> +		 since the epoch by default, or if there's a leading +, seconds
> +		 in the future, or if there is a leading +=, seconds ahead of
> +		 the current alarm.
> +
> +What:		/sys/class/rtc/rtc[0-*]/max_user_freq
> +Date:		October 2007
> +KernelVersion:	2.6.24
> +Contact:	Alexandre Belloni <alexandre.belloni@free-electrons.com>
> +Description:	(RW) The maximum interrupt rate an unprivileged user may request
> +		 from this RTC.
> +
> +What:		/sys/class/rtc/rtc[0-*]/hctosys
> +Date:		September 2009
> +KernelVersion:	2.6.32
> +Contact:	Alexandre Belloni <alexandre.belloni@free-electrons.com>
> +Description:	(RO) 1 if the RTC provided the system time at boot via the
> +		 CONFIG_RTC_HCTOSYS kernel option, 0 otherwise.
> +
> +What:		/sys/class/rtc/rtc[0-*]/offset
> +Date:		February 2016
> +KernelVersion:	4.6
> +Contact:	Alexandre Belloni <alexandre.belloni@free-electrons.com>
> +Description:	(RW) The amount which the rtc clock has been adjusted in firmware.
> +		 Visible only if the driver supports clock offset adjustment.
> +		 The unit is parts per billion, i.e. The number of clock ticks
> +		 which are added to or removed from the rtc's base clock per
> +		 billion ticks. A positive value makes a day pass more slowly,
> +		 longer, and a negative value makes a day pass more quickly.
> +
> +What:		/sys/bus/nvmem/devices/dev-name/nvmem
> +Date:		July 2017
> +KernelVersion:	4.13
> +Contact:	Alexandre Belloni <alexandre.belloni@free-electrons.com>
> +Description:	(RW) The non volatile storage exported as a raw file, as described
> +		 in Documentation/nvmem/nvmem.txt. The previous ABI
> +		 /sys/class/rtc/rtc[0-*]/device/nvram will be deprecated.
> +
> +IOCTL interface
> +---------------
> +
> +What:		/dev/rtc[0-*]
> +Date:		April 2005
> +KernelVersion:	2.6.12
> +Contact:	Alexandre Belloni <alexandre.belloni@free-electrons.com>
> +Description:	The ioctl() calls supported by /dev/rtc are also supported by
> +		the RTC class framework. However, because the chips and systems
> +		are not standardized, some PC/AT functionality might not be
> +		provided.  And in the same way, some newer features -- including
> +		those enabled by ACPI -- are exposed by the RTC class framework,
> +		but can't be supported by the older driver.
> +
> +		    *	RTC_RD_TIME, RTC_SET_TIME ... every RTC supports at
> +			least reading time, returning the result as a Gregorian
> +			calendar date and 24 hour wall clock time. To be most
> +			useful, this time may also be updated.
> +
> +		    *	RTC_AIE_ON, RTC_AIE_OFF, RTC_ALM_SET, RTC_ALM_READ ...
> +			when the RTC is connected to an IRQ line, it can often
> +			issue an alarm IRQ up to 24 hours in the future. (Use
> +			RTC_WKALM_* by preference.)
> +
> +		    *	RTC_WKALM_SET, RTC_WKALM_RD ... RTCs that can issue
> +			alarms beyond the next 24 hours use a slightly more
> +			powerful API, which supports setting the longer alarm
> +			time and enabling its IRQ using a single request (using
> +			the same model as EFI firmware).
> +
> +		    *	RTC_UIE_ON, RTC_UIE_OFF ... if the RTC offers IRQs, the
> +			RTC framework will emulate this mechanism.
> +
> +		    *	RTC_PIE_ON, RTC_PIE_OFF, RTC_IRQP_SET, RTC_IRQP_READ ...
> +		    	these icotls are emulated via a kernel hrtimer.
> +
> +		In many cases, the RTC alarm can be a system wake event, used to
> +		force Linux out of a low power sleep state (or hibernation) back
> +		to a fully operational state. For example, a system could enter
> +		a deep power saving state until it's time to execute some
> +		scheduled tasks.
> +
> +		Note that many of these ioctls are handled by the common rtc-dev
> +		interface. Some common examples:
> +
> +		    *	RTC_RD_TIME, RTC_SET_TIME: the read_time/set_time
> +		    	functions will be called with appropriate values.
> +
> +		    *	RTC_ALM_SET, RTC_ALM_READ, RTC_WKALM_SET, RTC_WKALM_RD:
> +			gets or sets the alarm rtc_timer. May call the set_alarm
> +			driver function.
> +
> +		    *	RTC_IRQP_SET, RTC_IRQP_READ: These are emulated by the
> +		    	generic code.
> +
> +		    *	RTC_PIE_ON, RTC_PIE_OFF: These are also emulated by the
> +		    	generic code.
> +
> +		If all else fails, check out the
> +		tools/testing/selftests/timers/rtctest.c test!
> diff --git a/Documentation/rtc.txt b/Documentation/rtc.txt
> index c0c977445fb9..a7890ca9a27e 100644
> --- a/Documentation/rtc.txt
> +++ b/Documentation/rtc.txt
> @@ -136,82 +136,4 @@ a high functionality RTC is integrated into the SOC.  That system might read
>  the system clock from the discrete RTC, but use the integrated one for all
>  other tasks, because of its greater functionality.
>
> -SYSFS interface
> ----------------
> -
> -The sysfs interface under /sys/class/rtc/rtcN provides access to various
> -rtc attributes without requiring the use of ioctls. All dates and times
> -are in the RTC's timezone, rather than in system time.
> -
> -================ ==============================================================
> -date  	   	 RTC-provided date
> -hctosys   	 1 if the RTC provided the system time at boot via the
> -		 CONFIG_RTC_HCTOSYS kernel option, 0 otherwise
> -max_user_freq	 The maximum interrupt rate an unprivileged user may request
> -		 from this RTC.
> -name		 The name of the RTC corresponding to this sysfs directory
> -since_epoch	 The number of seconds since the epoch according to the RTC
> -time		 RTC-provided time
> -wakealarm	 The time at which the clock will generate a system wakeup
> -		 event. This is a one shot wakeup event, so must be reset
> -		 after wake if a daily wakeup is required. Format is seconds
> -		 since the epoch by default, or if there's a leading +, seconds
> -		 in the future, or if there is a leading +=, seconds ahead of
> -		 the current alarm.
> -offset		 The amount which the rtc clock has been adjusted in firmware.
> -		 Visible only if the driver supports clock offset adjustment.
> -		 The unit is parts per billion, i.e. The number of clock ticks
> -		 which are added to or removed from the rtc's base clock per
> -		 billion ticks. A positive value makes a day pass more slowly,
> -		 longer, and a negative value makes a day pass more quickly.
> -*/nvmem		 The non volatile storage exported as a raw file, as described
> -		 in Documentation/nvmem/nvmem.txt
> -================ ==============================================================
> -
> -IOCTL interface
> ----------------
> -
> -The ioctl() calls supported by /dev/rtc are also supported by the RTC class
> -framework.  However, because the chips and systems are not standardized,
> -some PC/AT functionality might not be provided.  And in the same way, some
> -newer features -- including those enabled by ACPI -- are exposed by the
> -RTC class framework, but can't be supported by the older driver.
> -
> -    *	RTC_RD_TIME, RTC_SET_TIME ... every RTC supports at least reading
> -	time, returning the result as a Gregorian calendar date and 24 hour
> -	wall clock time.  To be most useful, this time may also be updated.
> -
> -    *	RTC_AIE_ON, RTC_AIE_OFF, RTC_ALM_SET, RTC_ALM_READ ... when the RTC
> -	is connected to an IRQ line, it can often issue an alarm IRQ up to
> -	24 hours in the future.  (Use RTC_WKALM_* by preference.)
> -
> -    *	RTC_WKALM_SET, RTC_WKALM_RD ... RTCs that can issue alarms beyond
> -	the next 24 hours use a slightly more powerful API, which supports
> -	setting the longer alarm time and enabling its IRQ using a single
> -	request (using the same model as EFI firmware).
> -
> -    *	RTC_UIE_ON, RTC_UIE_OFF ... if the RTC offers IRQs, the RTC framework
> -	will emulate this mechanism.
> -
> -    *	RTC_PIE_ON, RTC_PIE_OFF, RTC_IRQP_SET, RTC_IRQP_READ ... these icotls
> -	are emulated via a kernel hrtimer.
> -
> -In many cases, the RTC alarm can be a system wake event, used to force
> -Linux out of a low power sleep state (or hibernation) back to a fully
> -operational state.  For example, a system could enter a deep power saving
> -state until it's time to execute some scheduled tasks.
> -
> -Note that many of these ioctls are handled by the common rtc-dev interface.
> -Some common examples:
> -
> -    *	RTC_RD_TIME, RTC_SET_TIME: the read_time/set_time functions will be
> -	called with appropriate values.
> -
> -    *	RTC_ALM_SET, RTC_ALM_READ, RTC_WKALM_SET, RTC_WKALM_RD: gets or sets
> -	the alarm rtc_timer. May call the set_alarm driver function.
> -
> -    *	RTC_IRQP_SET, RTC_IRQP_READ: These are emulated by the generic code.
> -
> -    *	RTC_PIE_ON, RTC_PIE_OFF: These are also emulated by the generic code.
> -
> -If all else fails, check out the tools/testing/selftests/timers/rtctest.c test!
> +The sysfs and ioctl interfaces are described in Documentation/ABI/stable/rtc.
> --
> 2.15.1
>
>
