From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: [PATCH v3  03/15] dt-bindings: Document the ARM System timer bindings
Date: Thu, 12 Mar 2015 22:55:49 +0100
Message-ID: <1426197361-19290-4-git-send-email-maxime.coquelin@st.com>
References: <1426197361-19290-1-git-send-email-maxime.coquelin@st.com>
Return-path: <linux-gpio-owner@vger.kernel.org>
In-Reply-To: <1426197361-19290-1-git-send-email-maxime.coquelin@st.com>
Sender: linux-gpio-owner@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, afaerber@suse.de, geert@linux-m68k.org, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, stefan@agner.ch, pmeerw@pmeerw.net, pebolle@tiscali.nl
Cc: Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Joe Perches <joe@perches.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Rusty Russell <rusty@rustcorp.com.au>, Kees Cook <keescook@chromium.org>, Michal Marek <mmarek@suse.cz>, linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kerne
List-Id: linux-api@vger.kernel.org

From: Maxime Coquelin <mcoquelin.stm32@gmail.com>

This adds documentation of device tree bindings for the
ARM System timer.

Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
---
 .../devicetree/bindings/arm/armv7m_systick.txt     | 26 ++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/armv7m_systick.txt

diff --git a/Documentation/devicetree/bindings/arm/armv7m_systick.txt b/Documentation/devicetree/bindings/arm/armv7m_systick.txt
new file mode 100644
index 0000000..7cf4a24
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/armv7m_systick.txt
@@ -0,0 +1,26 @@
+* ARMv7M System Timer
+
+ARMv7-M includes a system timer, known as SysTick. Current driver only
+implements the clocksource feature.
+
+Required properties:
+- compatible	  : Should be "arm,armv7m-systick"
+- reg		  : The address range of the timer
+
+Required clocking property, have to be one of:
+- clocks	  : The input clock of the timer
+- clock-frequency : The rate in HZ in input of the ARM SysTick
+
+Examples:
+
+systick: timer@e000e010 {
+	compatible = "arm,armv7m-systick";
+	reg = <0xe000e010 0x10>;
+	clocks = <&clk_systick>;
+};
+
+systick: timer@e000e010 {
+	compatible = "arm,armv7m-systick";
+	reg = <0xe000e010 0x10>;
+	clock-frequency = <90000000>;
+};
-- 
1.9.1

