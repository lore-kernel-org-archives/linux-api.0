From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v9 11/11] seccomp: implement SECCOMP_FILTER_FLAG_TSYNC
Date: Thu, 10 Jul 2014 02:17:30 -0700
Message-ID: <CAGXu5jLUqz-T1tRBCpPLkzWijyAF-Vjw_7PnQ1EvUh4urwyaUg@mail.gmail.com>
References: <1403911380-27787-1-git-send-email-keescook@chromium.org>
        <1403911380-27787-12-git-send-email-keescook@chromium.org>
        <20140709180520.GA2560@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-mips-bounce@linux-mips.org>
In-Reply-To: <20140709180520.GA2560@redhat.com>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, Linux API <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-mips@linux-mips.org, linux-arch <linux-arch@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 9, 2014 at 11:05 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> First of all, sorry for delay ;)
>
> So far I quickly glanced at this series and everything look fine, but
> I am confused by the signal_group_exit() check,
>
> On 06/27, Kees Cook wrote:
>>
>> To make sure that de_thread() is actually able
>> to kill other threads during an exec, any sighand holders need to check
>> if they've been scheduled to be killed, and to give up on their work.
>
> Probably this connects to that check below? I can't understand this...
>
>> +     /*
>> +      * Make sure we cannot change seccomp or nnp state via TSYNC
>> +      * while another thread is in the middle of calling exec.
>> +      */
>> +     if (flags & SECCOMP_FILTER_FLAG_TSYNC &&
>> +         mutex_lock_killable(&current->signal->cred_guard_mutex))
>> +             goto out_free;
>
> -EINVAL looks a bit confusing in this case, but this is cosemtic because
> userspace won't see this error-code anyway.

Happy to use whatever since, as you say, it's cosmetic. Perhaps -EAGAIN?

>
>>       spin_lock_irq(&current->sighand->siglock);
>> +     if (unlikely(signal_group_exit(current->signal))) {
>> +             /* If thread is dying, return to process the signal. */
>
> OK, this doesn't hurt, but why?
>
> You could check __fatal_signal_pending() with the same effect. And since
> we hold this mutex, exec (de_thread) can be the source of that SIGKILL.
> We take this mutex specially to avoid the race with exec.
>
> So why do we need to abort if we race with kill() or exit_grouo() ?

In my initial code inspection that we could block waiting for the
cred_guard mutex, with exec holding it, exec would schedule death in
de_thread, and then once it released, the tsync thread would try to
keep running.

However, in looking at this again, now I'm concerned this produces a
dead-lock in de_thread, since it waits for all threads to actually
die, but tsync will be waiting with the killable mutex.

So I think I got too defensive when I read the top of de_thread where
it checks for pending signals itself.

It seems like I can just safely remove the singal_group_exit checks?
The other paths (non-tsync seccomp_set_mode_filter, and
seccomp_set_mode_strict) would just run until it finished the syscall,
and then died. I can't decide which feels cleaner: just letting stuff
clean up naturally on death or to short-circuit after taking
sighand->siglock.

What do you think?

-Kees

-- 
Kees Cook
Chrome OS Security
