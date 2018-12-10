From: Palmer Dabbelt <palmer@sifive.com>
Subject: Re: [PATCH v5 24/25] ptrace: add PTRACE_GET_SYSCALL_INFO request
Date: Mon, 10 Dec 2018 13:04:25 -0800 (PST)
Message-ID: <mhng-6b6b1220-80dc-4acf-8a4b-649ef2c38919@palmer-si-x1c4>
References: <20181210180421.wq3ruldbpvu2jpfm@pburton-laptop>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181210180421.wq3ruldbpvu2jpfm@pburton-laptop>
Sender: linux-kernel-owner@vger.kernel.org
To: paul.burton@mips.com
Cc: ldv@altlinux.org, ralf@linux-mips.org, jhogan@kernel.org, oleg@redhat.com, luto@kernel.org, lineprinter@altlinux.org, esyr@redhat.com, keescook@chromium.org, jannh@google.com, linux-api@vger.kernel.org, strace-devel@lists.strace.io, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 10 Dec 2018 10:04:22 PST (-0800), paul.burton@mips.com wrote:
> Hi Dmitry,
>
> On Mon, Dec 10, 2018 at 07:09:40PM +0300, Dmitry V. Levin wrote:
>> We decided to add .frame_pointer to struct ptrace_syscall_info just for
>> consistency with .instruction_pointer and .stack_pointer; I must have been
>> misled by comments in asm-generic/ptrace.h into thinking that
>> frame_pointer() is universally available across architectures.
>
> Is it correct to say that you're using frame_pointer() purely on user
> register state, not kernel?
>
> If so then one option would be to define it for MIPS as something like:
>
>     static inline unsigned long frame_pointer(struct pt_regs *regs)
>     {
>     	return regs->regs[30];
>     }
>
> My concern with that though would be that providing frame_pointer()
> unconditionally might mislead people into thinking that the kernel
> always has frame pointers, when in reality current MIPS kernels never
> do. In fact a comment in MIPS' asm/ptrace.h seems to suggest the lack of
> frame_pointer() is intentional for exactly that reason:
>
>> Don't use asm-generic/ptrace.h it defines FP accessors that don't make
>> sense on MIPS.  We rather want an error if they get invoked.
>
> Looking across architectures though MIPS isn't going to be the only one
> missing frame_pointer(). With a little grepping it appears that these
> architectures provide frame_pointer():
>
>   arm
>   arm64
>   hexagon
>   nds32
>   powerpc
>   riscv
>   sparc
>   um
>   x86
>
> That leaves a whole bunch of other architectures (16) which don't have
> frame_pointer(), or at least not in a way that I could see at a glance.

We (RISC-V) default to compiling without frame pointers.  I'm not sure if it 
even makes sense have frame_pointer() on RISC-V, as it'll usually return 
garbage.

>> Unlike .instruction_pointer and .stack_pointer that are actually needed
>> in strace, .frame_pointer is not used, so from strace PoV we don't really
>> need it.
>> 
>> So the question is, does anybody need a
>> struct ptrace_syscall_info.frame_pointer?
>> 
>> If yes, how can frame_pointer() be defined on MIPS?
>> Or should we just forget about making sense of frame_pointer() and remove
>> struct ptrace_syscall_info.frame_pointer from the proposed API?
>
> So, along these lines my suggestion would be to avoid it if you don't
> really need it anyway.
>
> Thanks,
>     Paul
