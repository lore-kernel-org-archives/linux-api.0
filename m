From: Benjamin Tissoires <benjamin.tissoires-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC v3 1/1] Input: Add userio module
Date: Wed, 22 Jul 2015 16:53:38 -0400
Message-ID: <CAN+gG=FJYpU681x6BfjODJEsT1OSL+WwV3zqCGjr7xGuo-r1aQ@mail.gmail.com>
References: <1437594773-22274-1-git-send-email-cpaul@redhat.com>
	<1437594773-22274-2-git-send-email-cpaul@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437594773-22274-2-git-send-email-cpaul-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Chandler Paul <cpaul-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Jiri Slaby <jslaby-IBi9RG/b67k@public.gmane.org>, Vishnu Patekar <vishnupatekar0510-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sebastian Ott <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-input <linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 22, 2015 at 3:52 PM, Stephen Chandler Paul <cpaul-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
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
> Signed-off-by: Stephen Chandler Paul <cpaul-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---

Thanks Chandler for the new version. I think we still need to enhance
the concurrency barriers here. See inline.

>  Documentation/input/userio.txt |  70 +++++++++++
>  MAINTAINERS                    |   6 +
>  drivers/input/serio/Kconfig    |  11 ++
>  drivers/input/serio/Makefile   |   1 +
>  drivers/input/serio/userio.c   | 261 +++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/userio.h    |  42 +++++++
>  6 files changed, 391 insertions(+)
>  create mode 100644 Documentation/input/userio.txt
>  create mode 100644 drivers/input/serio/userio.c
>  create mode 100644 include/uapi/linux/userio.h
>
> diff --git a/Documentation/input/userio.txt b/Documentation/input/userio.txt
> new file mode 100644
> index 0000000..0880c0f
> --- /dev/null
> +++ b/Documentation/input/userio.txt
> @@ -0,0 +1,70 @@
> +                             The userio Protocol
> +            (c) 2015 Stephen Chandler Paul <thatslyude-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> +                             Sponsored by Red Hat
> +--------------------------------------------------------------------------------
> +
> +1. Introduction
> +~~~~~~~~~~~~~~~
> +  This module is intended to try to make the lives of input driver developers
> +easier by allowing them to test various serio devices (mainly the various
> +touchpads found on laptops) without having to have the physical device in front
> +of them. userio accomplishes this by allowing any privileged userspace program
> +to directly interact with the kernel's serio driver and control a virtual serio
> +port from there.
> +
> +2. Usage overview
> +~~~~~~~~~~~~~~~~~
> +  In order to interact with the userio kernel module, one simply opens the
> +/dev/userio character device in their applications. Commands are sent to the
> +kernel module by writing to the device, and any data received from the serio
> +driver is read as-is from the /dev/userio device. All of the structures and
> +macros you need to interact with the device are defined in <linux/userio.h> and
> +<linux/serio.h>.
> +
> +3. Command Structure
> +~~~~~~~~~~~~~~~~~~~~
> +  The struct used for sending commands to /dev/userio is as follows:
> +
> +       struct userio_cmd {
> +               __u8 type;
> +               __u8 data;
> +       };
> +
> +  "type" describes the type of command that is being sent. This can be any one
> +of the USERIO_CMD macros defined in <linux/userio.h>. "data" is the argument
> +that goes along with the command. In the event that the command doesn't have an
> +argument, this field can be left untouched and will be ignored by the kernel.
> +Each command should be sent by writing the struct directly to the character
> +device. In the event that the command you send is invalid, an error will be
> +returned by the character device and a more descriptive error will be printed
> +to the kernel log. Only one command can be sent at a time, any additional data
> +written to the character device after the initial command will be ignored.
> +  To close the virtual serio port, just close /dev/userio.
> +
> +4. Commands
> +~~~~~~~~~~~
> +
> +4.1 USERIO_CMD_REGISTER
> +~~~~~~~~~~~~~~~~~~~~~~~
> +  Registers the port with the serio driver and begins transmitting data back and
> +forth. Registration can only be performed once a port type is set with
> +USERIO_CMD_SET_PORT_TYPE. Has no argument.
> +
> +4.2 USERIO_CMD_SET_PORT_TYPE
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +  Sets the type of port we're emulating, where "data" is the port type being
> +set. Can be any of the macros from <linux/serio.h>. For example: SERIO_8042
> +would set the port type to be a normal PS/2 port.
> +
> +4.3 USERIO_CMD_SEND_INTERRUPT
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +  Sends an interrupt through the virtual serio port to the serio driver, where
> +"data" is the interrupt data being sent.
> +
> +5. Userspace tools
> +~~~~~~~~~~~~~~~~~~
> +  The userio userspace tools are able to record PS/2 devices using some of the
> +debugging information from i8042, and play back the devices on /dev/userio. The
> +latest version of these tools can be found at:
> +
> +       https://github.com/Lyude/ps2emu
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a226416..68a0977 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10877,6 +10877,12 @@ S:     Maintained
>  F:     drivers/media/v4l2-core/videobuf2-*
>  F:     include/media/videobuf2-*
>
> +VIRTUAL PS/2 DEVICE DRIVER
> +M:     Stephen Chandler Paul <thatslyude-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> +S:     Maintained
> +F:     drivers/input/serio/ps2emu.c
> +F:     include/uapi/linux/ps2emu.h
> +
>  VIRTIO CONSOLE DRIVER
>  M:     Amit Shah <amit.shah-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>  L:     virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
> index 200841b..22b8b58 100644
> --- a/drivers/input/serio/Kconfig
> +++ b/drivers/input/serio/Kconfig
> @@ -292,4 +292,15 @@ config SERIO_SUN4I_PS2
>           To compile this driver as a module, choose M here: the
>           module will be called sun4i-ps2.
>
> +config USERIO
> +       tristate "Virtual serio device support"
> +       help
> +         Say Y here if you want to emulate serio devices using the userio
> +         kernel module.
> +
> +         To compile this driver as a module, choose M here: the module will be
> +         called userio.
> +
> +         If you are unsure, say N.
> +
>  endif
> diff --git a/drivers/input/serio/Makefile b/drivers/input/serio/Makefile
> index c600089..2374ef9 100644
> --- a/drivers/input/serio/Makefile
> +++ b/drivers/input/serio/Makefile
> @@ -30,3 +30,4 @@ obj-$(CONFIG_SERIO_APBPS2)    += apbps2.o
>  obj-$(CONFIG_SERIO_OLPC_APSP)  += olpc_apsp.o
>  obj-$(CONFIG_HYPERV_KEYBOARD)  += hyperv-keyboard.o
>  obj-$(CONFIG_SERIO_SUN4I_PS2)  += sun4i-ps2.o
> +obj-$(CONFIG_USERIO)           += userio.o
> diff --git a/drivers/input/serio/userio.c b/drivers/input/serio/userio.c
> new file mode 100644
> index 0000000..578b107
> --- /dev/null
> +++ b/drivers/input/serio/userio.c
> @@ -0,0 +1,261 @@
> +/*
> + * userio kernel serio device emulation module
> + * Copyright (C) 2015 Red Hat
> + * Copyright (C) 2015 Stephen Chandler Paul <thatslyude-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU Lesser General Public License as published by the
> + * Free Software Foundation; either version 2 of the License, or (at your
> + * option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
> + * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
> + * details.
> + */
> +#include <linux/circ_buf.h>
> +#include <linux/mutex.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/serio.h>
> +#include <linux/slab.h>
> +#include <linux/fs.h>
> +#include <linux/miscdevice.h>
> +#include <linux/sched.h>
> +#include <linux/poll.h>
> +#include <linux/spinlock.h>
> +#include <uapi/linux/userio.h>
> +
> +#define USERIO_NAME "userio"
> +#define USERIO_BUFSIZE 16
> +
> +static const struct file_operations userio_fops;
> +static struct miscdevice userio_misc;
> +
> +struct userio_device {
> +       struct serio *serio;
> +
> +       bool running;
> +
> +       u8 head;
> +       u8 tail;
> +
> +       /*
> +        * Since we need to copy from userspace when modifying the tail and we
> +        * don't want to lock up the serio driver during these operations, we
> +        * use two different locks
> +        */

My guts tell me that this is racy. You generally want to have a single
mutex/spinlock to protect your buffer. Having 2 might introduce
interesting complex problems...

> +       spinlock_t head_lock;
> +       struct mutex tail_lock;
> +
> +       unsigned char buf[USERIO_BUFSIZE];
> +
> +       wait_queue_head_t waitq;
> +};
> +
> +/**
> + * userio_device_write - Write data from serio to a userio device in userspace
> + * @id: The serio port for the userio device
> + * @val: The data to write to the device
> + */
> +static int userio_device_write(struct serio *id, unsigned char val)
> +{
> +       struct userio_device *userio = id->port_data;
> +       unsigned long flags;
> +
> +       if (!userio)
> +               return -1;
> +
> +       spin_lock_irqsave(&userio->head_lock, flags);
> +

I know Dmitry said that this could be called by several threads, but I
am not 100% sure.
This function is called by the serio driver, and I don't think we will
have more than one thread at a time in the serio driver (this would
raise interesting hardware behavior for a serial protocol).

Though protecting the head and the value here could be a good thing if
you protect also when you read them.

> +       userio->buf[userio->head] = val;
> +       userio->head = (userio->head + 1) % USERIO_BUFSIZE;
> +
> +       spin_unlock_irqrestore(&userio->head_lock, flags);
> +
> +       if (userio->head == userio->tail)
> +               dev_warn(userio_misc.this_device,
> +                        "Buffer overflowed, userio client isn't keeping up");
> +
> +       wake_up_interruptible(&userio->waitq);
> +
> +       return 0;
> +}
> +
> +static int userio_char_open(struct inode *inode, struct file *file)
> +{
> +       struct userio_device *userio;
> +
> +       userio = devm_kzalloc(userio_misc.this_device,
> +                             sizeof(struct userio_device), GFP_KERNEL);
> +       if (!userio)
> +               return -ENOMEM;
> +
> +       spin_lock_init(&userio->head_lock);
> +       mutex_init(&userio->tail_lock);
> +       init_waitqueue_head(&userio->waitq);
> +
> +       userio->serio = kzalloc(sizeof(struct serio), GFP_KERNEL);
> +       if (!userio->serio) {
> +               devm_kfree(userio_misc.this_device, userio);
> +               return -ENOMEM;
> +       }
> +
> +       userio->serio->write = userio_device_write;
> +       userio->serio->port_data = userio;
> +
> +       file->private_data = userio;
> +
> +       return 0;
> +}
> +
> +static int userio_char_release(struct inode *inode, struct file *file)
> +{
> +       struct userio_device *userio = file->private_data;
> +
> +       if (userio->serio) {
> +               userio->serio->port_data = NULL;
> +
> +               if (userio->running)
> +                       serio_unregister_port(userio->serio);
> +               else
> +                       kfree(userio->serio);
> +       }
> +
> +       devm_kfree(userio_misc.this_device, userio);

Calling devm_kfree directly should always raise a big red warning. The
point of having managed memory is to avoid calling kfree. If you have
to, then you probably should not call devm_kzalloc() in the first
place.

> +
> +       return 0;
> +}
> +
> +static ssize_t userio_char_read(struct file *file, char __user *buffer,
> +                               size_t count, loff_t *ppos)
> +{
> +       struct userio_device *userio = file->private_data;
> +       int ret;
> +       size_t nonwrap_len, copylen;
> +
> +       if (!count)
> +               return 0;
> +
> +       if (file->f_flags & O_NONBLOCK && userio->head == userio->tail)

This section is not protected while you are accessing userio->tail.
I think it is still safe here, but I am not 100% sure.

> +               return -EAGAIN;
> +       else {
> +               ret = wait_event_interruptible(userio->waitq,
> +                                              userio->head != userio->tail);

I would protect this under the mutex, but OTOH, it might lead also to
some interesting lockups.

> +
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       mutex_lock(&userio->tail_lock);
> +
> +       nonwrap_len = CIRC_CNT_TO_END(userio->head, userio->tail,
> +                                     USERIO_BUFSIZE);
> +       copylen = min(nonwrap_len, count);
> +
> +       if (copy_to_user(buffer, &userio->buf[userio->tail], copylen)) {
> +               mutex_unlock(&userio->tail_lock);
> +               return -EFAULT;
> +       }
> +
> +       userio->tail = (userio->tail + copylen) % USERIO_BUFSIZE;
> +
> +       mutex_unlock(&userio->tail_lock);
> +
> +       return copylen;
> +}
> +
> +static ssize_t userio_char_write(struct file *file, const char __user *buffer,
> +                                size_t count, loff_t *ppos)
> +{
> +       struct userio_device *userio = file->private_data;
> +       struct userio_cmd cmd;
> +
> +       if (count < sizeof(cmd))
> +               return -EINVAL;
> +
> +       if (copy_from_user(&cmd, buffer, sizeof(cmd)))
> +               return -EFAULT;
> +

Starting from here

> +       switch (cmd.type) {
> +       case USERIO_CMD_REGISTER:
> +               if (!userio->serio->id.type) {
> +                       dev_warn(userio_misc.this_device,
> +                                "No port type given on /dev/userio\n");
> +
> +                       return -EINVAL;
> +               }
> +               if (userio->running) {
> +                       dev_warn(userio_misc.this_device,
> +                                "Begin command sent, but we're already running\n");
> +
> +                       return -EINVAL;
> +               }
> +
> +               userio->running = true;
> +               serio_register_port(userio->serio);
> +               break;
> +
> +       case USERIO_CMD_SET_PORT_TYPE:
> +               if (userio->running) {
> +                       dev_warn(userio_misc.this_device,
> +                                "Can't change port type on an already running userio instance\n");
> +
> +                       return -EINVAL;
> +               }
> +
> +               userio->serio->id.type = cmd.data;
> +               break;
> +
> +       case USERIO_CMD_SEND_INTERRUPT:
> +               if (!userio->running) {
> +                       dev_warn(userio_misc.this_device,
> +                                "The device must be registered before sending interrupts\n");
> +
> +                       return -EINVAL;
> +               }
> +
> +               serio_interrupt(userio->serio, cmd.data, 0);
> +               break;
> +
> +       default:
> +               return -EINVAL;
> +       }

... to here, you should protect this against several threads. You
don't want to register twice the serio port because 2 threads read
userio->running as false when issuing USERIO_CMD_REGISTER.
Likewise, there could be races between USERIO_CMD_SEND_INTERRUPT and
USERIO_CMD_REGISTER.

I don't think this user-space interface (both read and write) is time
critical, so I would simply put a lock before each interaction with
the internal state and release it when done.

> +
> +       return sizeof(cmd);
> +}
> +
> +static unsigned int userio_char_poll(struct file *file, poll_table *wait)
> +{
> +       struct userio_device *userio = file->private_data;
> +
> +       poll_wait(file, &userio->waitq, wait);
> +
> +       if (userio->head != userio->tail)
> +               return POLLIN | POLLRDNORM;
> +
> +       return 0;
> +}
> +
> +static const struct file_operations userio_fops = {
> +       .owner          = THIS_MODULE,
> +       .open           = userio_char_open,
> +       .release        = userio_char_release,
> +       .read           = userio_char_read,
> +       .write          = userio_char_write,
> +       .poll           = userio_char_poll,
> +       .llseek         = no_llseek,
> +};
> +
> +static struct miscdevice userio_misc = {
> +       .fops   = &userio_fops,
> +       .minor  = MISC_DYNAMIC_MINOR,
> +       .name   = USERIO_NAME,
> +};
> +
> +MODULE_AUTHOR("Stephen Chandler Paul <thatslyude-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>");
> +MODULE_DESCRIPTION("userio");
> +MODULE_LICENSE("GPL");
> +
> +module_driver(userio_misc, misc_register, misc_deregister);
> diff --git a/include/uapi/linux/userio.h b/include/uapi/linux/userio.h
> new file mode 100644
> index 0000000..da0a3d6
> --- /dev/null
> +++ b/include/uapi/linux/userio.h
> @@ -0,0 +1,42 @@
> +/*
> + * userio.h
> + * Copyright (C) 2015 Red Hat
> + * Copyright (C) 2015 Lyude (Stephen Chandler Paul) <cpaul-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU Lesser General Public License as published by the
> + * Free Software Foundation; either version 2 of the License, or (at your
> + * option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
> + * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
> + * details.
> + *
> + * This is the public header used for user-space communication with the userio
> + * driver. __attribute__((__packed__)) is used  for all structs to keep ABI
> + * compatibility between all architectures.
> + */
> +
> +#ifndef _USERIO_H
> +#define _USERIO_H
> +
> +#include <linux/types.h>
> +
> +#define USERIO_CMD_REGISTER            0
> +#define USERIO_CMD_SET_PORT_TYPE       1
> +#define USERIO_CMD_SEND_INTERRUPT      2
> +
> +/*
> + * userio Commands
> + * All commands sent to /dev/userio are encoded using this structure. The type
> + * field should contain a USERIO_CMD* value that indicates what kind of command
> + * is being sent to userio. The data field should contain the accompanying
> + * argument for the command, if there is one.
> + */
> +struct userio_cmd {
> +       __u8 type;
> +       __u8 data;
> +} __attribute__((__packed__));
> +
> +#endif /* !_USERIO_H */
> --
> 2.4.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers,
Benjamin
