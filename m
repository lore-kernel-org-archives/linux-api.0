From: Oren Laadan <orenl-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
Date: Tue, 20 Oct 2009 16:13:04 -0400
Message-ID: <4ADE19D0.4060900@librato.com>
References: <20091013044925.GA28181@us.ibm.com> <4AD8C7E4.9000903@free.fr>	<20091016194451.GA28706@us.ibm.com> <4ADCCD68.9030003@free.fr>	<4ADCDE7F.4090501@librato.com>	<20091020005125.GG27627@count0.beaverton.ibm.com>	<m1vdiad9jd.fsf@fess.ebiederm.org> <20091020040315.GA26632@us.ibm.com>	<m1iqeauyvl.fsf@fess.ebiederm.org> <20091020183329.GB22646@us.ibm.com> <m1r5sxsw7w.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <m1r5sxsw7w.fsf-+imSwln9KH6u2/kzUuoCbdi2O/JbrIOy@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Daniel Lezcano <daniel.lezcano-GANU6spQydw@public.gmane.org>, randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Louis.Rilling-aw0BnHfMbSpBDgjK7y7TUQ@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org



Eric W. Biederman wrote:
> Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> writes:
> 
>> Eric W. Biederman [ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org] wrote:
>> | > Could you clarify ? How is the call to alloc_pidmap() from clone3() different
>> | > from the call from clone() itself ?
>> | 
>> | I think it is totally inappropriate to assign pids in a pid namespace
>> | where there are user space processes already running.
>>
>> Honestly, I don't understand why it is inappropriate or how this differs
>> from normal clone() - which also assigns pids in own and ancestor pid
>> namespaces.
> 
> The fact we can specify which pids we want.  I won't claim it is as
> exploitable as NULL pointer deferences have been but it has that kind
> of feel to it.

This security concern was first brought up by Linus, and to address it
we made clone3() require that the user be privileged to select pids.

But, honestly, a clone3() that allows the caller to request a specific
pid is like a restart() syscall that allows the caller to restore a
process with its original pid:  you would simply checkpoint, and then
alter the pid in the checkpoint image and restart, repeat ad infinitum.

>From your security prism, they are equivalent: they practically allow
a user to have an arbitrary process with a selected pid. So it doesn't
really matter - for this security concern - if you select the pid in
the kernel through restart() or from userspace through clone3().

Sure, you can also "choose" a pid today, by repeatedly forking until
you get what you want... but that is harder to exploit. In contrast,
both clone3() and restart() allow pid selection, instantaneously.
Which is why both require privileges if the caller wants to select/
restore pids.

Oren.
