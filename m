From: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
Date: Fri, 16 Oct 2009 12:44:51 -0700
Message-ID: <20091016194451.GA28706@us.ibm.com>
References: <20091013044925.GA28181@us.ibm.com> <4AD8C7E4.9000903@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AD8C7E4.9000903-GANU6spQydw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Lezcano <daniel.lezcano-GANU6spQydw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, Louis.Rilling-aw0BnHfMbSpBDgjK7y7TUQ@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Daniel Lezcano [daniel.lezcano-GANU6spQydw@public.gmane.org] wrote:
> Sukadev Bhattiprolu wrote:
>> Subject: [RFC][v8][PATCH 0/10] Implement clone3() system call
>>
>> To support application checkpoint/restart, a task must have the same pid it
>> had when it was checkpointed.  When containers are nested, the tasks within
>> the containers exist in multiple pid namespaces and hence have multiple pids
>> to specify during restart.
>>
>> This patchset implements a new system call, clone3() that lets a process
>> specify the pids of the child process.
>>
>> Patches 1 through 7 are helper patches, needed for choosing a pid for the
>> child process.
>>
>> PATCH 9 defines a prototype of the new system call. PATCH 10 adds some
>> documentation on the new system call, some/all of which will eventually
>> go into a man page.
>>   
>
> Sorry for jumping so late in the discussion and for having maybe my
> remarks pointless...
>
> If this syscall is only for checkpoint / restart, why this shouldn't be
> used with a future generic sys_restart syscall ?

As I tried to explain in PATCH 0/9, the ability to choose a pid is only
for C/R but we are also trying to clone-flags so we won't need yet
another variant of clone() fairly soon.

> Otherwise, shouldn't be more convenient to have something usable for
> everyone, let's say:
>
> cloneat(pid_t pid, pid_t desiredpid, ...);
>
> Where 'desiredpid' is a hint of for the kernel for the pid to be
> allocated (zero means the kernel will choose one for us) and the newly
> allocated task is the son of 'pid'.

Hmm, so P1 would call cloneat() to create a child P3 _on behalf_ of process
P2 ?  I did not know we had a requirement for that. Can you explain the
use-case more ? IOW, why can't P2 create the child P3 by itself ?

Note also that 'desiredpid' must be a list of pids (one for each pid
namespaces that the child will belong to) and hence we need 'nr_pids'
to specify the list. Given that we are limited to 6 parameters to the
syscall, such parameters must be stuffed into 'struct clone_args'.

So we should do something like:

	sys_clone3(u32 flags_low, pid_t pid, struct clone_args *carg,
		pid_t *desired_pids)

or (to match the name and parameters, move 'pid' parameter into clone_args)

> That looks more consistent with the "<syscall>at" family, 'openat',
> 'faccessat', 'readlinkat', etc ... and usable for something else than
> the checkpoint / restart.

The subtle difference though is that openat() does not open a file on
behalf of another process and so the 'at' suffix would not apply ?

>
> Thanks
>  -- Daniel
