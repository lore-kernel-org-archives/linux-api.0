From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH 19/31] media: au0828 handle media_init and media_register window
Date: Wed,  6 Jan 2016 13:27:08 -0700
Message-ID: <a275989c452bd997b1919740098990c97b126886.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <cover.1452105878.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net, johan@oljud.se, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-api@vger.kernel.orga
List-Id: linux-api@vger.kernel.org

Media device initialization and registration is split
and there is a window between media device init and
media device register during usb probe. au0828 bridge
driver has to coordinate managed media device init and
register with snd-usb-audio. Checking if the device is
registered during media device init could result in the
two drivers stepping on each other for media init. Change
the media device init in au0828 to check if media device
dev is set as this happens at the end of media device
init in au0828 and snd-usb-audio. Change register step
in au0828 to check if media device in registered.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 1f97fc0..6ef177c 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -229,7 +229,8 @@ static int au0828_media_device_init(struct au0828_dev *dev,
 	if (!mdev)
 		return -ENOMEM;
 
-	if (!media_devnode_is_registered(&mdev->devnode)) {
+	/* check if media device is already initialized */
+	if (!mdev->dev) {
 		mdev->dev = &udev->dev;
 
 		if (udev->product)
@@ -342,6 +343,27 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
 	return 0;
 }
 
+static int au0828_media_device_register(struct au0828_dev *dev,
+					struct usb_device *udev)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	int ret;
+
+	if (dev->media_dev &&
+		!media_devnode_is_registered(&dev->media_dev->devnode)) {
+
+		/* register media device */
+		ret = media_device_register(dev->media_dev);
+		if (ret) {
+			dev_err(&udev->dev,
+				"Media Device Register Error: %d\n", ret);
+			return ret;
+		}
+	}
+#endif
+	return 0;
+}
+
 static int au0828_usb_probe(struct usb_interface *interface,
 	const struct usb_device_id *id)
 {
@@ -469,7 +491,7 @@ static int au0828_usb_probe(struct usb_interface *interface,
 	}
 
 #ifdef CONFIG_MEDIA_CONTROLLER
-	retval = media_device_register(dev->media_dev);
+	retval = au0828_media_device_register(dev, usbdev);
 #endif
 
 done:
-- 
2.5.0
