From: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Subject: [PATCH/RFC] F_SETFL/Fasync BKL removal, now without unsightly global locks
Date: Mon,  2 Feb 2009 11:20:07 -0700
Message-ID: <1233598811-6871-1-git-send-email-corbet@lwn.net>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Here is yet another attempt to remove the BKL from the handling of changes
to filp->f_flags and FASYNC changes.  This approach is a bit more complex,
and has been split into four patches.  The end-result is the removal of the
BKL and some excess code.

1) Use bitops for f_flags: turn f_flags into an unsigned long and
   manipulate its contents with atomic bitops.  New NR_* macros have been
   defined for the bits which are actually changed after open/create time.

2) Use a bitlock in epoll: use one of the f_flags bit to replace the
   ep_lock spinlock.  This (more than) mitigates the growth in struct file
   created by part 1).  The bitop will be a bit slower, but it should not
   be a performance-critical part of the epoll implementation.  (Ideal
   courtesy of Matt Mackall).

3) Move FASYNC bit handling into ->fasync(): this is how changes to that
   bit and calls to f_op->fasync() are kept atomic in the absence of the
   BKL.  Almost every FASYNC implementation uses fasync_helper(), so the
   actual bit manipulation is done there.  The one exception (for sockets)
   has been fixed up.  At this point, there is no more BKL in these paths.
   (Idea-suggested-by: Andi Kleen).

4) Rationalize fasync_helper() return value handling.  Some drivers mapped
   positive return values from fasync_helper() onto zero, most others did
   not bother.  This optional cleanup patch moves that mapping into the VFS
   code, making things consistent and enabling the removal of some 50 lines
   of code.  It's worth noting that this is technically an ABI change: some
   drivers which returned positive values from fcntl(..., F_SETFL, ...)
   will now return zero instead.  I sure *hope* that wouldn't break
   anything... 

To be extra-sure that I wasn't breaking anything subtle, I went and figured
out how to run the Linux Test Project suite.  Pretty amazing stuff - I've
never run a program which would put my system's load average at 7400
before.  If there are any regressions here, LTP did not find them.

As always, comments welcome.

jon


--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
