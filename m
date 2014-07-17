From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Thu, 17 Jul 2014 17:14:25 -0400
Message-ID: <20140717211425.GU1491@thunk.org>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
 <53C8319A.8090108@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <53C8319A.8090108-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, beck-7YlrpqBBQ3VAfugRpC6u6w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Jul 17, 2014 at 01:27:06PM -0700, Andy Lutomirski wrote:
> > +	return urandom_read(NULL, buf, count, NULL);
> 
> This can return -ERESTARTSYS.  Does it need any logic to restart correctly?

Nope; because we only return -ERESTARTSYS when we haven't generated
any randomness yet.  The way /dev/urandom and /dev/random devices work
is that if we get interrupted, we return a short read.  We do *not*
resume generation of random bytes from where we got interrupted from
the signal handler.

This is consistent with the definition in the signal(7) man page:

       If a blocked call to one of the following interfaces is
       interrupted by a signal handler, then the call will be
       automatically restarted after the signal handler returns if the
       SA_RESTART flag was used; otherwise the call will fail with the
       error EINTR:

           * read(2), readv(2), write(2), writev(2), and ioctl(2)
             calls on "slow" devices.  A "slow" device is one where
             the I/O call may block for an indefinite time, for
             example, a terminal, pipe, or socket.  (A disk is not a
             slow device according to this definition.)  If an I/O
             call on a slow device has already transferred some data
             by the time it is interrupted by a signal handler, then
             the call will return a success status (normally, the
             number of bytes transferred).

And in answer to Zach's question along these lines, ERESTARTSYS gets
restarted or transformed into EINTR by the system call layer, so long
as you only set ERESTARTSYS when signal_pending(current) is true.  If
you accidentally set the return value to ERESTARTSYS when a signal is
not pending, this error code can escape out to user space, which is
considered a bug.  But we're using this correctly in
drivers/char/random.c.

						- Ted
