From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v4 10/10] MAINTAINERS: Update ARM Versatile Express platform entry
Date: Tue, 23 Feb 2016 14:34:28 +0000
Message-ID: <1456238068-25079-11-git-send-email-vladimir.murzin@arm.com>
References: <1456238068-25079-1-git-send-email-vladimir.murzin@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1456238068-25079-1-git-send-email-vladimir.murzin@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, linux@arm.linux.org.uk, gregkh@linuxfoundation.org, daniel.lezcano@linaro.org, tglx@linutronix.de, u.kleine-koenig@pengutronix.de, liviu.dudau@arm.com, sudeep.holla@arm.com, lorenzo.pieralisi@arm.com
Cc: mark.rutland@arm.com, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, jslaby@suse.cz, robh+dt@kernel.org, andy.shevchenko@gmail.com, gnomes@lxorguk.ukuu.org.uk, peter@hurleysoftware.com, devicetree@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This patch update ARM Versatile Express entry to cover bits needed for
Cortex-M Prototyping System (MPS2 platform). So patches for the latter
are collected by existing Vexpress and Juno maintainers (Liviu, Sudeep,
Lorenzo) and find their way upstream via Vexpess and/or Juno trees.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4978dc1..e827e3b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1726,6 +1726,7 @@ F:	*/*/vexpress*
 F:	*/*/*/vexpress*
 F:	drivers/clk/versatile/clk-vexpress-osc.c
 F:	drivers/clocksource/versatile.c
+N:	mps2
 
 ARM/VFP SUPPORT
 M:	Russell King <linux@arm.linux.org.uk>
-- 
1.7.9.5
