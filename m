From: Stephen Chandler Paul <cpaul-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v8] Input: Add userio module
Date: Fri, 09 Oct 2015 10:59:31 -0400
Message-ID: <1444402771.18131.11.camel@redhat.com>
References: <CANq1E4RCwq49T=iR40NfQLtxKdLCoTLFQB2KA17ksqRyTB568w@mail.gmail.com>
	 <1444401053-6686-1-git-send-email-cpaul@redhat.com>
	 <20151009145244.GB20559@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151009145244.GB20559@Red>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: LABBE Corentin <montjoie.mailing-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Jiri Slaby <jslaby-IBi9RG/b67k@public.gmane.org>, Vishnu Patekar <vishnupatekar0510-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sebastian Ott <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 2015-10-09 at 16:52 +0200, LABBE Corentin wrote:
> On Fri, Oct 09, 2015 at 10:30:53AM -0400, cpaul-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> > From: Stephen Chandler Paul <cpaul-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > +
> > +static ssize_t userio_char_read(struct file *file, char __user
> > *user_buffer,
> > +				size_t count, loff_t *ppos)
> > +{
> > +	struct userio_device *userio = file->private_data;
> > +	int ret;
> > +	size_t nonwrap_len, copylen;
> > +	unsigned char buf[USERIO_BUFSIZE];
> > +	unsigned long flags;
> > +
> > +	if (!count)
> > +		return 0;
> > +
> > +	/*
> > +	 * By the time we get here, the data that was waiting
> > might have been
> > +	 * taken by another thread. Grab the mutex and check if
> > there's still
> > +	 * any data waiting, otherwise repeat this process until
> > we have data
> > +	 * (unless the file descriptor is non-blocking of course)
> > +	 */
> > +	for (;;) {
> > +		spin_lock_irqsave(&userio->buf_lock, flags);
> > +
> > +		if (userio->head != userio->tail)
> > +			break;
> > +
> > +		spin_unlock_irqrestore(&userio->buf_lock, flags);
> > +
> > +		if (file->f_flags & O_NONBLOCK)
> > +			return -EAGAIN;
> > +
> > +		ret = wait_event_interruptible(userio->waitq,
> > +					       userio->head !=
> > userio->tail);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> > +	nonwrap_len = CIRC_CNT_TO_END(userio->head, userio->tail,
> > +				      USERIO_BUFSIZE);
> > +	copylen = min(nonwrap_len, count);
> > +	memcpy(buf, &userio->buf[userio->tail], copylen);
> > +
> > +	userio->tail = (userio->tail + copylen) % USERIO_BUFSIZE;
> > +
> > +	spin_unlock_irqrestore(&userio->buf_lock, flags);
> > +
> > +	if (copy_to_user(user_buffer, buf, copylen))
> > +		return -EFAULT;
> > +
> > +	return copylen;
> > +}
> 
> Hello
> 
> I think you could simplify by just return copy_to_user() since it
> return copylen in case of success.
> 
> Regards

Hi! You're mistaken here actually:
https://www.fsl.cs.sunysb.edu/kernel-api/re256.html
"Returns number of bytes that could not be copied. On success, this
will be zero". Plus, we need to check if the copy failed or not since
if it did we have to indicate -EFAULT to signal that the memory address
the user's buffer is pointed to isn't actually accessible.

Cheers,
	Lyude
