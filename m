From: Aishwarya Pant <aishpant-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] Documentation: rtc: move iotcl interface documentation
 to ABI
Date: Mon, 1 Jan 2018 23:01:24 +0530
Message-ID: <e0ac8fceb93e2520244b302b1472e9dc66a376da.1514827586.git.aishpant@gmail.com>
References: <cover.1514827586.git.aishpant@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cover.1514827586.git.aishpant-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-rtc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
List-Id: linux-api@vger.kernel.org

The ioctl interface should be in Documentation/ABI along with the rest
of the interfaces.

Signed-off-by: Aishwarya Pant <aishpant-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/ABI/testing/rtc-cdev | 42 ++++++++++++++++++++++++++++++++
 Documentation/rtc.txt              | 49 ++------------------------------------
 2 files changed, 44 insertions(+), 47 deletions(-)
 create mode 100644 Documentation/ABI/testing/rtc-cdev

diff --git a/Documentation/ABI/testing/rtc-cdev b/Documentation/ABI/testing/rtc-cdev
new file mode 100644
index 000000000000..97447283f13b
--- /dev/null
+++ b/Documentation/ABI/testing/rtc-cdev
@@ -0,0 +1,42 @@
+What:		/dev/rtcX
+Date:		April 2005
+KernelVersion:	2.6.12
+Contact:	linux-rtc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:
+		The ioctl interface to drivers for real-time clocks (RTCs).
+		Following actions are supported:
+
+		* RTC_RD_TIME, RTC_SET_TIME: Read or set the RTC time. Time
+		  format is a Gregorian calendar date and 24 hour wall clock
+		  time.
+
+		* RTC_AIE_ON, RTC_AIE_OFF: Enable or disable the alarm interrupt
+		  for RTCs that support alarms
+
+		* RTC_ALM_READ, RTC_ALM_SET: Read or set the alarm time for
+		  RTCs that support alarms. Can be set upto 24 hours in the
+		  future. Requires a separate RTC_AIE_ON call to enable the
+		  alarm interrupt. (Prefer to use RTC_WKALM_*)
+
+		* RTC_WKALM_RD, RTC_WKALM_SET: For RTCs that support a more
+		  powerful interface, which can issue alarms beyond 24 hours and
+		  enable IRQs in the same request.
+
+		* RTC_PIE_ON, RTC_PIE_OFF: Enable or disable the periodic
+		  interrupt for RTCs that support periodic interrupts.
+
+		* RTC_UIE_ON, RTC_UIE_OFF: Enable or disable the update
+		  interrupt for RTCs that support it.
+
+		* RTC_IRQP_READ, RTC_IRQP_SET: Read or set the frequency for
+		  periodic interrupts for RTCs that support periodic interrupts.
+		  Requires a separate RTC_PIE_ON call to enable the periodic
+		  interrupts.
+
+		The ioctl() calls supported by the older /dev/rtc interface are
+		also supported by the newer RTC class framework. However,
+		because the chips and systems are not standardized, some PC/AT
+		functionality might not be provided. And in the same way, some
+		newer features -- including those enabled by ACPI -- are exposed
+		by the RTC class framework, but can't be supported by the older
+		driver.
diff --git a/Documentation/rtc.txt b/Documentation/rtc.txt
index f521262cdc85..a129acf38537 100644
--- a/Documentation/rtc.txt
+++ b/Documentation/rtc.txt
@@ -136,50 +136,5 @@ a high functionality RTC is integrated into the SOC.  That system might read
 the system clock from the discrete RTC, but use the integrated one for all
 other tasks, because of its greater functionality.
 
-IOCTL interface
----------------
-
-The ioctl() calls supported by /dev/rtc are also supported by the RTC class
-framework.  However, because the chips and systems are not standardized,
-some PC/AT functionality might not be provided.  And in the same way, some
-newer features -- including those enabled by ACPI -- are exposed by the
-RTC class framework, but can't be supported by the older driver.
-
-    *	RTC_RD_TIME, RTC_SET_TIME ... every RTC supports at least reading
-	time, returning the result as a Gregorian calendar date and 24 hour
-	wall clock time.  To be most useful, this time may also be updated.
-
-    *	RTC_AIE_ON, RTC_AIE_OFF, RTC_ALM_SET, RTC_ALM_READ ... when the RTC
-	is connected to an IRQ line, it can often issue an alarm IRQ up to
-	24 hours in the future.  (Use RTC_WKALM_* by preference.)
-
-    *	RTC_WKALM_SET, RTC_WKALM_RD ... RTCs that can issue alarms beyond
-	the next 24 hours use a slightly more powerful API, which supports
-	setting the longer alarm time and enabling its IRQ using a single
-	request (using the same model as EFI firmware).
-
-    *	RTC_UIE_ON, RTC_UIE_OFF ... if the RTC offers IRQs, the RTC framework
-	will emulate this mechanism.
-
-    *	RTC_PIE_ON, RTC_PIE_OFF, RTC_IRQP_SET, RTC_IRQP_READ ... these icotls
-	are emulated via a kernel hrtimer.
-
-In many cases, the RTC alarm can be a system wake event, used to force
-Linux out of a low power sleep state (or hibernation) back to a fully
-operational state.  For example, a system could enter a deep power saving
-state until it's time to execute some scheduled tasks.
-
-Note that many of these ioctls are handled by the common rtc-dev interface.
-Some common examples:
-
-    *	RTC_RD_TIME, RTC_SET_TIME: the read_time/set_time functions will be
-	called with appropriate values.
-
-    *	RTC_ALM_SET, RTC_ALM_READ, RTC_WKALM_SET, RTC_WKALM_RD: gets or sets
-	the alarm rtc_timer. May call the set_alarm driver function.
-
-    *	RTC_IRQP_SET, RTC_IRQP_READ: These are emulated by the generic code.
-
-    *	RTC_PIE_ON, RTC_PIE_OFF: These are also emulated by the generic code.
-
-If all else fails, check out the tools/testing/selftests/timers/rtctest.c test!
+Check out tools/testing/selftests/timers/rtctest.c for an example usage of the
+ioctl interface.
-- 
2.15.1
