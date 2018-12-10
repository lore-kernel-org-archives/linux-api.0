From: Paul Burton <paul.burton@mips.com>
Subject: Re: [PATCH v5 24/25] ptrace: add PTRACE_GET_SYSCALL_INFO request
Date: Mon, 10 Dec 2018 18:04:22 +0000
Message-ID: <20181210180421.wq3ruldbpvu2jpfm@pburton-laptop>
References: <20181210043126.GX6131@altlinux.org>
 <201812102200.snodXJSH%fengguang.wu@intel.com>
 <20181210160940.GF14149@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181210160940.GF14149@altlinux.org>
Content-Language: en-US
Content-ID: <BA5D44B8C785D448AE71DFDDEBB696AF@namprd22.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, James Hogan <jhogan@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@kernel.org>, Elvira Khabirova <lineprinter@altlinux.org>, Eugene Syromyatnikov <esyr@redhat.com>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "strace-devel@lists.strace.io" <strace-devel@lists.strace.io>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Dmitry,

On Mon, Dec 10, 2018 at 07:09:40PM +0300, Dmitry V. Levin wrote:
> We decided to add .frame_pointer to struct ptrace_syscall_info just for
> consistency with .instruction_pointer and .stack_pointer; I must have bee=
n
> misled by comments in asm-generic/ptrace.h into thinking that
> frame_pointer() is universally available across architectures.

Is it correct to say that you're using frame_pointer() purely on user
register state, not kernel?

If so then one option would be to define it for MIPS as something like:

    static inline unsigned long frame_pointer(struct pt_regs *regs)
    {
    	return regs->regs[30];
    }

My concern with that though would be that providing frame_pointer()
unconditionally might mislead people into thinking that the kernel
always has frame pointers, when in reality current MIPS kernels never
do. In fact a comment in MIPS' asm/ptrace.h seems to suggest the lack of
frame_pointer() is intentional for exactly that reason:

> Don't use asm-generic/ptrace.h it defines FP accessors that don't make
> sense on MIPS.  We rather want an error if they get invoked.

Looking across architectures though MIPS isn't going to be the only one
missing frame_pointer(). With a little grepping it appears that these
architectures provide frame_pointer():

  arm
  arm64
  hexagon
  nds32
  powerpc
  riscv
  sparc
  um
  x86

That leaves a whole bunch of other architectures (16) which don't have
frame_pointer(), or at least not in a way that I could see at a glance.

> Unlike .instruction_pointer and .stack_pointer that are actually needed
> in strace, .frame_pointer is not used, so from strace PoV we don't really
> need it.
>=20
> So the question is, does anybody need a
> struct ptrace_syscall_info.frame_pointer?
>=20
> If yes, how can frame_pointer() be defined on MIPS?
> Or should we just forget about making sense of frame_pointer() and remove
> struct ptrace_syscall_info.frame_pointer from the proposed API?

So, along these lines my suggestion would be to avoid it if you don't
really need it anyway.

Thanks,
    Paul
