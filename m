From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH 13/31] media: au0828 fix au0828_create_media_graph() entity checks
Date: Wed,  6 Jan 2016 13:27:02 -0700
Message-ID: <ab77ed92dafb05b262a33fcd827f35ad8be3d619.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <cover.1452105878.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net, johan@oljud.se, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-api@vger.kernel.orga
List-Id: linux-api@vger.kernel.org

au0828_create_media_graph() doesn't do any checks to determine,
if vbi_dev, vdev, and input entities have been registered prior
to creating pad links. Checking graph_obj.mdev field works as
the graph_obj.mdev field gets initialized in the entity register
interface. Fix it to check graph_obj.mdev field before creating
pad links.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index f46fb43..8ef7c71 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -291,20 +291,27 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
 		if (ret)
 			return ret;
 	}
-	ret = media_create_pad_link(decoder, AU8522_PAD_VID_OUT,
-				    &dev->vdev.entity, 0,
-				    MEDIA_LNK_FL_ENABLED);
-	if (ret)
-		return ret;
-	ret = media_create_pad_link(decoder, AU8522_PAD_VBI_OUT,
-				    &dev->vbi_dev.entity, 0,
-				    MEDIA_LNK_FL_ENABLED);
-	if (ret)
-		return ret;
+	if (dev->vdev.entity.graph_obj.mdev) {
+		ret = media_create_pad_link(decoder, AU8522_PAD_VID_OUT,
+					    &dev->vdev.entity, 0,
+					    MEDIA_LNK_FL_ENABLED);
+		if (ret)
+			return ret;
+	}
+	if (dev->vbi_dev.entity.graph_obj.mdev) {
+		ret = media_create_pad_link(decoder, AU8522_PAD_VBI_OUT,
+					    &dev->vbi_dev.entity, 0,
+					    MEDIA_LNK_FL_ENABLED);
+		if (ret)
+			return ret;
+	}
 
 	for (i = 0; i < AU0828_MAX_INPUT; i++) {
 		struct media_entity *ent = &dev->input_ent[i];
 
+		if (!ent->graph_obj.mdev)
+			continue;
+
 		if (AUVI_INPUT(i).type == AU0828_VMUX_UNDEFINED)
 			break;
 
-- 
2.5.0
