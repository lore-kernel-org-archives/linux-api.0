From: LABBE Corentin <montjoie.mailing@gmail.com>
Subject: Re: [PATCH v8] Input: Add userio module
Date: Fri, 9 Oct 2015 16:52:44 +0200
Message-ID: <20151009145244.GB20559@Red>
References: <CANq1E4RCwq49T=iR40NfQLtxKdLCoTLFQB2KA17ksqRyTB568w@mail.gmail.com>
 <1444401053-6686-1-git-send-email-cpaul@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1444401053-6686-1-git-send-email-cpaul@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: cpaul@redhat.com
Cc: David Herrmann <dh.herrmann@gmail.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>, Vishnu Patekar <vishnupatekar0510@gmail.com>, Sebastian Ott <sebott@linux.vnet.ibm.com>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Hans de Goede <hdegoede@redhat.com>, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Oct 09, 2015 at 10:30:53AM -0400, cpaul@redhat.com wrote:
> From: Stephen Chandler Paul <cpaul@redhat.com>
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
> +
> +	/*
> +	 * By the time we get here, the data that was waiting might have been
> +	 * taken by another thread. Grab the mutex and check if there's still
> +	 * any data waiting, otherwise repeat this process until we have data
> +	 * (unless the file descriptor is non-blocking of course)
> +	 */
> +	for (;;) {
> +		spin_lock_irqsave(&userio->buf_lock, flags);
> +
> +		if (userio->head != userio->tail)
> +			break;
> +
> +		spin_unlock_irqrestore(&userio->buf_lock, flags);
> +
> +		if (file->f_flags & O_NONBLOCK)
> +			return -EAGAIN;
> +
> +		ret = wait_event_interruptible(userio->waitq,
> +					       userio->head != userio->tail);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	nonwrap_len = CIRC_CNT_TO_END(userio->head, userio->tail,
> +				      USERIO_BUFSIZE);
> +	copylen = min(nonwrap_len, count);
> +	memcpy(buf, &userio->buf[userio->tail], copylen);
> +
> +	userio->tail = (userio->tail + copylen) % USERIO_BUFSIZE;
> +
> +	spin_unlock_irqrestore(&userio->buf_lock, flags);
> +
> +	if (copy_to_user(user_buffer, buf, copylen))
> +		return -EFAULT;
> +
> +	return copylen;
> +}

Hello

I think you could simplify by just return copy_to_user() since it return copylen in case of success.

Regards

