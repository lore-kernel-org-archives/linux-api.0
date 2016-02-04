From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH v2 01/22] uapi/media.h: Declare interface types for ALSA
Date: Wed,  3 Feb 2016 21:03:33 -0700
Message-ID: <6d8fe067fa0ec07e9f667dbd2e163b6b63b4a614.1454557589.git.shuahkh@osg.samsung.com>
References: <cover.1454557589.git.shuahkh@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1454557589.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1454557589.git.shuahkh@osg.samsung.com>
References: <cover.1454557589.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net, johan@oljud.se, klock.android@gmail.com, nenggun.kim@samsung.com, j.anaszewski@samsung.com, geliangtang
List-Id: linux-api@vger.kernel.org

Declare the interface types to be used on alsa for
the new G_TOPOLOGY ioctl.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/media-entity.c | 16 ++++++++++++++++
 include/uapi/linux/media.h   | 22 ++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index f2e4360..6179543 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -65,6 +65,22 @@ static inline const char *intf_type(struct media_interface *intf)
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
+	case MEDIA_INTF_T_ALSA_SEQUENCER:
+		return "sequencer";
+	case MEDIA_INTF_T_ALSA_TIMER:
+		return "timer";
 	default:
 		return "unknown-intf";
 	}
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index c9eb42a..ee020e8 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -265,6 +265,7 @@ struct media_links_enum {
 
 #define MEDIA_INTF_T_DVB_BASE	0x00000100
 #define MEDIA_INTF_T_V4L_BASE	0x00000200
+#define MEDIA_INTF_T_ALSA_BASE	0x00000300
 
 /* Interface types */
 
@@ -280,6 +281,27 @@ struct media_links_enum {
 #define MEDIA_INTF_T_V4L_SUBDEV (MEDIA_INTF_T_V4L_BASE + 3)
 #define MEDIA_INTF_T_V4L_SWRADIO (MEDIA_INTF_T_V4L_BASE + 4)
 
+/**
+ * DOC: Media Controller Next Generation ALSA Interface Types
+ *
+ * MEDIA_INTF_T_ALSA_PCM_CAPTURE - PCM Capture Interface (pcm-capture)
+ * MEDIA_INTF_T_ALSA_PCM_PLAYBACK -  PCM Playback Interface (pcm-playback)
+ * MEDIA_INTF_T_ALSA_CONTROL -  ALSA Control Interface (alsa-control)
+ * MEDIA_INTF_T_ALSA_COMPRESS - ALSA Compression Interface (compress)
+ * MEDIA_INTF_T_ALSA_RAWMIDI - ALSA Raw MIDI Interface (rawmidi)
+ * MEDIA_INTF_T_ALSA_HWDEP - ALSA Hardware Dependent Interface (hwdep)
+ * MEDIA_INTF_T_ALSA_SEQUENCER - ALSA Sequencer (sequencer)
+ * MEDIA_INTF_T_ALSA_TIMER - ALSA Timer (timer)
+ */
+#define MEDIA_INTF_T_ALSA_PCM_CAPTURE   (MEDIA_INTF_T_ALSA_BASE)
+#define MEDIA_INTF_T_ALSA_PCM_PLAYBACK  (MEDIA_INTF_T_ALSA_BASE + 1)
+#define MEDIA_INTF_T_ALSA_CONTROL       (MEDIA_INTF_T_ALSA_BASE + 2)
+#define MEDIA_INTF_T_ALSA_COMPRESS      (MEDIA_INTF_T_ALSA_BASE + 3)
+#define MEDIA_INTF_T_ALSA_RAWMIDI       (MEDIA_INTF_T_ALSA_BASE + 4)
+#define MEDIA_INTF_T_ALSA_HWDEP         (MEDIA_INTF_T_ALSA_BASE + 5)
+#define MEDIA_INTF_T_ALSA_SEQUENCER     (MEDIA_INTF_T_ALSA_BASE + 6)
+#define MEDIA_INTF_T_ALSA_TIMER         (MEDIA_INTF_T_ALSA_BASE + 7)
+
 /*
  * MC next gen API definitions
  *
-- 
2.5.0
