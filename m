From: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [patch v18 4/4] Documentation: jtag: Add ABI documentation
Date: Mon, 29 Jan 2018 16:31:45 +0200
Message-ID: <1517236305-4880-5-git-send-email-oleksandrs@mellanox.com>
References: <1517236305-4880-1-git-send-email-oleksandrs@mellanox.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517236305-4880-1-git-send-email-oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org, jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org, tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vadimp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, system-sw-low-level-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, openocd-devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Added document that describe the ABI for JTAG class drivrer

Signed-off-by: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Acked-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
v17->v18
v16->v17
v15->v16
v14->v15
v13->v14
v12->v13
v11->v12
Tobias Klauser <tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org>
- rename /Documentation/ABI/testing/jatg-dev -> jtag-dev
- Typo: s/interfase/interface
v10->v11
v9->v10
Fixes added by Oleksandr:
- change jtag-cdev to jtag-dev in documentation
- update Kernel Version and Date in jtag-dev documentation;
v8->v9
v7->v8
v6->v7
Comments pointed by Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
- Added jtag-cdev documentation to Documentation/ABI/testing folder
---
 Documentation/ABI/testing/jtag-dev |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/jtag-dev

diff --git a/Documentation/ABI/testing/jtag-dev b/Documentation/ABI/testing/jtag-dev
new file mode 100644
index 0000000..9db83ea
--- /dev/null
+++ b/Documentation/ABI/testing/jtag-dev
@@ -0,0 +1,27 @@
+What:		/dev/jtag[0-9]+
+Date:		October 2017
+KernelVersion:	4.17
+Contact:	oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
+Description:
+		The misc device files /dev/jtag* are the interface
+		between JTAG master interface and userspace.
+
+		The ioctl(2)-based ABI is defined and documented in
+		[include/uapi]<linux/jtag.h>.
+
+		The following file operations are supported:
+
+		open(2)
+		The argument flag currently support only one access
+		mode O_RDWR.
+
+		ioctl(2)
+		Initiate various actions.
+		See the inline documentation in [include/uapi]<linux/jtag.h>
+		for descriptions of all ioctls.
+
+		close(2)
+		Stops and free up the I/O contexts that was associated
+		with the file descriptor.
+
+Users:		TBD
-- 
1.7.1
