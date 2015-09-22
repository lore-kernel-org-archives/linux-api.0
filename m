From: David Herrmann <dh.herrmann@gmail.com>
Subject: Re: [PATCH v5] Input: Add userio module
Date: Tue, 22 Sep 2015 12:59:59 +0200
Message-ID: <CANq1E4R32AsEryyUfUr69jSeJJXRPwfxvY9uuvH7UOqG9Z__Lg@mail.gmail.com>
References: <1442530810-28519-1-git-send-email-cpaul@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1442530810-28519-1-git-send-email-cpaul@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Stephen Chandler Paul <cpaul@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, "open list:HID CORE LAYER" <linux-input@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>, Vishnu Patekar <vishnupatekar0510@gmail.com>, Sebastian Ott <sebott@linux.vnet.ibm.com>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Hans de Goede <hdegoede@redhat.com>, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi

On Fri, Sep 18, 2015 at 1:00 AM,  <cpaul@redhat.com> wrote:
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
> ---
>                                     Changes
>
> * Correct "VIRTUAL PS/2 DEVICE" to "VIRTUAL SERIO DEVICE" in MAINTAINERS
> * Remove uneccessary forward declaration in userio
> * s/repeat repeat/repeat/
> * Drop userio->serio checks, this struct is allocated right when we register
>   the serio port so we don't need to worry about this ever being NULL
> * Allocate a static minor and use that
> * Add MODULE_ALIAS_MISCDEV() and MODULOE_ALIAS() lines to the module
> * Improve the module description
> * Change description for userio.h to "userio: virtual serio device support"
> * Fix double space in comments in userio.h
> * Change userio command types to enumerators
>
>                                    Responses
> * Re: if (!userio) in userio_device_write(): it happens if we close the file
>   descriptor while the input driver is trying to talk to the device, since we
>   can't immediately bring down the driver. Removing the condition breaks the
>   driver
> * Re: ignoring trailing bytes: The main reason for that is if we need to add
>   something else to the struct in the future. I doubt this will ever be done,
>   but I figured I might as well let that behavior go since it can't harm
>   anyone.
> * Re: ignoring larger payloads + adding larger payloads: As of right now there
>   really isn't one. serio_send() only allows you to send a single character at
>   a time, and we can add the ability to have flags using this same packet
>   format. I don't think userio is ever going to get much more complex then
>   this, since I don't think serio is going to be changing very much in the
>   future. This being said, if some unlikely circumstances happen and it does
>   happen  to change in such a way we need to extend the payload, we're
>   currently ignoring the rest of the payload so we could safely add additional
>   data onto the end of the struct.

Please always respond inline to the previous emails. Otherwise, you
break the thread and make it hard to track your responses. Nobody
minds multiple emails.

>  Documentation/input/userio.txt |  70 +++++++++++
>  MAINTAINERS                    |   6 +
>  drivers/input/serio/Kconfig    |  11 ++
>  drivers/input/serio/Makefile   |   1 +
>  drivers/input/serio/userio.c   | 277 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/miscdevice.h     |   1 +
>  include/uapi/linux/userio.h    |  44 +++++++
>  7 files changed, 410 insertions(+)
>  create mode 100644 Documentation/input/userio.txt
>  create mode 100644 drivers/input/serio/userio.c
>  create mode 100644 include/uapi/linux/userio.h

[snip]

> --- /dev/null
> +++ b/drivers/input/serio/userio.c
> @@ -0,0 +1,277 @@
> +/*
> + * userio kernel serio device emulation module
> + * Copyright (C) 2015 Red Hat
> + * Copyright (C) 2015 Stephen Chandler Paul <thatslyude@gmail.com>
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
> +#include <uapi/linux/userio.h>
> +
> +#define USERIO_NAME "userio"
> +#define USERIO_BUFSIZE 16
> +
> +static struct miscdevice userio_misc;
> +
> +struct userio_device {
> +       struct serio *serio;
> +       struct mutex lock;
> +
> +       bool running;
> +
> +       u8 head;
> +       u8 tail;
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
> +
> +       if (!userio)
> +               return -1;

I still cannot see why this is necessary. Care to elaborate?

> +
> +       mutex_lock(&userio->lock);
> +
> +       userio->buf[userio->head] = val;
> +       userio->head = (userio->head + 1) % USERIO_BUFSIZE;
> +
> +       if (userio->head == userio->tail)
> +               dev_warn(userio_misc.this_device,
> +                        "Buffer overflowed, userio client isn't keeping up");
> +
> +       mutex_unlock(&userio->lock);

As Dmitry mentioned, just add a spinlock to "struct userio_device"
(supplementary to the mutex) which just protects buf, head and tail.

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
> +       userio = kzalloc(sizeof(struct userio_device), GFP_KERNEL);
> +       if (!userio)
> +               return -ENOMEM;
> +
> +       mutex_init(&userio->lock);
> +       init_waitqueue_head(&userio->waitq);
> +
> +       userio->serio = kzalloc(sizeof(struct serio), GFP_KERNEL);
> +       if (!userio->serio) {
> +               kfree(userio);
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
> +       /* Don't free the serio port here, serio_unregister_port() does
> +        * this for us */
> +       if (userio->running)
> +               serio_unregister_port(userio->serio);
> +       else
> +               kfree(userio->serio);
> +
> +       kfree(userio);
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
> +       /*
> +        * By the time we get here, the data that was waiting might have been
> +        * taken by another thread. Grab the mutex and check if there's still
> +        * any data waiting, otherwise repeat repeat this process until we have
> +        * data (unless the file descriptor is non-blocking of course)
> +        */
> +       for (;;) {
> +               ret = mutex_lock_interruptible(&userio->lock);
> +               if (ret)
> +                       return ret;

Here it will be enough to take the spinlock rather than the mutex. The
buffer is empty by default, so no reason to synchronize against
write() calls.

> +
> +               if (userio->head != userio->tail)
> +                       break;
> +
> +               mutex_unlock(&userio->lock);
> +
> +               if (file->f_flags & O_NONBLOCK)
> +                       return -EAGAIN;
> +
> +               ret = wait_event_interruptible(userio->waitq,
> +                                              userio->head != userio->tail);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       nonwrap_len = CIRC_CNT_TO_END(userio->head, userio->tail,
> +                                     USERIO_BUFSIZE);
> +       copylen = min(nonwrap_len, count);
> +
> +       if (copy_to_user(buffer, &userio->buf[userio->tail], copylen)) {
> +               mutex_unlock(&userio->lock);
> +               return -EFAULT;
> +       }
> +
> +       userio->tail = (userio->tail + copylen) % USERIO_BUFSIZE;
> +
> +       mutex_unlock(&userio->lock);
> +
> +       return copylen;
> +}
> +
> +static ssize_t userio_char_write(struct file *file, const char __user *buffer,
> +                                size_t count, loff_t *ppos)
> +{
> +       struct userio_device *userio = file->private_data;
> +       struct userio_cmd cmd;
> +       int ret;
> +
> +       if (count < sizeof(cmd))
> +               return -EINVAL;
> +
> +       if (copy_from_user(&cmd, buffer, sizeof(cmd)))
> +               return -EFAULT;
> +
> +       ret = mutex_lock_interruptible(&userio->lock);
> +       if (ret)
> +               return ret;
> +
> +       switch (cmd.type) {
> +       case USERIO_CMD_REGISTER:
> +               if (!userio->serio->id.type) {
> +                       dev_warn(userio_misc.this_device,
> +                                "No port type given on /dev/userio\n");
> +
> +                       ret = -EINVAL;
> +                       goto out;
> +               }
> +               if (userio->running) {
> +                       dev_warn(userio_misc.this_device,
> +                                "Begin command sent, but we're already running\n");
> +
> +                       ret = -EBUSY;
> +                       goto out;
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
> +                       ret = -EBUSY;
> +                       goto out;
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
> +                       ret = -ENODEV;
> +                       goto out;
> +               }
> +
> +               serio_interrupt(userio->serio, cmd.data, 0);
> +               break;
> +
> +       default:
> +               ret = -EOPNOTSUPP;
> +               goto out;
> +       }
> +
> +       ret = sizeof(cmd);
> +
> +out:
> +       mutex_unlock(&userio->lock);
> +       return ret;
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
> +       .minor  = USERIO_MINOR,
> +       .name   = USERIO_NAME,
> +};
> +
> +MODULE_ALIAS_MISCDEV(USERIO_MINOR);
> +MODULE_ALIAS("devname:" USERIO_NAME);
> +
> +MODULE_AUTHOR("Stephen Chandler Paul <thatslyude@gmail.com>");
> +MODULE_DESCRIPTION("Virtual Serio Device Support");
> +MODULE_LICENSE("GPL");
> +
> +module_driver(userio_misc, misc_register, misc_deregister);
> diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
> index 81f6e42..5430374 100644
> --- a/include/linux/miscdevice.h
> +++ b/include/linux/miscdevice.h
> @@ -49,6 +49,7 @@
>  #define LOOP_CTRL_MINOR                237
>  #define VHOST_NET_MINOR                238
>  #define UHID_MINOR             239
> +#define USERIO_MINOR           240
>  #define MISC_DYNAMIC_MINOR     255
>
>  struct device;
> diff --git a/include/uapi/linux/userio.h b/include/uapi/linux/userio.h
> new file mode 100644
> index 0000000..37935b6
> --- /dev/null
> +++ b/include/uapi/linux/userio.h
> @@ -0,0 +1,44 @@
> +/*
> + * userio: virtual serio device support
> + * Copyright (C) 2015 Red Hat
> + * Copyright (C) 2015 Lyude (Stephen Chandler Paul) <cpaul@redhat.com>
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
> + * driver. __attribute__((__packed__)) is used for all structs to keep ABI
> + * compatibility between all architectures.
> + */
> +
> +#ifndef _USERIO_H
> +#define _USERIO_H
> +
> +#include <linux/types.h>
> +
> +enum userio_cmd_type {
> +       USERIO_CMD_REGISTER = 0,
> +       USERIO_CMD_SET_PORT_TYPE = 1,
> +       USERIO_CMD_SEND_INTERRUPT = 2
> +};
> +
> +/*
> + * userio Commands
> + * All commands sent to /dev/userio are encoded using this structure. The type
> + * field should contain a USERIO_CMD* value that indicates what kind of command
> + * is being sent to userio. The data field should contain the accompanying
> + * argument for the command, if there is one.
> + */
> +struct userio_cmd {
> +       enum userio_cmd_type type;

Here I'd stick to "__u8". Sorry, that wasn't clear in my previous
response. I just meant changing the definition to an enum.

Otherwise looks good to me.

Thanks
David

> +       __u8 data;
> +} __attribute__((__packed__));
> +
> +#endif /* !_USERIO_H */
> --
> 2.4.3
>
