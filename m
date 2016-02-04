From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH v2 18/22] media: au0828 Use au8522_media_pads enum for pad defines
Date: Wed,  3 Feb 2016 21:03:50 -0700
Message-ID: <3fff49f15bbf830fd7826f4ec93af75929d49eab.1454557589.git.shuahkh@osg.samsung.com>
References: <cover.1454557589.git.shuahkh@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1454557589.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1454557589.git.shuahkh@osg.samsung.com>
References: <cover.1454557589.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net, johan@oljud.se, klock.android@gmail.com, nenggun.kim@samsung.com, j.anaszewski@samsung.com, geliangtang
List-Id: linux-api@vger.kernel.org

Change au0828-core to use au8522_media_pads enum defines
instead of hard-coding the pad values.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index b02a122..92d22ed 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -20,6 +20,7 @@
  */
 
 #include "au0828.h"
+#include "au8522.h"
 
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -287,11 +288,13 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
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
