From: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RFC 0/8] Dynamic clock devices
Date: Thu, 4 Nov 2010 20:26:34 +0100
Message-ID: <cover.1288897198.git.richard.cochran@omicron.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, John Stultz <johnstul-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Okay, here is a work in progress, not well tested, but I would like to
get some feedback whether the direction is good or not.

The first patch introduces clock devices which can appear and
disappear like usb devices (and, I suppose, hot plug PCI but I am not
too sure that what is offered here would really work in that case).
The subsequent patches convert the clock_ and timer_ system calls, one
by one.

The clock_ syscalls are moved into a new file and they call the older
posix functions when needed. The timer_ syscalls stay where they are,
in posix-timers.c, since I did not want to change the fairly involved
timer management code. Eventually, we could remove the posix clock_*
functions for the CLOCK_* ids from posix-timers.c and rework them
using the new dynamic clock api. That would leave just the timer code
in posix-timers.c, as the file name suggests.

I dropped the idea of having user space open a sysfs file in order to
get a reference to a clock, since there are no open/release hooks
within sysfs for drivers (coincidentally, there has been some talk
about this on the lkml recently, but previously Greg KH object to
abusing sysfs as a "clockfs").

Instead, since many clocks (hpet, rtc, ptp, ...) will want to offer a
custom chardev for special advanced functionality, the dynamic clock
layer registers a cdev for the driver, placing its own hooks into the
open/release methods. The driver thus needs to access its private data
via a standard access method (not just by using fp->private_data). If
a driver doesn't want any chardev functions, that is okay, too.

Well, please take a look and let me know what you think.

Thanks,

Richard


Richard Cochran (8):
  Introduce dynamic clock devices
  clock device: convert clock_gettime
  clock device: convert clock_getres
  clock device: convert clock_settime
  clock device: convert timer_create
  clock device: convert timer_delete
  clock device: convert timer_gettime
  clock device: convert timer_settime

 include/linux/clockdevice.h  |  117 +++++++++++++++
 include/linux/posix-timers.h |   23 +++-
 include/linux/time.h         |    2 +
 kernel/posix-timers.c        |   51 +++++--
 kernel/time/Makefile         |    3 +-
 kernel/time/clockdevice.c    |  336 ++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 518 insertions(+), 14 deletions(-)
 create mode 100644 include/linux/clockdevice.h
 create mode 100644 kernel/time/clockdevice.c
