From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
Date: Tue, 20 Oct 2009 03:46:06 -0700
Message-ID: <m1iqeauyvl.fsf@fess.ebiederm.org>
References: <20091013044925.GA28181@us.ibm.com> <4AD8C7E4.9000903@free.fr>
	<20091016194451.GA28706@us.ibm.com> <4ADCCD68.9030003@free.fr>
	<4ADCDE7F.4090501@librato.com>
	<20091020005125.GG27627@count0.beaverton.ibm.com>
	<m1vdiad9jd.fsf@fess.ebiederm.org> <20091020040315.GA26632@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091020040315.GA26632-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org> (Sukadev Bhattiprolu's message of "Mon\, 19 Oct 2009 21\:03\:15 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Oren Laadan <orenl-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-GANU6spQydw@public.gmane.org>, randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Louis.Rilling-aw0BnHfMbSpBDgjK7y7TUQ@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> writes:

> Eric W. Biederman [ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org] wrote:
> | > clone3() seemed to be the leading contender from what I've read so far.
> | > Does anyone still object to clone3() after reading the whole thread?
> | 
> | I object to what clone3() is.  The name is not particularly interesting.
> | 
> | The sanity checks for assigning pids are missing and there is a todo
> | about it.  I am not comfortable with assigning pids to a new process
> | in a pid namespace with other processes user space processes executing
> | in it.
>
> Could you clarify ? How is the call to alloc_pidmap() from clone3() different
> from the call from clone() itself ?

I think it is totally inappropriate to assign pids in a pid namespace
where there are user space processes already running.

> | How we handle a clone extension depends critically on if we want to
> | create a processes for restart in user space or kernel space.
> | 
> | Could some one give me or point me at a strong case for creating the
> | processes for restart in user space?
>
> There has been a lot of discussion on this with reference to the
> Checkpoint/Restart patchset. See http://lkml.org/lkml/2009/4/13/401
> for instance.

Just read it.  Thank you.  Now I am certain clone_with_pids() is
not useful functionality to be exporting to userspace.

The only real argument in favor of doing this in user space is greater
flexibility.  I can see checkpointing/restoring a single thread process
without a pid namespace.  Anything more and you are just asking for
trouble.

A design that weakens security.  Increases maintenance costs.  All for
an unreliable result seems like a bad one to me.

> | The pid assignment code is currently ugly.  I asked that we just pass
> | in the min max pid pids that already exist into the core pid
> | assignment function and a constrained min/max that only admits a
> | single pid when we are allocating a struct pid for restart.  That was
> | not done and now we have a weird abortion with unnecessary special cases.
>
> I did post a version of the patch attemptint to implement that. As
> pointed out in:
>
> 	http://lkml.org/lkml/2009/8/17/445
>
> we would need more checks in alloc_pidmap() to cover cases like min or max
> being invalid or min being greater than max or max being greater than pid_max
> etc. Those checks also made the code ugly (imo).

If you need more checks you are doing it wrong.  The code already has min
and max values, and even a start value.  I was just strongly suggesting
we generalize where we get the values from, and then we have not special
cases. 

Eric
