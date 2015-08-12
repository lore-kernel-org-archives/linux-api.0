From: Cristina Opriceana <cristina.opriceana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] Documentation: iio-trig-sysfs: Document add_trigger
 attribute
Date: Wed, 12 Aug 2015 14:28:34 +0300
Message-ID: <abec7567354027e794de15da5a61e44bf627eacc.1439378363.git.cristina.opriceana@gmail.com>
References: <cover.1439378363.git.cristina.opriceana@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cover.1439378363.git.cristina.opriceana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This patch adds the ABI documentation for the add_trigger
attribute, which is provided by the iio-trig-sysfs stand-alone driver.

Signed-off-by: Cristina Opriceana <cristina.opriceana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/ABI/testing/sysfs-bus-iio-trigger-sysfs | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio-trigger-sysfs b/Documentation/ABI/testing/sysfs-bus-iio-trigger-sysfs
index 5235e6c..887aa92 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio-trigger-sysfs
+++ b/Documentation/ABI/testing/sysfs-bus-iio-trigger-sysfs
@@ -9,3 +9,14 @@ Description:
 		automated testing or in situations, where other trigger methods
 		are not applicable. For example no RTC or spare GPIOs.
 		X is the IIO index of the trigger.
+
+What:		/sys/bus/iio/devices/iio_sysfs_trigger/add_trigger
+KernelVersion:	2.6.39
+Contact:	linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:
+		This attribute is provided by the iio-trig-sysfs stand-alone
+		driver and it is used to activate the creation of a new trigger.
+		In order to achieve this, one should write a positive integer
+		into the associated file, which will serve as the id of the
+		trigger. If the trigger with the specified id is already present
+		in the system, an invalid argument message will be returned.
-- 
1.9.1
