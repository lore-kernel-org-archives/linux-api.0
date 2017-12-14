From: Oleksandr Shamray <oleksandrs@mellanox.com>
Subject: [patch v14 4/4] Documentation: jtag: Add ABI documentation
Date: Thu, 14 Dec 2017 18:29:31 +0200
Message-ID: <1513268971-13518-5-git-send-email-oleksandrs@mellanox.com>
References: <1513268971-13518-1-git-send-email-oleksandrs@mellanox.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513268971-13518-1-git-send-email-oleksandrs@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, openbmc@lists.ozlabs.org, joel@jms.id.au, jiri@resnulli.us, tklauser@distanz.ch, linux-serial@vger.kernel.org, vadimp@mellanox.com, system-sw-low-level@mellanox.com, robh+dt@kernel.org, openocd-devel-owner@lists.sourceforge.net, linux-api@vger.kernel.org, davem@davemloft.net, mchehab@kernel.org, Oleksandr Shamray <oleksandrs@mellanox.com>
List-Id: linux-api@vger.kernel.org

Added document that describe the ABI for JTAG class drivrer

Signed-off-by: Oleksandr Shamray <oleksandrs@mellanox.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
v13->v14
v12->v13
v11->v12
Tobias Klauser <tklauser@distanz.ch>
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
Comments pointed by Pavel Machek <pavel@ucw.cz>
- Added jtag-cdev documentation to Documentation/ABI/testing folder
---
 Documentation/ABI/testing/jtag-dev |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/jtag-dev

diff --git a/Documentation/ABI/testing/jtag-dev b/Documentation/ABI/testing/jtag-dev
new file mode 100644
index 0000000..cab867d
--- /dev/null
+++ b/Documentation/ABI/testing/jtag-dev
@@ -0,0 +1,27 @@
+What:		/dev/jtag[0-9]+
+Date:		October 2017
+KernelVersion:	4.15
+Contact:	oleksandrs@mellanox.com
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
\ No newline at end of file
-- 
1.7.1
