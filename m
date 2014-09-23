From: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Subject: [PATCHv7 08/26] driver core: amba: add documentation for binding path
	'driver_override'
Date: Tue, 23 Sep 2014 16:46:07 +0200
Message-ID: <1411483586-29304-9-git-send-email-a.motakis@virtualopensystems.com>
References: <1411483586-29304-1-git-send-email-a.motakis@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1411483586-29304-1-git-send-email-a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, will.deacon-5wv7dgnIgG8@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>, tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

Add documentation for alternative binding path 'driver_override' for
AMBA devices.

Signed-off-by: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
---
 Documentation/ABI/testing/sysfs-bus-amba | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-amba

diff --git a/Documentation/ABI/testing/sysfs-bus-amba b/Documentation/ABI/testing/sysfs-bus-amba
new file mode 100644
index 0000000..e7b5467
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-amba
@@ -0,0 +1,20 @@
+What:		/sys/bus/amba/devices/.../driver_override
+Date:		September 2014
+Contact:	Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
+Description:
+		This file allows the driver for a device to be specified which
+		will override standard OF, ACPI, ID table, and name matching.
+		When specified, only a driver with a name matching the value
+		written to driver_override will have an opportunity to bind to
+		the device. The override is specified by writing a string to the
+		driver_override file (echo vfio-amba > driver_override)	and may
+		be cleared with an empty string (echo > driver_override).
+		This returns the device to standard matching rules binding.
+		Writing to driver_override does not automatically unbind the
+		device from its current driver or make any attempt to
+		automatically load the specified driver. If no driver with a
+		matching name is currently loaded in the kernel, the device will
+		not bind to any driver. This also allows devices to opt-out of
+		driver binding using a driver_override name such as "none".
+		Only a single driver may be specified in the override, there is
+		no support for parsing delimiters.
-- 
1.8.3.2
