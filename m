From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH REBASE 4.5 18/31] media: au0828 change to use Managed Media Controller API
Date: Thu, 21 Jan 2016 11:09:48 -0700
Message-ID: <a0c6c96b8dbb916752cfb2f2f34da3c3e0862bb3.1453336831.git.shuahkh@osg.samsung.com>
References: <cover.1453336830.git.shuahkh@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <cover.1453336830.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1453336830.git.shuahkh@osg.samsung.com>
References: <cover.1453336830.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net, johan@oljud.se, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-api@vger.kernel.orga
List-Id: linux-api@vger.kernel.org

Change au0828 to use Managed Media Controller API to coordinate
creating/deleting media device on parent usb device it shares
with the snd-usb-audio driver. With this change, au0828 uses
media_device_get_devres() to allocate a new media device devres
or return an existing one, if it finds one.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index d0fb40b..10c50f5 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -135,10 +135,10 @@ static void au0828_unregister_media_device(struct au0828_dev *dev)
 {
 
 #ifdef CONFIG_MEDIA_CONTROLLER
-	if (dev->media_dev) {
+	if (dev->media_dev &&
+		media_devnode_is_registered(&dev->media_dev->devnode)) {
 		media_device_unregister(dev->media_dev);
 		media_device_cleanup(dev->media_dev);
-		kfree(dev->media_dev);
 		dev->media_dev = NULL;
 	}
 #endif
@@ -224,23 +224,24 @@ static int au0828_media_device_init(struct au0828_dev *dev,
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_device *mdev;
 
-	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
+	mdev = media_device_get_devres(&udev->dev);
 	if (!mdev)
 		return -ENOMEM;
 
-	mdev->dev = &udev->dev;
+	if (!media_devnode_is_registered(&mdev->devnode)) {
+		mdev->dev = &udev->dev;
 
-	if (!dev->board.name)
-		strlcpy(mdev->model, "unknown au0828", sizeof(mdev->model));
-	else
-		strlcpy(mdev->model, dev->board.name, sizeof(mdev->model));
-	if (udev->serial)
-		strlcpy(mdev->serial, udev->serial, sizeof(mdev->serial));
-	strcpy(mdev->bus_info, udev->devpath);
-	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
-	mdev->driver_version = LINUX_VERSION_CODE;
+		if (udev->product)
+			strlcpy(mdev->model, udev->product,
+				sizeof(mdev->model));
+		if (udev->serial)
+			strlcpy(mdev->serial, udev->serial,
+				sizeof(mdev->serial));
+		strcpy(mdev->bus_info, udev->devpath);
+		mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
 
-	media_device_init(mdev);
+		media_device_init(mdev);
+	}
 
 	dev->media_dev = mdev;
 #endif
-- 
2.5.0
