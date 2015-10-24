From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v6.2 1/1] Input: Add userio module
Date: Sat, 24 Oct 2015 15:40:12 -0700
Message-ID: <20151024224012.GA13584@dtor-pixel>
References: <1444053984.8404.1.camel@redhat.com>
 <1445633266-14691-1-git-send-email-cpaul@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1445633266-14691-1-git-send-email-cpaul@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: cpaul@redhat.com
Cc: David Herrmann <dh.herrmann@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org, linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>, Vishnu Patekar <vishnupatekar0510@gmail.com>, Sebastian Ott <sebott@linux.vnet.ibm.com>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Hans de Goede <hdegoede@redhat.com>, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Stephen,

On Fri, Oct 23, 2015 at 04:47:46PM -0400, cpaul@redhat.com wrote:
> From: Stephen Chandler Paul <cpaul@redhat.com>
> 
> Debugging input devices, specifically laptop touchpads, can be tricky
> without having the physical device handy. Here we try to remedy that
> with userio. This module allows an application to connect to a character
> device provided by the kernel, and emulate any serio device. In
> combination with userspace programs that can record PS/2 devices and
> replay them through the /dev/userio device, this allows developers to
> debug driver issues on the PS/2 level with devices simply by requesting
> a recording from the user experiencing the issue without having to have
> the physical hardware in front of them.
> 
> Signed-off-by: Stephen Chandler Paul <cpaul@redhat.com>
> Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
> ---
> 				    Changes
> * Remove the if (!userio) { return -1; } check that somehow got left in.
> 
> Sorry this took so long! I was wondering why you hadn't replied yet, only to
> notice I only made this change on my own tree and never sent out a response
> patch. Oops.

Thank you for making all the changes.

> +
> +static ssize_t userio_char_read(struct file *file, char __user *user_buffer,
> +				size_t count, loff_t *ppos)
> +{
> +	struct userio_device *userio = file->private_data;
> +	int ret;
> +	size_t nonwrap_len, copylen;
> +	unsigned char buf[USERIO_BUFSIZE];
> +	unsigned long flags;
> +
> +	if (!count)
> +		return 0;

This is not quite right: read of size 0 should still check if there is
data in the buffer and return -EAGAIN for non-blocking descriptors.

I cooked a patch (below) that should adjust the read behavior (_+ a
coupe of formatting changes), please take a look.

Thanks!

-- 
Dmitry

userio - misc fixups

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/serio/Kconfig  |    9 ++-
 drivers/input/serio/userio.c |  122 ++++++++++++++++++++++--------------------
 2 files changed, 70 insertions(+), 61 deletions(-)

diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index 22b8b58..c3d05b4 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -293,10 +293,13 @@ config SERIO_SUN4I_PS2
 	  module will be called sun4i-ps2.
 
 config USERIO
-	tristate "Virtual serio device support"
+	tristate "User space serio port driver support"
 	help
-	  Say Y here if you want to emulate serio devices using the userio
-	  kernel module.
+	  Say Y here if you want to support user level drivers for serio
+	  subsystem accessible under char device 10:240 - /dev/userio. Using
+	  this facility userspace programs can implement serio ports that
+	  will be used by the standard in-kernel serio consumer drivers,
+	  such as psmouse and atkbd.
 
 	  To compile this driver as a module, choose M here: the module will be
 	  called userio.
diff --git a/drivers/input/serio/userio.c b/drivers/input/serio/userio.c
index 7a89371..df1fd41 100644
--- a/drivers/input/serio/userio.c
+++ b/drivers/input/serio/userio.c
@@ -4,14 +4,14 @@
  * Copyright (C) 2015 Stephen Chandler Paul <thatslyude@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Lesser General Public License as published by the
- * Free Software Foundation; either version 2 of the License, or (at your
- * option) any later version.
+ * under the terms of the GNU Lesser General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or (at
+ * your option) any later version.
  *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
- * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
- * details.
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser
+ * General Public License for more details.
  */
 
 #include <linux/circ_buf.h>
@@ -27,14 +27,14 @@
 #include <linux/poll.h>
 #include <uapi/linux/userio.h>
 
-#define USERIO_NAME "userio"
-#define USERIO_BUFSIZE 16
+#define USERIO_NAME		"userio"
+#define USERIO_BUFSIZE		16
 
 static struct miscdevice userio_misc;
 
 struct userio_device {
 	struct serio *serio;
-	struct mutex lock;
+	struct mutex mutex;
 
 	bool running;
 
@@ -81,7 +81,7 @@ static int userio_char_open(struct inode *inode, struct file *file)
 	if (!userio)
 		return -ENOMEM;
 
-	mutex_init(&userio->lock);
+	mutex_init(&userio->mutex);
 	spin_lock_init(&userio->buf_lock);
 	init_waitqueue_head(&userio->waitq);
 
@@ -103,12 +103,15 @@ static int userio_char_release(struct inode *inode, struct file *file)
 {
 	struct userio_device *userio = file->private_data;
 
-	/* Don't free the serio port here, serio_unregister_port() does
-	 * this for us */
-	if (userio->running)
+	if (userio->running) {
+		/*
+		 * Don't free the serio port here, serio_unregister_port()
+		 * does it for us.
+		 */
 		serio_unregister_port(userio->serio);
-	else
+	} else {
 		kfree(userio->serio);
+	}
 
 	kfree(userio);
 
@@ -119,48 +122,56 @@ static ssize_t userio_char_read(struct file *file, char __user *user_buffer,
 				size_t count, loff_t *ppos)
 {
 	struct userio_device *userio = file->private_data;
-	int ret;
+	int error;
 	size_t nonwrap_len, copylen;
 	unsigned char buf[USERIO_BUFSIZE];
 	unsigned long flags;
 
-	if (!count)
-		return 0;
-
 	/*
-	 * By the time we get here, the data that was waiting might have been
-	 * taken by another thread. Grab the mutex and check if there's still
-	 * any data waiting, otherwise repeat this process until we have data
-	 * (unless the file descriptor is non-blocking of course)
+	 * By the time we get here, the data that was waiting might have
+	 * been taken by another thread. Grab the buffer lock and check if
+	 * there's still any data waiting, otherwise repeat this process
+	 * until we have data (unless the file descriptor is non-blocking
+	 * of course).
 	 */
 	for (;;) {
 		spin_lock_irqsave(&userio->buf_lock, flags);
 
-		if (userio->head != userio->tail)
-			break;
+		nonwrap_len = CIRC_CNT_TO_END(userio->head,
+					      userio->tail,
+					      USERIO_BUFSIZE);
+		copylen = min(nonwrap_len, count);
+		if (copylen) {
+			memcpy(buf, &userio->buf[userio->tail], copylen);
+			userio->tail = (userio->tail + copylen) %
+							USERIO_BUFSIZE;
+		}
 
 		spin_unlock_irqrestore(&userio->buf_lock, flags);
 
+		if (nonwrap_len)
+			break;
+
+		/* buffer was/is empty */
 		if (file->f_flags & O_NONBLOCK)
 			return -EAGAIN;
 
-		ret = wait_event_interruptible(userio->waitq,
-					       userio->head != userio->tail);
-		if (ret)
-			return ret;
+		/*
+		 * count == 0 is special - no IO is done but we check
+		 * for error conditions (see above).
+		 */
+		if (count == 0)
+			return 0;
+
+		error = wait_event_interruptible(userio->waitq,
+						 userio->head != userio->tail);
+		if (error)
+			return error;
 	}
 
-	nonwrap_len = CIRC_CNT_TO_END(userio->head, userio->tail,
-				      USERIO_BUFSIZE);
-	copylen = min(nonwrap_len, count);
-	memcpy(buf, &userio->buf[userio->tail], copylen);
-
-	userio->tail = (userio->tail + copylen) % USERIO_BUFSIZE;
-
-	spin_unlock_irqrestore(&userio->buf_lock, flags);
-
-	if (copy_to_user(user_buffer, buf, copylen))
-		return -EFAULT;
+	if (copylen)
+		if (copy_to_user(user_buffer, buf, copylen))
+			return -EFAULT;
 
 	return copylen;
 }
@@ -170,7 +181,7 @@ static ssize_t userio_char_write(struct file *file, const char __user *buffer,
 {
 	struct userio_device *userio = file->private_data;
 	struct userio_cmd cmd;
-	int ret;
+	int error;
 
 	if (count != sizeof(cmd)) {
 		dev_warn(userio_misc.this_device, "Invalid payload size\n");
@@ -180,9 +191,9 @@ static ssize_t userio_char_write(struct file *file, const char __user *buffer,
 	if (copy_from_user(&cmd, buffer, sizeof(cmd)))
 		return -EFAULT;
 
-	ret = mutex_lock_interruptible(&userio->lock);
-	if (ret)
-		return ret;
+	error = mutex_lock_interruptible(&userio->mutex);
+	if (error)
+		return error;
 
 	switch (cmd.type) {
 	case USERIO_CMD_REGISTER:
@@ -190,14 +201,14 @@ static ssize_t userio_char_write(struct file *file, const char __user *buffer,
 			dev_warn(userio_misc.this_device,
 				 "No port type given on /dev/userio\n");
 
-			ret = -EINVAL;
+			error = -EINVAL;
 			goto out;
 		}
+
 		if (userio->running) {
 			dev_warn(userio_misc.this_device,
 				 "Begin command sent, but we're already running\n");
-
-			ret = -EBUSY;
+			error = -EBUSY;
 			goto out;
 		}
 
@@ -209,8 +220,7 @@ static ssize_t userio_char_write(struct file *file, const char __user *buffer,
 		if (userio->running) {
 			dev_warn(userio_misc.this_device,
 				 "Can't change port type on an already running userio instance\n");
-
-			ret = -EBUSY;
+			error = -EBUSY;
 			goto out;
 		}
 
@@ -221,8 +231,7 @@ static ssize_t userio_char_write(struct file *file, const char __user *buffer,
 		if (!userio->running) {
 			dev_warn(userio_misc.this_device,
 				 "The device must be registered before sending interrupts\n");
-
-			ret = -ENODEV;
+			error = -ENODEV;
 			goto out;
 		}
 
@@ -230,15 +239,13 @@ static ssize_t userio_char_write(struct file *file, const char __user *buffer,
 		break;
 
 	default:
-		ret = -EOPNOTSUPP;
+		error = -EOPNOTSUPP;
 		goto out;
 	}
 
-	ret = sizeof(cmd);
-
 out:
-	mutex_unlock(&userio->lock);
-	return ret;
+	mutex_unlock(&userio->mutex);
+	return error ?: count;
 }
 
 static unsigned int userio_char_poll(struct file *file, poll_table *wait)
@@ -268,6 +275,7 @@ static struct miscdevice userio_misc = {
 	.minor	= USERIO_MINOR,
 	.name	= USERIO_NAME,
 };
+module_driver(userio_misc, misc_register, misc_deregister);
 
 MODULE_ALIAS_MISCDEV(USERIO_MINOR);
 MODULE_ALIAS("devname:" USERIO_NAME);
@@ -275,5 +283,3 @@ MODULE_ALIAS("devname:" USERIO_NAME);
 MODULE_AUTHOR("Stephen Chandler Paul <thatslyude@gmail.com>");
 MODULE_DESCRIPTION("Virtual Serio Device Support");
 MODULE_LICENSE("GPL");
-
-module_driver(userio_misc, misc_register, misc_deregister);
