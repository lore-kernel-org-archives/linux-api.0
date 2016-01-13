From: Wu-Cheng Li <wuchengli@chromium.org>
Subject: [PATCH] v4l: add V4L2_CID_MPEG_VIDEO_FORCE_FRAME_TYPE
Date: Wed, 13 Jan 2016 20:03:30 +0800
Message-ID: <1452686611-145620-1-git-send-email-wuchengli@chromium.org>
Return-path: <linux-media-owner@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
To: pawel@osciak.com, mchehab@osg.samsung.com, hverkuil@xs4all.nl, k.debski@samsung.com, crope@iki.fi, standby24x7@gmail.com, wuchengli@chromium.org, nicolas.dufresne@collabora.com, ricardo.ribalda@gmail.com, ao2@ao2.it, bparrot@ti.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Some drivers also need a control like
V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE to force an encoder frame
type. This patch adds a general V4L2_CID_MPEG_VIDEO_FORCE_FRAME_TYPE.

This control only affects the next queued buffer. There's no need to
clear the value after requesting an I frame. But all controls are set
in v4l2_ctrl_handler_setup. So a default DISABLED value is required.
Basically this control is like V4L2_CTRL_TYPE_BUTTON with parameters.
How to prevent a control from being set in v4l2_ctrl_handler_setup so
DISABLED value is not needed? Does it make sense not to set a control
if it is EXECUTE_ON_WRITE?

Wu-Cheng Li (1):
  v4l: add V4L2_CID_MPEG_VIDEO_FORCE_FRAME_TYPE.

 Documentation/DocBook/media/v4l/controls.xml | 23 +++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c         | 13 +++++++++++++
 include/uapi/linux/v4l2-controls.h           |  5 +++++
 3 files changed, 41 insertions(+)

-- 
2.6.0.rc2.230.g3dd15c0
