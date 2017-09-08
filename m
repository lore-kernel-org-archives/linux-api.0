From: Oleksandr Shamray <oleksandrs@mellanox.com>
Subject: [patch v8 4/4] Documentation: jtag: Add ABI documentation
Date: Fri,  8 Sep 2017 19:13:49 +0300
Message-ID: <1504887229-2748-5-git-send-email-oleksandrs@mellanox.com>
References: <1504887229-2748-1-git-send-email-oleksandrs@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1504887229-2748-1-git-send-email-oleksandrs@mellanox.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: gregkh@linuxfoundation.org, arnd@arndb.de
Cc: devicetree@vger.kernel.org, jiri@resnulli.us, system-sw-low-level@mellanox.com, linux-api@vger.kernel.org, openbmc@lists.ozlabs.org, linux-kernel@vger.kernel.org, openocd-devel-owner@lists.sourceforge.net, mec@shout.net, robh+dt@kernel.org, joel@jms.id.au, linux-serial@vger.kernel.org, vadimp@maellanox.com, Oleksandr Shamray <oleksandrs@mellanox.com>, tklauser@distanz.ch, mchehab@kernel.org, davem@davemloft.net, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

Added document that describe the ABI for JTAG class drivrer

Signed-off-by: Oleksandr Shamray <oleksandrs@mellanox.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
v7->v8
v6->v7
Comments pointed by Pavel Machek <pavel@ucw.cz>
- Added jtag-cdev documentation to Documentation/ABI/testing folder
---
 Documentation/ABI/testing/jatg-cdev |   27 +++++++++++++++++++++++++++
 MAINTAINERS                         |    1 +
 2 files changed, 28 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/jatg-cdev

diff --git a/Documentation/ABI/testing/jatg-cdev b/Documentation/ABI/testing/jatg-cdev
new file mode 100644
index 0000000..14a3610
--- /dev/null
+++ b/Documentation/ABI/testing/jatg-cdev
@@ -0,0 +1,27 @@
+What:		/dev/jtag[0-9]+
+Date:		September 2017
+KernelVersion:	4.14
+Contact:	oleksandrs@mellanox.com
+Description:
+		The character device files /dev/jtag* are the interface
+		between JTAG master interfase and userspace.
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
diff --git a/MAINTAINERS b/MAINTAINERS
index bfdfa94..dfcf49c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7300,6 +7300,7 @@ F:	include/linux/jtag.h
 F:	include/uapi/linux/jtag.h
 F:	drivers/jtag/
 F:	Documentation/devicetree/bindings/jtag/
+F:	Documentation/ABI/testing/jtag-cdev
 
 K10TEMP HARDWARE MONITORING DRIVER
 M:	Clemens Ladisch <clemens@ladisch.de>
-- 
1.7.1
