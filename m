From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v5 01/10] dt-bindings: document the MPS2 timer bindings
Date: Fri,  1 Apr 2016 15:02:52 +0100
Message-ID: <1459519381-34441-2-git-send-email-vladimir.murzin@arm.com>
References: <1459519381-34441-1-git-send-email-vladimir.murzin@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459519381-34441-1-git-send-email-vladimir.murzin@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, linux@arm.linux.org.uk, gregkh@linuxfoundation.org, daniel.lezcano@linaro.org, tglx@linutronix.de, liviu.dudau@arm.com, sudeep.holla@arm.com, lorenzo.pieralisi@arm.com
Cc: mark.rutland@arm.com, gnomes@lxorguk.ukuu.org.uk, peter@hurleysoftware.com, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, andy.shevchenko@gmail.com, robh+dt@kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This adds documentation of device tree bindings for the
timers found on ARM MPS2 platform.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/timer/arm,mps2-timer.txt   |   28 ++++++++++++++++++++
 1 file changed, 28 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/timer/arm,mps2-timer.txt

diff --git a/Documentation/devicetree/bindings/timer/arm,mps2-timer.txt b/Documentation/devicetree/bindings/timer/arm,mps2-timer.txt
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
+- compatible	: Should be "arm,mps2-timer"
+- reg		: Address and length of the register set
+- interrupts	: Reference to the timer interrupt
+
+Required clocking property, have to be one of:
+- clocks	  : The input clock of the timer
+- clock-frequency : The rate in HZ in input of the ARM MPS2 timer
+
+Examples:
+
+timer1: mps2-timer@40000000 {
+	compatible = "arm,mps2-timer";
+	reg = <0x40000000 0x1000>;
+	interrupts = <8>;
+	clocks = <&sysclk>;
+};
+
+timer2: mps2-timer@40001000 {
+	compatible = "arm,mps2-timer";
+	reg = <0x40001000 0x1000>;
+	interrupts = <9>;
+	clock-frequency = <25000000>;
+};
-- 
1.7.9.5
