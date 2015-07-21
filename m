From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [RFC] Input: Add ps2emu module
Date: Tue, 21 Jul 2015 12:15:12 -0700
Message-ID: <20150721191512.GB21710@kroah.com>
References: <1437505634-8633-1-git-send-email-cpaul@redhat.com>
 <1437505634-8633-2-git-send-email-cpaul@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1437505634-8633-2-git-send-email-cpaul@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Chandler Paul <cpaul@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>, Vishnu Patekar <vishnupatekar0510@gmail.com>, Sebastian Ott <sebott@linux.vnet.ibm.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-input@vger.kernel.org, linux-api@vger.kernel.org, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Hans de Goede <hdegoede@redhat.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 21, 2015 at 03:07:14PM -0400, Stephen Chandler Paul wrote:
> +#define ps2emu_warn(format, args...) \
> +	dev_warn(ps2emu_misc.this_device, format, ## args)

Don't make a wrapper function for another wrapper function, just spell
the thing out in the code, makes it much easier to debug and maintain
over time.

It will also cause you to rename "this_device" to "dev" to make it
easier to type :)

> +static int ps2emu_char_open(struct inode *inode, struct file *file)
> +{
> +	struct ps2emu_device *ps2emu = NULL;
> +
> +	ps2emu = kzalloc(sizeof(struct ps2emu_device), GFP_KERNEL);
> +	if (!ps2emu)
> +		return -ENOMEM;
> +
> +	init_waitqueue_head(&ps2emu->waitq);
> +
> +	ps2emu->serio.write = ps2emu_device_write;
> +	ps2emu->serio.port_data = ps2emu;
> +
> +	file->private_data = ps2emu;
> +
> +	nonseekable_open(inode, file);

Why call this at all?

> +	ret = copy_to_user(buffer, &ps2emu->buf[ps2emu->tail], copylen);
> +	if (ret)
> +		return ret;

Wrong error value, please return -EFAULT.

> +	rc = copy_from_user(&cmd, buffer, sizeof(cmd));
> +	if (rc)
> +		return rc;

Same thing here, -EFAULT.

> +	case PS2EMU_CMD_SEND_INTERRUPT:
> +		if (unlikely(!ps2emu->running)) {

Unless you can verify likely/unlikely actually makes a difference in
your code, don't ever use it.  Hint, it's not needed here.

thanks,

greg k-h
