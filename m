From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v8 9/9] seccomp: implement SECCOMP_FILTER_FLAG_TSYNC
Date: Wed, 25 Jun 2014 10:09:00 -0700
Message-ID: <CAGXu5jLHDew1fifGY_mWgwcH7evm0T8rqSnBrw4XpoAXGK+t-Q@mail.gmail.com>
References: <1403642893-23107-1-git-send-email-keescook@chromium.org>
	<1403642893-23107-10-git-send-email-keescook@chromium.org>
	<20140625142121.GD7892@redhat.com>
	<CAGXu5jJtLrjbobZC1FD4WV-Jm2p7cRGa1aSPK-d_isnfCZAHdA@mail.gmail.com>
	<20140625165209.GA14720@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140625165209.GA14720-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Julien Tinnes <jln-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jun 25, 2014 at 9:52 AM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 06/25, Kees Cook wrote:
>>
>> On Wed, Jun 25, 2014 at 7:21 AM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> >
>> > But. Doesn't this change add a new security hole?
>> >
>> > Obviously, we should not allow to install a filter and then (say) exec
>> > a suid binary, that is why we have no_new_privs/LSM_UNSAFE_NO_NEW_PRIVS.
>> >
>> > But what if "thread->seccomp.filter = caller->seccomp.filter" races with
>> > any user of task_no_new_privs() ? Say, suppose this thread has already
>> > passed check_unsafe_exec/etc and it is going to exec the suid binary?
>>
>> Oh, ew. Yeah. It looks like there's a cred lock to be held to combat this?
>
> Yes, cred_guard_mutex looks like an obvious choice... Hmm, but somehow
> initially I thought that the fix won't be simple. Not sure why.
>
> Yes, at least this should close the race with suid-exec. And there are no
> other users. Except apparmor, and I hope you will check it because I simply
> do not know what it does ;)
>
>> I wonder if changes to nnp need to "flushed" during syscall entry
>> instead of getting updated externally/asynchronously? That way it
>> won't be out of sync with the seccomp mode/filters.
>>
>> Perhaps secure computing needs to check some (maybe seccomp-only)
>> atomic flags and flip on the "real" nnp if found?
>
> Not sure I understand you, could you clarify?

Instead of having TSYNC change the nnp bit, it can set a new flag, say:

    task->seccomp.flags |= SECCOMP_NEEDS_NNP;

This would be set along with seccomp.mode, seccomp.filter, and
TIF_SECCOMP. Then, during the next secure_computing() call that thread
makes, it would check the flag:

    if (task->seccomp.flags & SECCOMP_NEEDS_NNP)
        task->nnp = 1;

This means that nnp couldn't change in the middle of a running syscall.

Hmmm. Perhaps this doesn't solve anything, though? Perhaps my proposal
above would actually make things worse, since now we'd have a thread
with seccomp set up, and no nnp. If it was in the middle of exec,
we're still causing a problem.

I think we'd also need a way to either delay the seccomp changes, or
to notice this condition during exec. Bleh.

What actually happens with a multi-threaded process calls exec? I
assume all the other threads are destroyed?

> But I was also worried that task_no_new_privs(current) is no longer stable
> inside the syscall paths, perhaps this is what you meant? However I do not
> see something bad here... And this has nothing to do with the race above.
>
> Also. Even ignoring no_new_privs, SECCOMP_FILTER_FLAG_TSYNC is not atomic
> and we can do nothing with this fact (unless it try to freeze the thread
> group somehow), perhaps it makes sense to document this somehow.
>
> I mean, suppose you want to ensure write-to-file is not possible, so you
> do seccomp(SECCOMP_FILTER_FLAG_TSYNC, nack_write_to_file_filter). You can't
> assume that this has effect right after seccomp() returns, this can obviously
> race with a sub-thread which has already entered sys_write().
>
> Once again, I am not arguing, just I think it makes sense to at least mention
> the limitations during the discussion.

Right -- this is an accepted limitation. I will call it out
specifically in the man-page; that's a good idea.

-Kees

-- 
Kees Cook
Chrome OS Security
