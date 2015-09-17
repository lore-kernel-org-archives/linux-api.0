From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 3/9] [media] dvb: don't use 'time_t' in event ioctl
Date: Thu, 17 Sep 2015 23:19:34 +0200
Message-ID: <1442524780-781677-4-git-send-email-arnd@arndb.de>
References: <1442524780-781677-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442524780-781677-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, y2038@lists.linaro.org, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, linux-api@vger.kernel.org, linux-samsung-soc@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

'struct video_event' is used for the VIDEO_GET_EVENT ioctl, implemented
by drivers/media/pci/ivtv/ivtv-ioctl.c and
drivers/media/pci/ttpci/av7110_av.c. The structure contains a 'time_t',
which will be redefined in the future to be 64-bit wide, causing an
incompatible ABI change for this ioctl.

As it turns out, neither of the drivers currently sets the timestamp
field, and it is presumably useless anyway because of the limited
resolutions (no sub-second times). This means we can simply change
the structure definition to use a 'long' instead of 'time_t' and
remain compatible with all existing user space binaries when time_t
gets changed.

If anybody ever starts using this field, they have to make sure not
to use 1970 based seconds in there, as those overflow in 2038.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/uapi/linux/dvb/video.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/dvb/video.h b/include/uapi/linux/dvb/video.h
index d3d14a59d2d5..6c7f9298d7c2 100644
--- a/include/uapi/linux/dvb/video.h
+++ b/include/uapi/linux/dvb/video.h
@@ -135,7 +135,8 @@ struct video_event {
 #define VIDEO_EVENT_FRAME_RATE_CHANGED	2
 #define VIDEO_EVENT_DECODER_STOPPED 	3
 #define VIDEO_EVENT_VSYNC 		4
-	__kernel_time_t timestamp;
+	/* unused, make sure to use atomic time for y2038 if it ever gets used */
+	long timestamp;
 	union {
 		video_size_t size;
 		unsigned int frame_rate;	/* in frames per 1000sec */
-- 
2.1.0.rc2
