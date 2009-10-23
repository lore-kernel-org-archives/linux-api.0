From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
Date: Thu, 22 Oct 2009 18:03:42 -0700
Message-ID: <m1bpjyrkep.fsf@fess.ebiederm.org>
References: <4ADCCD68.9030003@free.fr> <4ADCDE7F.4090501@librato.com>
	<20091020005125.GG27627@count0.beaverton.ibm.com>
	<m1vdiad9jd.fsf@fess.ebiederm.org> <20091020040315.GA26632@us.ibm.com>
	<m1iqeauyvl.fsf@fess.ebiederm.org> <20091020183329.GB22646@us.ibm.com>
	<m1r5sxsw7w.fsf@fess.ebiederm.org> <20091021062021.GA2667@us.ibm.com>
	<m1eioxrtsb.fsf@fess.ebiederm.org> <20091023004253.GA7915@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091023004253.GA7915-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org> (Sukadev Bhattiprolu's message of "Thu\, 22 Oct 2009 17\:42\:53 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Oren Laadan <orenl-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-GANU6spQydw@public.gmane.org>, randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Louis.Rilling-aw0BnHfMbSpBDgjK7y7TUQ@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> writes:

> Eric W. Biederman [ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org] wrote:
> | +static int set_pidmap(struct pid_namespace *pid_ns, int target)
> | +{
> | +	if (target >= pid_max)
> | +		return -1;
>
> I am changing this and the next return to 'return -EINVAL', to match
> an earlier patch in my patchset.
>
> | +	if (target < RESERVED_PIDS)
>
> Should we replace RESERVED_PIDS with 0 ? We currently allow new
> containers to have pids 1..32K in the first pass and in subsequent
> passes assign starting at RESERVED_PIDS.

If it is a preexisting namespace pid namespace removing the RESERVED_PIDS
check removes most if not all of the point of RESERVED_PIDS.

In a new fresh pid namespace I have no problem with not performing
the RESERVED_PIDS check.

So I guess that makes the check.

if ((target < RESERVED_PIDS) && pid_ns->last_pid >= RESERVED_PIDS)
   return -EINVAL;

Eric
