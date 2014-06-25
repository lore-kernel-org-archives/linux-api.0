From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v8 9/9] seccomp: implement SECCOMP_FILTER_FLAG_TSYNC
Date: Wed, 25 Jun 2014 11:25:26 -0700
Message-ID: <CAGXu5j+Gw8V5qFueWJiA2rEntALFQ1KXOJaPg3OcJZKDCibyMg@mail.gmail.com>
References: <1403642893-23107-1-git-send-email-keescook@chromium.org>
	<1403642893-23107-10-git-send-email-keescook@chromium.org>
	<20140625142121.GD7892@redhat.com>
	<CAGXu5jJtLrjbobZC1FD4WV-Jm2p7cRGa1aSPK-d_isnfCZAHdA@mail.gmail.com>
	<20140625165209.GA14720@redhat.com>
	<CAGXu5jLHDew1fifGY_mWgwcH7evm0T8rqSnBrw4XpoAXGK+t-Q@mail.gmail.com>
	<20140625172410.GA17133@redhat.com>
	<CAGXu5jKkLS3++_dtWHnjWudVvaSR9DRwjNG3q00SmSy6XoCMaw@mail.gmail.com>
	<CALCETrXr+g6tM+9gQJKKnGj_XoyXi+7ZQpAWjykhOAErpE8MBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <CALCETrXr+g6tM+9gQJKKnGj_XoyXi+7ZQpAWjykhOAErpE8MBw@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, Linux API <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-mips@linux-mips.org, linux-arch <linux-arch@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jun 25, 2014 at 11:09 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Wed, Jun 25, 2014 at 10:57 AM, Kees Cook <keescook@chromium.org> wrote:
>> On Wed, Jun 25, 2014 at 10:24 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>>> On 06/25, Kees Cook wrote:
>>>>
>>>> On Wed, Jun 25, 2014 at 9:52 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>>>> >
>>>> > Yes, at least this should close the race with suid-exec. And there are no
>>>> > other users. Except apparmor, and I hope you will check it because I simply
>>>> > do not know what it does ;)
>>>> >
>>>> >> I wonder if changes to nnp need to "flushed" during syscall entry
>>>> >> instead of getting updated externally/asynchronously? That way it
>>>> >> won't be out of sync with the seccomp mode/filters.
>>>> >>
>>>> >> Perhaps secure computing needs to check some (maybe seccomp-only)
>>>> >> atomic flags and flip on the "real" nnp if found?
>>>> >
>>>> > Not sure I understand you, could you clarify?
>>>>
>>>> Instead of having TSYNC change the nnp bit, it can set a new flag, say:
>>>>
>>>>     task->seccomp.flags |= SECCOMP_NEEDS_NNP;
>>>>
>>>> This would be set along with seccomp.mode, seccomp.filter, and
>>>> TIF_SECCOMP. Then, during the next secure_computing() call that thread
>>>> makes, it would check the flag:
>>>>
>>>>     if (task->seccomp.flags & SECCOMP_NEEDS_NNP)
>>>>         task->nnp = 1;
>>>>
>>>> This means that nnp couldn't change in the middle of a running syscall.
>>>
>>> Aha, so you were worried about the same thing. Not sure we need this,
>>> but at least I understand you and...
>>>
>>>> Hmmm. Perhaps this doesn't solve anything, though? Perhaps my proposal
>>>> above would actually make things worse, since now we'd have a thread
>>>> with seccomp set up, and no nnp. If it was in the middle of exec,
>>>> we're still causing a problem.
>>>
>>> Yes ;)
>>>
>>>> I think we'd also need a way to either delay the seccomp changes, or
>>>> to notice this condition during exec. Bleh.
>>>
>>> Hmm. confused again,
>>
>> I mean to suggest that the tsync changes would be stored in each
>> thread, but somewhere other than the true seccomp struct, but with
>> TIF_SECCOMP set. When entering secure_computing(), current would check
>> for the "changes to sync", and apply them, then start the syscall. In
>> this way, we can never race a syscall (like exec).
>
> I'm not sure that helps.  If you set a pending filter part-way through
> exec, and exec copies that pending filter but doesn't notice NNP, then
> there's an exploitable race.
>
>>
>>>> What actually happens with a multi-threaded process calls exec? I
>>>> assume all the other threads are destroyed?
>>>
>>> Yes. But this is the point-of-no-return, de_thread() is called after the execing
>>> thared has already passed (say) check_unsafe_exec().
>>>
>>> However, do_execve() takes cred_guard_mutex at the start in prepare_bprm_creds()
>>> and drops it in install_exec_creds(), so it should solve the problem?
>>
>> I can't tell yet. I'm still trying to understand the order of
>> operations here. It looks like de_thread() takes the sighand lock.
>> do_execve_common does:
>>
>> prepare_bprm_creds (takes cred_guard_mutex)
>> check_unsafe_exec (checks nnp to set LSM_UNSAFE_NO_NEW_PRIVS)
>> prepare_binprm (handles suid escalation, checks nnp separately)
>>     security_bprm_set_creds (checks LSM_UNSAFE_NO_NEW_PRIVS)
>> exec_binprm
>>     load_elf_binary
>>         flush_old_exec
>>             de_thread (takes and releases sighand->lock)
>>         install_exec_creds (releases cred_guard_mutex)
>>
>> I don't see a way to use cred_guard_mutex during tsync (which holds
>> sighand->lock) without dead-locking. What were you considering here?
>
> Grab cred_guard_mutex and then sighand->lock, perhaps?

Ah, yes, task->signal is like sighand: shared across all threads.

-- 
Kees Cook
Chrome OS Security
