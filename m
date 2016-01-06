From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH 01/31] uapi/media.h: Declare interface types for ALSA
Date: Wed,  6 Jan 2016 13:26:50 -0700
Message-ID: <b1d228cdcc9246f7bfe28877e9f6bff174e94993.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <cover.1452105878.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net, johan@oljud.se, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-api@vger.kernel.org, alsa-devel@alsa-project.org
List-Id: linux-api@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Declare the interface types to be used on alsa for the new
G_TOPOLOGY ioctl.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-entity.c | 12 ++++++++++++
 include/uapi/linux/media.h   |  8 ++++++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index eb38bc3..6e02d19 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -65,6 +65,18 @@ static inline const char *intf_type(struct media_interface *intf)
 		return "v4l2-subdev";
 	case MEDIA_INTF_T_V4L_SWRADIO:
 		return "swradio";
+	case MEDIA_INTF_T_ALSA_PCM_CAPTURE:
+		return "pcm-capture";
+	case MEDIA_INTF_T_ALSA_PCM_PLAYBACK:
+		return "pcm-playback";
+	case MEDIA_INTF_T_ALSA_CONTROL:
+		return "alsa-control";
+	case MEDIA_INTF_T_ALSA_COMPRESS:
+		return "compress";
+	case MEDIA_INTF_T_ALSA_RAWMIDI:
+		return "rawmidi";
+	case MEDIA_INTF_T_ALSA_HWDEP:
+		return "hwdep";
 	default:
 		return "unknown-intf";
 	}
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index cacfceb..75cbe92 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -252,6 +252,7 @@ struct media_links_enum {
 
 #define MEDIA_INTF_T_DVB_BASE	0x00000100
 #define MEDIA_INTF_T_V4L_BASE	0x00000200
+#define MEDIA_INTF_T_ALSA_BASE	0x00000300
 
 /* Interface types */
 
@@ -267,6 +268,13 @@ struct media_links_enum {
 #define MEDIA_INTF_T_V4L_SUBDEV (MEDIA_INTF_T_V4L_BASE + 3)
 #define MEDIA_INTF_T_V4L_SWRADIO (MEDIA_INTF_T_V4L_BASE + 4)
 
+#define MEDIA_INTF_T_ALSA_PCM_CAPTURE   (MEDIA_INTF_T_ALSA_BASE)
+#define MEDIA_INTF_T_ALSA_PCM_PLAYBACK  (MEDIA_INTF_T_ALSA_BASE + 1)
+#define MEDIA_INTF_T_ALSA_CONTROL       (MEDIA_INTF_T_ALSA_BASE + 2)
+#define MEDIA_INTF_T_ALSA_COMPRESS      (MEDIA_INTF_T_ALSA_BASE + 3)
+#define MEDIA_INTF_T_ALSA_RAWMIDI       (MEDIA_INTF_T_ALSA_BASE + 4)
+#define MEDIA_INTF_T_ALSA_HWDEP         (MEDIA_INTF_T_ALSA_BASE + 5)
+
 /*
  * MC next gen API definitions
  *
-- 
2.5.0
