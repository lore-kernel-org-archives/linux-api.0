From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 1/2] tracing/syscalls: allow multiple syscall numbers per syscall
Date: Tue, 30 Aug 2016 11:52:39 -0700
Message-ID: <CALCETrWy5cUDJmTVrjSSqWHc4KyxTPjoD7yU7iqTSHfkK4UwvA@mail.gmail.com>
References: <1472463007-6469-1-git-send-email-marcin.nowakowski@imgtec.com>
 <CALCETrW1m9ozck-ugX6AKnL7oNA8rvMTjhFGqtVSvKL9BMXMZA@mail.gmail.com> <f40020e1-200c-f113-5174-5fe4d4c000dc@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f40020e1-200c-f113-5174-5fe4d4c000dc@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Cc: Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, open list <linux-kernel@vger.kernel.org>, Linux MIPS Mailing List <linux-mips@linux-mips.org>
List-Id: linux-api@vger.kernel.org

On Tue, Aug 30, 2016 at 1:14 AM, Marcin Nowakowski
<marcin.nowakowski@imgtec.com> wrote:
>
>
> On 30.08.2016 01:55, Andy Lutomirski wrote:
>>
>> On Aug 29, 2016 11:30 AM, "Marcin Nowakowski"
>> <marcin.nowakowski@imgtec.com> wrote:
>>>
>>>
>>> Syscall metadata makes an assumption that only a single syscall number
>>> corresponds to a given method. This is true for most archs, but
>>> can break tracing otherwise.
>>>
>>> For MIPS platforms, depending on the choice of supported ABIs, up to 3
>>> system call numbers can correspond to the same call - depending on which
>>> ABI the userspace app uses.
>>
>>
>> MIPS isn't special here.  x86 does the same thing.  Why isn't this a
>> problem on x86?
>>
>
> Hi Andy,
>
> My understanding is that MIPS is quite different to what most other
> architectures do ...
> First of all x86 disables tracing of compat syscalls as that didn't work
> properly because of wrong mapping of syscall numbers to syscalls:
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=f431b634f
>
> Moreover, when trace_syscalls is initialised, the syscall metadata is
> updated to include the right syscall numbers. That uses arch_syscall_addr
> method, which has a default implementation in kernel/trace/trace_syscalls.c:
>
> unsigned long __init __weak arch_syscall_addr(int nr)
> {
>         return (unsigned long)sys_call_table[nr];
> }
>
> that works for x86 and only uses 'native' syscalls, ie. for x86_64 will not
> map any of the ia32_sys_call_table entries. So on one hand we have the code
> that disables tracing for x86_64 compat, on the other we only ensure that
> the native calls are mapped.
> It is quite different for MIPS where syscall numbers for different ABIs have
> distinct call numbers, so the following code maps the syscalls
> (for O32 -> 4xxx, N64 -> 5xxx, N32 -> 6xxx):

x86 has that, too.  There are three types of x86 syscalls: i386
(AUDIT_ARCH_I386, low nr), x86_64 (AUDIT_ARCH_X86_64, low nr, nr can
overlap i386 with differnt meanings), and x32 (AUDIT_ARCH_X86_64, high
nr).

>
> unsigned long __init arch_syscall_addr(int nr)
> {
>         if (nr >= __NR_N32_Linux && nr <= __NR_N32_Linux +
> __NR_N32_Linux_syscalls)
>                 return (unsigned long)sysn32_call_table[nr -
> __NR_N32_Linux];
>         if (nr >= __NR_64_Linux  && nr <= __NR_64_Linux +
> __NR_64_Linux_syscalls)
>                 return (unsigned long)sys_call_table[nr - __NR_64_Linux];
>         if (nr >= __NR_O32_Linux && nr <= __NR_O32_Linux +
> __NR_O32_Linux_syscalls)
>                 return (unsigned long)sys32_call_table[nr - __NR_O32_Linux];
>         return (unsigned long) &sys_ni_syscall;
> }
>
> As a result when init_ftrace_syscalls() loops through all the possible
> syscall numbers,  it first finds an O32 implementation, then N64 and finally
> N32. As the current code doesn't expect multiple references to a given
> syscall number, it always overrides the metadata with the last found - as a
> result only N32 syscalls are mapped.

Okay, I think I see what's going on.  init_ftrace_syscalls() does:

        meta = find_syscall_meta(addr);

Unless I'm missing some reason why this is a sensible thing to do,
this seems overcomplicated and incorrect.  There is exactly one caller
of find_syscall_meta() and that caller knows the syscall number.  Why
doesn't it just look up the metadata by *number* instead of by syscall
implementation address?  There are plenty of architectures for which
multiple logically different syscalls can share an implementation
(e.g. pretty much everything that calls in_compat_syscall()).

Can't this be radically simplified by just calling
syscall_nr_to_meta() instead and deleting find_syscall_meta()?  Or is
there some reason that it makes sense for one syscall_metadata to have
multiple syscalls nrs?  (Also, keep in mind that, on x86, the nr is
insufficient to identify the syscall.  You really need to know both nr
and arch to identify the syscall, so sticking an array of syscall nrs
somewhere doesn't accurately express the x86 situation.)

--Andy
