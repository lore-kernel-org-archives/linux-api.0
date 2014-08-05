From: Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>
Subject: Re: [PATCH 4/7] locking/rwsem: threshold limited spinning for
 active readers
Date: Mon, 04 Aug 2014 22:41:41 -0700
Message-ID: <1407217301.2566.28.camel@buesod1.americas.hpqcorp.net>
References: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com>
	 <1407119782-41119-5-git-send-email-Waiman.Long@hp.com>
	 <1407214461.2566.14.camel@buesod1.americas.hpqcorp.net>
	 <1407216632.2566.22.camel@buesod1.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1407216632.2566.22.camel-5JQ4ckphU/8SZAcGdq5asR6epYMZPwEe5NbjCUgZEJk@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Waiman Long <Waiman.Long-VXdhtT5mjnY@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>, Scott J Norton <scott.norton-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, 2014-08-04 at 22:30 -0700, Davidlohr Bueso wrote:
> On Mon, 2014-08-04 at 21:54 -0700, Davidlohr Bueso wrote:
> > >  #ifdef CONFIG_RWSEM_SPIN_ON_OWNER
> > > +/*
> > > + * The owner field is set to RWSEM_READ_OWNED if the last owner(s) are
> > > + * readers. It is not reset until a writer takes over and set it to its
> > > + * task structure pointer or NULL when it frees the lock. So a value
> > > + * of RWSEM_READ_OWNED doesn't mean it currently has active readers.
> > > + */
> > > +#define RWSEM_READ_OWNED	((struct task_struct *)-1)
> > 
> > Looks rather weird...
> 
> Instead of populating owner when taking the reader lock, why not just
> leave it NULL. Then, we can differentiate between the owner being NULL
> either because it is taken by reader(s) or simply because it is not
> taken. So something like this:
> 
> static inline bool rwsem_owner_is_reader(struct rw_semaphore *sem)
> {
> 	return !sem->owner && rwsem_is_locked(sem));
> }

Although we could race between both checks, specially when going into
slowpaths, too bad. Probably a read barrier before calling is_locked
too. Anyway, you see, things start getting funky.
