From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v9 00/24] ILP32 for ARM64
Date: Sat, 13 Oct 2018 09:54:22 -0700
Message-ID: <CALCETrW0sFoOknkLGFSiobQLg9O4qzD9f-9ws8uk69J1X866cg@mail.gmail.com>
References: <20180516081910.10067-1-ynorov@caviumnetworks.com>
 <20180724173957.GA22106@yury-thinkpad> <20181010141017.GA2881@asgard.redhat.com>
 <20181010153655.GA212880@arrakis.emea.arm.com> <20181013021416.GE21972@asgard.redhat.com>
 <20181013093411.o3id6yzkspsxr5jt@mbp>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181013093411.o3id6yzkspsxr5jt@mbp>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Eugene Syromiatnikov <esyr@redhat.com>, linux-doc@vger.kernel.org, szabolcs.nagy@arm.com, palmer@sifive.com, Heiko Carstens <heiko.carstens@de.ibm.com>, ynorov@caviumnetworks.com, Pavel Machek <pavel@ucw.cz>, philipp.tomsich@theobroma-systems.com, "Joseph S. Myers" <joseph@codesourcery.com>, linux-arch <linux-arch@vger.kernel.org>, sellcey@caviumnetworks.com, Prasun.Kapoor@caviumnetworks.com, schwab@suse.de, Alexander Graf <agraf@suse.de>, bamv2005@gmail.com, Geert Uytterhoeven <geert@linux-m68k.org>, Dave Martin <Dave.Martin@arm.com>, Adam Borowski <kilobyte@angband.pl>, manuel.montezelo@gmail.com, James Hogan <james.hogan@imgtec.com>, Chris Metcalf <cmetcalf@mellanox.com>, Arnd Bergmann <arnd@arndb.de>, Andrew Pinski <pinskia@gmail.com>, linyongting@huawei.com
List-Id: linux-api@vger.kernel.org

> On Oct 13, 2018, at 2:34 AM, Catalin Marinas <catalin.marinas@arm.com> wrote:
>
>> On Sat, Oct 13, 2018 at 04:14:16AM +0200, Eugene Syromiatnikov wrote:
>>> On Wed, Oct 10, 2018 at 04:36:56PM +0100, Catalin Marinas wrote:
>>>> On Wed, Oct 10, 2018 at 04:10:21PM +0200, Eugene Syromiatnikov wrote:
>>>> I have some questions regarding AArch64 ILP32 implementation for which I
>>>> failed to find an answer myself:
>>>> * How ptrace() tracer is supposed to distinguish between ILP32 and LP64
>>>>   tracees? For MIPS N32 and x32 this is possible based on syscall
>>>>   number, but for AArch64 ILP32 I do not see such a sign. There's also
>>>>   ARM_ip is employed for signalling entering/exiting, I wonder whether
>>>>   it's possible to employ it also for signalling tracee's personality.
>>>
>>> With the current implementation, I don't think you can distinguish. From
>>> the kernel perspective, the register set is the same. What is the
>>> use-case for this?
>>
>> Err, a ptrace()-based tracer trying to trace a process, for example?
>
> I first thought it wouldn't matter for ptrace-based tracers since the
> syscall numbers are (mostly) the same. But the arguments layout in
> register is indeed different, so I see your point now about having to
> distinguish.
>
>>> We could add a new regset to expose the ILP32 state (NT_ARM_..., I can't
>>> think of a name now but probably not PER* as this implies PER_LINUX_...
>>> which is independent from TIF_32BIT_*).
>>
>> So that would require an additional ptrace() call on each syscall stop,
>> is that correct?
>
> The ILP32 state does not change at run-time, so it could only do a
> ptrace() call once and save the information. No need to re-read it on
> each syscall stop.
>

Please solve this in an arch independent way.  This situation is
basically unusably broken on x86 right now.  Please solve it for real,
by, for example, adding a new ptrace operation that returns something
like this:

enum ptrace_syscall_state {
  NO_SYSCALL,
  SYSCALL_ENTRY,
  SYSCALL_EXIT,
  /* other values may be defined in the future. */
};

struct ptrace_syscall_info {
  enum ptrace_syscall_state state;
  unsigned long arch;
  union {
    struct {
      unsigned long nr;
      unsigned long args[6];
   } entry;
   struct {
      unsigned long ret;
   } exit;
};

where arch is an AUDIT_ARCH_XYZ constant.

On x86, it's currently essentially impossible for tools like strace to
correctly decode syscalls.

> We could set a high bit in the syscall number reported to the ptrace
> caller (though not changing the syscall ABI) but I haven't thought of
> other consequences. For example, can the ptrace caller change the
> syscall number?

Yes it can.

>
>>>> * What's the reasoning behind capping syscall arguments to 32 bit? x32
>>>>   and MIPS N32 do not have such a restriction (and do not need special
>>>>   wrappers for syscalls that pass 64-bit values as a result, except
>>>>   when they do,  as it is the case for preadv2 on x32); moreover, that
>>>>   would lead to insurmountable difficulties for AArch64 ILP32 tracers
>>>>   that try to trace LP64 tracees, as it would be impossible to pass
>>>>   64-bit addresses to process_vm_{read,write} or ptrace PEEK/POKE.
>>>
>>> We've attempted in earlier versions to allow a mix of 32 and 64-bit
>>> register values from ILP32 but it got pretty complicated. The entry code
>>> would need to know which registers need zeroing of the top 32-bit
>>
>> If kernel specifies 64-bit wide registers for syscalls, then it's the
>> caller's (libc's) responsibility to properly sign-extend arguments when
>> needed, and glibc, for example, already has proper type definitions that
>> aimed to handle this.
>
> We tried, see my other reply.
>
> --
> Catalin
