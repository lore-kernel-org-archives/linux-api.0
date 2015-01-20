From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC 0/6] epoll: Introduce new syscall "epoll_mod_wait"
Date: Tue, 20 Jan 2015 13:48:36 +0100
Message-ID: <54BE4EA4.6080901@gmail.com>
References: <1421747878-30744-1-git-send-email-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421747878-30744-1-git-send-email-famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Rashika Kheria <rashika.kheria-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Peter Zijlstra <peterz@infrad>
List-Id: linux-api@vger.kernel.org

Hello Fam Zheng,

I know this API has been through a number of iterations, and there were 
discussions about the design that led to it becoming more complex.
But, let us assume that someone has not seen those discussions,
or forgotten them, or is too lazy to go hunting list archives.

Then: this patch series should somewhere have an explanation of
why the API is what it is, ideally with links to previous relevant
discussions. I see that you do part of that in

    [PATCH RFC 5/6] epoll: Add implementation for epoll_mod_wait

There are however no links to previous discussions in that mail (I guess
http://thread.gmane.org/gmane.linux.kernel/1861430/focus=91591 is most
relevant, nor is there any sort of change log in the commit message 
that explains the evolution of the API. Having those would ease the 
task of reviewers.

Coming back to THIS mail, this man page should also include an
explanation of why the API is what it is. That would include much
of the detail from the 5/6 patch, and probably more info besides.

Some specific points below.

On 01/20/2015 10:57 AM, Fam Zheng wrote:
> This adds a new system call, epoll_mod_wait. It's described as below:
> 
> NAME
>        epoll_mod_wait - modify and wait for I/O events on an epoll file
>                         descriptor
> 
> SYNOPSIS
> 
>        int epoll_mod_wait(int epfd, int flags,
>                           int ncmds, struct epoll_mod_cmd *cmds,
>                           struct epoll_wait_spec *spec);
> 
> DESCRIPTION
> 
>        The epoll_mod_wait() system call can be seen as an enhanced combination
>        of several epoll_ctl(2) calls, which are followed by an epoll_pwait(2)
>        call. It is superior in two cases:
>        
>        1) When epoll_ctl(2) are followed by epoll_wait(2), using epoll_mod_wait
>        will save context switches between user mode and kernel mode;
>
>        2) When you need higher precision than microsecond for wait timeout.

s/microsecond/millisecond/

> 
>        The epoll_ctl(2) operations are embedded into this call by with ncmds
>        and cmds. The latter is an array of command structs:
> 
>            struct epoll_mod_cmd {
> 
>                   /* Reserved flags for future extension, must be 0 for now. */
>                   int flags;
> 
>                   /* The same as epoll_ctl() op parameter. */
>                   int op;
> 
>                   /* The same as epoll_ctl() fd parameter. */
>                   int fd;
> 
>                   /* The same as the "events" field in struct epoll_event. */
>                   uint32_t events;
> 
>                   /* The same as the "data" field in struct epoll_event. */
>                   uint64_t data;
> 
>                   /* Output field, will be set to the return code once this
>                    * command is executed by kernel */
>                   int error;
>            };
>        
>        There is no guartantee that all the commands are executed in order. Only

s/guartantee/guarantee/

I think the word "all" is not needed in this sentence.

Why is there no guarantee that the commands are run in order?
The order matters if there are operations on the same fd.

>        if all the commands are successfully executed (all the error fields are
>        set to 0), events are polled.

Does the operation execute all commands, or stop when it encounters the first 
error? In other words, when looping over the returned 'error' fields, what
is the termination condition for the user-space application?

(Yes, I know I can trivially inspect the patch 5/6 to answer this question, 
but the man page should explicitly state this so that I don't have to 
read the source, and also because it is only if you explicitly document 
the intended behavior that I can tell whether the actual implementation 
matches the intention.)

>        The last parameter "spec" is a pointer to struct epoll_wait_spec, which
>        contains the information about how to poll the events. If it's NULL, this
>        call will immediately return after running all the commands in cmds.
> 
>        The structure is defined as below:
> 
>            struct epoll_wait_spec {
> 
>                   /* The same as "maxevents" in epoll_pwait() */
>                   int maxevents;
> 
>                   /* The same as "events" in epoll_pwait() */
>                   struct epoll_event *events;
> 
>                   /* Which clock to use for timeout */
>                   int clockid;

Which clocks can be specified here?
CLOCK_MONOTONIC?
CLOCK_REALTIME?
CLOCK_PROCESS_CPUTIME_ID?
clock_getcpuclockid()?
others?

>                   /* Maximum time to wait if there is no event */
>                   struct timespec timeout;

Is this timeout relative or absolute?

>                   /* The same as "sigmask" in epoll_pwait() */
>                   sigset_t *sigmask;

I just want to confirm here that 'sigmask' can be NULL, meaning
that we degenerate to epoll_wait() functionality, right?

>                   /* The same as "sigsetsize" in epoll_pwait() */
>                   size_t sigsetsize;
>            } EPOLL_PACKED;

What is the "EPOLL_PACKED" here for?

> RETURN VALUE
> 
>        When any error occurs, epoll_mod_wait() returns -1 and errno is set
>        appropriately. All the "error" fields in cmds are unchanged before they
>        are executed, and if any cmds are executed, the "error" fields are set
>        to a return code accordingly. See also epoll_ctl for more details of the
>        return code.
> 
>        When successful, epoll_mod_wait() returns the number of file
>        descriptors ready for the requested I/O, or zero if no file descriptor
>        became ready during the requested timeout milliseconds.

s/milliseconds//

> 
>        If spec is NULL, it returns 0 if all the commands are successful, and -1
>        if an error occured.

s/occured/occurred/

> ERRORS
> 
>        These errors apply on either the return value of epoll_mod_wait or error
>        status for each command, respectively.
>
>        EBADF  epfd or fd is not a valid file descriptor.
> 
>        EFAULT The memory area pointed to by events is not accessible with write
>               permissions.
> 
>        EINTR  The call was interrupted by a signal handler before either any of
>               the requested events occurred or the timeout expired; see
>               signal(7).
> 
>        EINVAL epfd is not an epoll file descriptor, or maxevents is less than
>               or equal to zero, or fd is the same as epfd, or the requested
>               operation op is not supported by this interface.

Add: Or 'flags' is nonzero. Or a 'cmds.flags' field is nonzero.

>        EEXIST op was EPOLL_CTL_ADD, and the supplied file descriptor fd is
>               already registered with this epoll instance.
> 
>        ENOENT op was EPOLL_CTL_MOD or EPOLL_CTL_DEL, and fd is not registered
>               with this epoll instance.
> 
>        ENOMEM There was insufficient memory to handle the requested op control
>               operation.
> 
>        ENOSPC The limit imposed by /proc/sys/fs/epoll/max_user_watches was
>               encountered while trying to register (EPOLL_CTL_ADD) a new file
>               descriptor on an epoll instance.  See epoll(7) for further
>               details.
> 
>        EPERM  The target file fd does not support epoll.
> 
> CONFORMING TO
> 
>        epoll_mod_wait() is Linux-specific.
> 
> SEE ALSO
> 
>        epoll_create(2), epoll_ctl(2), epoll_wait(2), epoll_pwait(2), epoll(7)

Please add sigprocmask(2).

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
