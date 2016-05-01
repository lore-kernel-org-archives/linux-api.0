From: "Andrew F. Davis" <afd@ti.com>
Subject: [PATCH 01/13] iio: health/afe440x: Fix kernel-doc format
Date: Sun, 1 May 2016 15:36:51 -0500
Message-ID: <1462135023-14445-2-git-send-email-afd@ti.com>
References: <1462135023-14445-1-git-send-email-afd@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462135023-14445-1-git-send-email-afd@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald <pmeerw@pmeerw.net>
Cc: linux-iio@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, "Andrew F. Davis" <afd@ti.com>
List-Id: linux-api@vger.kernel.org

Fix kernel-doc formatting for structs, and while we are making little
fixes, clarify the module description and update the copywrite.

Signed-off-by: Andrew F. Davis <afd@ti.com>
---
 drivers/iio/health/afe4403.c | 18 +++++++++---------
 drivers/iio/health/afe4404.c | 16 ++++++++--------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/iio/health/afe4403.c b/drivers/iio/health/afe4403.c
index 88e43f8..2094113 100644
--- a/drivers/iio/health/afe4403.c
+++ b/drivers/iio/health/afe4403.c
@@ -1,7 +1,7 @@
 /*
  * AFE4403 Heart Rate Monitors and Low-Cost Pulse Oximeters
  *
- * Copyright (C) 2015 Texas Instruments Incorporated - http://www.ti.com/
+ * Copyright (C) 2015-2016 Texas Instruments Incorporated - http://www.ti.com/
  *	Andrew F. Davis <afd@ti.com>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -103,13 +103,13 @@
 #define AFE4403_TIAGAIN_RES_NONE	0x7
 
 /**
- * struct afe4403_data
- * @dev - Device structure
- * @spi - SPI device handle
- * @regmap - Register map of the device
- * @regulator - Pointer to the regulator for the IC
- * @trig - IIO trigger for this device
- * @irq - ADC_RDY line interrupt number
+ * struct afe4403_data - AFE4403 device instance data
+ * @dev: Device structure
+ * @spi: SPI device handle
+ * @regmap: Register map of the device
+ * @regulator: Pointer to the regulator for the IC
+ * @trig: IIO trigger for this device
+ * @irq: ADC_RDY line interrupt number
  */
 struct afe4403_data {
 	struct device *dev;
@@ -704,5 +704,5 @@ static struct spi_driver afe4403_spi_driver = {
 module_spi_driver(afe4403_spi_driver);
 
 MODULE_AUTHOR("Andrew F. Davis <afd@ti.com>");
-MODULE_DESCRIPTION("TI AFE4403 Heart Rate and Pulse Oximeter");
+MODULE_DESCRIPTION("TI AFE4403 Heart Rate Monitor and Pulse Oximeter AFE");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/iio/health/afe4404.c b/drivers/iio/health/afe4404.c
index 5096a46..7127d03 100644
--- a/drivers/iio/health/afe4404.c
+++ b/drivers/iio/health/afe4404.c
@@ -1,7 +1,7 @@
 /*
  * AFE4404 Heart Rate Monitors and Low-Cost Pulse Oximeters
  *
- * Copyright (C) 2015 Texas Instruments Incorporated - http://www.ti.com/
+ * Copyright (C) 2015-2016 Texas Instruments Incorporated - http://www.ti.com/
  *	Andrew F. Davis <afd@ti.com>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -106,12 +106,12 @@
 #define AFE4404_TIA_GAIN_RES_2_M	0x7
 
 /**
- * struct afe4404_data
- * @dev - Device structure
- * @regmap - Register map of the device
- * @regulator - Pointer to the regulator for the IC
- * @trig - IIO trigger for this device
- * @irq - ADC_RDY line interrupt number
+ * struct afe4404_data - AFE4404 device instance data
+ * @dev: Device structure
+ * @regmap: Register map of the device
+ * @regulator: Pointer to the regulator for the IC
+ * @trig: IIO trigger for this device
+ * @irq: ADC_RDY line interrupt number
  */
 struct afe4404_data {
 	struct device *dev;
@@ -675,5 +675,5 @@ static struct i2c_driver afe4404_i2c_driver = {
 module_i2c_driver(afe4404_i2c_driver);
 
 MODULE_AUTHOR("Andrew F. Davis <afd@ti.com>");
-MODULE_DESCRIPTION("TI AFE4404 Heart Rate and Pulse Oximeter");
+MODULE_DESCRIPTION("TI AFE4404 Heart Rate Monitor and Pulse Oximeter AFE");
 MODULE_LICENSE("GPL v2");
-- 
2.8.1
