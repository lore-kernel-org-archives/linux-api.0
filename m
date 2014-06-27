From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v8 3/9] seccomp: introduce writer locking
Date: Fri, 27 Jun 2014 10:27:05 -0700
Message-ID: <CAGXu5j+97V=8H-ft0Rmn8PPR7X=m_L5vLzgneUvbv920+8Yc2w@mail.gmail.com>
References: <1403642893-23107-1-git-send-email-keescook@chromium.org>
	<1403642893-23107-4-git-send-email-keescook@chromium.org>
	<20140625180705.GB18185@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20140625180705.GB18185@redhat.com>
Sender: linux-arch-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, Linux API <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-mips@linux-mips.org, linux-arch <linux-arch@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jun 25, 2014 at 11:07 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 06/24, Kees Cook wrote:
>>
>> +static void copy_seccomp(struct task_struct *p)
>> +{
>> +#ifdef CONFIG_SECCOMP
>> +     /*
>> +      * Must be called with sighand->lock held, which is common to
>> +      * all threads in the group. Regardless, nothing special is
>> +      * needed for the child since it is not yet in the tasklist.
>> +      */
>> +     BUG_ON(!spin_is_locked(&current->sighand->siglock));
>> +
>> +     get_seccomp_filter(current);
>> +     p->seccomp = current->seccomp;
>> +
>> +     if (p->seccomp.mode != SECCOMP_MODE_DISABLED)
>> +             set_tsk_thread_flag(p, TIF_SECCOMP);
>> +#endif
>> +}
>
> Wait. But what about no_new_privs? We should copy it as well...
>
> Perhaps this helper should be updated a bit and moved into seccomp.c so
> that seccomp_sync_threads() could use it too.

Ah! Yes. I had been thinking it had been copied during the task_struct
duplication, but that would have been before holding sighand->lock, so
it needs explicit recopying. Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
