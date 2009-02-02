From: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Subject: [PATCH 4/4] Rationalize fasync return values
Date: Mon,  2 Feb 2009 11:20:11 -0700
Message-ID: <1233598811-6871-5-git-send-email-corbet@lwn.net>
References: <1233598811-6871-1-git-send-email-corbet@lwn.net>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1233598811-6871-1-git-send-email-corbet-T1hC0tSOHrs@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Most fasync implementations do something like:

     return fasync_helper(...);

But fasync_helper() will return a positive value at times - a feature used
in at least one place.  Thus, a number of other drivers do:

     err = fasync_helper(...);
     if (err < 0)
             return err;
     return 0;

In the interests of consistency and more concise code, it makes sense to
map positive return values onto zero where ->fasync() is called.

Signed-off-by: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
---
 drivers/char/sonypi.c              |    7 +------
 drivers/gpu/drm/drm_fops.c         |    6 +-----
 drivers/hid/usbhid/hiddev.c        |    5 +----
 drivers/ieee1394/dv1394.c          |    6 +-----
 drivers/input/evdev.c              |    5 +----
 drivers/input/joydev.c             |    5 +----
 drivers/input/mousedev.c           |    5 +----
 drivers/input/serio/serio_raw.c    |    4 +---
 drivers/net/wan/cosa.c             |    4 ++--
 drivers/platform/x86/sony-laptop.c |    7 +------
 drivers/scsi/sg.c                  |    4 +---
 fs/fcntl.c                         |    2 ++
 fs/ioctl.c                         |    2 +-
 fs/pipe.c                          |   17 +++--------------
 sound/core/control.c               |    7 ++-----
 sound/core/pcm_native.c            |    4 +---
 sound/core/timer.c                 |    6 +-----
 17 files changed, 22 insertions(+), 74 deletions(-)

diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
index f437443..fd3dced 100644
--- a/drivers/char/sonypi.c
+++ b/drivers/char/sonypi.c
@@ -888,12 +888,7 @@ found:
 
 static int sonypi_misc_fasync(int fd, struct file *filp, int on)
 {
-	int retval;
-
-	retval = fasync_helper(fd, filp, on, &sonypi_device.fifo_async);
-	if (retval < 0)
-		return retval;
-	return 0;
+	return fasync_helper(fd, filp, on, &sonypi_device.fifo_async);
 }
 
 static int sonypi_misc_release(struct inode *inode, struct file *file)
diff --git a/drivers/gpu/drm/drm_fops.c b/drivers/gpu/drm/drm_fops.c
index b06a537..9ec9d5d 100644
--- a/drivers/gpu/drm/drm_fops.c
+++ b/drivers/gpu/drm/drm_fops.c
@@ -337,14 +337,10 @@ int drm_fasync(int fd, struct file *filp, int on)
 {
 	struct drm_file *priv = filp->private_data;
 	struct drm_device *dev = priv->minor->dev;
-	int retcode;
 
 	DRM_DEBUG("fd = %d, device = 0x%lx\n", fd,
 		  (long)old_encode_dev(priv->minor->device));
-	retcode = fasync_helper(fd, filp, on, &dev->buf_async);
-	if (retcode < 0)
-		return retcode;
-	return 0;
+	return fasync_helper(fd, filp, on, &dev->buf_async);
 }
 EXPORT_SYMBOL(drm_fasync);
 
diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index d73eea3..55828da 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -227,12 +227,9 @@ void hiddev_report_event(struct hid_device *hid, struct hid_report *report)
  */
 static int hiddev_fasync(int fd, struct file *file, int on)
 {
-	int retval;
 	struct hiddev_list *list = file->private_data;
 
-	retval = fasync_helper(fd, file, on, &list->fasync);
-
-	return retval < 0 ? retval : 0;
+	return fasync_helper(fd, file, on, &list->fasync);
 }
 
 
diff --git a/drivers/ieee1394/dv1394.c b/drivers/ieee1394/dv1394.c
index a329e6b..22e5487 100644
--- a/drivers/ieee1394/dv1394.c
+++ b/drivers/ieee1394/dv1394.c
@@ -1325,11 +1325,7 @@ static int dv1394_fasync(int fd, struct file *file, int on)
 
 	struct video_card *video = file_to_video_card(file);
 
-	int retval = fasync_helper(fd, file, on, &video->fasync);
-
-	if (retval < 0)
-		return retval;
-        return 0;
+	return fasync_helper(fd, file, on, &video->fasync);
 }
 
 static ssize_t dv1394_write(struct file *file, const char __user *buffer, size_t count, loff_t *ppos)
diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index ed8baa0..7a7a026 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -94,11 +94,8 @@ static void evdev_event(struct input_handle *handle,
 static int evdev_fasync(int fd, struct file *file, int on)
 {
 	struct evdev_client *client = file->private_data;
-	int retval;
-
-	retval = fasync_helper(fd, file, on, &client->fasync);
 
-	return retval < 0 ? retval : 0;
+	return fasync_helper(fd, file, on, &client->fasync);
 }
 
 static int evdev_flush(struct file *file, fl_owner_t id)
diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
index 6f23662..4224f01 100644
--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -159,12 +159,9 @@ static void joydev_event(struct input_handle *handle,
 
 static int joydev_fasync(int fd, struct file *file, int on)
 {
-	int retval;
 	struct joydev_client *client = file->private_data;
 
-	retval = fasync_helper(fd, file, on, &client->fasync);
-
-	return retval < 0 ? retval : 0;
+	return fasync_helper(fd, file, on, &client->fasync);
 }
 
 static void joydev_free(struct device *dev)
diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index ef99a7e..17fd6d4 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -403,12 +403,9 @@ static void mousedev_event(struct input_handle *handle,
 
 static int mousedev_fasync(int fd, struct file *file, int on)
 {
-	int retval;
 	struct mousedev_client *client = file->private_data;
 
-	retval = fasync_helper(fd, file, on, &client->fasync);
-
-	return retval < 0 ? retval : 0;
+	return fasync_helper(fd, file, on, &client->fasync);
 }
 
 static void mousedev_free(struct device *dev)
diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
index 06bbd0e..b03009b 100644
--- a/drivers/input/serio/serio_raw.c
+++ b/drivers/input/serio/serio_raw.c
@@ -58,10 +58,8 @@ static unsigned int serio_raw_no;
 static int serio_raw_fasync(int fd, struct file *file, int on)
 {
 	struct serio_raw_list *list = file->private_data;
-	int retval;
 
-	retval = fasync_helper(fd, file, on, &list->fasync);
-	return retval < 0 ? retval : 0;
+	return fasync_helper(fd, file, on, &list->fasync);
 }
 
 static struct serio_raw *serio_raw_locate(int minor)
diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index d80b72e..ce753e9 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -993,8 +993,8 @@ static struct fasync_struct *fasync[256] = { NULL, };
 static int cosa_fasync(struct inode *inode, struct file *file, int on)
 {
         int port = iminor(inode);
-        int rv = fasync_helper(inode, file, on, &fasync[port]);
-        return rv < 0 ? rv : 0;
+
+	return fasync_helper(inode, file, on, &fasync[port]);
 }
 #endif
 
diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index 537959d..bc8996c 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -1917,12 +1917,7 @@ static struct sonypi_compat_s sonypi_compat = {
 
 static int sonypi_misc_fasync(int fd, struct file *filp, int on)
 {
-	int retval;
-
-	retval = fasync_helper(fd, filp, on, &sonypi_compat.fifo_async);
-	if (retval < 0)
-		return retval;
-	return 0;
+	return fasync_helper(fd, filp, on, &sonypi_compat.fifo_async);
 }
 
 static int sonypi_misc_release(struct inode *inode, struct file *file)
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 8f0bd3f..b656cde 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1154,7 +1154,6 @@ sg_poll(struct file *filp, poll_table * wait)
 static int
 sg_fasync(int fd, struct file *filp, int mode)
 {
-	int retval;
 	Sg_device *sdp;
 	Sg_fd *sfp;
 
@@ -1163,8 +1162,7 @@ sg_fasync(int fd, struct file *filp, int mode)
 	SCSI_LOG_TIMEOUT(3, printk("sg_fasync: %s, mode=%d\n",
 				   sdp->disk->disk_name, mode));
 
-	retval = fasync_helper(fd, filp, mode, &sfp->async_qp);
-	return (retval < 0) ? retval : 0;
+	return fasync_helper(fd, filp, mode, &sfp->async_qp);
 }
 
 static int
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 7b641d9..7a74571 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -192,6 +192,8 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
 		error = filp->f_op->fasync(fd, filp, (arg & FASYNC) != 0);
 		if (error < 0)
 			goto out;
+		if (error > 0)
+			error = 0;
 	}
 	/*
 	 * Now that we use bitops we have to tweak each bit individually.
diff --git a/fs/ioctl.c b/fs/ioctl.c
index bc32cb2..fcfd0e6 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -432,7 +432,7 @@ static int ioctl_fioasync(unsigned int fd, struct file *filp,
 		else
 			error = -ENOTTY;
 	}
-	return error;
+	return error < 0 ? error : 0;
 }
 
 static int ioctl_fsfreeze(struct file *filp)
diff --git a/fs/pipe.c b/fs/pipe.c
index 3a48ba5..900de67 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -667,10 +667,7 @@ pipe_read_fasync(int fd, struct file *filp, int on)
 	retval = fasync_helper(fd, filp, on, &inode->i_pipe->fasync_readers);
 	mutex_unlock(&inode->i_mutex);
 
-	if (retval < 0)
-		return retval;
-
-	return 0;
+	return retval;
 }
 
 
@@ -684,10 +681,7 @@ pipe_write_fasync(int fd, struct file *filp, int on)
 	retval = fasync_helper(fd, filp, on, &inode->i_pipe->fasync_writers);
 	mutex_unlock(&inode->i_mutex);
 
-	if (retval < 0)
-		return retval;
-
-	return 0;
+	return retval;
 }
 
 
@@ -701,16 +695,11 @@ pipe_rdwr_fasync(int fd, struct file *filp, int on)
 	mutex_lock(&inode->i_mutex);
 
 	retval = fasync_helper(fd, filp, on, &pipe->fasync_readers);
-
 	if (retval >= 0)
 		retval = fasync_helper(fd, filp, on, &pipe->fasync_writers);
 
 	mutex_unlock(&inode->i_mutex);
-
-	if (retval < 0)
-		return retval;
-
-	return 0;
+	return retval;
 }
 
 
diff --git a/sound/core/control.c b/sound/core/control.c
index 636b3b5..4b20fa2 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -1373,12 +1373,9 @@ EXPORT_SYMBOL(snd_ctl_unregister_ioctl_compat);
 static int snd_ctl_fasync(int fd, struct file * file, int on)
 {
 	struct snd_ctl_file *ctl;
-	int err;
+
 	ctl = file->private_data;
-	err = fasync_helper(fd, file, on, &ctl->fasync);
-	if (err < 0)
-		return err;
-	return 0;
+	return fasync_helper(fd, file, on, &ctl->fasync);
 }
 
 /*
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index a789efc..a75c194 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3246,9 +3246,7 @@ static int snd_pcm_fasync(int fd, struct file * file, int on)
 	err = fasync_helper(fd, file, on, &runtime->fasync);
 out:
 	unlock_kernel();
-	if (err < 0)
-		return err;
-	return 0;
+	return err;
 }
 
 /*
diff --git a/sound/core/timer.c b/sound/core/timer.c
index 7965320..3f0050d 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -1825,13 +1825,9 @@ static long snd_timer_user_ioctl(struct file *file, unsigned int cmd,
 static int snd_timer_user_fasync(int fd, struct file * file, int on)
 {
 	struct snd_timer_user *tu;
-	int err;
 
 	tu = file->private_data;
-	err = fasync_helper(fd, file, on, &tu->fasync);
-        if (err < 0)
-		return err;
-	return 0;
+	return fasync_helper(fd, file, on, &tu->fasync);
 }
 
 static ssize_t snd_timer_user_read(struct file *file, char __user *buffer,
-- 
1.6.1.1

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
