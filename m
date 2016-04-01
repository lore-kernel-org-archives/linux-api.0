From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v5 10/10] MAINTAINERS: Update ARM Versatile Express platform entry
Date: Fri,  1 Apr 2016 15:03:01 +0100
Message-ID: <1459519381-34441-11-git-send-email-vladimir.murzin@arm.com>
References: <1459519381-34441-1-git-send-email-vladimir.murzin@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459519381-34441-1-git-send-email-vladimir.murzin@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, linux@arm.linux.org.uk, gregkh@linuxfoundation.org, daniel.lezcano@linaro.org, tglx@linutronix.de, liviu.dudau@arm.com, sudeep.holla@arm.com, lorenzo.pieralisi@arm.com
Cc: mark.rutland@arm.com, gnomes@lxorguk.ukuu.org.uk, peter@hurleysoftware.com, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, andy.shevchenko@gmail.com, robh+dt@kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
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
index 03e00c7..9f07e7c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1771,6 +1771,7 @@ F:	*/*/vexpress*
 F:	*/*/*/vexpress*
 F:	drivers/clk/versatile/clk-vexpress-osc.c
 F:	drivers/clocksource/versatile.c
+N:	mps2
 
 ARM/VFP SUPPORT
 M:	Russell King <linux@arm.linux.org.uk>
-- 
1.7.9.5
