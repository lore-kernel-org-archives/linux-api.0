From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH v2 17/22] media: au0828 disable tuner to demod link
Date: Wed,  3 Feb 2016 21:03:49 -0700
Message-ID: <ce0a0d11f4ebe26b7d7ff7011cf98c4b64892905.1454557589.git.shuahkh@osg.samsung.com>
References: <cover.1454557589.git.shuahkh@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1454557589.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1454557589.git.shuahkh@osg.samsung.com>
References: <cover.1454557589.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net, johan@oljud.se, klock.android@gmail.com, nenggun.kim@samsung.com, j.anaszewski@samsung.com, geliangtang
List-Id: linux-api@vger.kernel.org

Change au0828_create_media_graph() to find and disable
tuner and demod link. This helps avoid an additional
disable step when tuner is requested by video or audio.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 868babe..b02a122 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -254,7 +254,7 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_device *mdev = dev->media_dev;
 	struct media_entity *entity;
-	struct media_entity *tuner = NULL, *decoder = NULL;
+	struct media_entity *tuner = NULL, *decoder = NULL, *demod = NULL;
 	int i, ret;
 
 	if (!mdev)
@@ -268,6 +268,9 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
 		case MEDIA_ENT_F_ATV_DECODER:
 			decoder = entity;
 			break;
+		case MEDIA_ENT_F_DTV_DEMOD:
+			demod = entity;
+			break;
 		}
 	}
 
@@ -322,6 +325,21 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
 			break;
 		}
 	}
+
+	/*
+	 * Disable tuner to demod link to avoid disable step
+	 * when tuner is requested by video or audio
+	*/
+	if (tuner && demod) {
+		struct media_link *link;
+
+		list_for_each_entry(link, &demod->links, list) {
+			if (link->sink->entity == demod &&
+			    link->source->entity == tuner) {
+				media_entity_setup_link(link, 0);
+			}
+		}
+	}
 #endif
 	return 0;
 }
-- 
2.5.0
