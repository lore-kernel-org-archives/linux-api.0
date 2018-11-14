From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [PATCH v5 06/27] x86/cet: Control protection exception handler
Date: Wed, 14 Nov 2018 12:19:42 -0800
Message-ID: <307b6162b0270871e664ca88a96b4ea0d1b3f65b.camel@intel.com>
References: <20181011151523.27101-1-yu-cheng.yu@intel.com>
         <20181011151523.27101-7-yu-cheng.yu@intel.com>
         <20181114184436.GK13926@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181114184436.GK13926@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pa
List-Id: linux-api@vger.kernel.org

On Wed, 2018-11-14 at 19:44 +0100, Borislav Petkov wrote:
> That subject needs a verb:
> 
> Subject: [PATCH v5 06/27] x86/cet: Add control protection exception handler
> 
> On Thu, Oct 11, 2018 at 08:15:02AM -0700, Yu-cheng Yu wrote:
> > A control protection exception is triggered when a control flow transfer
> > attempt violated shadow stack or indirect branch tracking constraints.
> > For example, the return address for a RET instruction differs from the
> > safe copy on the shadow stack; or a JMP instruction arrives at a non-
> > ENDBR instruction.
> > 
> > The control protection exception handler works in a similar way as the
> > general protection fault handler.
> > 
> > Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
> > ---
> >  arch/x86/entry/entry_64.S          |  2 +-
> >  arch/x86/include/asm/traps.h       |  3 ++
> >  arch/x86/kernel/idt.c              |  4 ++
> >  arch/x86/kernel/signal_compat.c    |  2 +-
> >  arch/x86/kernel/traps.c            | 64 ++++++++++++++++++++++++++++++
> >  include/uapi/asm-generic/siginfo.h |  3 +-
> >  6 files changed, 75 insertions(+), 3 deletions(-)
> 
> A *lot* of style problems here. Please use checkpatch and then common
> sense to check your patches before sending. All those below are valid,
> AFAICT:
> 
> WARNING: function definition argument 'struct pt_regs *' should also have an
> identifier name
> #76: FILE: arch/x86/include/asm/traps.h:81:
> +dotraplinkage void do_control_protection(struct pt_regs *, long);
> 
> WARNING: function definition argument 'long' should also have an identifier
> name
> #76: FILE: arch/x86/include/asm/traps.h:81:
> +dotraplinkage void do_control_protection(struct pt_regs *, long);

Yes, I was not sure if the addition should follow the existing style (which does
not have identifier names).  What do you think is right?

Thanks,
Yu-cheng
