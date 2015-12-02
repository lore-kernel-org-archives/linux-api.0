From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v1 01/10] dt-bindings: document the MPS2 timer bindings
Date: Wed,  2 Dec 2015 09:33:01 +0000
Message-ID: <1449048790-25859-2-git-send-email-vladimir.murzin@arm.com>
References: <1449048790-25859-1-git-send-email-vladimir.murzin@arm.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449048790-25859-1-git-send-email-vladimir.murzin@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, linux@arm.linux.org.uk, gregkh@linuxfoundation.org, daniel.lezcano@linaro.org, tglx@linutronix.de, u.kleine-koenig@pengutronix.de, afaerber@suse.de, mcoquelin.stm32@gmail.com
Cc: Mark.Rutland@arm.com, Pawel.Moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, jslaby@suse.cz, robh+dt@kernel.org, devicetree@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This adds documentation of device tree bindings for the
timers found on ARM MPS2 platform.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/timer/arm,mps2-timer.txt   |   28 ++++++++++++++++=
++++
 1 file changed, 28 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/timer/arm,mps2-timer.=
txt

diff --git a/Documentation/devicetree/bindings/timer/arm,mps2-timer.txt b/D=
ocumentation/devicetree/bindings/timer/arm,mps2-timer.txt
new file mode 100644
index 0000000..48f84d7
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/arm,mps2-timer.txt
@@ -0,0 +1,28 @@
+ARM MPS2 timer
+
+The MPS2 platform has simple general-purpose 32 bits timers.
+
+Required properties:
+- compatible=09: Should be "arm,mps2-timer"
+- reg=09=09: Address and length of the register set
+- interrupts=09: Reference to the timer interrupt
+
+Required clocking property, have to be one of:
+- clocks=09  : The input clock of the timer
+- clock-frequency : The rate in HZ in input of the ARM MPS2 timer
+
+Examples:
+
+timer1: mps2-timer@40000000 {
+=09compatible =3D "arm,mps2-timer";
+=09reg =3D <0x40000000 0x1000>;
+=09interrupts =3D <8>;
+=09clocks =3D <&sysclk>;
+};
+
+timer2: mps2-timer@40001000 {
+=09compatible =3D "arm,mps2-timer";
+=09reg =3D <0x40001000 0x1000>;
+=09interrupts =3D <9>;
+=09clock-frequency =3D <25000000>;
+};
--=20
1.7.9.5
