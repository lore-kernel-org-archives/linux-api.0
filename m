From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: [PATCH] rtc: sysfs: move sysfs & ioctl interface to
 Documentation/ABI
Date: Mon, 1 Jan 2018 15:23:48 +0100
Message-ID: <20180101142348.GU18255@piout.net>
References: <20180101115726.GA4519@mordor.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180101115726.GA4519@mordor.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Aishwarya Pant <aishpant@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>, Jonathan Corbet <corbet@lwn.net>, linux-rtc@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>, gregkh@linuxfoundation.org
List-Id: linux-api@vger.kernel.org

Hi,

Well, I had that patch:
https://git.kernel.org/pub/scm/linux/kernel/git/abelloni/linux.git/commit/?h=rtc-ranges&id=79729c30854986faf4d26b0303dba220f4ef89de
part of a series I didn't send yet (it is still WIP and I just pushed
it).

Can you rebase on top of that? The RO/RW annotation would be a nice
addition.

Please, move the ioctl documentation to its own file,
Documentation/ABI/stable/rtc-cdev

On 01/01/2018 at 17:27:26 +0530, Aishwarya Pant wrote:
> +IOCTL interface
> +---------------
> +
> +What:		/dev/rtc[0-*]

The [0-*] range is not correct, it should be [0-9]+

> +Date:		April 2005
> +KernelVersion:	2.6.12
> +Contact:	Alexandre Belloni <alexandre.belloni@free-electrons.com>

This must be the RTC mailing list.

> +Description:	The ioctl() calls supported by /dev/rtc are also supported by
> +		the RTC class framework. However, because the chips and systems
> +		are not standardized, some PC/AT functionality might not be
> +		provided.  And in the same way, some newer features -- including
> +		those enabled by ACPI -- are exposed by the RTC class framework,
> +		but can't be supported by the older driver.
> +

Out of context, this paragraph is weird.

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

The reference to this test should probably stay in rtc.txt

-- 
Alexandre Belloni, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
