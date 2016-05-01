From: "Andrew F. Davis" <afd@ti.com>
Subject: [PATCH 06/13] iio: health/afe440x: Remove unneeded offset handling
Date: Sun, 1 May 2016 15:36:56 -0500
Message-ID: <1462135023-14445-7-git-send-email-afd@ti.com>
References: <1462135023-14445-1-git-send-email-afd@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462135023-14445-1-git-send-email-afd@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald <pmeerw@pmeerw.net>
Cc: linux-iio@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, "Andrew F. Davis" <afd@ti.com>
List-Id: linux-api@vger.kernel.org

No channel in the afe4403 driver has IIO_CHAN_INFO_OFFSET set so
remove the handlers for this.

Signed-off-by: Andrew F. Davis <afd@ti.com>
---
 drivers/iio/health/afe4403.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/iio/health/afe4403.c b/drivers/iio/health/afe4403.c
index bcff528..cac6090 100644
--- a/drivers/iio/health/afe4403.c
+++ b/drivers/iio/health/afe4403.c
@@ -293,14 +293,6 @@ static int afe4403_read_raw(struct iio_dev *indio_dev,
 			if (ret)
 				return ret;
 			return IIO_VAL_INT;
-		case IIO_CHAN_INFO_OFFSET:
-			ret = regmap_read(afe->regmap, reg_info.offreg,
-					  val);
-			if (ret)
-				return ret;
-			*val &= reg_info.mask;
-			*val >>= reg_info.shift;
-			return IIO_VAL_INT;
 		}
 		break;
 	case IIO_CURRENT:
@@ -333,15 +325,6 @@ static int afe4403_write_raw(struct iio_dev *indio_dev,
 	const struct afe440x_reg_info reg_info = afe4403_reg_info[chan->address];
 
 	switch (chan->type) {
-	case IIO_INTENSITY:
-		switch (mask) {
-		case IIO_CHAN_INFO_OFFSET:
-			return regmap_update_bits(afe->regmap,
-				reg_info.offreg,
-				reg_info.mask,
-				(val << reg_info.shift));
-		}
-		break;
 	case IIO_CURRENT:
 		switch (mask) {
 		case IIO_CHAN_INFO_RAW:
-- 
2.8.1
