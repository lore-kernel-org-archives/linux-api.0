From: Wu-Cheng Li <wuchengli@chromium.org>
Subject: [PATCH v2 0/2] new control V4L2_CID_MPEG_VIDEO_FORCE_I_FRAME
Date: Thu, 14 Jan 2016 16:33:57 +0800
Message-ID: <1452760439-35564-1-git-send-email-wuchengli@chromium.org>
Return-path: <linux-media-owner@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
To: pawel@osciak.com, mchehab@osg.samsung.com, hverkuil@xs4all.nl, k.debski@samsung.com, crope@iki.fi, standby24x7@gmail.com, wuchengli@chromium.org, nicolas.dufresne@collabora.com, ricardo.ribalda@gmail.com, ao2@ao2.it, bparrot@ti.com, kyungmin.park@samsung.com, jtp.park@samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, tiffany.lin@mediatek.com, djkurtz@chromium.org
List-Id: linux-api@vger.kernel.org

v2 changes the control to button type and adds the support to s5p-mfc.

Wu-Cheng Li (2):
  v4l: add V4L2_CID_MPEG_VIDEO_FORCE_I_FRAME.
  s5p-mfc: add the support of V4L2_CID_MPEG_VIDEO_FORCE_I_FRAME.

 Documentation/DocBook/media/v4l/controls.xml |  8 ++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 13 +++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c         |  2 ++
 include/uapi/linux/v4l2-controls.h           |  1 +
 4 files changed, 24 insertions(+)

-- 
2.6.0.rc2.230.g3dd15c0
