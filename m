From: Cristina Moraru <cristina.moraru09@gmail.com>
Subject: [PATCH 2/5] iio: hmc5843: Swap suspend and resume implementations
Date: Mon,  8 Feb 2016 00:21:48 +0200
Message-ID: <1454883711-15489-3-git-send-email-cristina.moraru09@gmail.com>
References: <1454883711-15489-1-git-send-email-cristina.moraru09@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454883711-15489-1-git-send-email-cristina.moraru09@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jic23@kernel.org, knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net, gregkh@linuxfoundation.org, cristina.opriceana@gmail.com, marek@goldelico.com, sdliyong@gmail.com, linux-iio@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, tolga.ceylan@gmail.com, k.kozlowski@samsung.com, javier@osg.samsung.com, arnd@arndb.de, geert@linux-m68k.org, irina.tirdea@intel.com, daniel.baluta@intel.com, octavia.purdila@intel.com
Cc: Cristina Moraru <cristina.moraru09@gmail.com>
List-Id: linux-api@vger.kernel.org

Swap implementations of hmc5843_common_suspend and
hmc5843_common_resume functions for they have been
inversed. Device should go on SLEEP mode on suspend
and on CONTINUOUS mode on resume.

Signed-off-by: Cristina Moraru <cristina.moraru09@gmail.com>
---
 drivers/staging/iio/magnetometer/hmc5843_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/iio/magnetometer/hmc5843_core.c b/drivers/staging/iio/magnetometer/hmc5843_core.c
index 4e2a7ec..dca8d64 100644
--- a/drivers/staging/iio/magnetometer/hmc5843_core.c
+++ b/drivers/staging/iio/magnetometer/hmc5843_core.c
@@ -612,14 +612,14 @@ static const unsigned long hmc5843_scan_masks[] = {0x7, 0};
 int hmc5843_common_suspend(struct device *dev)
 {
 	return hmc5843_set_mode(iio_priv(dev_get_drvdata(dev)),
-			HMC5843_MODE_CONVERSION_CONTINUOUS);
+				HMC5843_MODE_SLEEP);
 }
 EXPORT_SYMBOL(hmc5843_common_suspend);
 
 int hmc5843_common_resume(struct device *dev)
 {
 	return hmc5843_set_mode(iio_priv(dev_get_drvdata(dev)),
-				HMC5843_MODE_SLEEP);
+		HMC5843_MODE_CONVERSION_CONTINUOUS);
 }
 EXPORT_SYMBOL(hmc5843_common_resume);
 
-- 
1.9.1
