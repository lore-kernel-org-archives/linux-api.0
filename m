From: "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
Date: Tue, 20 Oct 2009 09:16:25 -0500
Message-ID: <20091020141625.GA3645@us.ibm.com>
References: <20091013044925.GA28181@us.ibm.com> <4AD8C7E4.9000903@free.fr> <20091016194451.GA28706@us.ibm.com> <4ADCCD68.9030003@free.fr> <4ADCDE7F.4090501@librato.com> <20091020005125.GG27627@count0.beaverton.ibm.com> <m1vdiad9jd.fsf@fess.ebiederm.org> <20091020040315.GA26632@us.ibm.com> <m1iqeauyvl.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <m1iqeauyvl.fsf-+imSwln9KH6u2/kzUuoCbdi2O/JbrIOy@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Louis.Rilling-aw0BnHfMbSpBDgjK7y7TUQ@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Eric W. Biederman (ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org):
> Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> writes:
> The only real argument in favor of doing this in user space is greater
> flexibility.

Yyyyup.

> I can see checkpointing/restoring a single thread process
> without a pid namespace.  Anything more and you are just asking for
> trouble.
> 
> A design that weakens security.

How does it weaken security?  It requires CAP_SYS_ADMIN, and, when
targeted capabilities are added, it will require CAP_SYS_ADMIN to
only those pid namespaces in which we choose a pid.

> Increases maintenance costs.

Does it really?  It re-uses most of the existing code.  More so than
the only existing in-kernel restart code I've seen does.

> All for
> an unreliable result seems like a bad one to me.

I've personally always been on the fence as to whether we rebuild the
process tree in user-space or kernel.  And I'm still on the fence, as
nothing you've said has convinced me otherwise.

> > | The pid assignment code is currently ugly.  I asked that we just pass
> > | in the min max pid pids that already exist into the core pid
> > | assignment function and a constrained min/max that only admits a
> > | single pid when we are allocating a struct pid for restart.  That was
> > | not done and now we have a weird abortion with unnecessary special cases.
> >
> > I did post a version of the patch attemptint to implement that. As
> > pointed out in:
> >
> > 	http://lkml.org/lkml/2009/8/17/445
> >
> > we would need more checks in alloc_pidmap() to cover cases like min or max
> > being invalid or min being greater than max or max being greater than pid_max
> > etc. Those checks also made the code ugly (imo).
> 
> If you need more checks you are doing it wrong.  The code already has min
> and max values, and even a start value.  I was just strongly suggesting
> we generalize where we get the values from, and then we have not special
> cases. 

(I'm not sure whether this argument is a separate one - regarding the
implementation of choosing the pid - from the kernel-vs-userspace one
or not, so will wait for a response to my other email about your API)

thanks,
-serge
