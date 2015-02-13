From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH RFC v3 0/7] epoll: Introduce new syscalls,
 epoll_ctl_batch and epoll_pwait1
Date: Fri, 13 Feb 2015 01:53:57 -0800
Message-ID: <20150213095357.GA20668@mew>
References: <1423818243-15410-1-git-send-email-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1423818243-15410-1-git-send-email-famz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Fam Zheng <famz@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, David Herrmann <dh.herrmann@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Miklos Szeredi <mszeredi@suse.cz>, David Drysdale <drysdale@google.com>, Oleg Nesterov <oleg@redhat.com>, "David S. Miller" <davem@davemloft.net>, Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>, Theodore Ts'o <tytso@mit.edu>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Rashika Kheria <rashika.kheria@gmail.com>, Hugh Dickins <hughd@google.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Peter Zijlstra <peterz@>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 13, 2015 at 05:03:56PM +0800, Fam Zheng wrote:
> Hi all,
> 
> This is the updated series for the new epoll system calls, with the cover
> letter rewritten which includes some more explanation. Comments are very
> welcome!
> 
> Original Motivation
> ===================
> 
> QEMU, and probably many more select/poll based applications, will consider
> epoll as an alternative, when its event loop needs to handle a big number of
> fds. However, there are currently two concerns with epoll which prevents the
> switching from ppoll to epoll. 
> 
> The major one is the timeout precision.
> 
> For example in QEMU, the main loop takes care of calling callbacks at a
> specific timeout - the QEMU timer API. The timeout value in ppoll depends on
> the next firing timer. epoll_pwait's millisecond timeout is so coarse that
> rounding up the timeout will hurt performance badly.
> 
> The minor one is the number of system call to update fd set.
> 
> While epoll can handle a large number of fds quickly, it still requires one
> epoll_ctl per fd update, compared to the one-shot call to select/poll with an
> fd array. This may as well make epoll inferior to ppoll in the cases where a
> small, but frequently changing set of fds are polled by the event loop.
> 
> This series introduces two new epoll APIs to address them respectively. The
> idea of epoll_ctl_batch is suggested by Andy Lutomirski in [1], who also
> suggested clockid as a parameter in epoll_pwait1.
> 
> Discussion
> ==========
> 
> [Note: This is the question part regarding the interface contract of
> epoll_ctl_batch.  If you don't have the context of what is epoll_ctl_batch yet,
> please skip this part and probably start with the man page style documentation.
> You can resume to this section later.]
> 
> [Thanks to Omar Sandoval <osandov@osandov.com>, who pointed out this in
> reviewing v1]
> 
> We try to report status for each command in epoll_ctl_batch, by writting to
> user provided command array (pointed to cmds). The tricky thing in the
> implementation is that, copying the results back to userspace comes last, after
> the commands are executed. At this point, if the copy_to_user fails, the
> effects are done and no return - or if we add some mechanism to revert it, the
> code will be too complicated and slow.
> 
> In above corner case, the return value of epoll_ctl_batch is smaller than
> ncmds, which assures our caller that last N commands failed, where N = ncmds -
> ret.  But they'll also find that cmd.result is not changed to error code.
> 
> I suppose this is not a big deal, because 1) it should happen very rarely. 2)
> user does know the actual number of commands that succeed.
> 
> So, do we leave it as is? Or is there any way to improve?
> 
> One tiny improvement (not a complete fix) in my mind is a testing copy_to_user
> before we execute the commands. If it succeeds, it's even less likely the last
> copy_to_user could fail, so that we can even probably assert it won't. The
> testing 'copy_to_user(cmds, &kcmds, ...)' will not hurt functionality if do it
> right after 'copy_from_user(&kcmds, cmds, ...)'. But I'm not sure about the
> performance impact, especially when @ncmds is big.
> 
I don't think this is the right thing to do, since, for example, another
thread could unmap the memory region holding buffer between the "check"
copy_to_user and the actual one.

The two alternatives that I see are:

1. If copy_to_user fails, ignore it and return the number of commands
that succeeded (i.e., what the code in your patch does).
2. If copy_to_user fails, return -EFAULT, regardless of how many
commands succeeded.

The problem with 1 is that it could potentially mask bugs in a user
program. You could imagine a buggy program that passes a read-only
buffer to epoll_ctl_batch and never finds out about it because they
don't get the error. (Then, when there's a real error in one of the
epoll_ctl_cmds, but .result is 0, someone will be very confused.)

So I think 2 is the better option. Sure, the user will have no idea how
many commands were executed, but when would EFAULT on this system call
be part of normal operation, anyways? You'll find the memory bug, fix
it, and rest easy knowing that nothing is silently failing behind your
back.

> Links
> =====
> 
> [1]: http://lists.openwall.net/linux-kernel/2015/01/08/542
> 
> Changelog
> =========
> 
> Changes from v2 (https://lkml.org/lkml/2015/2/4/105)
> ----------------------------------------------------
> 
>   - Rename epoll_ctl_cmd.error_hint to "result". [Michael]
> 
>   - Add background introduction in cover letter. [Michael]
> 
>   - Expand the last struct of epoll_pwait1, add clockid and timespec.
>   
>   - Update man page in cover letter accordingly:
> 
>     * "error_hint" -> "result".
>     * The result field's caveat in "RETURN VALUE" secion of epoll_ctl_batch.
> 
>   Please review!
> 
> Changes from v1 (https://lkml.org/lkml/2015/1/20/189)
> -----------------------------------------------------
> 
>   - As discussed in previous thread [1], split the call to epoll_ctl_batch and
>     epoll_pwait. [Michael]
> 
>   - Fix memory leaks. [Omar]
> 
>   - Add a short comment about the ignored copy_to_user failure. [Omar]
> 
>   - Cover letter rewritten.
> 
[snip]

-- 
Omar
