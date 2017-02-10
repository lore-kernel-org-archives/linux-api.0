From: Kees Cook <keescook@chromium.org>
Subject: Re: [RFC] syscalls: Restore address limit after a syscall
Date: Fri, 10 Feb 2017 12:49:34 -0800
Message-ID: <CAGXu5jJf5z5f0O=T4awfF98OR7+kaQaFFJu3kXXa402vq-Mj2Q@mail.gmail.com>
References: <20170209183358.103094-1-thgarnie@google.com> <CAGXu5j+hyXxpyU1R+BeL9RwPhT6HSNE0c_b7MP_V0rYSAepYFw@mail.gmail.com>
 <CALCETrWrbDnka=aqzQ5+7WN2N6RwFsQb7smcnjQMsjov+y=dTQ@mail.gmail.com>
 <CAJcbSZHv7w5jYQ2AZ-g4Kc0mX0jRRbHCKwFKx1EFuOAby1yxXA@mail.gmail.com>
 <CALCETrVS6J2_GPWBoxUFUhjdyce0TBdroA+FjfdNywr9_k6hew@mail.gmail.com> <20170210192242.GM27312@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-6495-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Sender: keescook@google.com
In-Reply-To: <20170210192242.GM27312@n2100.armlinux.org.uk>
To: Russell King - ARM Linux <linux@armlinux.org.uk>, Mark Rutland <mark.rutland@arm.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Thomas Garnier <thgarnie@google.com>, Stephen Bates <stephen.bates@pmcs.com>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>, Jeff Moyer <jmoyer@redhat.com>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Milosz Tanski <milosz@adfin.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 10, 2017 at 11:22 AM, Russell King - ARM Linux
<linux@armlinux.org.uk> wrote:
> On Thu, Feb 09, 2017 at 06:42:34PM -0800, Andy Lutomirski wrote:
>> On Thu, Feb 9, 2017 at 3:41 PM, Thomas Garnier <thgarnie@google.com> wrote:
>> > So by default it is in the wrapper. If selected, an architecture can
>> > disable the wrapper put it in the best places. Understood correctly?
>>
>> Sounds good to me.
>>
>> Presumably the result should go through -mm.  Want to cc: akpm and
>> linux-arch@ on the next version?
>>
>> I've also cc'd arm and s390 folks -- those are the other arches that
>> try to be on top of hardening.
>
> The best place for this on ARM is in the assembly code, rather than in
> the hundreds of system calls - having it in one place is surely better
> for reducing the cache impact.
>
> This (untested) patch should be sufficient for ARM - there's two choices
> which I think make sense to do this:
> 1. Immediately after returning the syscall
> 2. Immediately before any returning to userspace
>
> (1) has the advantage that the address limit will be forced for the
> exit-path works that we do, preventing those making accesses to kernel
> space.
>
> (2) has the advantage that we'd guarantee that the address limit will
> be forced while userspace is running for the next entry into kernel
> space.
>
> There's actually a third option as well:
>
> (3) forcing the address limit on entry to the kernel from userspace.
>
> This patch implements option 1.
>
>  arch/arm/kernel/entry-common.S | 6 ++++++
>  1 files changed, 6 insertions(+)
>
> diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
> index eb5cd77bf1d8..6a717a2ccb88 100644
> --- a/arch/arm/kernel/entry-common.S
> +++ b/arch/arm/kernel/entry-common.S
> @@ -39,6 +39,8 @@
>  ret_fast_syscall:
>   UNWIND(.fnstart       )
>   UNWIND(.cantunwind    )
> +       mov     r1, #TASK_SIZE
> +       str     r1, [tsk, #TI_ADDR_LIMIT]
>         disable_irq_notrace                     @ disable interrupts
>         ldr     r1, [tsk, #TI_FLAGS]            @ re-check for syscall tracing
>         tst     r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
> @@ -64,6 +66,8 @@ ENDPROC(ret_fast_syscall)
>  ret_fast_syscall:
>   UNWIND(.fnstart       )
>   UNWIND(.cantunwind    )
> +       mov     r1, #TASK_SIZE
> +       str     r1, [tsk, #TI_ADDR_LIMIT]
>         str     r0, [sp, #S_R0 + S_OFF]!        @ save returned r0
>         disable_irq_notrace                     @ disable interrupts
>         ldr     r1, [tsk, #TI_FLAGS]            @ re-check for syscall tracing
> @@ -262,6 +266,8 @@ ENDPROC(vector_swi)
>         b       ret_slow_syscall
>
>  __sys_trace_return:
> +       mov     r1, #TASK_SIZE
> +       str     r1, [tsk, #TI_ADDR_LIMIT]
>         str     r0, [sp, #S_R0 + S_OFF]!        @ save returned r0
>         mov     r0, sp
>         bl      syscall_trace_exit
>

That looks pretty great! If I'm reading the macros correctly, this'll
only happen on _actual_ syscall exit, right? So all the crazy OABI
stuff won't suddenly break? e.g.:

asmlinkage long sys_oabi_semtimedop(int semid,
...
                mm_segment_t fs = get_fs();
                set_fs(KERNEL_DS);
                err = sys_semtimedop(semid, sops, nsops, timeout);
                set_fs(fs);
...
        return err;
}

Is there a similarly good place to do this for arm64?

-Kees

-- 
Kees Cook
Pixel Security
