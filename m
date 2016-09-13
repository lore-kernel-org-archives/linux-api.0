From: Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 2/3] tracing/syscalls: add handling for compat tasks
Date: Tue, 13 Sep 2016 07:41:52 +0200
Message-ID: <c212f850-db6a-10ba-bbeb-490be9ea953b@imgtec.com>
References: <1473408209-17335-1-git-send-email-marcin.nowakowski@imgtec.com>
 <1473408209-17335-3-git-send-email-marcin.nowakowski@imgtec.com>
 <CALCETrVVTTFrbKJYcgMurH-+QsiGaZv3FoJNDsUY67fs7+kMcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrVVTTFrbKJYcgMurH-+QsiGaZv3FoJNDsUY67fs7+kMcQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Andy,

Thanks for your review and the comments, I'll address them in a next 
iteration. Do you have any other comments on the complete patchset?

On 12.09.2016 19:35, Andy Lutomirski wrote:
> On Sep 9, 2016 1:04 AM, "Marcin Nowakowski"
> <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org> wrote:
>>
>> Extend the syscall tracing subsystem by adding a handler for compat
>> tasks. For some architectures, where compat tasks' syscall numbers have
>> an exclusive set of syscall numbers, this already works since the
>> removal of syscall_nr.
>> Architectures where the same syscall may use a different syscall number
>> for compat tasks need to define ARCH_COMPAT_SYSCALL_NUMBERS_OVERLAP and
>> define a method arch_trace_is_compat_syscall(struct pt_regs*) that tells
>> if a current task is a compat one.
>> For architectures that define ARCH_COMPAT_SYSCALL_NUMBERS_OVERLAP the
>> number of trace event files is doubled and all syscall trace events are
>> identified by the syscall number offset by NR_syscalls.
>>
>> Note that as this patch series is posted as an RFC, this currently only
>> includes arch updates for MIPS and x86 (and has only been tested on
>> MIPS and x86_64). I will work on updating other arch trees after this
>> solution is reviewed.
>
> I bet you didn't test x32 -- see below :)

Indeed ... I've tried with x86_64 and 32-bit x86, but not x32 syscalls. 
I will review that part.

>>
>> Signed-off-by: Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
>>
>> ---
>>  arch/mips/kernel/ftrace.c     |   4 +-
>>  arch/x86/include/asm/ftrace.h |  10 +---
>>  arch/x86/kernel/ftrace.c      |  14 ++++++
>>  include/linux/ftrace.h        |   2 +-
>>  kernel/trace/trace.h          |  11 +++-
>>  kernel/trace/trace_syscalls.c | 113 +++++++++++++++++++++++++-----------------
>>  6 files changed, 94 insertions(+), 60 deletions(-)
>>
>> diff --git a/arch/mips/kernel/ftrace.c b/arch/mips/kernel/ftrace.c
>> index 937c54b..e150cf6 100644
>> --- a/arch/mips/kernel/ftrace.c
>> +++ b/arch/mips/kernel/ftrace.c
>> @@ -412,7 +412,7 @@ out:
>>  #ifdef CONFIG_FTRACE_SYSCALLS
>>
>>  #ifdef CONFIG_32BIT
>> -unsigned long __init arch_syscall_addr(int nr)
>> +unsigned long __init arch_syscall_addr(int nr, int compat)
>>  {
>>         return (unsigned long)sys_call_table[nr - __NR_O32_Linux];
>>  }
>> @@ -420,7 +420,7 @@ unsigned long __init arch_syscall_addr(int nr)
>>
>>  #ifdef CONFIG_64BIT
>>
>> -unsigned long __init arch_syscall_addr(int nr)
>> +unsigned long __init arch_syscall_addr(int nr, int compat)
>
> bool compat?

Yes, that should make the intention more clear.

>>  {
>>  #ifdef CONFIG_MIPS32_N32
>>         if (nr >= __NR_N32_Linux && nr <= __NR_N32_Linux + __NR_N32_Linux_syscalls)
>> diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
>> index a4820d4..a24a21c 100644
>> --- a/arch/x86/include/asm/ftrace.h
>> +++ b/arch/x86/include/asm/ftrace.h
>> @@ -47,15 +47,7 @@ int ftrace_int3_handler(struct pt_regs *regs);
>>  #if defined(CONFIG_FTRACE_SYSCALLS) && defined(CONFIG_IA32_EMULATION)
>>  #include <asm/compat.h>
>>
>> -/*
>> - * Because ia32 syscalls do not map to x86_64 syscall numbers
>> - * this screws up the trace output when tracing a ia32 task.
>> - * Instead of reporting bogus syscalls, just do not trace them.
>> - *
>> - * If the user really wants these, then they should use the
>> - * raw syscall tracepoints with filtering.
>> - */
>> -#define ARCH_TRACE_IGNORE_COMPAT_SYSCALLS 1
>> +#define ARCH_COMPAT_SYSCALL_NUMBERS_OVERLAP 1
>>  static inline bool arch_trace_is_compat_syscall(struct pt_regs *regs)
>>  {
>>         if (in_compat_syscall())
>
> This isn't your fault obviously, but shouldn't that be in_ia32_syscall()?

Thanks for pointing this out - I'll need to review this part of code a 
bit more.

Marcin
