From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH 12/31] media: au0828 Use au8522_media_pads enum for pad defines
Date: Wed,  6 Jan 2016 13:27:01 -0700
Message-ID: <42ed5fee893ad2729f24862b52df92f6b4874421.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <cover.1452105878.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net, johan@oljud.se, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-api@vger.kernel.orga
List-Id: linux-api@vger.kernel.org

Change au0828-core to use au8522_media_pads enum defines
instead of hard-coding the pad values when it creates
media graph linking decode pads to other entities.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 101d329..f46fb43 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -20,6 +20,7 @@
  */
 
 #include "au0828.h"
+#include "au8522.h"
 
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -290,11 +291,13 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
 		if (ret)
 			return ret;
 	}
-	ret = media_create_pad_link(decoder, 1, &dev->vdev.entity, 0,
+	ret = media_create_pad_link(decoder, AU8522_PAD_VID_OUT,
+				    &dev->vdev.entity, 0,
 				    MEDIA_LNK_FL_ENABLED);
 	if (ret)
 		return ret;
-	ret = media_create_pad_link(decoder, 2, &dev->vbi_dev.entity, 0,
+	ret = media_create_pad_link(decoder, AU8522_PAD_VBI_OUT,
+				    &dev->vbi_dev.entity, 0,
 				    MEDIA_LNK_FL_ENABLED);
 	if (ret)
 		return ret;
-- 
2.5.0
