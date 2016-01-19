From: Wu-Cheng Li <wuchengli@chromium.org>
Subject: [PATCH v4 1/2] v4l: add V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME.
Date: Tue, 19 Jan 2016 15:07:09 +0800
Message-ID: <1453187230-97231-2-git-send-email-wuchengli@chromium.org>
References: <1453187230-97231-1-git-send-email-wuchengli@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453187230-97231-1-git-send-email-wuchengli@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: pawel@osciak.com, mchehab@osg.samsung.com, hverkuil@xs4all.nl, k.debski@samsung.com, crope@iki.fi, standby24x7@gmail.com, wuchengli@chromium.org, nicolas.dufresne@collabora.com, ricardo.ribalda@gmail.com, ao2@ao2.it, bparrot@ti.com, kyungmin.park@samsung.com, jtp.park@samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, tiffany.lin@mediatek.com, djkurtz@chromium.org
List-Id: linux-api@vger.kernel.org

Some drivers also need a control like
V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE to force an encoder
key frame. Add a general V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME
so the new drivers and applications can use it.

Signed-off-by: Wu-Cheng Li <wuchengli@chromium.org>
---
 Documentation/DocBook/media/v4l/controls.xml | 8 ++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c         | 2 ++
 include/uapi/linux/v4l2-controls.h           | 1 +
 3 files changed, 11 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index f13a429..a62ea7b 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -2330,6 +2330,14 @@ vertical search range for motion estimation module in video encoder.</entry>
 	      </row>
 
 	      <row><entry></entry></row>
+	      <row id="v4l2-mpeg-video-force-key-frame">
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME</constant>&nbsp;</entry>
+		<entry>button</entry>
+	      </row><row><entry spanname="descr">Force a key frame for the next queued buffer. Applicable to encoders.
+This is a general, codec-agnostic keyframe control.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
 	      <row>
 		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE</constant>&nbsp;</entry>
 		<entry>integer</entry>
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index c9d5537..bd1b7ad 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -747,6 +747,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_MV_H_SEARCH_RANGE:		return "Horizontal MV Search Range";
 	case V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE:		return "Vertical MV Search Range";
 	case V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER:		return "Repeat Sequence Header";
+	case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:		return "Force Key Frame";
 
 	/* VPX controls */
 	case V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS:		return "VPX Number of Partitions";
@@ -985,6 +986,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE:
 		*type = V4L2_CTRL_TYPE_INTEGER;
 		break;
+	case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:
 	case V4L2_CID_PAN_RESET:
 	case V4L2_CID_TILT_RESET:
 	case V4L2_CID_FLASH_STROBE:
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 2d225bc..5b49df6 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -390,6 +390,7 @@ enum v4l2_mpeg_video_multi_slice_mode {
 #define V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER		(V4L2_CID_MPEG_BASE+226)
 #define V4L2_CID_MPEG_VIDEO_MV_H_SEARCH_RANGE		(V4L2_CID_MPEG_BASE+227)
 #define V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE		(V4L2_CID_MPEG_BASE+228)
+#define V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME		(V4L2_CID_MPEG_BASE+229)
 
 #define V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP		(V4L2_CID_MPEG_BASE+300)
 #define V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP		(V4L2_CID_MPEG_BASE+301)
-- 
2.6.0.rc2.230.g3dd15c0
