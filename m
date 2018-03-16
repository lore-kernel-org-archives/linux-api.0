From: Howard McLauchlan <hmclauchlan@fb.com>
Subject: Re: [PATCH] bpf: whitelist syscalls for error injection
Date: Fri, 16 Mar 2018 15:55:04 -0700
Message-ID: <f47e1374-43eb-d7c6-dd0a-5d530ff2b4e2@fb.com>
References: <20180313231627.1247-1-hmclauchlan@fb.com>
 <CALCETrWWAB4FcDe=uUUBiq9YZ-jN1G7kNjdEw=Pwe1SSqyL5LQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWWAB4FcDe=uUUBiq9YZ-jN1G7kNjdEw=Pwe1SSqyL5LQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Yonghong Song <yhs@fb.com>, "David S . Miller" <davem@davemloft.net>, Thomas Garnier <thgarnie@google.com>, kernel-team <kernel-team@fb.com>
List-Id: linux-api@vger.kernel.org

On 03/13/2018 04:56 PM, Andy Lutomirski wrote:
> On Tue, Mar 13, 2018 at 11:16 PM, Howard McLauchlan <hmclauchlan@fb.com> wrote:
>> Error injection is a useful mechanism to fail arbitrary kernel
>> functions. However, it is often hard to guarantee an error propagates
>> appropriately to user space programs. By injecting into syscalls, we can
>> return arbitrary values to user space directly; this increases
>> flexibility and robustness in testing, allowing us to test user space
>> error paths effectively.
> 
> Temporary NAK IMO.  Specifically:
> 
>> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
>> index a78186d826d7..e8c6d63ace78 100644
>> --- a/include/linux/syscalls.h
>> +++ b/include/linux/syscalls.h
>> @@ -191,6 +191,8 @@ static inline int is_syscall_trace_event(struct trace_event_call *tp_event)
>>
>>  #define SYSCALL_DEFINE0(sname)                                 \
>>         SYSCALL_METADATA(_##sname, 0);                          \
>> +       asmlinkage long sys_##sname(void);                      \
>> +       ALLOW_ERROR_INJECTION(sys_##sname, ERRNO);              \
> 
> sys_xyz() is not just the syscall itself; it's also a helper that's
> used for entirely silly reasons by various bits of kernel code for
> quite a few syscalls.  Fortunately, Dominik has patches to fix that,
> and Linus is even considering pulling them for 4.16.  This patch will
> most likely conflict with the final result of Dominik's series.
> 
> Can you and Dominik coordinate a bit to get this patch or its
> equivalent landed on top of Dominik's work?  It might make sense for
> Dominik to just add this patch to his series so it can land with the
> rest of it.  Dominik, Ingo, what do you think?
> 
> --Andy
> 

Dominik, 

This patch applies cleanly on top of your patch series. Is there anything you'd need from me to get this in on top of your work? 

Howard 
