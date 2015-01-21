From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC 5/6] epoll: Add implementation for epoll_mod_wait
Date: Wed, 21 Jan 2015 08:52:46 +0100
Message-ID: <54BF5ACE.6030206@gmail.com>
References: <1421747878-30744-1-git-send-email-famz@redhat.com> <1421747878-30744-6-git-send-email-famz@redhat.com> <54BE4F1D.7090807@gmail.com> <20150121045903.GA2858@fam-t430.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150121045903.GA2858-+wGkCoP0yD+sDdueE5tM26fLeoKvNuZc@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Rashika Kheria <rashika.kheria-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Fam Zheng,

On 01/21/2015 05:59 AM, Fam Zheng wrote:
> On Tue, 01/20 13:50, Michael Kerrisk (man-pages) wrote:
>> Hello Fam Zheng,
>>
>> On 01/20/2015 10:57 AM, Fam Zheng wrote:
>>> This syscall is a sequence of
>>>
>>> 1) a number of epoll_ctl calls
>>> 2) a epoll_pwait, with timeout enhancement.
>>>
>>> The epoll_ctl operations are embeded so that application doesn't have to use
>>> separate syscalls to insert/delete/update the fds before poll. It is more
>>> efficient if the set of fds varies from one poll to another, which is the
>>> common pattern for certain applications. 
>>
>> Which applications? Could we have some specific examples? This is a 
>> complex API, and it needs good justification.
> 
> OK, I'll explain more in v2.

Okay.

[...]

>>> The only complexity is returning the result of each operation.  For each
>>> epoll_mod_cmd in cmds, the field "error" is an output field that will be stored
>>> the return code *iff* the command is executed (0 for success and -errno of the
>>> equivalent epoll_ctl call), and will be left unchanged if the command is not
>>> executed because some earlier error, for example due to failure of
>>> copy_from_user to copy the array.
>>>
>>> Applications can utilize this fact to do error handling: they could initialize
>>> all the epoll_mod_wait.error to a positive value, which is by definition not a
>>> possible output value from epoll_mod_wait. Then when the syscall returned, they
>>> know whether or not the command is executed by comparing each error with the
>>> init value, if they're different, they have the result of the command.
>>> More roughly, they can put any non-zero and not distinguish "not run" from
>>> failure.
>>
>> The "cmds' are not executed in a specified order plus the need to
>> initialize the 'errors' fields to a positive value feels a bit ugly.
>> And indeed the whole "command list was only partially run" case
>> is not pretty. Am I correct to understand that if an error is found
>> during execution of one of the "epoll_ctl" commands in 'cmds' then
>> the system call will return -1 with errno set, indicating an error,
>> even though the epoll interest list may have changed because some
>> of the earlier 'cmds' executed successfully? This all seems a bit of
>> a headache for user space.
> 
> This is the trade-off for batching. The best we can do is probably make this
> transactional: none or all of the commands succeeds. It will require a much
> more complex implementation, though. 

Transactional would be more comfortable for user-space, and while I 
can see that it would be complex to implement, perhaps the greater
point might be that the implementation is CPU expensive.

> But even with that, the error reporting on
> which command failed is a complication.

My suggestions below could make the error reporting much simpler...

>> I have a couple of questions:
>>
>> Q1. I can see that batching "epoll_ctl" commands might be useful,
>> since it results in fewer systems calls. But, does it really
>> need to be bound together with the "epoll_pwait" functionality?
>> (Perhaps this point was covered in previous discussions, but
>> neither the message accompanying this patch nor the 0/6 man page
>> provide a compelling rationale for the need to bind these two
>> operations together.)
>>
>> Yes, I realize you might save a system call, but it makes for a
>> cumbersome API that has the above headache, and also forces the 
>> need for double pointer indirection in the 'spec' argument (i.e., 
>> spec is a pointer to an array of structures where each element
>> in turn includes an 'events' pointer that points to another array).
>>
>> Why not a simpler API with two syscalls such as:
>>
>> epoll_ctl_batch(int epfd, int flags,
>>                 int ncmds, struct epoll_mod_cmd *cmds);
>>
>> epoll_pwait1(int epfd, struct epoll_event *events, int maxevents, 
>>              struct timespec *timeout, int clock_id, 
>>              const sigset_t *sigmask, size_t sigsetsize);
> 
> The problem is that there is no room for flags field in epoll_pwait1, which is
> asked for, in previous discussion thread [1].

Ahh yes, I certainly should not have forgotten that. But that's easily solved.
Do as for pselect6():

strcut sigargs {
    const sigset_t *ss;
    size_t          ss_len; /* Size (in bytes) of object pointed
                               to by 'ss' */
}

epoll_pwait1(int epfd, struct epoll_event *events, int maxevents, 
             struct timespec *timeout, int clock_id, int flags,
             int timeout,
             const struct sigargs *sargs);

> I don't see epoll_mod_wait as a *significantly more* complicated interface
> compared to epoll_ctl_batch and epoll_pwait1 above. 

My biggest problem with epoll_ctl_wait() is the complexity of error 
handling. epoll_ctl_batch and epoll_pwait1 would simplify that, as I 
note below.

Aside from that, I do think that epoll_ctl_wait() passes a certain
threshold of complexity that warrants good justification, which
I haven't really seen yet.

> In epoll_mod_wait, if you
> leave out ncmds and cmds, it is effectively a poll without batch; and if
> leaving out spec, it is effectively a batch without poll.
> 
> The most important change here is the timeout. IMO I wouldn't mind leaving out
> batching. Integrating it is requested by Andy:
> 
> [1]: http://thread.gmane.org/gmane.linux.kernel/1861430/focus=91591
> 
> which also made sense to me; I do have a patch in QEMU to call epoll_ctl for a
> number of times right before epoll_wait.
> 
> [Sorry for not putting anything into cover letter changelog, but it is also
> interesting to see people's reaction on the patch itself without bias of
> others' opinions. This indeed brings in more points. :]

But it also has the downside that the same discussions
may be repeated.

>> This gives us much of the benefit of reducing system calls, but 
>> with greater simplicity. And epoll_ctl_batch() could simply return
>> the number of 'cmds' that were successfully executed.)
>>
>> Q2. In the man page in 0/6 you said that the 'cmds' were not 
>> guaranteed to be executed in order. Why not? If you did provide
>> such a guarantee, then, when using your current epoll_mod_wait(),
>> user space could do the following:
> 
> I guess we can make a guarentee on that.

I'm puzzled by that response. Surely you *must* guarantee it.
If there's no defined order, then if the batch includes multiple 
commands that operate on the same FD, the result is undefined 
unless you provide that guarantee. (Unless, of course, you want to
explicitly specify that using the same FD multiple times in the
batch gives undefined behavior.)

>> 1. Initialize the cmd.errors fields to zero.
>> 2. Call epoll_ctl_mod()
>> 3. Iterate through cmd.errors looking for the first nonzero 
>>    field.
> 
> It's close, but zero is not good enough, if copy_from_user of cmds failed in
> the first place. Impossible value, or error value, will be safer.

See my comment in the earlier mail. If you split this into two 
APIs, and epoll_ctl_batch() is guaranteed to execute 'cmds' in order, 
then the return value of epoll_ctl_batch() could be used to tell
user space how many commands succeeded. Much simpler!

>>> Also, timeout parameter is enhanced: timespec is used, compared to the old ms
>>> scalar. This provides higher precision. 
>>
>> Yes, that change seemed inevitable. It slightly puzzled me at the time when
>> Davide Libenzi added epoll_wait() that the timeout was milliseconds, even
>> though pselect() already had demonstrated the need for higher precision.
>> I should have called it out way back then :-{.
>>
>>> The parameter field in struct
>>> epoll_wait_spec, "clockid", also makes it possible for users to use a different
>>> clock than the default when it makes more sense.
>>>
>>> Signed-off-by: Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> ---
>>>  fs/eventpoll.c           | 60 ++++++++++++++++++++++++++++++++++++++++++++++++
>>>  include/linux/syscalls.h |  5 ++++
>>>  2 files changed, 65 insertions(+)
>>>
>>> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
>>> index e7a116d..2cc22c9 100644
>>> --- a/fs/eventpoll.c
>>> +++ b/fs/eventpoll.c
>>> @@ -2067,6 +2067,66 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
>>>  			      sigmask ? &ksigmask : NULL);
>>>  }
>>>  
>>> +SYSCALL_DEFINE5(epoll_mod_wait, int, epfd, int, flags,
>>> +		int, ncmds, struct epoll_mod_cmd __user *, cmds,
>>> +		struct epoll_wait_spec __user *, spec)
>>> +{
>>> +	struct epoll_mod_cmd *kcmds = NULL;
>>> +	int i, ret = 0;
>>> +	int cmd_size = sizeof(struct epoll_mod_cmd) * ncmds;
>>> +
>>> +	if (flags)
>>> +		return -EINVAL;
>>> +	if (ncmds) {
>>> +		if (!cmds)
>>> +			return -EINVAL;
>>> +		kcmds = kmalloc(cmd_size, GFP_KERNEL);
>>> +		if (!kcmds)
>>> +			return -ENOMEM;
>>> +		if (copy_from_user(kcmds, cmds, cmd_size)) {
>>> +			ret = -EFAULT;
>>> +			goto out;
>>> +		}
>>> +	}
>>> +	for (i = 0; i < ncmds; i++) {
>>> +		struct epoll_event ev = (struct epoll_event) {
>>> +			.events = kcmds[i].events,
>>> +			.data = kcmds[i].data,
>>> +		};
>>> +		if (kcmds[i].flags) {
>>> +			kcmds[i].error = ret = -EINVAL;
>>
>> To make the 'ret' change a little more obvious, maybe it's better to write
>>
>> 			ret = kcmds[i].error = -EINVAL;
>>
>>> +			goto out;
>>> +		}
>>> +		kcmds[i].error = ret = ep_ctl_do(epfd, kcmds[i].op, kcmds[i].fd, ev);
>>
>> Likewise:
>> 		ret = kcmds[i].error = ep_ctl_do(epfd, kcmds[i].op, kcmds[i].fd, ev);
>>
>>> +		if (ret)
>>> +			goto out;
>>> +	}
>>> +	if (spec) {
>>> +		sigset_t ksigmask;
>>> +		struct epoll_wait_spec kspec;
>>> +		ktime_t timeout;
>>> +
>>> +		if(copy_from_user(&kspec, spec, sizeof(struct epoll_wait_spec)))
>>
>> Cosmetic point: s/if(/if (/
>>
>>> +			return -EFAULT;
>>> +		if (kspec.sigmask) {
>>> +			if (kspec.sigsetsize != sizeof(sigset_t))
>>> +				return -EINVAL;
>>> +			if (copy_from_user(&ksigmask, kspec.sigmask, sizeof(ksigmask)))
>>> +				return -EFAULT;
>>> +		}
>>> +		timeout = timespec_to_ktime(kspec.timeout);
>>> +		ret = epoll_pwait_do(epfd, kspec.events, kspec.maxevents,
>>> +				     kspec.clockid, timeout,
>>> +				     kspec.sigmask ? &ksigmask : NULL);
>>
>> If I understand correctly, the implementation means that the
>> 'size_t sigsetsize' field will probably need to be exposed to 
>> applications. In the existing epoll_pwait() call (as in  ppoll()
>> and pselect()) the 'size_t sigsetsize' argument is hidden by glibc.
>> However, unless we expect glibc to do some structure copying to/from
>> a structure that hides this field, then we're going end up exposing
>> 'size_t sigsetsize' to applications. (This could be avoided, if we
>> split the API as I suggest above. glibc would do the same thing 
>> in epoll_pwait1() that it currently does in epoll_pwait().)

You missed responding to this point; I think it matters.
(There were also some other points to consider in my reply 
to your 0/6 mail.)

Cheers,

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
