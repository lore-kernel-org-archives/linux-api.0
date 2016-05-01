From: "Andrew F. Davis" <afd@ti.com>
Subject: [PATCH 02/13] iio: health/afe440x: Remove of_match_ptr and ifdefs
Date: Sun, 1 May 2016 15:36:52 -0500
Message-ID: <1462135023-14445-3-git-send-email-afd@ti.com>
References: <1462135023-14445-1-git-send-email-afd@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462135023-14445-1-git-send-email-afd@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald <pmeerw@pmeerw.net>
Cc: linux-iio@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, "Andrew F. Davis" <afd@ti.com>
List-Id: linux-api@vger.kernel.org

The drivers DT tables are not built-in when OF is not enabled, this does
not save us enough to justify ugly ifdefs. Clean this up.

Signed-off-by: Andrew F. Davis <afd@ti.com>
---
 drivers/iio/health/afe4403.c | 4 +---
 drivers/iio/health/afe4404.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/iio/health/afe4403.c b/drivers/iio/health/afe4403.c
index 2094113..e3700cf 100644
--- a/drivers/iio/health/afe4403.c
+++ b/drivers/iio/health/afe4403.c
@@ -498,13 +498,11 @@ static const struct regmap_config afe4403_regmap_config = {
 	.volatile_table = &afe4403_volatile_table,
 };
 
-#ifdef CONFIG_OF
 static const struct of_device_id afe4403_of_match[] = {
 	{ .compatible = "ti,afe4403", },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, afe4403_of_match);
-#endif
 
 static int __maybe_unused afe4403_suspend(struct device *dev)
 {
@@ -694,7 +692,7 @@ MODULE_DEVICE_TABLE(spi, afe4403_ids);
 static struct spi_driver afe4403_spi_driver = {
 	.driver = {
 		.name = AFE4403_DRIVER_NAME,
-		.of_match_table = of_match_ptr(afe4403_of_match),
+		.of_match_table = afe4403_of_match,
 		.pm = &afe4403_pm_ops,
 	},
 	.probe = afe4403_probe,
diff --git a/drivers/iio/health/afe4404.c b/drivers/iio/health/afe4404.c
index 7127d03..783b9b4 100644
--- a/drivers/iio/health/afe4404.c
+++ b/drivers/iio/health/afe4404.c
@@ -469,13 +469,11 @@ static const struct regmap_config afe4404_regmap_config = {
 	.volatile_table = &afe4404_volatile_table,
 };
 
-#ifdef CONFIG_OF
 static const struct of_device_id afe4404_of_match[] = {
 	{ .compatible = "ti,afe4404", },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, afe4404_of_match);
-#endif
 
 static int __maybe_unused afe4404_suspend(struct device *dev)
 {
@@ -665,7 +663,7 @@ MODULE_DEVICE_TABLE(i2c, afe4404_ids);
 static struct i2c_driver afe4404_i2c_driver = {
 	.driver = {
 		.name = AFE4404_DRIVER_NAME,
-		.of_match_table = of_match_ptr(afe4404_of_match),
+		.of_match_table = afe4404_of_match,
 		.pm = &afe4404_pm_ops,
 	},
 	.probe = afe4404_probe,
-- 
2.8.1
