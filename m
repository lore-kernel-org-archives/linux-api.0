From: Cristina Opriceana <cristina.opriceana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] Documentation: iio-trig-sysfs: Add remove_trigger
 attribute ABI
Date: Wed, 12 Aug 2015 14:29:41 +0300
Message-ID: <8d4239f13743401a9adf67fc919c552c5f42537a.1439378363.git.cristina.opriceana@gmail.com>
References: <cover.1439378363.git.cristina.opriceana@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cover.1439378363.git.cristina.opriceana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This patch adds the documentation ABI for the remove_trigger
attribute, provided by the iio-trig-sysfs stand-alone driver.

Signed-off-by: Cristina Opriceana <cristina.opriceana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/ABI/testing/sysfs-bus-iio-trigger-sysfs | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio-trigger-sysfs b/Documentation/ABI/testing/sysfs-bus-iio-trigger-sysfs
index 887aa92..6de6e6b 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio-trigger-sysfs
+++ b/Documentation/ABI/testing/sysfs-bus-iio-trigger-sysfs
@@ -20,3 +20,14 @@ Description:
 		into the associated file, which will serve as the id of the
 		trigger. If the trigger with the specified id is already present
 		in the system, an invalid argument message will be returned.
+
+What:		/sys/bus/iio/devices/iio_sysfs_trigger/remove_trigger
+KernelVersion:	2.6.39
+Contact:	linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:
+		This attribute is used to unregister and delete a previously
+		created trigger from the list of available triggers. In order to
+		achieve this, one should write a positive integer into the
+		associated file, representing the id of the trigger that needs
+		to be removed. If the trigger can't be found, an invalid
+		argument message will be returned to the user.
-- 
1.9.1
