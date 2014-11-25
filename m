From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Subject: [PATCH v4 7/8] MAINTAINERS: Include DA9150 files in Dialog Semiconductor
 support list.
Date: Tue, 25 Nov 2014 18:25:37 +0000
Message-ID: <4b02cb8422fee25f5bc7c456778b00c9cfd2158f.1416938054.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1416938054.git.Adam.Thomson.Opensource@diasemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <cover.1416938054.git.Adam.Thomson.Opensource@diasemi.com>
Sender: linux-pm-owner@vger.kernel.org
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>, Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org, Sebastian Reichel <sre@kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>, linux-api@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, support.opensource@diasemi.com
List-Id: linux-api@vger.kernel.org

Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 MAINTAINERS | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0ff630d..4d2c39a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2990,12 +2990,15 @@ S:	Supported
 F:	Documentation/hwmon/da90??
 F:	drivers/gpio/gpio-da90??.c
 F:	drivers/hwmon/da90??-hwmon.c
+F:	drivers/iio/adc/da91??-*.c
 F:	drivers/input/misc/da90??_onkey.c
 F:	drivers/input/touchscreen/da9052_tsi.c
 F:	drivers/leds/leds-da90??.c
 F:	drivers/mfd/da903x.c
 F:	drivers/mfd/da90??-*.c
+F:	drivers/mfd/da91??-*.c
 F:	drivers/power/da9052-battery.c
+F:	drivers/power/da91??-*.c
 F:	drivers/regulator/da903x.c
 F:	drivers/regulator/da9???-regulator.[ch]
 F:	drivers/rtc/rtc-da90??.c
@@ -3005,6 +3008,7 @@ F:	include/linux/mfd/da903x.h
 F:	include/linux/mfd/da9052/
 F:	include/linux/mfd/da9055/
 F:	include/linux/mfd/da9063/
+F:	include/linux/mfd/da9150/
 F:	include/sound/da[79]*.h
 F:	sound/soc/codecs/da[79]*.[ch]

--
1.9.3

