From: Laura Abbott <labbott@redhat.com>
Subject: Re: [PATCH] proc: restrict kernel stack dumps to root
Date: Wed, 12 Sep 2018 15:47:58 -0700
Message-ID: <4ceb318d-9af6-7a78-db6a-cfe9dd8a0823@redhat.com>
References: <20180911183909.233413-1-jannh@google.com>
 <CAG48ez03ivLr6w+V911V7pqb1o=kcJw4CLEktcSVVE+=hXXP=w@mail.gmail.com>
 <CAGXu5jKBPh+TSCuaitpPdk89hW=ch+QeRsUfE68pLpzLS=z4Jg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jKBPh+TSCuaitpPdk89hW=ch+QeRsUfE68pLpzLS=z4Jg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Ken Chen <kenchen@google.com>, kernel list <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Security Officers <security@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 09/12/2018 03:27 PM, Kees Cook wrote:
> On Wed, Sep 12, 2018 at 8:29 AM, Jann Horn <jannh@google.com> wrote:
>> +linux-api, I guess
>>
>> On Tue, Sep 11, 2018 at 8:39 PM Jann Horn <jannh@google.com> wrote:
>>>
>>> Restrict the ability to inspect kernel stacks of arbitrary tasks to root
>>> in order to prevent a local attacker from exploiting racy stack unwinding
>>> to leak kernel task stack contents.
>>> See the added comment for a longer rationale.
>>>
>>> There don't seem to be any users of this userspace API that can't
>>> gracefully bail out if reading from the file fails. Therefore, I believe
>>> that this change is unlikely to break things.
>>> In the case that this patch does end up needing a revert, the next-best
>>> solution might be to fake a single-entry stack based on wchan.
>>>
>>> Fixes: 2ec220e27f50 ("proc: add /proc/*/stack")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Jann Horn <jannh@google.com>
>>> ---
>>>   fs/proc/base.c | 14 ++++++++++++++
>>>   1 file changed, 14 insertions(+)
>>>
>>> diff --git a/fs/proc/base.c b/fs/proc/base.c
>>> index ccf86f16d9f0..7e9f07bf260d 100644
>>> --- a/fs/proc/base.c
>>> +++ b/fs/proc/base.c
>>> @@ -407,6 +407,20 @@ static int proc_pid_stack(struct seq_file *m, struct pid_namespace *ns,
>>>          unsigned long *entries;
>>>          int err;
>>>
>>> +       /*
>>> +        * The ability to racily run the kernel stack unwinder on a running task
>>> +        * and then observe the unwinder output is scary; while it is useful for
>>> +        * debugging kernel issues, it can also allow an attacker to leak kernel
>>> +        * stack contents.
>>> +        * Doing this in a manner that is at least safe from races would require
>>> +        * some work to ensure that the remote task can not be scheduled; and
>>> +        * even then, this would still expose the unwinder as local attack
>>> +        * surface.
>>> +        * Therefore, this interface is restricted to root.
>>> +        */
>>> +       if (!file_ns_capable(m->file, &init_user_ns, CAP_SYS_ADMIN))
>>> +               return -EACCES;
> 
> In the past, we've avoided hard errors like this in favor of just
> censoring the output. Do we want to be more cautious here? (i.e.
> return 0 or a fuller seq_printf(m, "[<0>] privileged\n"); return 0;)
> 

The -EACCES is a strong hint to run with root privileges which is
nice from an end user perspective. If we don't want to return an
actual error, I think the "privileged" message would be okay.

Laura

>>> +
>>>          entries = kmalloc_array(MAX_STACK_TRACE_DEPTH, sizeof(*entries),
>>>                                  GFP_KERNEL);
>>>          if (!entries)
>>> --
>>> 2.19.0.rc2.392.g5ba43deb5a-goog
>>>
> 
> -Kees
> 
