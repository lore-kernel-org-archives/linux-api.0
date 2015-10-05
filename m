From: Stephen Chandler Paul <cpaul-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6.1 1/1] Input: Add userio module
Date: Mon, 05 Oct 2015 10:06:24 -0400
Message-ID: <1444053984.8404.1.camel@redhat.com>
References: <1443030589-27574-1-git-send-email-cpaul@redhat.com>
	 <1443030899-28737-1-git-send-email-cpaul@redhat.com>
	 <20151002173714.GA8437@dtor-ws>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151002173714.GA8437@dtor-ws>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Jiri Slaby <jslaby-IBi9RG/b67k@public.gmane.org>, Vishnu Patekar <vishnupatekar0510-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sebastian Ott <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 2015-10-02 at 10:37 -0700, Dmitry Torokhov wrote:
> On Wed, Sep 23, 2015 at 01:54:59PM -0400, cpaul-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> > +static int userio_device_write(struct serio *id, unsigned char
> > val)
> > +{
> > +	struct userio_device *userio = id->port_data;
> > +	unsigned long flags;
> > +
> > +	if (!userio)
> > +		return -1;
> 
> I still have the same question: how can this happen? Where do we
> reset
> port data to NULL? What happens if we set to NULL after checking?
> 

Actually David pointed out this line was not needed, somehow it still
got left in the patch. I'll send an updated version in just a minute
with the changes.

Cheers,
	Lyude
> > +
> > +	spin_lock_irqsave(&userio->buf_lock, flags);
> > +
> > +	userio->buf[userio->head] = val;
> > +	userio->head = (userio->head + 1) % USERIO_BUFSIZE;
> > +
> > +	if (userio->head == userio->tail)
> > +		dev_warn(userio_misc.this_device,
> > +			 "Buffer overflowed, userio client isn't
> > keeping up");
> > +
> > +	spin_unlock_irqrestore(&userio->buf_lock, flags);
> > +
> > +	wake_up_interruptible(&userio->waitq);
> > +
> > +	return 0;
> > +}
> 
> Thanks.
> 
