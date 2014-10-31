From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: kdbus: add driver skeleton, ioctl entry points and utility
 functions
Date: Fri, 31 Oct 2014 01:23:39 +0100 (CET)
Message-ID: <alpine.LRH.2.00.1410310114290.11562@twin.jikos.cz>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <1414620056-6675-4-git-send-email-gregkh@linuxfoundation.org> <alpine.DEB.2.11.1410302224230.5308@nanos>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1410302224230.5308@nanos>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, desrt-0xnayjDhYQY@public.gmane.org, hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 31 Oct 2014, Thomas Gleixner wrote:

> > +static long kdbus_handle_ioctl(struct file *file, unsigned int cmd,
> > +			       unsigned long arg)
> > +{
> > +	struct kdbus_handle *handle = file->private_data;
> > +	void __user *argp = (void __user *)arg;
> > +	enum kdbus_handle_type type = handle->type;
> > +
> > +	/* make sure all handle fields are set if handle->type is */
> > +	smp_rmb();
> 
> Sure. You really need this kind of serialization because your design
> choice of allowing opaque handles in the first place.
> 
> I'm really interested why you need this rmb() at all. Just because you
> have several threads in user space which might race with the type
> assignment when they call the ioctl?
> 
> We have a strict requirement to document memory barriers. The
> following comment definitely does not fulfil this requirement as it
> just documents that someone observed a race of unknown provenance and
> got it 'fixed' with a 'smp_rmb()'
> 
> > +     /* make sure all handle fields are set if handle->type is */
> 
> That's really hillarious, The user space side knows excatly upfront
> which type of 'handle' it wants to open. Making it an opaque handle in
> the first place and let the kernel deal with the actual type
> assignment is beyond silly. Especially if that involves undocumented
> memory barriers.

I have been staring at exactly this for rather a long time today. 

Apparently this barrier pairs with smp_wmb() in kdbus_handle_transform() 
and tries to make sure that whenever handle->type is seen as updated, 
handle->ptr is as well.

But it's still difficult for me to understand all the memory ordering 
rules and consequences of this strict ordering (my current understanding 
is that the barrier is not needed, but I will have to think about it a 
little bit more), so a nice and explanatory comment precisely describing 
the race this is protecting against would be very welcome.

Thanks,

-- 
Jiri Kosina
SUSE Labs
