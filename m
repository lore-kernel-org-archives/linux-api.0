From: cpaul@redhat.com
Subject: [PATCH v7] Input: Add userio module
Date: Mon,  5 Oct 2015 11:55:29 -0400
Message-ID: <1444060529-11164-1-git-send-email-cpaul@redhat.com>
References: <20151002173714.GA8437@dtor-ws>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151002173714.GA8437@dtor-ws>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: David Herrmann <dh.herrmann@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>, Vishnu Patekar <vishnupatekar0510@gmail.com>, Sebastian Ott <sebott@linux.vnet.ibm.com>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Hans de Goede <hdegoede@redhat.com>, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Stephen Chandler Paul <cpaul@redhat.com>

Debugging input devices, specifically laptop touchpads, can be tricky
without having the physical device handy. Here we try to remedy that
with userio. This module allows an application to connect to a character
device provided by the kernel, and emulate any serio device. In
combination with userspace programs that can record PS/2 devices and
replay them through the /dev/userio device, this allows developers to
debug driver issues on the PS/2 level with devices simply by requesting
a recording from the user experiencing the issue without having to have
the physical hardware in front of them.

Signed-off-by: Stephen Chandler Paul <cpaul@redhat.com>
---
				    Changes
* Removed useless if (!userio) check in userio_device_write()

 Documentation/input/userio.txt |  70 ++++++++++
 MAINTAINERS                    |   6 +
 drivers/input/serio/Kconfig    |  11 ++
 drivers/input/serio/Makefile   |   1 +
 drivers/input/serio/userio.c   | 286 +++++++++++++++++++++++++++++++++++++++++
 include/linux/miscdevice.h     |   1 +
 include/uapi/linux/userio.h    |  44 +++++++
 7 files changed, 419 insertions(+)
 create mode 100644 Documentation/input/userio.txt
 create mode 100644 drivers/input/serio/userio.c
 create mode 100644 include/uapi/linux/userio.h

diff --git a/Documentation/input/userio.txt b/Documentation/input/userio.txt
new file mode 100644
index 0000000..0880c0f
--- /dev/null
+++ b/Documentation/input/userio.txt
@@ -0,0 +1,70 @@
+			      The userio Protocol
+	     (c) 2015 Stephen Chandler Paul <thatslyude@gmail.com>
+			      Sponsored by Red Hat
+--------------------------------------------------------------------------------
+
+1. Introduction
+~~~~~~~~~~~~~~~
+  This module is intended to try to make the lives of input driver developers
+easier by allowing them to test various serio devices (mainly the various
+touchpads found on laptops) without having to have the physical device in front
+of them. userio accomplishes this by allowing any privileged userspace program
+to directly interact with the kernel's serio driver and control a virtual serio
+port from there.
+
+2. Usage overview
+~~~~~~~~~~~~~~~~~
+  In order to interact with the userio kernel module, one simply opens the
+/dev/userio character device in their applications. Commands are sent to the
+kernel module by writing to the device, and any data received from the serio
+driver is read as-is from the /dev/userio device. All of the structures and
+macros you need to interact with the device are defined in <linux/userio.h> and
+<linux/serio.h>.
+
+3. Command Structure
+~~~~~~~~~~~~~~~~~~~~
+  The struct used for sending commands to /dev/userio is as follows:
+
+	struct userio_cmd {
+		__u8 type;
+		__u8 data;
+	};
+
+  "type" describes the type of command that is being sent. This can be any one
+of the USERIO_CMD macros defined in <linux/userio.h>. "data" is the argument
+that goes along with the command. In the event that the command doesn't have an
+argument, this field can be left untouched and will be ignored by the kernel.
+Each command should be sent by writing the struct directly to the character
+device. In the event that the command you send is invalid, an error will be
+returned by the character device and a more descriptive error will be printed
+to the kernel log. Only one command can be sent at a time, any additional data
+written to the character device after the initial command will be ignored.
+  To close the virtual serio port, just close /dev/userio.
+
+4. Commands
+~~~~~~~~~~~
+
+4.1 USERIO_CMD_REGISTER
+~~~~~~~~~~~~~~~~~~~~~~~
+  Registers the port with the serio driver and begins transmitting data back and
+forth. Registration can only be performed once a port type is set with
+USERIO_CMD_SET_PORT_TYPE. Has no argument.
+
+4.2 USERIO_CMD_SET_PORT_TYPE
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+  Sets the type of port we're emulating, where "data" is the port type being
+set. Can be any of the macros from <linux/serio.h>. For example: SERIO_8042
+would set the port type to be a normal PS/2 port.
+
+4.3 USERIO_CMD_SEND_INTERRUPT
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+  Sends an interrupt through the virtual serio port to the serio driver, where
+"data" is the interrupt data being sent.
+
+5. Userspace tools
+~~~~~~~~~~~~~~~~~~
+  The userio userspace tools are able to record PS/2 devices using some of the
+debugging information from i8042, and play back the devices on /dev/userio. The
+latest version of these tools can be found at:
+
+	https://github.com/Lyude/ps2emu
diff --git a/MAINTAINERS b/MAINTAINERS
index 797236b..ba59bd7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11100,6 +11100,12 @@ S:	Maintained
 F:	drivers/media/v4l2-core/videobuf2-*
 F:	include/media/videobuf2-*
 
+VIRTUAL SERIO DEVICE DRIVER
+M:	Stephen Chandler Paul <thatslyude@gmail.com>
+S:	Maintained
+F:	drivers/input/serio/userio.c
+F:	include/uapi/linux/userio.h
+
 VIRTIO CONSOLE DRIVER
 M:	Amit Shah <amit.shah@redhat.com>
 L:	virtualization@lists.linux-foundation.org
diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index 200841b..22b8b58 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -292,4 +292,15 @@ config SERIO_SUN4I_PS2
 	  To compile this driver as a module, choose M here: the
 	  module will be called sun4i-ps2.
 
+config USERIO
+	tristate "Virtual serio device support"
+	help
+	  Say Y here if you want to emulate serio devices using the userio
+	  kernel module.
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called userio.
+
+	  If you are unsure, say N.
+
 endif
diff --git a/drivers/input/serio/Makefile b/drivers/input/serio/Makefile
index c600089..2374ef9 100644
--- a/drivers/input/serio/Makefile
+++ b/drivers/input/serio/Makefile
@@ -30,3 +30,4 @@ obj-$(CONFIG_SERIO_APBPS2)	+= apbps2.o
 obj-$(CONFIG_SERIO_OLPC_APSP)	+= olpc_apsp.o
 obj-$(CONFIG_HYPERV_KEYBOARD)	+= hyperv-keyboard.o
 obj-$(CONFIG_SERIO_SUN4I_PS2)	+= sun4i-ps2.o
+obj-$(CONFIG_USERIO)		+= userio.o
diff --git a/drivers/input/serio/userio.c b/drivers/input/serio/userio.c
new file mode 100644
index 0000000..0ada7cf
--- /dev/null
+++ b/drivers/input/serio/userio.c
@@ -0,0 +1,286 @@
+/*
+ * userio kernel serio device emulation module
+ * Copyright (C) 2015 Red Hat
+ * Copyright (C) 2015 Stephen Chandler Paul <thatslyude@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU Lesser General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
+ * details.
+ */
+#include <linux/circ_buf.h>
+#include <linux/mutex.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/serio.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/sched.h>
+#include <linux/poll.h>
+#include <uapi/linux/userio.h>
+
+#define USERIO_NAME "userio"
+#define USERIO_BUFSIZE 16
+
+static struct miscdevice userio_misc;
+
+struct userio_device {
+	struct serio *serio;
+	struct mutex lock;
+
+	bool running;
+
+	u8 head;
+	u8 tail;
+
+	spinlock_t buf_lock;
+	unsigned char buf[USERIO_BUFSIZE];
+
+	wait_queue_head_t waitq;
+};
+
+/**
+ * userio_device_write - Write data from serio to a userio device in userspace
+ * @id: The serio port for the userio device
+ * @val: The data to write to the device
+ */
+static int userio_device_write(struct serio *id, unsigned char val)
+{
+	struct userio_device *userio = id->port_data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&userio->buf_lock, flags);
+
+	userio->buf[userio->head] = val;
+	userio->head = (userio->head + 1) % USERIO_BUFSIZE;
+
+	if (userio->head == userio->tail)
+		dev_warn(userio_misc.this_device,
+			 "Buffer overflowed, userio client isn't keeping up");
+
+	spin_unlock_irqrestore(&userio->buf_lock, flags);
+
+	wake_up_interruptible(&userio->waitq);
+
+	return 0;
+}
+
+static int userio_char_open(struct inode *inode, struct file *file)
+{
+	struct userio_device *userio;
+
+	userio = kzalloc(sizeof(struct userio_device), GFP_KERNEL);
+	if (!userio)
+		return -ENOMEM;
+
+	mutex_init(&userio->lock);
+	spin_lock_init(&userio->buf_lock);
+	init_waitqueue_head(&userio->waitq);
+
+	userio->serio = kzalloc(sizeof(struct serio), GFP_KERNEL);
+	if (!userio->serio) {
+		kfree(userio);
+		return -ENOMEM;
+	}
+
+	userio->serio->write = userio_device_write;
+	userio->serio->port_data = userio;
+
+	file->private_data = userio;
+
+	return 0;
+}
+
+static int userio_char_release(struct inode *inode, struct file *file)
+{
+	struct userio_device *userio = file->private_data;
+
+	/* Don't free the serio port here, serio_unregister_port() does
+	 * this for us */
+	if (userio->running)
+		serio_unregister_port(userio->serio);
+	else
+		kfree(userio->serio);
+
+	kfree(userio);
+
+	return 0;
+}
+
+static ssize_t userio_char_read(struct file *file, char __user *user_buffer,
+				size_t count, loff_t *ppos)
+{
+	struct userio_device *userio = file->private_data;
+	int ret;
+	size_t nonwrap_len, copylen;
+	unsigned char buf[USERIO_BUFSIZE];
+	unsigned long flags;
+
+	if (!count)
+		return 0;
+
+	ret = mutex_lock_interruptible(&userio->lock);
+	if (ret)
+		return ret;
+
+	/*
+	 * By the time we get here, the data that was waiting might have been
+	 * taken by another thread. Grab the mutex and check if there's still
+	 * any data waiting, otherwise repeat this process until we have data
+	 * (unless the file descriptor is non-blocking of course)
+	 */
+	for (;;) {
+		spin_lock_irqsave(&userio->buf_lock, flags);
+
+		if (userio->head != userio->tail)
+			break;
+
+		spin_unlock_irqrestore(&userio->buf_lock, flags);
+
+		if (file->f_flags & O_NONBLOCK) {
+			ret = -EAGAIN;
+			goto out;
+		}
+
+		ret = wait_event_interruptible(userio->waitq,
+					       userio->head != userio->tail);
+		if (ret)
+			goto out;
+	}
+
+	nonwrap_len = CIRC_CNT_TO_END(userio->head, userio->tail,
+				      USERIO_BUFSIZE);
+	copylen = min(nonwrap_len, count);
+	memcpy(&buf, &userio->buf[userio->tail], copylen);
+
+	userio->tail = (userio->tail + copylen) % USERIO_BUFSIZE;
+
+	spin_unlock_irqrestore(&userio->buf_lock, flags);
+
+	if (copy_to_user(user_buffer, &buf, copylen))
+		ret = -EFAULT;
+	else
+		ret = copylen;
+
+out:
+	mutex_unlock(&userio->lock);
+	return ret;
+}
+
+static ssize_t userio_char_write(struct file *file, const char __user *buffer,
+				 size_t count, loff_t *ppos)
+{
+	struct userio_device *userio = file->private_data;
+	struct userio_cmd cmd;
+	int ret;
+
+	if (count < sizeof(cmd))
+		return -EINVAL;
+
+	if (copy_from_user(&cmd, buffer, sizeof(cmd)))
+		return -EFAULT;
+
+	ret = mutex_lock_interruptible(&userio->lock);
+	if (ret)
+		return ret;
+
+	switch (cmd.type) {
+	case USERIO_CMD_REGISTER:
+		if (!userio->serio->id.type) {
+			dev_warn(userio_misc.this_device,
+				 "No port type given on /dev/userio\n");
+
+			ret = -EINVAL;
+			goto out;
+		}
+		if (userio->running) {
+			dev_warn(userio_misc.this_device,
+				 "Begin command sent, but we're already running\n");
+
+			ret = -EBUSY;
+			goto out;
+		}
+
+		userio->running = true;
+		serio_register_port(userio->serio);
+		break;
+
+	case USERIO_CMD_SET_PORT_TYPE:
+		if (userio->running) {
+			dev_warn(userio_misc.this_device,
+				 "Can't change port type on an already running userio instance\n");
+
+			ret = -EBUSY;
+			goto out;
+		}
+
+		userio->serio->id.type = cmd.data;
+		break;
+
+	case USERIO_CMD_SEND_INTERRUPT:
+		if (!userio->running) {
+			dev_warn(userio_misc.this_device,
+				 "The device must be registered before sending interrupts\n");
+
+			ret = -ENODEV;
+			goto out;
+		}
+
+		serio_interrupt(userio->serio, cmd.data, 0);
+		break;
+
+	default:
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	ret = sizeof(cmd);
+
+out:
+	mutex_unlock(&userio->lock);
+	return ret;
+}
+
+static unsigned int userio_char_poll(struct file *file, poll_table *wait)
+{
+	struct userio_device *userio = file->private_data;
+
+	poll_wait(file, &userio->waitq, wait);
+
+	if (userio->head != userio->tail)
+		return POLLIN | POLLRDNORM;
+
+	return 0;
+}
+
+static const struct file_operations userio_fops = {
+	.owner		= THIS_MODULE,
+	.open		= userio_char_open,
+	.release	= userio_char_release,
+	.read		= userio_char_read,
+	.write		= userio_char_write,
+	.poll		= userio_char_poll,
+	.llseek		= no_llseek,
+};
+
+static struct miscdevice userio_misc = {
+	.fops	= &userio_fops,
+	.minor	= USERIO_MINOR,
+	.name	= USERIO_NAME,
+};
+
+MODULE_ALIAS_MISCDEV(USERIO_MINOR);
+MODULE_ALIAS("devname:" USERIO_NAME);
+
+MODULE_AUTHOR("Stephen Chandler Paul <thatslyude@gmail.com>");
+MODULE_DESCRIPTION("Virtual Serio Device Support");
+MODULE_LICENSE("GPL");
+
+module_driver(userio_misc, misc_register, misc_deregister);
diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
index 81f6e42..5430374 100644
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -49,6 +49,7 @@
 #define LOOP_CTRL_MINOR		237
 #define VHOST_NET_MINOR		238
 #define UHID_MINOR		239
+#define USERIO_MINOR		240
 #define MISC_DYNAMIC_MINOR	255
 
 struct device;
diff --git a/include/uapi/linux/userio.h b/include/uapi/linux/userio.h
new file mode 100644
index 0000000..37d147f
--- /dev/null
+++ b/include/uapi/linux/userio.h
@@ -0,0 +1,44 @@
+/*
+ * userio: virtual serio device support
+ * Copyright (C) 2015 Red Hat
+ * Copyright (C) 2015 Lyude (Stephen Chandler Paul) <cpaul@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU Lesser General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
+ * details.
+ *
+ * This is the public header used for user-space communication with the userio
+ * driver. __attribute__((__packed__)) is used for all structs to keep ABI
+ * compatibility between all architectures.
+ */
+
+#ifndef _USERIO_H
+#define _USERIO_H
+
+#include <linux/types.h>
+
+enum userio_cmd_type {
+	USERIO_CMD_REGISTER = 0,
+	USERIO_CMD_SET_PORT_TYPE = 1,
+	USERIO_CMD_SEND_INTERRUPT = 2
+};
+
+/*
+ * userio Commands
+ * All commands sent to /dev/userio are encoded using this structure. The type
+ * field should contain a USERIO_CMD* value that indicates what kind of command
+ * is being sent to userio. The data field should contain the accompanying
+ * argument for the command, if there is one.
+ */
+struct userio_cmd {
+	__u8 type;
+	__u8 data;
+} __attribute__((__packed__));
+
+#endif /* !_USERIO_H */
-- 
2.4.3
