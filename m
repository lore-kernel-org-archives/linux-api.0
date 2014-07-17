From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Thu, 17 Jul 2014 16:43:40 -0400
Message-ID: <20140717204340.GS1491@thunk.org>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
 <20140717161215.GA14951@infradead.org>
 <20140717170115.GO1491@thunk.org>
 <CAComcpObt4y--GEuAZgzkaDWnrJYBKhwsvqjOkdiXU_yGnV2Tg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAComcpObt4y--GEuAZgzkaDWnrJYBKhwsvqjOkdiXU_yGnV2Tg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bob Beck <beck-7YlrpqBBQ3VAfugRpC6u6w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 17, 2014 at 11:50:58AM -0600, Bob Beck wrote:
> >
> > int getentropy(void *buf, size_t buflen)
> > {
> >         int     ret;
> >
> >         ret = getentropy(buf, buflen, 0);
> >         return (ret > 0) ? 0 : ret;
> > }
> >
> > The reason for the additional flags is that I'm trying to solve more
> > problems than just getentropy()'s raison d'etre.  The discussion of
> > this is in the commit description; let me know if there bits that I
> > could make clearer.
> 
> Ted is that the right flags with the new call so it doesn't block?

Yes, it's currently the correct flags.  There are some people who are
arguing for GRND_NONBLOCK instead of GRND_BLOCK.  The original idea
was that default should always be non-blocking, and you want 0 to be
the default.

On Thu, Jul 17, 2014 at 12:48:12PM -0700, Zach Brown wrote:
> Do we want it to block by default and have the flag be _NONBLOCK?  Feels
> more.. familiar.

Yes, I'm starting to think so.  In the default case where we are using
the urandom pool, we *do* want the default to block until the pool is
initialized.  At least, the FreeBSD people have been whining forever
that Linux is horribly insecure because we don't block until we are
sure that we know that we have good entropy in the pool.

The git description explains why I haven't changed this to date; I
didn't want to break userspace.  In addition, I've been working
awfully hard to make sure that least on x86 systems, that we gather
enough system noise that despite the fact that we are being very
conservative in our entropy estimation/accounting), the pool gets
initialized very quickly.

My goal was that on x86 laptops and severs, that the pool would be
fully initialized before the openssh scripts has a chance to run.  We
have a printk that triggers if something tries to read from
/dev/urandom before it is fully initialized, and we seem to be doing
pretty well.  Systemd seems to want to read from /dev/urandom in very
early boot:

Jul 11 21:14:10 closure kernel: [    2.941902] random: systemd urandom read with 109 bits of entropy available

.... but if you use the old-fashioned System V init scripts, it seems
to work fairly well.  :-)

So in practice, the fact that we block at system init time shouldn't
be a hardship for LibreSSL in most cases --- and in the case where you
are running on an embedded system where there are barely any devices,
no cycle counter, and nothing that produces enough interrupts to
initialize the pool, what would you prefer that we do?  Return data
that might not be fully "seed grade entropy"?

If you are determined to get data from a not a fully initialized
entropy pool, then you can open /dev/urandom and get it via the old
interface.  In actual practice, this shouldn't happen except in very
early boot, when any sane system wouldn't be trying to create
long-term public keys anyway.  (The fact that most systems try to
create OpenSSH's host keys as the first thing after an out-of-the-Box
first boot situation is something I've always considered Crazy-Eddie
Bat-Shit Insane....)  And that early in the boot sequence, it's highly
unlikely that an attacker would be carrying out a fd exhaustion
attack, since the network won't have been started.  And if you are
determined to get data even from an potentially insecure pool, and you
can't open /dev/urandom due to a fd exhaustion attack, the right
answer is to SIGKILL yourself anyway....

						- Ted
