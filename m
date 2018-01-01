From: Aishwarya Pant <aishpant@gmail.com>
Subject: [PATCH 1/2] Documentation: rtc: add sysfs file permissions
Date: Mon, 1 Jan 2018 23:00:42 +0530
Message-ID: <1237d9e0d486da6df6bd6260482bab9f930b319c.1514827586.git.aishpant@gmail.com>
References: <cover.1514827586.git.aishpant@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1514827586.git.aishpant@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@free-electrons.com>, Jonathan Corbet <corbet@lwn.net>, linux-rtc@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>, gregkh@linuxfoundation.org
List-Id: linux-api@vger.kernel.org

Annotate the sysfs interface of rtc with file specific permissions
(RO/RW).

Signed-off-by: Aishwarya Pant <aishpant@gmail.com>
---
 Documentation/ABI/testing/sysfs-class-rtc | 44 ++++++++++++++++---------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-rtc b/Documentation/ABI/testing/sysfs-class-rtc
index df2eca7e2e77..5083841b03d4 100644
--- a/Documentation/ABI/testing/sysfs-class-rtc
+++ b/Documentation/ABI/testing/sysfs-class-rtc
@@ -18,14 +18,14 @@ Date:		March 2006
 KernelVersion:	2.6.17
 Contact:	linux-rtc@vger.kernel.org
 Description:
-		RTC-provided date in YYYY-MM-DD format
+		(RO) RTC-provided date in YYYY-MM-DD format
 
 What:		/sys/class/rtc/rtcX/hctosys
 Date:		September 2009
 KernelVersion:	2.6.32
 Contact:	linux-rtc@vger.kernel.org
 Description:
-		1 if the RTC provided the system time at boot via the
+		(RO) 1 if the RTC provided the system time at boot via the
 		CONFIG_RTC_HCTOSYS kernel option, 0 otherwise
 
 What:		/sys/class/rtc/rtcX/max_user_freq
@@ -33,7 +33,7 @@ Date:		October 2007
 KernelVersion:	2.6.24
 Contact:	linux-rtc@vger.kernel.org
 Description:
-		The maximum interrupt rate an unprivileged user may request
+		(RW) The maximum interrupt rate an unprivileged user may request
 		from this RTC.
 
 What:		/sys/class/rtc/rtcX/name
@@ -41,58 +41,60 @@ Date:		March 2006
 KernelVersion:	2.6.17
 Contact:	linux-rtc@vger.kernel.org
 Description:
-		The name of the RTC corresponding to this sysfs directory
+		(RO) The name of the RTC corresponding to this sysfs directory
 
 What:		/sys/class/rtc/rtcX/range
 Date:		January 2018
 KernelVersion:	4.16
 Contact:	linux-rtc@vger.kernel.org
 Description:
-		Valid time range for the RTC, as seconds from epoch, formatted
-		as [min, max]
+		(RO) Valid time range for the RTC, as seconds from epoch,
+		formatted as [min, max]
 
 What:		/sys/class/rtc/rtcX/since_epoch
 Date:		March 2006
 KernelVersion:	2.6.17
 Contact:	linux-rtc@vger.kernel.org
 Description:
-		RTC-provided time as the number of seconds since the epoch
+		(RO) RTC-provided time as the number of seconds since the epoch
 
 What:		/sys/class/rtc/rtcX/time
 Date:		March 2006
 KernelVersion:	2.6.17
 Contact:	linux-rtc@vger.kernel.org
 Description:
-		RTC-provided time in 24-hour notation (hh:mm:ss)
+		(RO) RTC-provided time in 24-hour notation (hh:mm:ss)
 
 What:		/sys/class/rtc/rtcX/*/nvmem
 Date:		February 2016
 KernelVersion:	4.6
 Contact:	linux-rtc@vger.kernel.org
 Description:
-		The non volatile storage exported as a raw file, as described in
-		Documentation/nvmem/nvmem.txt
+		(RW) The non volatile storage exported as a raw file, as
+		described in Documentation/nvmem/nvmem.txt
 
 What:		/sys/class/rtc/rtcX/offset
 Date:		February 2016
 KernelVersion:	4.6
 Contact:	linux-rtc@vger.kernel.org
 Description:
-		The amount which the rtc clock has been adjusted in firmware.
-		Visible only if the driver supports clock offset adjustment.
-		The unit is parts per billion, i.e. The number of clock ticks
-		which are added to or removed from the rtc's base clock per
-		billion ticks. A positive value makes a day pass more slowly,
-		longer, and a negative value makes a day pass more quickly.
+		(RW) The amount which the rtc clock has been adjusted in
+		firmware. Visible only if the driver supports clock offset
+		adjustment. The unit is parts per billion, i.e. The number of
+		clock ticks which are added to or removed from the rtc's base
+		clock per billion ticks. A positive value makes a day pass more
+		slowly, longer, and a negative value makes a day pass more
+		quickly.
 
 What:		/sys/class/rtc/rtcX/wakealarm
 Date:		February 2007
 KernelVersion:	2.6.20
 Contact:	linux-rtc@vger.kernel.org
 Description:
-		The time at which the clock will generate a system wakeup event.
-		This is a one shot wakeup event, so must be reset after wake if
-		a daily wakeup is required. Format is seconds since the epoch by
-		default, or if there's a leading +, seconds in the future, or if
-		there is a leading +=, seconds ahead of the current alarm.
+		(RW) The time at which the clock will generate a system wakeup
+		event. This is a one shot wakeup event, so must be reset after
+		wake if a daily wakeup is required. Format is seconds since the
+		epoch by default, or if there's a leading +, seconds in the
+		future, or if there is a leading +=, seconds ahead of the
+		current alarm.
 
-- 
2.15.1

