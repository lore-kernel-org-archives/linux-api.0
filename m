From: Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] tracing/syscalls: allow multiple syscall numbers per
 syscall
Date: Tue, 30 Aug 2016 10:14:34 +0200
Message-ID: <f40020e1-200c-f113-5174-5fe4d4c000dc@imgtec.com>
References: <1472463007-6469-1-git-send-email-marcin.nowakowski@imgtec.com>
 <CALCETrW1m9ozck-ugX6AKnL7oNA8rvMTjhFGqtVSvKL9BMXMZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrW1m9ozck-ugX6AKnL7oNA8rvMTjhFGqtVSvKL9BMXMZA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org
List-Id: linux-api@vger.kernel.org



On 30.08.2016 01:55, Andy Lutomirski wrote:
> On Aug 29, 2016 11:30 AM, "Marcin Nowakowski"
> <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org> wrote:
>>
>> Syscall metadata makes an assumption that only a single syscall number
>> corresponds to a given method. This is true for most archs, but
>> can break tracing otherwise.
>>
>> For MIPS platforms, depending on the choice of supported ABIs, up to 3
>> system call numbers can correspond to the same call - depending on which
>> ABI the userspace app uses.
>
> MIPS isn't special here.  x86 does the same thing.  Why isn't this a
> problem on x86?
>

Hi Andy,

My understanding is that MIPS is quite different to what most other 
architectures do ...
First of all x86 disables tracing of compat syscalls as that didn't work 
properly because of wrong mapping of syscall numbers to syscalls:
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=f431b634f

Moreover, when trace_syscalls is initialised, the syscall metadata is 
updated to include the right syscall numbers. That uses 
arch_syscall_addr method, which has a default implementation in 
kernel/trace/trace_syscalls.c:

unsigned long __init __weak arch_syscall_addr(int nr)
{
         return (unsigned long)sys_call_table[nr];
}

that works for x86 and only uses 'native' syscalls, ie. for x86_64 will 
not map any of the ia32_sys_call_table entries. So on one hand we have 
the code that disables tracing for x86_64 compat, on the other we only 
ensure that the native calls are mapped.
It is quite different for MIPS where syscall numbers for different ABIs 
have distinct call numbers, so the following code maps the syscalls
(for O32 -> 4xxx, N64 -> 5xxx, N32 -> 6xxx):

unsigned long __init arch_syscall_addr(int nr)
{
         if (nr >= __NR_N32_Linux && nr <= __NR_N32_Linux + 
__NR_N32_Linux_syscalls)
                 return (unsigned long)sysn32_call_table[nr - 
__NR_N32_Linux];
         if (nr >= __NR_64_Linux  && nr <= __NR_64_Linux + 
__NR_64_Linux_syscalls)
                 return (unsigned long)sys_call_table[nr - __NR_64_Linux];
         if (nr >= __NR_O32_Linux && nr <= __NR_O32_Linux + 
__NR_O32_Linux_syscalls)
                 return (unsigned long)sys32_call_table[nr - 
__NR_O32_Linux];
         return (unsigned long) &sys_ni_syscall;
}

As a result when init_ftrace_syscalls() loops through all the possible 
syscall numbers,  it first finds an O32 implementation, then N64 and 
finally N32. As the current code doesn't expect multiple references to a 
given syscall number, it always overrides the metadata with the last 
found - as a result only N32 syscalls are mapped.
This is generally unexpected and wrong behaviour, and to makes things 
worse - since when N32 support is enabled, it overwrites N64 entries, it 
becomes impossible to trace native syscalls.

 > Also, you seem to be partially reinventing AUDIT_ARCH here.  Can you
 > use that and integrate with syscall_get_arch()?

Please correct me if I don't understand what you meant here, but I don't 
see how these can be integrated ...
For MIPS syscall_get_arch() properly determines arch type and calling 
convention, but that information is not enough to determine what call 
was made and how to map it to syscall metadata from another calling 
convention.

Marcin
