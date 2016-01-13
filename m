From: Wu-Cheng Li <wuchengli@chromium.org>
Subject: [PATCH] v4l: add V4L2_CID_MPEG_VIDEO_FORCE_FRAME_TYPE.
Date: Wed, 13 Jan 2016 20:03:31 +0800
Message-ID: <1452686611-145620-2-git-send-email-wuchengli@chromium.org>
References: <1452686611-145620-1-git-send-email-wuchengli@chromium.org>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <1452686611-145620-1-git-send-email-wuchengli@chromium.org>
Sender: linux-media-owner@vger.kernel.org
To: pawel@osciak.com, mchehab@osg.samsung.com, hverkuil@xs4all.nl, k.debski@samsung.com, crope@iki.fi, standby24x7@gmail.com, wuchengli@chromium.org, nicolas.dufresne@collabora.com, ricardo.ribalda@gmail.com, ao2@ao2.it, bparrot@ti.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Some drivers also need a control like
V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE to force an encoder
frame type. Add a general V4L2_CID_MPEG_VIDEO_FORCE_FRAME_TYPE
so the new drivers and applications can use it.

Signed-off-by: Wu-Cheng Li <wuchengli@chromium.org>
---
 Documentation/DocBook/media/v4l/controls.xml | 23 +++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c         | 13 +++++++++++++
 include/uapi/linux/v4l2-controls.h           |  5 +++++
 3 files changed, 41 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index f13a429..326947c 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -2330,6 +2330,29 @@ vertical search range for motion estimation module in video encoder.</entry>
 	      </row>
 
 	      <row><entry></entry></row>
+	      <row id="v4l2-mpeg-video-force-frame-type">
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_FORCE_FRAME_TYPE</constant>&nbsp;</entry>
+		<entry>enum&nbsp;v4l2_mpeg_video_force_frame_type</entry>
+	      </row>
+	      <row><entry spanname="descr">Force a frame type for the next queued buffer. Applicable to encoders.
+This is a general, codec-agnostic keyframe control. This is a write-only and execute-on-write control. Possible values are:</entry>
+	      </row>
+	      <row>
+		<entrytbl spanname="descr" cols="2">
+		  <tbody valign="top">
+		    <row>
+		      <entry><constant>V4L2_MPEG_FORCE_FRAME_TYPE_DISABLED</constant>&nbsp;</entry>
+		      <entry>Force a specific frame type disabled.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_FORCE_FRAME_TYPE_I_FRAME</constant>&nbsp;</entry>
+		      <entry>Force an I-frame.</entry>
+		    </row>
+		  </tbody>
+		</entrytbl>
+	      </row>
+
+	      <row><entry></entry></row>
 	      <row>
 		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE</constant>&nbsp;</entry>
 		<entry>integer</entry>
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index c9d5537..53a8f72 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -315,6 +315,11 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"Max Bytes",
 		NULL,
 	};
+	static const char * const force_frame_type[] = {
+		"Disabled",
+		"I Frame",
+		NULL,
+	};
 	static const char * const entropy_mode[] = {
 		"CAVLC",
 		"CABAC",
@@ -533,6 +538,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		return header_mode;
 	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE:
 		return multi_slice;
+	case V4L2_CID_MPEG_VIDEO_FORCE_FRAME_TYPE:
+		return force_frame_type;
 	case V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE:
 		return entropy_mode;
 	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:
@@ -747,6 +754,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_MV_H_SEARCH_RANGE:		return "Horizontal MV Search Range";
 	case V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE:		return "Vertical MV Search Range";
 	case V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER:		return "Repeat Sequence Header";
+	case V4L2_CID_MPEG_VIDEO_FORCE_FRAME_TYPE:		return "Force an encoded frame type";
 
 	/* VPX controls */
 	case V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS:		return "VPX Number of Partitions";
@@ -1045,6 +1053,11 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_DETECT_MD_MODE:
 		*type = V4L2_CTRL_TYPE_MENU;
 		break;
+	case V4L2_CID_MPEG_VIDEO_FORCE_FRAME_TYPE:
+		*type = V4L2_CTRL_TYPE_MENU;
+		*flags |= V4L2_CTRL_FLAG_WRITE_ONLY |
+			  V4L2_CTRL_FLAG_EXECUTE_ON_WRITE;
+		break;
 	case V4L2_CID_LINK_FREQ:
 		*type = V4L2_CTRL_TYPE_INTEGER_MENU;
 		break;
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 2d225bc..c2be60c 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -390,6 +390,11 @@ enum v4l2_mpeg_video_multi_slice_mode {
 #define V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER		(V4L2_CID_MPEG_BASE+226)
 #define V4L2_CID_MPEG_VIDEO_MV_H_SEARCH_RANGE		(V4L2_CID_MPEG_BASE+227)
 #define V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE		(V4L2_CID_MPEG_BASE+228)
+#define V4L2_CID_MPEG_VIDEO_FORCE_FRAME_TYPE		(V4L2_CID_MPEG_BASE+229)
+enum v4l2_mpeg_video_force_frame_type {
+	V4L2_MPEG_VIDEO_FORCE_FRAME_TYPE_DISABLED	= 0,
+	V4L2_MPEG_VIDEO_FORCE_FRAME_TYPE_I_FRAME	= 1,
+};
 
 #define V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP		(V4L2_CID_MPEG_BASE+300)
 #define V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP		(V4L2_CID_MPEG_BASE+301)
-- 
2.6.0.rc2.230.g3dd15c0
