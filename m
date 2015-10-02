From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v6.1 1/1] Input: Add userio module
Date: Fri, 2 Oct 2015 10:37:14 -0700
Message-ID: <20151002173714.GA8437@dtor-ws>
References: <1443030589-27574-1-git-send-email-cpaul@redhat.com>
 <1443030899-28737-1-git-send-email-cpaul@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1443030899-28737-1-git-send-email-cpaul@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: cpaul@redhat.com
Cc: David Herrmann <dh.herrmann@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org, linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>, Vishnu Patekar <vishnupatekar0510@gmail.com>, Sebastian Ott <sebott@linux.vnet.ibm.com>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Hans de Goede <hdegoede@redhat.com>, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Sep 23, 2015 at 01:54:59PM -0400, cpaul@redhat.com wrote:
> +static int userio_device_write(struct serio *id, unsigned char val)
> +{
> +	struct userio_device *userio = id->port_data;
> +	unsigned long flags;
> +
> +	if (!userio)
> +		return -1;

I still have the same question: how can this happen? Where do we reset
port data to NULL? What happens if we set to NULL after checking?

> +
> +	spin_lock_irqsave(&userio->buf_lock, flags);
> +
> +	userio->buf[userio->head] = val;
> +	userio->head = (userio->head + 1) % USERIO_BUFSIZE;
> +
> +	if (userio->head == userio->tail)
> +		dev_warn(userio_misc.this_device,
> +			 "Buffer overflowed, userio client isn't keeping up");
> +
> +	spin_unlock_irqrestore(&userio->buf_lock, flags);
> +
> +	wake_up_interruptible(&userio->waitq);
> +
> +	return 0;
> +}

Thanks.

-- 
Dmitry
