From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v8 9/9] seccomp: implement SECCOMP_FILTER_FLAG_TSYNC
Date: Wed, 25 Jun 2014 10:40:47 -0700
Message-ID: <CALCETrXUUzebX3pRbAyCD82fCg_XeaWBCcUAO4uAAm1EDu6i5Q@mail.gmail.com>
References: <1403642893-23107-1-git-send-email-keescook@chromium.org>
 <1403642893-23107-10-git-send-email-keescook@chromium.org>
 <20140625142121.GD7892@redhat.com> <CAGXu5jJtLrjbobZC1FD4WV-Jm2p7cRGa1aSPK-d_isnfCZAHdA@mail.gmail.com>
 <20140625165209.GA14720@redhat.com> <CAGXu5jLHDew1fifGY_mWgwcH7evm0T8rqSnBrw4XpoAXGK+t-Q@mail.gmail.com>
 <20140625172410.GA17133@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20140625172410.GA17133@redhat.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, Linux API <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-mips@linux-mips.org, linux-arch <linux-arch@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jun 25, 2014 at 10:24 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 06/25, Kees Cook wrote:
>>
>> On Wed, Jun 25, 2014 at 9:52 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> >
>> > Yes, at least this should close the race with suid-exec. And there are no
>> > other users. Except apparmor, and I hope you will check it because I simply
>> > do not know what it does ;)
>> >
>> >> I wonder if changes to nnp need to "flushed" during syscall entry
>> >> instead of getting updated externally/asynchronously? That way it
>> >> won't be out of sync with the seccomp mode/filters.
>> >>
>> >> Perhaps secure computing needs to check some (maybe seccomp-only)
>> >> atomic flags and flip on the "real" nnp if found?
>> >
>> > Not sure I understand you, could you clarify?
>>
>> Instead of having TSYNC change the nnp bit, it can set a new flag, say:
>>
>>     task->seccomp.flags |= SECCOMP_NEEDS_NNP;
>>
>> This would be set along with seccomp.mode, seccomp.filter, and
>> TIF_SECCOMP. Then, during the next secure_computing() call that thread
>> makes, it would check the flag:
>>
>>     if (task->seccomp.flags & SECCOMP_NEEDS_NNP)
>>         task->nnp = 1;
>>
>> This means that nnp couldn't change in the middle of a running syscall.
>
> Aha, so you were worried about the same thing. Not sure we need this,
> but at least I understand you and...
>
>> Hmmm. Perhaps this doesn't solve anything, though? Perhaps my proposal
>> above would actually make things worse, since now we'd have a thread
>> with seccomp set up, and no nnp. If it was in the middle of exec,
>> we're still causing a problem.
>
> Yes ;)
>
>> I think we'd also need a way to either delay the seccomp changes, or
>> to notice this condition during exec. Bleh.
>
> Hmm. confused again,
>
>> What actually happens with a multi-threaded process calls exec? I
>> assume all the other threads are destroyed?
>
> Yes. But this is the point-of-no-return, de_thread() is called after the execing
> thared has already passed (say) check_unsafe_exec().
>
> However, do_execve() takes cred_guard_mutex at the start in prepare_bprm_creds()
> and drops it in install_exec_creds(), so it should solve the problem?

If you rely on this, then please fix this comment in fs/exec.c:

/*
 * determine how safe it is to execute the proposed program
 * - the caller must hold ->cred_guard_mutex to protect against
 *   PTRACE_ATTACH
 */
static void check_unsafe_exec(struct linux_binprm *bprm)

It sounds like cred_guard_mutex is there for exactly this reason  :)

--Andy
