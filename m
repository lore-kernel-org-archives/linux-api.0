From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [RFC v3 1/1] Input: Add userio module
Date: Wed, 22 Jul 2015 14:39:59 -0700
Message-ID: <20150722213959.GD14875@dtor-ws>
References: <1437594773-22274-1-git-send-email-cpaul@redhat.com>
 <1437594773-22274-2-git-send-email-cpaul@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1437594773-22274-2-git-send-email-cpaul@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Stephen Chandler Paul <cpaul@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>, Vishnu Patekar <vishnupatekar0510@gmail.com>, Sebastian Ott <sebott@linux.vnet.ibm.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-input@vger.kernel.org, linux-api@vger.kernel.org, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Hans de Goede <hdegoede@redhat.com>
List-Id: linux-api@vger.kernel.org

Hi Stephen,

On Wed, Jul 22, 2015 at 03:52:53PM -0400, Stephen Chandler Paul wrote:
> +static int userio_char_open(struct inode *inode, struct file *file)
> +{
> +	struct userio_device *userio;
> +
> +	userio = devm_kzalloc(userio_misc.this_device,
> +			      sizeof(struct userio_device), GFP_KERNEL);
> +	if (!userio)
> +		return -ENOMEM;

Never ever use devm_ API outside of device probe() calls because
devm-managed resources only freed after failed probe() or after remove()
callback on driver model device and not any other device (block, char,
etc) in the system.

> +
> +	spin_lock_init(&userio->head_lock);
> +	mutex_init(&userio->tail_lock);
> +	init_waitqueue_head(&userio->waitq);
> +
> +	userio->serio = kzalloc(sizeof(struct serio), GFP_KERNEL);
> +	if (!userio->serio) {
> +		devm_kfree(userio_misc.this_device, userio);

And indeed here you have ot manually release the acquired resource. So
the only benefit you got form devm* is wasted resousrces.

> +		return -ENOMEM;
> +	}
> +
> +	userio->serio->write = userio_device_write;
> +	userio->serio->port_data = userio;
> +
> +	file->private_data = userio;
> +
> +	return 0;
> +}
> +
> +static int userio_char_release(struct inode *inode, struct file *file)
> +{
> +	struct userio_device *userio = file->private_data;
> +
> +	if (userio->serio) {
> +		userio->serio->port_data = NULL;

No need to reset, it is going away.

> +
> +		if (userio->running)
> +			serio_unregister_port(userio->serio);
> +		else
> +			kfree(userio->serio);
> +	}
> +
> +	devm_kfree(userio_misc.this_device, userio);
> +
> +	return 0;
> +}
> +
> +static ssize_t userio_char_read(struct file *file, char __user *buffer,
> +				size_t count, loff_t *ppos)
> +{
> +	struct userio_device *userio = file->private_data;
> +	int ret;
> +	size_t nonwrap_len, copylen;
> +
> +	if (!count)
> +		return 0;
> +
> +	if (file->f_flags & O_NONBLOCK && userio->head == userio->tail)
> +		return -EAGAIN;
> +	else {

This is racy. If there was data and other thread "stole" it here then
your O_NONBLOCK will block. See evdev_read() how you supposed to handle
this.

Thanks.

-- 
Dmitry
