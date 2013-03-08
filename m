From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH 1/3] posix timers: Allocate timer id per process (v2)
Date: Fri, 8 Mar 2013 13:50:28 +0100 (CET)
Message-ID: <alpine.LFD.2.02.1303081349020.22263@ionos>
References: <512665BA.9040802@parallels.com> <512665E1.4040800@parallels.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <512665E1.4040800-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Helsley <matt.helsley-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Pavel,

On Thu, 21 Feb 2013, Pavel Emelyanov wrote:

> Patch replaces global idr with global hash table for posix timers and
> makes timer ids unique not globally, but per process. Next free timer id is
> type of integer and stored on signal struct (posix_timer_id). If free timer
> id reaches negative value on timer creation, it will be dropped to zero and
> -EAGAIN will be returned to user.
> 
> Hash table has 512 slots.
> Key is constructed as follows:
> key = hash_32(hash_32(current->signal) ^ posix_timer_id));
> 
> Note: with this patch, id, returned to user, is not the minimal free
> amymore. It means, that id, returned to user space in loop, listed below,
> will be increasing on each iteration till INT_MAX and then dropped to zero:
> 
> while(1) {
> 	id = timer_create(...);
> 	timer_delete(id);
> }
> 
> In this version the helpers from include/linux/hashtable.h are used
> instead of hand-made hash-table.

I think the patches are ready to go, though the changelog needs quite
some care.

It's explaining what the patch does and not why. Can you please
rework?

Thanks,

	tglx
