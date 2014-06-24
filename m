From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v7 7/9] seccomp: implement SECCOMP_FILTER_FLAG_TSYNC
Date: Tue, 24 Jun 2014 11:05:22 -0700
Message-ID: <CAGXu5jKoDEXffJqFSjhO+D=5toJOA=KAomi+LQOahPDYKFbEdg@mail.gmail.com>
References: <1403560693-21809-1-git-send-email-keescook@chromium.org>
	<1403560693-21809-8-git-send-email-keescook@chromium.org>
	<20140624172753.GA31435@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20140624172753.GA31435@redhat.com>
Sender: linux-arch-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Alexei Starovoitov <ast@plumgrid.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, Linux API <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-mips@linux-mips.org, linux-arch <linux-arch@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 24, 2014 at 10:27 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 06/23, Kees Cook wrote:
>>
>> +static pid_t seccomp_can_sync_threads(void)
>> +{
>> +     struct task_struct *thread, *caller;
>> +
>> +     BUG_ON(write_can_lock(&tasklist_lock));
>> +     BUG_ON(!spin_is_locked(&current->sighand->siglock));
>> +
>> +     if (current->seccomp.mode != SECCOMP_MODE_FILTER)
>> +             return -EACCES;
>> +
>> +     /* Validate all threads being eligible for synchronization. */
>> +     thread = caller = current;
>> +     for_each_thread(caller, thread) {
>> +             pid_t failed;
>> +
>> +             if (thread->seccomp.mode == SECCOMP_MODE_DISABLED ||
>> +                 (thread->seccomp.mode == SECCOMP_MODE_FILTER &&
>> +                  is_ancestor(thread->seccomp.filter,
>> +                              caller->seccomp.filter)))
>> +                     continue;
>> +
>> +             /* Return the first thread that cannot be synchronized. */
>> +             failed = task_pid_vnr(thread);
>> +             /* If the pid cannot be resolved, then return -ESRCH */
>> +             if (failed == 0)
>> +                     failed = -ESRCH;
>
> forgot to mention, task_pid_vnr() can't fail. sighand->siglock is held,
> for_each_thread() can't see a thread which has passed unhash_process().

Certainly good to know, but I'd be much more comfortable leaving this
check as-is. Having "failed" return with "0" would be very very bad
(userspace would think the filter had been successfully applied, etc).
I'd rather stay highly defensive here.

-Kees

-- 
Kees Cook
Chrome OS Security
