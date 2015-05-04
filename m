From: Ricardo Ribalda Delgado <ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/4] Add support for V4L2_PIX_FMT_Y16_BE
Date: Mon,  4 May 2015 10:07:28 +0200
Message-ID: <1430726852-11715-1-git-send-email-ricardo.ribalda@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ramakrishnan Muthukrishnan <ramakrmu-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

New pixel format type Y16_BE (16 bits greyscale big-endian).

Once I get the fist feedback on this patch I will send the patches for
v4lconvert and qv4l2.


Thanks

Ricardo Ribalda Delgado (4):
  media/vivid: Add support for Y16 format
  media/v4l2-core: Add support for V4L2_PIX_FMT_Y16_BE
  media/vivid: Add support for Y16_BE format
  media/vivid: Code cleanout

 drivers/media/platform/vivid/vivid-tpg.c        | 20 ++++++++++++++++----
 drivers/media/platform/vivid/vivid-vid-common.c | 16 ++++++++++++++++
 drivers/media/v4l2-core/v4l2-ioctl.c            |  1 +
 include/uapi/linux/videodev2.h                  |  1 +
 4 files changed, 34 insertions(+), 4 deletions(-)

-- 
2.1.4
