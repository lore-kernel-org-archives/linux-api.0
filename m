From: Stephen Chandler Paul <cpaul@redhat.com>
Subject: [RFC] Input: Add ps2emu module
Date: Tue, 21 Jul 2015 15:07:14 -0400
Message-ID: <1437505634-8633-2-git-send-email-cpaul@redhat.com>
References: <1437505634-8633-1-git-send-email-cpaul@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437505634-8633-1-git-send-email-cpaul@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>, Vishnu Patekar <vishnupatekar0510@gmail.com>, Sebastian Ott <sebott@linux.vnet.ibm.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-input@vger.kernel.org, linux-api@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>, Hans de Goede <hdegoede@redhat.com>, Stephen Chandler Paul <cpaul@redhat.com>
List-Id: linux-api@vger.kernel.org

Debugging input devices, specifically laptop touchpads, can be tricky
without having the physical device handy. Here we try to remedy that
with ps2emu. This module allows an application to connect to a character
device provided by the kernel, and simulate any PS/2 device. In
combination with userspace programs that can record PS/2 devices and
replay them through the /dev/ps2emu device, this allows developers to
debug driver issues on the PS/2 level with devices simply by requesting
a recording from the user experiencing the issue without having to have
the physical hardware in front of them.

Signed-off-by: Stephen Chandler Paul <cpaul@redhat.com>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 Documentation/input/ps2emu.txt |  72 ++++++++++++
 MAINTAINERS                    |   6 +
 drivers/input/serio/Kconfig    |  10 ++
 drivers/input/serio/Makefile   |   1 +
 drivers/input/serio/ps2emu.c   | 253 +++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/ps2emu.h    |  42 +++++++
 6 files changed, 384 insertions(+)
 create mode 100644 Documentation/input/ps2emu.txt
 create mode 100644 drivers/input/serio/ps2emu.c
 create mode 100644 include/uapi/linux/ps2emu.h

diff --git a/Documentation/input/ps2emu.txt b/Documentation/input/ps2emu.txt
new file mode 100644
index 0000000..560298c
--- /dev/null
+++ b/Documentation/input/ps2emu.txt
@@ -0,0 +1,72 @@
+			      The ps2emu Protocol
+	     (c) 2015 Stephen Chandler Paul <thatslyude@gmail.com>
+			      Sponsored by Red Hat
+--------------------------------------------------------------------------------
+
+1. Introduction
+~~~~~~~~~~~~~~~
+  This module is intended to try to make the lives of input driver developers
+easier by allowing them to test various PS/2 devices (mainly the various
+touchpads found on laptops) without having to have the physical device in front
+of them. ps2emu accomplishes this by allowing any privileged userspace program
+to directly interact with the kernel's serio driver and pretend to be a PS/2
+device.
+
+2. Usage overview
+~~~~~~~~~~~~~~~~~
+  In order to interact with the ps2emu kernel module, one simply opens the
+/dev/ps2emu character device in their applications. Commands are sent to the
+kernel module by writing to the device, and any data received from the serio
+driver is read as-is from the /dev/ps2emu device. All of the structures and
+macros you need to interact with the device are defined in <linux/ps2emu.h>.
+
+3. Command Structure
+~~~~~~~~~~~~~~~~~~~~
+  The struct used for sending commands to /dev/ps2emu is as follows:
+
+	struct ps2emu_cmd {
+		__u8 type;
+		__u8 data;
+	};
+
+  "type" describes the type of command that is being sent. This can be any one
+of the PS2EMU_CMD macros defined in <linux/ps2emu.h>. "data" is the argument
+that goes along with the command. In the event that the command doesn't have an
+argument, this field can be left untouched and will be ignored by the kernel.
+Each command should be sent by writing the struct directly to the character
+device. In the event that the command you send is invalid, an error will be
+returned by the character device and a more descriptive error will be printed
+to the kernel log. Only one command can be sent at a time, any additional data
+written to the character device after the initial command will be ignored.
+  To close the virtual PS/2 port, just close /dev/ps2emu.
+
+4. Commands
+~~~~~~~~~~~
+
+4.1 PS2EMU_CMD_REGISTER
+~~~~~~~~~~~~~~~~~~~~~~~
+  Registers the port with the serio driver and begins transmitting data back and
+forth. Registration can only be performed once a port type is set with
+PS2EMU_CMD_SET_PORT_TYPE. Has no argument.
+
+4.2 PS2EMU_CMD_SET_PORT_TYPE
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+  Sets the type of port we're emulating, where "data" is the port type being
+set. Can be any of the following macros from <linux/serio.h>:
+
+	SERIO_8042
+	SERIO_8042_XL
+	SERIO_PS_PSTHRU
+
+4.3 PS2EMU_CMD_SEND_INTERRUPT
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+  Sends an interrupt through the virtual PS/2 port to the serio driver, where
+"data" is the interrupt data being sent.
+
+5. Userspace tools
+~~~~~~~~~~~~~~~~~~
+  The ps2emu userspace tools are able to record PS/2 devices using some of the
+debugging information from i8042, and play back the devices on /dev/ps2emu. The
+latest version of these tools can be found at:
+
+	https://github.com/Lyude/ps2emu
diff --git a/MAINTAINERS b/MAINTAINERS
index a226416..68a0977 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10877,6 +10877,12 @@ S:	Maintained
 F:	drivers/media/v4l2-core/videobuf2-*
 F:	include/media/videobuf2-*
 
+VIRTUAL PS/2 DEVICE DRIVER
+M:	Stephen Chandler Paul <thatslyude@gmail.com>
+S:	Maintained
+F:	drivers/input/serio/ps2emu.c
+F:	include/uapi/linux/ps2emu.h
+
 VIRTIO CONSOLE DRIVER
 M:	Amit Shah <amit.shah@redhat.com>
 L:	virtualization@lists.linux-foundation.org
diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index 200841b..cc3563f 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -292,4 +292,14 @@ config SERIO_SUN4I_PS2
 	  To compile this driver as a module, choose M here: the
 	  module will be called sun4i-ps2.
 
+config PS2EMU
+	tristate "Virtual PS/2 device support"
+	help
+	  Say Y here if you want to emulate PS/2 devices using the ps2emu tools.
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called ps2emu.
+
+	  If you are unsure, say N.
+
 endif
diff --git a/drivers/input/serio/Makefile b/drivers/input/serio/Makefile
index c600089..7b20936 100644
--- a/drivers/input/serio/Makefile
+++ b/drivers/input/serio/Makefile
@@ -30,3 +30,4 @@ obj-$(CONFIG_SERIO_APBPS2)	+= apbps2.o
 obj-$(CONFIG_SERIO_OLPC_APSP)	+= olpc_apsp.o
 obj-$(CONFIG_HYPERV_KEYBOARD)	+= hyperv-keyboard.o
 obj-$(CONFIG_SERIO_SUN4I_PS2)	+= sun4i-ps2.o
+obj-$(CONFIG_PS2EMU)		+= ps2emu.o
diff --git a/drivers/input/serio/ps2emu.c b/drivers/input/serio/ps2emu.c
new file mode 100644
index 0000000..77b5ca8
--- /dev/null
+++ b/drivers/input/serio/ps2emu.c
@@ -0,0 +1,253 @@
+/*
+ * ps2emu kernel PS/2 device emulation module
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
+#include <linux/libps2.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/sched.h>
+#include <linux/poll.h>
+#include <uapi/linux/ps2emu.h>
+
+#define PS2EMU_NAME "ps2emu"
+#define PS2EMU_MINOR MISC_DYNAMIC_MINOR
+#define PS2EMU_BUFSIZE 16
+
+static const struct file_operations ps2emu_fops;
+static struct miscdevice ps2emu_misc;
+
+struct ps2emu_device {
+	struct serio serio;
+
+	bool running;
+
+	u8 head;
+	u8 tail;
+	unsigned char buf[PS2EMU_BUFSIZE];
+
+	wait_queue_head_t waitq;
+};
+
+#define ps2emu_warn(format, args...) \
+	dev_warn(ps2emu_misc.this_device, format, ## args)
+
+/**
+ * ps2emu_device_write - Write data from serio to a ps2emu device in userspace
+ * @id: The serio port for the ps2emu device
+ * @val: The data to write to the device
+ */
+static int ps2emu_device_write(struct serio *id, unsigned char val)
+{
+	struct ps2emu_device *ps2emu = id->port_data;
+	u8 newhead;
+
+	ps2emu->buf[ps2emu->head] = val;
+
+	newhead = ps2emu->head + 1;
+
+	if (newhead < PS2EMU_BUFSIZE)
+		ps2emu->head = newhead;
+	else
+		ps2emu->head = 0;
+
+	if (unlikely(newhead == ps2emu->tail))
+		ps2emu_warn("Buffer overflowed, ps2emu client isn't keeping up");
+
+	wake_up_interruptible(&ps2emu->waitq);
+
+	return 0;
+}
+
+static int ps2emu_char_open(struct inode *inode, struct file *file)
+{
+	struct ps2emu_device *ps2emu = NULL;
+
+	ps2emu = kzalloc(sizeof(struct ps2emu_device), GFP_KERNEL);
+	if (!ps2emu)
+		return -ENOMEM;
+
+	init_waitqueue_head(&ps2emu->waitq);
+
+	ps2emu->serio.write = ps2emu_device_write;
+	ps2emu->serio.port_data = ps2emu;
+
+	file->private_data = ps2emu;
+
+	nonseekable_open(inode, file);
+
+	return 0;
+}
+
+static int ps2emu_char_release(struct inode *inode, struct file *file)
+{
+	struct ps2emu_device *ps2emu = file->private_data;
+
+	/*
+	 * We can rely on serio_unregister_port() to free the ps2emu struct on
+	 * it's own
+	 */
+	if (ps2emu->running)
+		serio_unregister_port(&ps2emu->serio);
+	else
+		kfree(ps2emu);
+
+	return 0;
+}
+
+static ssize_t ps2emu_char_read(struct file *file, char __user *buffer,
+				size_t count, loff_t *ppos)
+{
+	struct ps2emu_device *ps2emu = file->private_data;
+	int ret;
+	size_t nonwrap_len, copylen;
+	u8 head; /* So we only access ps2emu->head once */
+
+	if (file->f_flags & O_NONBLOCK) {
+		head = ps2emu->head;
+
+		if (head == ps2emu->tail)
+			return -EAGAIN;
+	} else {
+		ret = wait_event_interruptible(
+		       ps2emu->waitq, (head = ps2emu->head) != ps2emu->tail);
+
+		if (ret)
+			return ret;
+	}
+
+	nonwrap_len = CIRC_CNT_TO_END(head, ps2emu->tail, PS2EMU_BUFSIZE);
+	copylen = min(nonwrap_len, count);
+
+	ret = copy_to_user(buffer, &ps2emu->buf[ps2emu->tail], copylen);
+	if (ret)
+		return ret;
+
+	ps2emu->tail += copylen;
+	if (ps2emu->tail == PS2EMU_BUFSIZE)
+		ps2emu->tail = 0;
+
+	return copylen;
+}
+
+static ssize_t ps2emu_char_write(struct file *file, const char __user *buffer,
+				 size_t count, loff_t *ppos)
+{
+	struct ps2emu_device *ps2emu = file->private_data;
+	struct ps2emu_cmd cmd;
+	int rc;
+
+	if (count < sizeof(cmd))
+		return -EINVAL;
+
+	rc = copy_from_user(&cmd, buffer, sizeof(cmd));
+	if (rc)
+		return rc;
+
+	switch (cmd.type) {
+	case PS2EMU_CMD_REGISTER:
+		if (!ps2emu->serio.id.type) {
+			ps2emu_warn("No port type given on /dev/ps2emu\n");
+
+			return -EINVAL;
+		}
+		if (ps2emu->running) {
+			ps2emu_warn("Begin command sent, but we're already running\n");
+
+			return -EINVAL;
+		}
+
+		ps2emu->running = true;
+		serio_register_port(&ps2emu->serio);
+		break;
+
+	case PS2EMU_CMD_SET_PORT_TYPE:
+		if (ps2emu->running) {
+			ps2emu_warn("Can't change port type on an already running ps2emu instance\n");
+
+			return -EINVAL;
+		}
+
+		switch (cmd.data) {
+		case SERIO_8042:
+		case SERIO_8042_XL:
+		case SERIO_PS_PSTHRU:
+			ps2emu->serio.id.type = cmd.data;
+			break;
+
+		default:
+			ps2emu_warn("Invalid port type 0x%hhx\n", cmd.data);
+
+			return -EINVAL;
+		}
+
+		break;
+
+	case PS2EMU_CMD_SEND_INTERRUPT:
+		if (unlikely(!ps2emu->running)) {
+			ps2emu_warn("The device must be registered before sending interrupts\n");
+
+			return -EINVAL;
+		}
+
+		serio_interrupt(&ps2emu->serio, cmd.data, 0);
+
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return sizeof(cmd);
+}
+
+static unsigned int ps2emu_char_poll(struct file *file, poll_table *wait)
+{
+	struct ps2emu_device *ps2emu = file->private_data;
+
+	poll_wait(file, &ps2emu->waitq, wait);
+
+	if (ps2emu->head != ps2emu->tail)
+		return POLLIN | POLLRDNORM;
+
+	return 0;
+}
+
+static const struct file_operations ps2emu_fops = {
+	.owner		= THIS_MODULE,
+	.open		= ps2emu_char_open,
+	.release	= ps2emu_char_release,
+	.read		= ps2emu_char_read,
+	.write		= ps2emu_char_write,
+	.poll		= ps2emu_char_poll,
+	.llseek		= no_llseek,
+};
+
+static struct miscdevice ps2emu_misc = {
+	.fops	= &ps2emu_fops,
+	.minor	= PS2EMU_MINOR,
+	.name	= PS2EMU_NAME,
+};
+
+MODULE_AUTHOR("Stephen Chandler Paul <thatslyude@gmail.com>");
+MODULE_DESCRIPTION("ps2emu");
+MODULE_LICENSE("GPL");
+
+module_driver(ps2emu_misc, misc_register, misc_deregister);
diff --git a/include/uapi/linux/ps2emu.h b/include/uapi/linux/ps2emu.h
new file mode 100644
index 0000000..63f5cc9
--- /dev/null
+++ b/include/uapi/linux/ps2emu.h
@@ -0,0 +1,42 @@
+/*
+ * ps2emu.h
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
+ * This is the public header used for user-space communication with the ps2emu
+ * driver. __attribute__((__packed__)) is used  for all structs to keep ABI
+ * compatibility between all architectures.
+ */
+
+#ifndef _PS2EMU_H
+#define _PS2EMU_H
+
+#include <linux/types.h>
+
+#define PS2EMU_CMD_REGISTER		0
+#define PS2EMU_CMD_SET_PORT_TYPE	1
+#define PS2EMU_CMD_SEND_INTERRUPT	2
+
+/*
+ * ps2emu Commands
+ * All commands sent to /dev/ps2emu are encoded using this structure. The type
+ * field should contain a PS2EMU_CMD* value that indicates what kind of command
+ * is being sent to ps2emu. The data field should contain the accompanying
+ * argument for the command, if there is one.
+ */
+struct ps2emu_cmd {
+	__u8 type;
+	__u8 data;
+} __attribute__((__packed__));
+
+#endif /* !_PS2EMU_H */
-- 
2.4.3
