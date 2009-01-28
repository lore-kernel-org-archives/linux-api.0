From: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Date: Wed, 28 Jan 2009 14:05:18 -0700
Message-ID: <20090128140518.16d84a2b@bike.lwn.net>
References: <20090115153211.663df310@bike.lwn.net>
	<20090122065104.2787df2d.akpm@linux-foundation.org>
	<20090122203248.GA20159@infradead.org>
	<20090123045646.GK15750@one.firstfloor.org>
	<20090127165504.53ed7a2d.akpm@linux-foundation.org>
	<20090128031439.GA11025@redhat.com>
	<20090128173618.GA3174@infradead.org>
	<20090128104414.09aee3f9@bike.lwn.net>
	<20090128175541.GA7074@infradead.org>
	<1233166427.5202.907.camel@calx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1233166427.5202.907.camel@calx>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 28 Jan 2009 12:13:47 -0600
Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org> wrote:

> Maybe we can just demote f_ep_lock to f_lock and share it? 

We'd have to move it out of the CONFIG_EPOLL ifdef, but that could be
done.  The bigger problem is that there is resistance to putting a lock
around accesses to f_flags.  I've tried that before...

It also doesn't solve the FASYNC atomicity problem unless we decide to
call ->fasync() with the lock held, and that opens yet another can of
worms.

> Or extend flags and have two independent bitlocks in it. This actually
> shrinks struct_file for most users.

That has some potential.  We'd only need one bitlock (for epoll).
Biggest problem might be preventing the regular file flags from
expanding into the lock bit, especially since those flags are defined
in a pile of architecture-dependent .h files.  I'll look into it.

(That's somebody's cue to tell me why this approach is all wrong
too...:)

Thanks,

jon
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
