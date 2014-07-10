From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v9 11/11] seccomp: implement SECCOMP_FILTER_FLAG_TSYNC
Date: Thu, 10 Jul 2014 09:03:50 -0700
Message-ID: <CAGXu5jK_BBAexok1G1vbxL6764n+7h1kLRSu074MMFzF0QrafQ@mail.gmail.com>
References: <1403911380-27787-1-git-send-email-keescook@chromium.org>
	<1403911380-27787-12-git-send-email-keescook@chromium.org>
	<20140709180520.GA2560@redhat.com>
	<CAGXu5jLUqz-T1tRBCpPLkzWijyAF-Vjw_7PnQ1EvUh4urwyaUg@mail.gmail.com>
	<20140710150832.GA20861@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140710150832.GA20861-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Julien Tinnes <jln-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 10, 2014 at 8:08 AM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 07/10, Kees Cook wrote:
>>
>> On Wed, Jul 9, 2014 at 11:05 AM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> >
>> >> +     /*
>> >> +      * Make sure we cannot change seccomp or nnp state via TSYNC
>> >> +      * while another thread is in the middle of calling exec.
>> >> +      */
>> >> +     if (flags & SECCOMP_FILTER_FLAG_TSYNC &&
>> >> +         mutex_lock_killable(&current->signal->cred_guard_mutex))
>> >> +             goto out_free;
>> >
>> > -EINVAL looks a bit confusing in this case, but this is cosemtic because
>> > userspace won't see this error-code anyway.
>>
>> Happy to use whatever since, as you say, it's cosmetic. Perhaps -EAGAIN?
>
> Or -EINTR. I do not really mind, I only mentioned this because I had another
> nit.
>
>> >>       spin_lock_irq(&current->sighand->siglock);
>> >> +     if (unlikely(signal_group_exit(current->signal))) {
>> >> +             /* If thread is dying, return to process the signal. */
>> >
>> > OK, this doesn't hurt, but why?
>> >
>> > You could check __fatal_signal_pending() with the same effect. And since
>> > we hold this mutex, exec (de_thread) can be the source of that SIGKILL.
>> > We take this mutex specially to avoid the race with exec.
>> >
>> > So why do we need to abort if we race with kill() or exit_grouo() ?
>>
>> In my initial code inspection that we could block waiting for the
>> cred_guard mutex, with exec holding it, exec would schedule death in
>> de_thread, and then once it released, the tsync thread would try to
>> keep running.
>>
>> However, in looking at this again, now I'm concerned this produces a
>> dead-lock in de_thread, since it waits for all threads to actually
>> die, but tsync will be waiting with the killable mutex.
>
> That is why you should always use _killable (or _interruptible) if you
> want to take ->cred_guard_mutex.
>
> If this thread races with de_thread() which holds this mutex, it will
> be killed and mutex_lock_killable() will fail.
>
> (to clarify; this deadlock is not "fatal", de_thread() can be killed too,
>  but this doesn't really matter).
>
>> So I think I got too defensive when I read the top of de_thread where
>> it checks for pending signals itself.
>>
>> It seems like I can just safely remove the singal_group_exit checks?
>> The other paths (non-tsync seccomp_set_mode_filter, and
>> seccomp_set_mode_strict)
>
> Yes, I missed another signal_group_exit() in seccomp_set_mode_strict().
> It looks equally unneeded.
>
>> I can't decide which feels cleaner: just letting stuff
>> clean up naturally on death or to short-circuit after taking
>> sighand->siglock.
>
> I'd prefer to simply remove the singal_group_exit checks.
>
> I won't argue if you prefer to keep them, but then please add a comment
> to explain that this is not needed for correctness.
>
> Because otherwise the code looks confusing, as if there is a subtle reason
> why we must not do this if killed.

Sounds good! I'll clean it all up for v10.

-Kees

-- 
Kees Cook
Chrome OS Security
