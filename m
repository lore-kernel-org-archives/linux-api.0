From: Oleksandr Shamray <oleksandrs@mellanox.com>
Subject: [patch v24 4/4] Documentation: jtag: Add ABI documentation
Date: Tue, 29 May 2018 15:58:40 +0300
Message-ID: <1527598720-21220-5-git-send-email-oleksandrs@mellanox.com>
References: <1527598720-21220-1-git-send-email-oleksandrs@mellanox.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1527598720-21220-1-git-send-email-oleksandrs@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, openbmc@lists.ozlabs.org, joel@jms.id.au, jiri@resnulli.us, tklauser@distanz.ch, linux-serial@vger.kernel.org, vadimp@mellanox.com, system-sw-low-level@mellanox.com, robh+dt@kernel.org, openocd-devel-owner@lists.sourceforge.net, linux-api@vger.kernel.org, davem@davemloft.net, mchehab@kernel.org, Oleksandr Shamray <oleksandrs@mellanox.com>
List-Id: linux-api@vger.kernel.org

Added document that describe the ABI for JTAG class drivrer

Signed-off-by: Oleksandr Shamray <oleksandrs@mellanox.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
v22->v23
Comments pointed by Randy Dunlap <rdunlap@infradead.org>
- fix spell in ABI doccumentation

v21->v22
Comments pointed by Randy Dunlap <rdunlap@infradead.org>
- fix spell in ABI doccumentation

v20->v21
Comments pointed by Randy Dunlap <rdunlap@infradead.org>
- Fix JTAG dirver help in Kconfig

v19->v20
Comments pointed by Randy Dunlap <rdunlap@infradead.org>
- Fix JTAG doccumentation

v18->v19
Pavel Machek <pavel@ucw.cz>
- Added JTAG doccumentation to Documentation/jtag

v17->v18
v16->v17
v15->v16
v14->v15
v13->v14
v12->v13
v11->v12 Tobias Klauser <tklauser@distanz.ch>
Comments pointed by
- rename /Documentation/ABI/testing/jatg-dev -> jtag-dev
- Typo: s/interfase/interface
v10->v11
v9->v10
Fixes added by Oleksandr:
- change jtag-cdev to jtag-dev in documentation
- update KernelVersion and Date in jtag-dev documentation;
v8->v9
v7->v8
v6->v7
Comments pointed by Pavel Machek <pavel@ucw.cz>
- Added jtag-cdev documentation to Documentation/ABI/testing folder
---
 Documentation/ABI/testing/jtag-dev |   27 +++++++++
 Documentation/jtag/overview        |   27 +++++++++
 Documentation/jtag/transactions    |  109 ++++++++++++++++++++++++++++++++++++
 MAINTAINERS                        |    1 +
 4 files changed, 164 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/jtag-dev
 create mode 100644 Documentation/jtag/overview
 create mode 100644 Documentation/jtag/transactions

diff --git a/Documentation/ABI/testing/jtag-dev b/Documentation/ABI/testing/jtag-dev
new file mode 100644
index 0000000..4325316
--- /dev/null
+++ b/Documentation/ABI/testing/jtag-dev
@@ -0,0 +1,27 @@
+What:		/dev/jtag[0-9]+
+Date:		May 2018
+KernelVersion:	4.18
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
diff --git a/Documentation/jtag/overview b/Documentation/jtag/overview
new file mode 100644
index 0000000..f179095
--- /dev/null
+++ b/Documentation/jtag/overview
@@ -0,0 +1,27 @@
+Linux kernel JTAG support
+=========================
+
+JTAG is an industry standard for verifying hardware.JTAG provides access to
+many logic signals of a complex integrated circuit, including the device pins.
+
+A JTAG interface is a special interface added to a chip.
+Depending on the version of JTAG, two, four, or five pins are added.
+
+The connector pins are:
+	TDI (Test Data In)
+	TDO (Test Data Out)
+	TCK (Test Clock)
+	TMS (Test Mode Select)
+	TRST (Test Reset) optional
+
+JTAG interface is designed to have two parts - basic core driver and
+hardware specific driver. The basic driver introduces a general interface
+which is not dependent of specific hardware. It provides communication
+between user space and hardware specific driver.
+Each JTAG device is represented as a char device from (jtag0, jtag1, ...).
+Access to a JTAG device is performed through IOCTL calls.
+
+Call flow example:
+User: open  -> /dev/jatgX
+User: ioctl -> /dev/jtagX -> JTAG core driver -> JTAG hardware specific driver
+User: close -> /dev/jatgX
diff --git a/Documentation/jtag/transactions b/Documentation/jtag/transactions
new file mode 100644
index 0000000..ffabde0
--- /dev/null
+++ b/Documentation/jtag/transactions
@@ -0,0 +1,109 @@
+The JTAG API
+=============
+
+JTAG master devices can be accessed through a character misc-device.
+Each JTAG master interface can be accessed by using /dev/jtagN.
+
+JTAG system calls set:
+- SIR (Scan Instruction Register, IEEE 1149.1 Instruction Register scan);
+- SDR (Scan Data Register, IEEE 1149.1 Data Register scan);
+- RUNTEST (Forces the IEEE 1149.1 bus to a run state for a specified
+number of clocks.
+
+open(), close()
+-------
+open() opens JTAG device. Only one open operation per JTAG device
+can be performed. Two or more open for one device will return error.
+
+Open/Close  device:
+- jtag_fd = open("/dev/jtag0", O_RDWR);
+- close(jtag_fd);
+
+ioctl()
+-------
+All access operations to JTAG devices are erformed through ioctl interface.
+The IOCTL interface supports these requests:
+	JTAG_IOCRUNTEST - Force JTAG state machine to RUN_TEST/IDLE state
+	JTAG_SIOCFREQ - Set JTAG TCK frequency
+	JTAG_GIOCFREQ - Get JTAG TCK frequency
+	JTAG_IOCXFER - send JTAG data Xfer
+	JTAG_GIOCSTATUS - get current JTAG TAP status
+	JTAG_SIOCMODE - set JTAG mode flags.
+
+JTAG_SIOCFREQ, JTAG_GIOCFREQ
+------
+Set/Get JTAG clock speed:
+
+	unsigned int jtag_fd;
+	ioctl(jtag_fd, JTAG_SIOCFREQ, &frq);
+	ioctl(jtag_fd, JTAG_GIOCFREQ, &frq);
+
+JTAG_IOCRUNTEST
+------
+Force JTAG state machine to RUN_TEST/IDLE state
+
+struct jtag_run_test_idle {
+	__u8	reset;
+	__u8	endstate;
+	__u8	tck;
+};
+
+reset: 0 - run IDLE/PAUSE from current state
+	   1 - go through TEST_LOGIC/RESET state before IDLE/PAUSE
+endstate: completion flag
+tck: clock counter
+
+Example:
+	struct jtag_run_test_idle runtest;
+
+	runtest.endstate = JTAG_STATE_IDLE;
+	runtest.reset = 0;
+	runtest.tck = data_p->tck;
+	usleep(25 * 1000);
+	ioctl(jtag_fd, JTAG_IOCRUNTEST, &runtest);
+
+JTAG_IOCXFER
+------
+Send SDR/SIR transaction
+
+struct jtag_xfer {
+	__u8	type;
+	__u8	direction;
+	__u8	endstate;
+	__u8	padding;
+	__u32	length;
+	__u64	tdio;
+};
+
+type: transfer type - JTAG_SIR_XFER/JTAG_SDR_XFER
+direction: xfer direction - JTAG_SIR_XFER/JTAG_SDR_XFER
+length: xfer data length in bits
+tdio : xfer data array
+endstate: xfer end state after transaction finish
+	   can be: JTAG_STATE_IDLE/JTAG_STATE_PAUSEIR/JTAG_STATE_PAUSEDR
+
+Example:
+	struct jtag_xfer xfer;
+	static char buf[64];
+	static unsigned int buf_len = 0;
+	[...]
+	xfer.type = JTAG_SDR_XFER;
+	xfer.tdio = (__u64)buf;
+	xfer.length = buf_len;
+	xfer.endstate = JTAG_STATE_IDLE;
+
+	if (is_read)
+		xfer.direction = JTAG_READ_XFER;
+	else
+		xfer.direction = JTAG_WRITE_XFER;
+
+	ioctl(jtag_fd, JTAG_IOCXFER, &xfer);
+
+JTAG_SIOCMODE
+------
+If hardware driver can support different running modes you can change it.
+
+Example:
+	unsigned int mode;
+	mode = JTAG_XFER_HW_MODE;
+	ioctl(jtag_fd, JTAG_SIOCMODE, &mode);
diff --git a/MAINTAINERS b/MAINTAINERS
index a5e5f75..e067eda 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7618,6 +7618,7 @@ F:	include/linux/jtag.h
 F:	include/uapi/linux/jtag.h
 F:	drivers/jtag/
 F:	Documentation/devicetree/bindings/jtag/
+F:	Documentation/ABI/testing/jtag-dev
 
 K10TEMP HARDWARE MONITORING DRIVER
 M:	Clemens Ladisch <clemens@ladisch.de>
-- 
1.7.1
