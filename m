From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v1 10/10] ARM: dts: introduce MPS2 AN399/AN400
Date: Wed,  2 Dec 2015 09:33:10 +0000
Message-ID: <1449048790-25859-11-git-send-email-vladimir.murzin@arm.com>
References: <1449048790-25859-1-git-send-email-vladimir.murzin@arm.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449048790-25859-1-git-send-email-vladimir.murzin@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, linux@arm.linux.org.uk, gregkh@linuxfoundation.org, daniel.lezcano@linaro.org, tglx@linutronix.de, u.kleine-koenig@pengutronix.de, afaerber@suse.de, mcoquelin.stm32@gmail.com
Cc: Mark.Rutland@arm.com, Pawel.Moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, jslaby@suse.cz, robh+dt@kernel.org, devicetree@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Application Notes 399 and 400 shares the same memory map and
features. Both are shipped with Cortex-M7 and have the same  peripheral
as AN385/AN386, but with different location of PSRAM and Ethernet
controller.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 arch/arm/boot/dts/Makefile       |    4 +-
 arch/arm/boot/dts/mps2-an399.dts |   92 ++++++++++++++++++++++++++++++++++=
++++
 2 files changed, 95 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/mps2-an399.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 4ef3720..6603a1f 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -237,7 +237,9 @@ dtb-$(CONFIG_ARCH_MMP) +=3D \
 dtb-$(CONFIG_MACH_MESON8B) +=3D \
 =09meson8b-mxq.dtb \
 =09meson8b-odroidc1.dtb
-dtb-$(CONFIG_ARCH_MPS2) +=3D mps2-an385.dtb
+dtb-$(CONFIG_ARCH_MPS2) +=3D \
+=09mps2-an385.dtb \
+=09mps2-an399.dtb
 dtb-$(CONFIG_ARCH_MOXART) +=3D \
 =09moxart-uc7112lx.dtb
 dtb-$(CONFIG_SOC_IMX1) +=3D \
diff --git a/arch/arm/boot/dts/mps2-an399.dts b/arch/arm/boot/dts/mps2-an39=
9.dts
new file mode 100644
index 0000000..e591d75
--- /dev/null
+++ b/arch/arm/boot/dts/mps2-an399.dts
@@ -0,0 +1,92 @@
+/*
+ * Copyright (C) 2015 ARM Limited
+ *
+ * Author: Vladimir Murzin <vladimir.murzin@arm.com>
+ *
+ * This file is dual-licensed: you can use it either under the terms
+ * of the GPL or the X11 license, at your option. Note that this dual
+ * licensing only applies to this file, and not this project as a
+ * whole.
+ *
+ *  a) This file is free software; you can redistribute it and/or
+ *     modify it under the terms of the GNU General Public License as
+ *     published by the Free Software Foundation; either version 2 of the
+ *     License, or (at your option) any later version.
+ *
+ *     This file is distributed in the hope that it will be useful,
+ *     but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *     GNU General Public License for more details.
+ *
+ * Or, alternatively,
+ *
+ *  b) Permission is hereby granted, free of charge, to any person
+ *     obtaining a copy of this software and associated documentation
+ *     files (the "Software"), to deal in the Software without
+ *     restriction, including without limitation the rights to use,
+ *     copy, modify, merge, publish, distribute, sublicense, and/or
+ *     sell copies of the Software, and to permit persons to whom the
+ *     Software is furnished to do so, subject to the following
+ *     conditions:
+ *
+ *     The above copyright notice and this permission notice shall be
+ *     included in all copies or substantial portions of the Software.
+ *
+ *     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *     EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
+ *     OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *     NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
+ *     HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
+ *     WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ *     FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ *     OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+/dts-v1/;
+
+#include "mps2.dtsi"
+
+/ {
+=09model =3D "ARM MPS2 Application Note 399/400";
+=09compatible =3D "arm,mps2";
+
+=09aliases {
+=09=09serial0 =3D &uart0;
+=09};
+
+=09chosen {
+=09=09bootargs =3D "rdinit=3D/sbin/init earlycon";
+=09=09stdout-path =3D "serial0:9600n8";
+=09};
+
+=09memory {
+=09=09device_type =3D "memory";
+=09=09reg =3D <0x60000000 0x1000000>;
+=09};
+
+
+=09ethernet@a0000000 {
+=09=09compatible =3D "smsc,lan9220", "smsc,lan9115";
+=09=09reg =3D <0xa0000000 0x10000>;
+=09=09interrupts =3D <13>;
+=09=09interrupt-parent =3D <&nvic>;
+=09=09smsc,irq-active-high;
+=09};
+};
+
+&uart0 {
+=09status =3D "okay";
+};
+
+
+&timer0 {
+=09status =3D "okay";
+};
+
+&timer1 {
+=09status =3D "okay";
+};
+
+&wdt {
+=09status =3D "okay";
+};
--=20
1.7.9.5
