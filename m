From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v8 5/9] seccomp: split mode set routines
Date: Wed, 25 Jun 2014 07:51:25 -0700
Message-ID: <CAGXu5jJkFxh4K=40xuh6tu3kUf4oJM8Dry+4upBdRieW3FNLgw@mail.gmail.com>
References: <1403642893-23107-1-git-send-email-keescook@chromium.org>
	<1403642893-23107-6-git-send-email-keescook@chromium.org>
	<20140625135121.GB7892@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20140625135121.GB7892@redhat.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, Linux API <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-mips@linux-mips.org, linux-arch <linux-arch@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jun 25, 2014 at 6:51 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 06/24, Kees Cook wrote:
>>
>> +static inline void seccomp_assign_mode(struct task_struct *task,
>> +                                    unsigned long seccomp_mode)
>> +{
>> +     BUG_ON(!spin_is_locked(&task->sighand->siglock));
>> +
>> +     task->seccomp.mode = seccomp_mode;
>> +     set_tsk_thread_flag(task, TIF_SECCOMP);
>> +}
>
> OK, but unless task == current this can race with secure_computing().
> I think this needs smp_mb__before_atomic() and secure_computing() needs
> rmb() after test_bit(TIF_SECCOMP).
>
> Otherwise, can't __secure_computing() hit BUG() if it sees the old
> mode == SECCOMP_MODE_DISABLED ?
>
> Or seccomp_run_filters() can see ->filters == NULL and WARN(),
> smp_load_acquire() only serializes that LOAD with the subsequent memory
> operations.

Hm, actually, now I'm worried about smp_load_acquire() being too slow
in run_filters().

The ordering must be:
- task->seccomp.filter must be valid before
- task->seccomp.mode is set, which must be valid before
- TIF_SECCOMP is set

But I don't want to impact secure_computing(). What's the best way to
make sure this ordering is respected?

-Kees

-- 
Kees Cook
Chrome OS Security
