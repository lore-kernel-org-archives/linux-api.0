From: Martin Kepplinger <martink-1KBjaw7Xf1+zQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH v5] add support for Freescale's MMA8653FC 10 bit accelerometer
Date: Fri, 20 Mar 2015 15:06:14 +0100
Message-ID: <1426860374-10415-1-git-send-email-martink@posteo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mark.rutland-5wv7dgnIgG8@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Pawel.Moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, alexander.stein-93q1YBGzJSMe9JSWTWOYM3xStJ4P+DSV@public.gmane.org, benjamin.tissoires-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Martin Kepplinger <martin.kepplinger-SN7IsUiht6C/RdPyistoZJqQE7yCjDx5@public.gmane.org>, Christoph Muellner <christoph.muellner-SN7IsUiht6C/RdPyistoZJqQE7yCjDx5@public.gmane.org>
List-Id: linux-api@vger.kernel.org

=46rom: Martin Kepplinger <martin.kepplinger-SN7IsUiht6C/RdPyistoZJqQE7yCjDx5@public.gmane.org>

The MMA8653FC is a low-power, three-axis, capacitive micromachined
accelerometer with 10 bits of resolution with flexible user-programmabl=
e
options.

Embedded interrupt functions enable overall power savings, by relieving=
 the
host processor from continuously polling data, for example using the po=
ll()
system call.

The device can be configured to generate wake-up interrupt signals from=
 any
combination of the configurable embedded functions, enabling the MMA865=
3FC
to monitor events while remaining in a low-power mode during periods of
inactivity.

This driver provides devicetree properties to program the device's beha=
viour
and a simple, tested and documented sysfs interface. The data sheet and=
 more
information is available on Freescale's website.

Signed-off-by: Martin Kepplinger <martin.kepplinger@theobroma-systems.c=
om>
Signed-off-by: Christoph Muellner <christoph.muellner@theobroma-systems=
=2Ecom>
---

patch revision history
=2E.....................
v5 clean up (suggested by Varka Bhadram) and move the driver to staging
v4 changes DT propery names, adds a missing interrupt source and remove=
s
   the DT option to set interrupt line active high due to unsuccesful t=
esting
v3 moves the driver from drivers/input/misc to drivers/misc
v2 corrects licensing and commit messages and adds appropriate recipien=
ts


 drivers/staging/Kconfig               |   2 +
 drivers/staging/mma8653fc/Kconfig     |  10 +
 drivers/staging/mma8653fc/Makefile    |   1 +
 drivers/staging/mma8653fc/TODO        | 146 ++++++
 drivers/staging/mma8653fc/mma8653fc.c | 864 ++++++++++++++++++++++++++=
++++++++
 5 files changed, 1023 insertions(+)
 create mode 100644 drivers/staging/mma8653fc/Kconfig
 create mode 100644 drivers/staging/mma8653fc/Makefile
 create mode 100644 drivers/staging/mma8653fc/TODO
 create mode 100644 drivers/staging/mma8653fc/mma8653fc.c

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 45baa83..661e5f5 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -108,4 +108,6 @@ source "drivers/staging/fbtft/Kconfig"
=20
 source "drivers/staging/i2o/Kconfig"
=20
+source "drivers/staging/mma8653fc/Kconfig"
+
 endif # STAGING
diff --git a/drivers/staging/mma8653fc/Kconfig b/drivers/staging/mma865=
3fc/Kconfig
new file mode 100644
index 0000000..988451b
--- /dev/null
+++ b/drivers/staging/mma8653fc/Kconfig
@@ -0,0 +1,10 @@
+config MMA8653FC
+        tristate "MMA8653FC - Freescale's 3-Axis, 10-bit Digital Accel=
erometer"
+        depends on I2C
+        default n
+        help
+          Say Y here if you want to support Freescale's MMA8653FC Acce=
lerometer
+          through I2C interface.
+
+          To compile this driver as a module, choose M here: the
+          module will be called mma8653fc.
diff --git a/drivers/staging/mma8653fc/Makefile b/drivers/staging/mma86=
53fc/Makefile
new file mode 100644
index 0000000..9a245a3
--- /dev/null
+++ b/drivers/staging/mma8653fc/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_MMA8653FC)         +=3D mma8653fc.o
diff --git a/drivers/staging/mma8653fc/TODO b/drivers/staging/mma8653fc=
/TODO
new file mode 100644
index 0000000..0a31225
--- /dev/null
+++ b/drivers/staging/mma8653fc/TODO
@@ -0,0 +1,146 @@
+- move to IIO device API. The current DT/sysfs interface is documented=
 below
+
+Documentation/ABI/testing/...
+-----------------------------
+What:		/sys/bus/i2c/drivers/mma8653fc/*/standby
+Date:		March 2015
+Contact:	Martin Kepplinger <martin.kepplinger-SN7IsUiht6C/RdPyistoZJqQE7yCjDx5@public.gmane.org>
+Description:
+		Write 0 to this in order to turn on the device, and 1 to turn
+		it off. Read to see if it is turned on or off.
+
+
+What:		/sys/bus/i2c/drivers/mma8653fc/*/currentmode
+Date:		March 2015
+Contact:	Martin Kepplinger <martin.kepplinger-SN7IsUiht6C/RdPyistoZJqQE7yCjDx5@public.gmane.org>
+Description:
+		Reading this provides the current state of the device, read
+		directly from a register. This can be "standby", "wake" or
+		"sleep".
+
+
+What:		/sys/bus/i2c/drivers/mma8653fc/*/position
+Date:		March 2015
+Contact:	Martin Kepplinger <martin.kepplinger-SN7IsUiht6C/RdPyistoZJqQE7yCjDx5@public.gmane.org>
+Description:
+		Read only. Without interrupts enabled gets current position
+		values by reading. Poll "position" with interrupt conditions
+		set, to get notified; see Documentation/.../fsl,mma8653fc.txt
+
+		position file format:
+		"x y z [landscape/portrait status] [front/back status]"
+
+		x y z values:
+			in mg
+		landscape/portrait status char:
+			r	landscape right
+			d	portrait down
+			u	portrait up
+			l	landscape left
+		front/back status char:
+			f	front facing
+			b	back facing
+
+
+Documentation/devicetree/bindings/...
+-------------------------------------
+Required properties:
+- compatible
+	"fsl,mma8653fc"
+- reg
+	I2C address
+
+Optional properties:
+
+- interrupt-parent
+	a phandle for the interrupt controller (see
+	Documentation/devicetree/bindings/interrupt-controller/interrupts.txt=
)
+- interrupts
+	interrupt line to which the chip is connected (active low)
+- int1
+	set to use interrupt line 1, default is line 2
+	the interrupt sources can be routed to one of the two lines
+- ir-freefall-motion-x
+	activate freefall/motion interrupts on x axis
+- ir-freefall-motion-y
+	activate freefall/motion interrupts on y axis
+- ir-freefall-motion-z
+	activate freefall/motion interrupts on z axis
+- irq-threshold
+	0 < value < 8000: threshold for motion interrupts in mg
+- ir-landscape-portrait
+	activate landscape/portrait interrupts
+- ir-auto-wake
+	activate wake/sleep change interrupts
+- ir-data-ready:
+	activate data-ready interrupts
+	Interrupt events can be activated in any combination.
+- dynamic-range
+	2, 4, or 8: dynamic measurement range in g, default: 2
+	In =C2=B12 g mode, sensitivity =3D 256 counts/g.
+	In =C2=B14 g mode, sensitivity =3D 128 counts/g.
+	In =C2=B18 g mode, sensitivity =3D 64 counts/g.
+- auto-wake-sleep
+	auto sleep mode (lower frequency)
+- motion-mode
+	use motion mode instead of freefall mode (trigger if >threshold).
+	per default an interrupt occurs if motion values fall below the
+	value set in "threshold" and therefore can detect free fall on the
+	vertical axis (depending on the position of the device).
+	Setting this values inverts the behaviour and an interrupt occurs
+	above the threshold value, so usually activate horizontal axis in
+	this case.
+
+- x-offset
+	0 < value < 500: calibration offset in mg
+	The offset correction values are used to realign the Zero-g position
+	of the X, Y, and Z-axis after the device is mounted on a board.
+	this value has an offset of 250 itself:
+	0 is -250mg, 250 is 0 mg, 500 is 250mg
+- y-offset
+	see x-offset
+- z-offset
+	see x-offset
+
+Example 1:
+for a device laying on flat ground to recognize acceleration over 100m=
g.
+x-axis is calibrated to +10mg. Adapt interrupt line to your device.
+
+mma8653fc@1d {
+		compatible =3D "fsl,mma8653fc";
+		interrupt-parent =3D <&gpio1>;
+		interrupts =3D <5 0>;
+		reg =3D <0x1d>;
+
+		dynamic-range =3D <2>;
+		motion-mode;
+		ir-freefall-motion-x;
+		ir-freefall-motion-y;
+		irq-threshold =3D <100>;
+		x-offset =3D <160>;
+};
+
+Example 2:
+for a device mounted on a wall with y being the vertical axis. This re=
cognizes
+y-acceleration below 800mg, so free fall or changing the orientation o=
f the
+device (y not being the vertical axis and having ~1000mg anymore).
+
+mma8653fc@1d {
+		compatible =3D "fsl,mma8653fc";
+		interrupt-parent =3D <&gpio1>;
+		interrupts =3D <5 0>;
+		reg =3D <0x1d>;
+
+		dynamic-range =3D <2>;
+		ir-freefall-motion-y;
+		irq-threshold =3D <800>;
+};
+
+Example 3:
+minimal example. lets users read current acceleration values. No polli=
ng
+is available.
+
+mma8653fc@1d {
+		compatible =3D "fsl,mma8653fc";
+		reg =3D <0x1d>;
+};
diff --git a/drivers/staging/mma8653fc/mma8653fc.c b/drivers/staging/mm=
a8653fc/mma8653fc.c
new file mode 100644
index 0000000..4bd7f99
--- /dev/null
+++ b/drivers/staging/mma8653fc/mma8653fc.c
@@ -0,0 +1,864 @@
+/*
+ * mma8653fc.c - Support for Freescale MMA8653FC 3-axis 10-bit acceler=
ometer
+ *
+ * Copyright (c) 2014 Theobroma Systems Design and Consulting GmbH
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/types.h>
+#include <linux/of_device.h>
+#include <linux/of_irq.h>
+
+#define DRV_NAME	"mma8653fc"
+#define MMA8653FC_DEVICE_ID	0x5a
+
+#define MMA8653FC_STATUS	0x00
+
+#define ZYXOW_MASK	0x80
+#define ZYXDR		0x08
+
+#define MMA8653FC_WHO_AM_I	0x0d
+
+#define MMA8653FC_SYSMOD	0x0b
+#define STATE_STANDBY	0x00
+#define STATE_WAKE	0x01
+#define STATE_SLEEP	0x02
+
+#define MMA8450_STATUS_ZXYDR	0x08
+
+/*
+ * 10 bit output data registers
+ * MSB: 7:0 bits 9:2 of data word
+ * LSB: 7:6 bits 1:0 of data word
+ */
+#define MMA8653FC_OUT_X_MSB	0x01
+#define MMA8653FC_OUT_X_LSB	0x02
+#define MMA8653FC_OUT_Y_MSB	0x03
+#define MMA8653FC_OUT_Y_LSB	0x04
+#define MMA8653FC_OUT_Z_MSB	0x05
+#define MMA8653FC_OUT_Z_LSB	0x06
+
+/*
+ * Portrait/Landscape Status
+ */
+#define MMA8653FC_PL_STATUS	0x10
+
+#define NEWLP		0x80
+#define LAPO_HIGH	0x04
+#define LAPO_LOW	0x02
+#define BAFRO		0x01
+
+/*
+ * Portrait/Landscape Configuration
+ */
+#define MMA8653FC_PL_CFG	0x11
+
+#define PL_EN		(1 << 6)
+
+/*
+ * Data calibration registers
+ */
+#define MMA8653FC_OFF_X		0x2f
+#define MMA8653FC_OFF_Y		0x30
+#define MMA8653FC_OFF_Z		0x31
+
+/* 0 to 500 for dts, but -250 to 250 in mg */
+#define DEFAULT_OFF	250
+
+/*
+ * bits 1:0 dynamic range
+ * 00 +/- 2g
+ * 01 +/- 4g
+ * 10 +/- 8g
+ *
+ * HPF_Out bit 4 - data high pass or low pass filtered
+ */
+#define MMA8653FC_XYZ_DATA_CFG	0x0e
+
+#define RANGE_MASK	0x03
+#define RANGE2G		0x00
+#define RANGE4G		0x01
+#define RANGE8G		0x02
+/* values for calculation */
+#define SHIFT_2G	8
+#define INCR_2G		128
+#define SHIFT_4G	7
+#define INCR_4G		64
+#define SHIFT_8G	6
+#define INCR_8G		32
+#define DYN_RANGE_2G	2
+#define DYN_RANGE_4G	4
+#define DYN_RANGE_8G	8
+
+/*
+ * System Control Reg 1
+ */
+#define MMA8653FC_CTRL_REG1	0x2a
+
+#define ACTIVE_BIT	(1 << 0)
+#define ODR_MASK	0x38
+#define ODR_DEFAULT	0x20 /* 50 Hz */
+#define ASLP_RATE_MASK	0xc0
+#define ASLP_RATE_DEFAULT 0x80 /* 6.25 Hz */
+
+/*
+ * Sys Control Reg 2
+ *
+ * auto-sleep enable, software reset
+ */
+#define MMA8653FC_CTRL_REG2	0x2b
+
+#define SLPE		(1 << 2)
+#define SELFTEST	(1 << 7)
+#define SOFT_RESET	(1 << 6)
+
+/*
+ * Interrupt Source
+ */
+#define MMA8653FC_INT_SOURCE	0x0c
+
+#define SRC_ASLP	(1 << 7)
+#define SRC_LNDPRT	(1 << 4)
+#define SRC_FF_MT	(1 << 2)
+#define SRC_DRDY	(1 << 0)
+
+/*
+ * Interrupt Control Register
+ *
+ * default: active low
+ * default push-pull, not open-drain
+ */
+#define MMA8653FC_CTRL_REG3	0x2c
+
+#define WAKE_LNDPRT	(1 << 5)
+#define WAKE_FF_MT	(1 << 3)
+#define IPOL		(1 << 1)
+#define PP_OD		(1 << 0)
+
+/*
+ * Interrupt Enable Register
+ */
+#define MMA8653FC_CTRL_REG4	0x2d
+
+#define INT_EN_ASLP	(1 << 7)
+#define INT_EN_LNDPRT	(1 << 4)
+#define INT_EN_FF_MT	(1 << 2)
+#define INT_EN_DRDY	(1 << 0)
+
+/*
+ * Interrupt Configuration Register
+ * bit value 0 ... INT2 (default)
+ * bit value 1 ... INT1
+ */
+#define MMA8653FC_CTRL_REG5	0x2e
+
+#define INT_CFG_ASLP	(1 << 7)
+#define INT_CFG_LNDPRT	(1 << 4)
+#define INT_CFG_FF_MT	(1 << 2)
+#define INT_CFG_DRDY	(1 << 0)
+
+/*
+ * Freefall / Motion Configuration Register
+ *
+ * Event Latch enable/disable, motion or freefall mode
+ * and event flag enable per axis
+ */
+#define MMA8653FC_FF_MT_CFG	0x15
+
+#define FF_MT_CFG_ELE	(1 << 7)
+#define FF_MT_CFG_OAE	(1 << 6)
+#define FF_MT_CFG_ZEFE	(1 << 5)
+#define FF_MT_CFG_YEFE	(1 << 4)
+#define FF_MT_CFG_XEFE	(1 << 3)
+
+/*
+ * Freefall / Motion Source Register
+ */
+#define MMA8653FC_FF_MT_SRC	0x16
+
+/*
+ * Freefall / Motion Threshold Register
+ *
+ * define motion threshold
+ * 0.063 g/LSB, 127 counts(0x7f) (7 bit from LSB)
+ * range: 0.063g - 8g
+ */
+#define MMA8653FC_FF_MT_THS	0x17
+
+struct axis_triple {
+	s16 x;
+	s16 y;
+	s16 z;
+};
+
+struct mma8653fc_pdata {
+	s8 x_axis_offset;
+	s8 y_axis_offset;
+	s8 z_axis_offset;
+	bool auto_wake_sleep;
+	u32 range;
+	bool int1;
+	bool motion_mode;
+	u8 freefall_motion_thr;
+	bool int_src_data_ready;
+	bool int_src_ff_mt_x;
+	bool int_src_ff_mt_y;
+	bool int_src_ff_mt_z;
+	bool int_src_lndprt;
+	bool int_src_aslp;
+};
+
+struct mma8653fc {
+	struct i2c_client *client;
+	struct mutex mutex;
+	struct mma8653fc_pdata pdata;
+	struct axis_triple saved;
+	char orientation;
+	char bafro;
+	bool standby;
+	int irq;
+	unsigned int_mask;
+	u8 (*read)(struct mma8653fc *, unsigned char);
+	void (*write)(struct mma8653fc *, unsigned char, unsigned char);
+};
+
+/* defaults */
+static const struct mma8653fc_pdata mma8653fc_default_init =3D {
+	.range =3D 2,
+	.x_axis_offset =3D DEFAULT_OFF,
+	.y_axis_offset =3D DEFAULT_OFF,
+	.z_axis_offset =3D DEFAULT_OFF,
+	.auto_wake_sleep =3D false,
+	.int1 =3D false,
+	.motion_mode =3D false,
+	.freefall_motion_thr =3D 5,
+	.int_src_data_ready =3D false,
+	.int_src_ff_mt_x =3D false,
+	.int_src_ff_mt_y =3D false,
+	.int_src_ff_mt_z =3D false,
+	.int_src_lndprt =3D false,
+	.int_src_aslp =3D false,
+};
+
+static void mma8653fc_get_triple(struct mma8653fc *mma)
+{
+	u8 buf[6];
+	u8 status;
+
+	buf[0] =3D 0;
+
+	status =3D mma->read(mma, MMA8653FC_STATUS);
+	if (status & ZYXOW_MASK)
+		dev_dbg(&mma->client->dev, "previous read not completed\n");
+
+	buf[0] =3D mma->read(mma, MMA8653FC_OUT_X_MSB);
+	buf[1] =3D mma->read(mma, MMA8653FC_OUT_X_LSB);
+	buf[2] =3D mma->read(mma, MMA8653FC_OUT_Y_MSB);
+	buf[3] =3D mma->read(mma, MMA8653FC_OUT_Y_LSB);
+	buf[4] =3D mma->read(mma, MMA8653FC_OUT_Z_MSB);
+	buf[5] =3D mma->read(mma, MMA8653FC_OUT_Z_LSB);
+
+	mutex_lock(&mma->mutex);
+	/* move from registers to s16 */
+	mma->saved.x =3D (buf[1] | (buf[0] << 8)) >> 6;
+	mma->saved.y =3D (buf[3] | (buf[2] << 8)) >> 6;
+	mma->saved.z =3D (buf[5] | (buf[4] << 8)) >> 6;
+	mma->saved.x =3D sign_extend32(mma->saved.x, 9);
+	mma->saved.y =3D sign_extend32(mma->saved.y, 9);
+	mma->saved.z =3D sign_extend32(mma->saved.z, 9);
+
+	/* calc g, see data sheet and application note */
+	switch (mma->pdata.range) {
+	case DYN_RANGE_2G:
+		mma->saved.x =3D le16_to_cpu((1000 * mma->saved.x +
+					    INCR_2G) >> SHIFT_2G);
+		mma->saved.y =3D le16_to_cpu((1000 * mma->saved.y +
+					   INCR_2G) >> SHIFT_2G);
+		mma->saved.z =3D le16_to_cpu((1000 * mma->saved.z +
+					   INCR_2G) >> SHIFT_2G);
+		break;
+	case DYN_RANGE_4G:
+		mma->saved.x =3D le16_to_cpu((1000 * mma->saved.x +
+					   INCR_4G) >> SHIFT_4G);
+		mma->saved.y =3D le16_to_cpu((1000 * mma->saved.y +
+					   INCR_4G) >> SHIFT_4G);
+		mma->saved.z =3D le16_to_cpu((1000 * mma->saved.z +
+					   INCR_4G) >> SHIFT_4G);
+		break;
+	case DYN_RANGE_8G:
+		mma->saved.x =3D le16_to_cpu((1000 * mma->saved.x +
+					   INCR_8G) >> SHIFT_8G);
+		mma->saved.y =3D le16_to_cpu((1000 * mma->saved.y +
+					   INCR_8G) >> SHIFT_8G);
+		mma->saved.z =3D le16_to_cpu((1000 * mma->saved.z +
+					   INCR_8G) >> SHIFT_8G);
+		break;
+	default:
+		dev_err(&mma->client->dev, "internal data corrupt\n");
+	}
+	mutex_unlock(&mma->mutex);
+}
+
+static void mma8653fc_get_orientation(struct mma8653fc *mma, u8 byte)
+{
+	if ((byte & LAPO_HIGH) && !(LAPO_LOW))
+		mma->orientation =3D 'r'; /* landscape right */
+	if (!(byte & LAPO_HIGH) && (byte & LAPO_LOW))
+		mma->orientation =3D 'd'; /* portrait down */
+	if (!(byte & LAPO_HIGH) && !(byte & LAPO_LOW))
+		mma->orientation =3D 'u'; /* portrait up */
+	if ((byte & LAPO_HIGH) && (byte & LAPO_LOW))
+		mma->orientation =3D 'l'; /* landscape left */
+
+	if (byte & BAFRO)
+		mma->bafro =3D 'b'; /* back facing */
+	else
+		mma->bafro =3D 'f'; /* front facing */
+}
+
+static irqreturn_t mma8653fc_irq(int irq, void *handle)
+{
+	struct mma8653fc *mma =3D handle;
+	u8 int_src;
+	u8 byte;
+
+	int_src =3D mma->read(mma, MMA8653FC_INT_SOURCE);
+	if (int_src & SRC_DRDY)
+		/* data ready handle */
+	if (int_src & SRC_FF_MT) {
+		/* freefall/motion change handle */
+		dev_dbg(&mma->client->dev,
+			"freefall or motion change\n");
+		byte =3D mma->read(mma, MMA8653FC_FF_MT_SRC);
+	}
+	if (int_src & SRC_LNDPRT) {
+		/* landscape/portrait change handle */
+		dev_dbg(&mma->client->dev,
+			"landscape / portrait change\n");
+		byte =3D mma->read(mma, MMA8653FC_PL_STATUS);
+		mma8653fc_get_orientation(mma, byte);
+	}
+	if (int_src & SRC_ASLP)
+		/* autosleep change handle */
+	mma8653fc_get_triple(mma);
+
+	sysfs_notify(&mma->client->dev.kobj, NULL, "position");
+
+	return IRQ_HANDLED;
+}
+
+static void __mma8653fc_enable(struct mma8653fc *mma)
+{
+	u8 byte;
+
+	byte =3D mma->read(mma, MMA8653FC_CTRL_REG1);
+	mma->write(mma, MMA8653FC_CTRL_REG1, byte | ACTIVE_BIT);
+}
+
+static void __mma8653fc_disable(struct mma8653fc *mma)
+{
+	u8 byte;
+
+	byte =3D mma->read(mma, MMA8653FC_CTRL_REG1);
+	mma->write(mma, MMA8653FC_CTRL_REG1, byte & ~ACTIVE_BIT);
+}
+
+static ssize_t mma8653fc_standby_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct i2c_client *client =3D to_i2c_client(dev);
+	struct mma8653fc *mma =3D i2c_get_clientdata(client);
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n", mma->standby);
+}
+
+static ssize_t mma8653fc_standby_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct i2c_client *client =3D to_i2c_client(dev);
+	struct mma8653fc *mma =3D i2c_get_clientdata(client);
+	unsigned int val;
+	int error;
+
+	error =3D kstrtouint(buf, 10, &val);
+	if (error)
+		return error;
+
+	mutex_lock(&mma->mutex);
+
+	if (val) {
+		if (!mma->standby)
+			__mma8653fc_disable(mma);
+	} else {
+		if (mma->standby)
+			__mma8653fc_enable(mma);
+	}
+
+	mma->standby =3D !!val;
+
+	mutex_unlock(&mma->mutex);
+
+	return count;
+}
+
+static DEVICE_ATTR(standby, 0664, mma8653fc_standby_show,
+				  mma8653fc_standby_store);
+
+static ssize_t mma8653fc_currentmode_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct i2c_client *client =3D to_i2c_client(dev);
+	struct mma8653fc *mma =3D i2c_get_clientdata(client);
+	ssize_t count;
+	u8 byte;
+
+	byte =3D mma->read(mma, MMA8653FC_SYSMOD);
+	if (byte < 0)
+		return byte;
+
+	switch (byte) {
+	case STATE_STANDBY:
+		count =3D scnprintf(buf, PAGE_SIZE, "standby\n");
+		break;
+	case STATE_WAKE:
+		count =3D scnprintf(buf, PAGE_SIZE, "wake\n");
+		break;
+	case STATE_SLEEP:
+		count =3D scnprintf(buf, PAGE_SIZE, "sleep\n");
+		break;
+	default:
+		count =3D scnprintf(buf, PAGE_SIZE, "unknown\n");
+	}
+	return count;
+}
+static DEVICE_ATTR(currentmode, S_IRUGO, mma8653fc_currentmode_show, N=
ULL);
+
+static ssize_t mma8653fc_position_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct i2c_client *client =3D to_i2c_client(dev);
+	struct mma8653fc *mma =3D i2c_get_clientdata(client);
+	ssize_t count;
+	u8 byte;
+
+	if (!mma->irq) {
+		byte =3D mma->read(mma, MMA8653FC_PL_STATUS);
+		if (byte & NEWLP)
+			mma8653fc_get_orientation(mma, byte);
+
+		byte =3D mma->read(mma, MMA8653FC_STATUS);
+		if (byte & ZYXDR)
+			mma8653fc_get_triple(mma);
+
+		msleep(20);
+		dev_dbg(&client->dev, "data polled\n");
+	}
+	mutex_lock(&mma->mutex);
+	count =3D scnprintf(buf, PAGE_SIZE, "%d %d %d %c %c\n",
+			mma->saved.x, mma->saved.y, mma->saved.z,
+			mma->orientation, mma->bafro);
+	mutex_unlock(&mma->mutex);
+
+	return count;
+}
+static DEVICE_ATTR(position, S_IRUGO, mma8653fc_position_show, NULL);
+
+static struct attribute *mma8653fc_attributes[] =3D {
+	&dev_attr_position.attr,
+	&dev_attr_standby.attr,
+	&dev_attr_currentmode.attr,
+	NULL,
+};
+
+static const struct attribute_group mma8653fc_attr_group =3D {
+	.attrs =3D mma8653fc_attributes,
+};
+
+static u8 mma8653fc_read(struct mma8653fc *mma, unsigned char reg)
+{
+	u8 val;
+
+	val =3D i2c_smbus_read_byte_data(mma->client, reg);
+	if (val < 0) {
+		dev_err(&mma->client->dev,
+			"failed to read %x register\n", reg);
+	}
+	return val;
+}
+
+static void mma8653fc_write(struct mma8653fc *mma, unsigned char reg,
+			   unsigned char val)
+{
+	int ret;
+
+	ret =3D i2c_smbus_write_byte_data(mma->client, reg, val);
+	if (ret) {
+		dev_err(&mma->client->dev,
+			"failed to write %x register\n", reg);
+	}
+}
+
+static const struct of_device_id mma8653fc_dt_ids[] =3D {
+	{ .compatible =3D "fsl,mma8653fc", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, mma8653fc_dt_ids);
+
+static const struct mma8653fc_pdata *mma8653fc_probe_dt(struct device =
*dev)
+{
+	struct mma8653fc_pdata *pdata;
+	struct device_node *node =3D dev->of_node;
+	const struct of_device_id *match;
+	u32 testu32;
+	s32 tests32;
+
+	if (!node) {
+		dev_err(dev, "no associated DT data\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	match =3D of_match_device(mma8653fc_dt_ids, dev);
+	if (!match) {
+		dev_err(dev, "unknown device model\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	pdata =3D devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return ERR_PTR(-ENOMEM);
+
+	*pdata =3D mma8653fc_default_init;
+
+	/* overwrite from dts */
+	testu32 =3D pdata->x_axis_offset;
+	tests32 =3D 0;
+	of_property_read_u32(node, "x-offset", &testu32);
+	tests32 =3D testu32 - DEFAULT_OFF;
+	if ((tests32) && (tests32 <=3D DEFAULT_OFF) &&
+	    (tests32 >=3D -DEFAULT_OFF)) {
+		dev_info(dev, "use %dmg offset on X axis\n", tests32);
+		/* calc register value, resolution: 1.96mg */
+		pdata->x_axis_offset =3D (s8) (tests32 / 2);
+	}
+	testu32 =3D pdata->y_axis_offset;
+	tests32 =3D 0;
+	of_property_read_u32(node, "y-offset", &testu32);
+	tests32 =3D testu32 - DEFAULT_OFF;
+	if ((tests32) && (tests32 <=3D DEFAULT_OFF) &&
+	    (tests32 >=3D -DEFAULT_OFF)) {
+		dev_info(dev, "use %dmg offset on Y axis\n", tests32);
+		pdata->y_axis_offset =3D (s8) (tests32 / 2);
+	}
+	testu32 =3D pdata->z_axis_offset;
+	tests32 =3D 0;
+	of_property_read_u32(node, "z-offset", &testu32);
+	tests32 =3D testu32 - DEFAULT_OFF;
+	if ((tests32) && (tests32 <=3D DEFAULT_OFF) &&
+	    (tests32 >=3D -DEFAULT_OFF)) {
+		dev_info(dev, "use %dmg offset on Z axis\n", tests32);
+		pdata->z_axis_offset =3D (s8) (tests32 / 2);
+	}
+
+	testu32 =3D 0;
+	of_property_read_u32(node, "dynamic-range", &testu32);
+	if ((testu32) && (testu32 !=3D 2) && (testu32 !=3D 4) && (testu32 !=3D=
 8)) {
+		dev_warn(dev, "wrong value for full scale range in dtb\n");
+	} else {
+		if (testu32)
+			pdata->range =3D testu32;
+	}
+
+	if (of_property_read_bool(node, "auto-wake-sleep"))
+		pdata->auto_wake_sleep =3D true;
+
+	if (of_property_read_bool(node, "int1"))
+		pdata->int1 =3D true;
+
+	if (of_property_read_bool(node, "motion-mode"))
+		pdata->motion_mode =3D true;
+
+	if (of_property_read_bool(node, "ir-data-ready"))
+		pdata->int_src_data_ready =3D true;
+
+	if (of_property_read_bool(node, "ir-freefall-motion-x"))
+		pdata->int_src_ff_mt_x =3D true;
+
+	if (of_property_read_bool(node, "ir-freefall-motion-y"))
+		pdata->int_src_ff_mt_y =3D true;
+
+	if (of_property_read_bool(node, "ir-freefall-motion-z"))
+		pdata->int_src_ff_mt_z =3D true;
+
+	if (of_property_read_bool(node, "ir-auto-wake"))
+		pdata->int_src_aslp =3D true;
+
+	if (of_property_read_bool(node, "ir-landscape-portrait"))
+		pdata->int_src_lndprt =3D true;
+
+	testu32 =3D 0;
+	of_property_read_u32(node, "irq-threshold", &testu32);
+	/* always uses maximum range +/- 8000g, resolution 63mg */
+	if ((testu32 <=3D 8000) && (testu32 > 0)) {
+		dev_dbg(dev, "use freefall / motion threshold %dmg\n",
+			 testu32);
+		/* calculate register value from mg */
+		pdata->freefall_motion_thr =3D (testu32 / 63) + 1;
+	}
+
+	return pdata;
+}
+static int mma8653fc_i2c_probe(struct i2c_client *client,
+				       const struct i2c_device_id *id)
+{
+	struct mma8653fc *mma;
+	const struct mma8653fc_pdata *pdata;
+	int err;
+	u8 byte;
+
+	err =3D i2c_check_functionality(client->adapter,
+			I2C_FUNC_SMBUS_BYTE_DATA);
+	if (!err) {
+		dev_err(&client->dev, "SMBUS Byte Data not Supported\n");
+		return -EIO;
+	}
+
+	mma =3D devm_kzalloc(&client->dev, sizeof(*mma), GFP_KERNEL);
+	if (!mma)
+		err =3D -ENOMEM;
+
+	pdata =3D dev_get_platdata(&client->dev);
+	if (!pdata) {
+		pdata =3D mma8653fc_probe_dt(&client->dev);
+		if (IS_ERR(pdata)) {
+			err =3D PTR_ERR(pdata);
+			dev_err(&client->dev, "pdata from DT failed\n");
+			return err;
+		}
+	}
+	mma->pdata =3D *pdata;
+	pdata =3D &mma->pdata;
+	mma->client =3D client;
+	mma->read =3D &mma8653fc_read;
+	mma->write =3D &mma8653fc_write;
+
+	mutex_init(&mma->mutex);
+
+	i2c_set_clientdata(client, mma);
+
+	err =3D sysfs_create_group(&client->dev.kobj, &mma8653fc_attr_group);
+	if (err)
+		return err;
+
+	byte =3D mma->read(mma, MMA8653FC_WHO_AM_I);
+	if (byte !=3D MMA8653FC_DEVICE_ID) {
+		dev_err(&client->dev, "wrong device for driver\n");
+		return -ENODEV;
+	}
+	dev_info(&client->dev, "loading driver for device id %x\n", byte);
+
+	mma->irq =3D irq_of_parse_and_map(client->dev.of_node, 0);
+	if (!mma->irq) {
+		dev_err(&client->dev, "Unable to parse or map IRQ\n");
+		goto no_irq;
+	}
+
+	err =3D irq_set_irq_type(mma->irq, IRQ_TYPE_EDGE_FALLING);
+	if (err) {
+		dev_err(&client->dev, "set_irq_type failed\n");
+		return err;
+	}
+
+	err =3D devm_request_threaded_irq(&client->dev, mma->irq, NULL,
+					mma8653fc_irq, IRQF_ONESHOT,
+					dev_name(&mma->client->dev), mma);
+	if (err) {
+		dev_err(&client->dev, "irq %d busy?\n", mma->irq);
+		return err;
+	}
+
+	mma->write(mma, MMA8653FC_CTRL_REG2, SOFT_RESET);
+
+	__mma8653fc_disable(mma);
+	mma->standby =3D true;
+
+	/* enable desired interrupts */
+	mma->orientation =3D '\0';
+	mma->bafro =3D '\0';
+	byte =3D 0;
+	if (pdata->int_src_data_ready) {
+		byte |=3D INT_EN_DRDY;
+		dev_dbg(&client->dev, "DATA READY interrupt source enabled\n");
+	}
+	if (pdata->int_src_ff_mt_x || pdata->int_src_ff_mt_y ||
+	    pdata->int_src_ff_mt_z) {
+		byte |=3D INT_EN_FF_MT;
+		dev_dbg(&client->dev, "FF MT interrupt source enabled\n");
+	}
+	if (pdata->int_src_lndprt) {
+		mma->write(mma, MMA8653FC_PL_CFG, PL_EN);
+		byte |=3D INT_EN_LNDPRT;
+		dev_dbg(&client->dev, "LNDPRT interrupt source enabled\n");
+	}
+	if (pdata->int_src_aslp) {
+		byte |=3D INT_EN_ASLP;
+		dev_dbg(&client->dev, "ASLP interrupt source enabled\n");
+	}
+	mma->write(mma, MMA8653FC_CTRL_REG4, byte);
+
+	/* force everything to line 1 */
+	if (pdata->int1) {
+		mma->write(mma, MMA8653FC_CTRL_REG5,
+			   (INT_CFG_ASLP | INT_CFG_LNDPRT |
+			   INT_CFG_FF_MT | INT_CFG_DRDY));
+		dev_dbg(&client->dev, "using interrupt line 1\n");
+	}
+no_irq:
+	/* range mode */
+	byte =3D mma->read(mma, MMA8653FC_XYZ_DATA_CFG);
+	byte &=3D ~RANGE_MASK;
+	switch (pdata->range) {
+	case DYN_RANGE_2G:
+		byte |=3D RANGE2G;
+		dev_dbg(&client->dev, "use 2g range\n");
+		break;
+	case DYN_RANGE_4G:
+		byte |=3D RANGE4G;
+		dev_dbg(&client->dev, "use 4g range\n");
+		break;
+	case DYN_RANGE_8G:
+		byte |=3D RANGE8G;
+		dev_dbg(&client->dev, "use 8g range\n");
+		break;
+	default:
+		dev_err(&client->dev, "wrong range mode value\n");
+		return -EINVAL;
+	}
+	mma->write(mma, MMA8653FC_XYZ_DATA_CFG, byte);
+
+	/* data calibration offsets */
+	if (pdata->x_axis_offset)
+		mma->write(mma, MMA8653FC_OFF_X, pdata->x_axis_offset);
+	if (pdata->y_axis_offset)
+		mma->write(mma, MMA8653FC_OFF_Y, pdata->y_axis_offset);
+	if (pdata->z_axis_offset)
+		mma->write(mma, MMA8653FC_OFF_Z, pdata->z_axis_offset);
+
+	/* if autosleep, wake on both landscape and motion changes */
+	if (pdata->auto_wake_sleep) {
+		byte =3D 0;
+		byte |=3D WAKE_LNDPRT;
+		byte |=3D WAKE_FF_MT;
+		mma->write(mma, MMA8653FC_CTRL_REG3, byte);
+		mma->write(mma, MMA8653FC_CTRL_REG2, SLPE);
+		dev_dbg(&client->dev, "auto sleep enabled\n");
+	}
+
+	/* data rates */
+	byte =3D 0;
+	byte =3D mma->read(mma, MMA8653FC_CTRL_REG1);
+	byte &=3D ~ODR_MASK;
+	byte |=3D ODR_DEFAULT;
+	byte &=3D ~ASLP_RATE_MASK;
+	byte |=3D ASLP_RATE_DEFAULT;
+	mma->write(mma, MMA8653FC_CTRL_REG1, byte);
+
+	/* freefall / motion config */
+	byte =3D 0;
+	if (pdata->motion_mode) {
+		byte |=3D FF_MT_CFG_OAE;
+		dev_dbg(&client->dev, "detect motion instead of freefall\n");
+	}
+	byte |=3D FF_MT_CFG_ELE;
+	if (pdata->int_src_ff_mt_x)
+		byte |=3D FF_MT_CFG_XEFE;
+	if (pdata->int_src_ff_mt_y)
+		byte |=3D FF_MT_CFG_YEFE;
+	if (pdata->int_src_ff_mt_z)
+		byte |=3D FF_MT_CFG_ZEFE;
+	mma->write(mma, MMA8653FC_FF_MT_CFG, byte);
+
+	if (pdata->freefall_motion_thr) {
+		mma->write(mma, MMA8653FC_FF_MT_THS,
+			   pdata->freefall_motion_thr);
+		/* calculate back to mg */
+		dev_dbg(&client->dev, "threshold set to %dmg\n",
+			 (63 * pdata->freefall_motion_thr) - 1);
+	}
+
+	return 0;
+}
+
+static int mma8653fc_remove(struct i2c_client *client)
+{
+	dev_dbg(&client->dev, "unregistered accelerometer\n");
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int mma8653fc_suspend(struct device *dev)
+{
+	struct i2c_client *client =3D to_i2c_client(dev);
+	struct mma8653fc *mma =3D i2c_get_clientdata(client);
+
+	__mma8653fc_disable(mma);
+
+	return 0;
+}
+
+static int mma8653fc_resume(struct device *dev)
+{
+	struct i2c_client *client =3D to_i2c_client(dev);
+	struct mma8653fc *mma =3D i2c_get_clientdata(client);
+
+	__mma8653fc_enable(mma);
+
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(mma8653fc_pm_ops, mma8653fc_suspend, mma8653f=
c_resume);
+#define MMA8653FC_PM_OPS (&mma8653fc_pm_ops)
+#else
+#define MMA8653FC_PM_OPS NULL
+#endif
+
+static const struct i2c_device_id mma8653fc_id[] =3D {
+	{ DRV_NAME, 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, mma8653fc_id);
+
+static struct i2c_driver mma8653fc_driver =3D {
+	.driver =3D {
+		.name =3D DRV_NAME,
+		.owner =3D THIS_MODULE,
+		.of_match_table =3D mma8653fc_dt_ids,
+		.pm =3D MMA8653FC_PM_OPS,
+	},
+	.probe    =3D mma8653fc_i2c_probe,
+	.remove   =3D mma8653fc_remove,
+	.id_table =3D mma8653fc_id,
+};
+
+module_i2c_driver(mma8653fc_driver);
+
+MODULE_AUTHOR("Martin Kepplinger <martin.kepplinger@theobroma-systems.=
com");
+MODULE_DESCRIPTION("Freescale's MMA8653FC Three-Axis Accelerometer I2C=
 Driver");
+MODULE_LICENSE("GPL");
--=20
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
