From: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org
Subject: Re: [PATCH 2/6] x86: Opt into HAVE_COPY_THREAD_TLS, for both
 32-bit and 64-bit
Date: Fri, 13 Mar 2015 15:43:19 -0700
Message-ID: <20150313224319.GA11282@cloud>
References: <cover.1426180120.git.josh@joshtriplett.org>
 <cf79b9f0c40314e6bfda7c634e378015bd7ba037.1426180120.git.josh@joshtriplett.org>
 <CALCETrUbQJhE8VCTt5yQ+KBZOJnNC5e3yUneKjhwhKxgvfU2Xg@mail.gmail.com>
 <20150313223139.GD10954@cloud>
 <CALCETrWspvNcEYxwbo1+ifXSj7Qj7YdcRgmNvZ1RaBrUAK12Zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWspvNcEYxwbo1+ifXSj7Qj7YdcRgmNvZ1RaBrUAK12Zw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 13, 2015 at 03:38:31PM -0700, Andy Lutomirski wrote:
> On Fri, Mar 13, 2015 at 3:31 PM,  <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:
> > On Fri, Mar 13, 2015 at 03:01:16PM -0700, Andy Lutomirski wrote:
> >> On Thu, Mar 12, 2015 at 6:40 PM, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:
> >> > For 32-bit userspace on a 64-bit kernel, this requires modifying
> >> > stub32_clone to actually swap the appropriate arguments to match
> >> > CONFIG_CLONE_BACKWARDS, rather than just leaving the C argument for tls
> >> > broken.
> >> >
> >> > Signed-off-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
> >> > Signed-off-by: Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >> > ---
> >> >  arch/x86/Kconfig             | 1 +
> >> >  arch/x86/ia32/ia32entry.S    | 2 +-
> >> >  arch/x86/kernel/process_32.c | 6 +++---
> >> >  arch/x86/kernel/process_64.c | 8 ++++----
> >> >  4 files changed, 9 insertions(+), 8 deletions(-)
> >> >
> >> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> >> > index b7d31ca..4960b0d 100644
> >> > --- a/arch/x86/Kconfig
> >> > +++ b/arch/x86/Kconfig
> >> > @@ -124,6 +124,7 @@ config X86
> >> >         select MODULES_USE_ELF_REL if X86_32
> >> >         select MODULES_USE_ELF_RELA if X86_64
> >> >         select CLONE_BACKWARDS if X86_32
> >> > +       select HAVE_COPY_THREAD_TLS
> >> >         select ARCH_USE_BUILTIN_BSWAP
> >> >         select ARCH_USE_QUEUE_RWLOCK
> >> >         select OLD_SIGSUSPEND3 if X86_32 || IA32_EMULATION
> >> > diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
> >> > index 156ebca..0286735 100644
> >> > --- a/arch/x86/ia32/ia32entry.S
> >> > +++ b/arch/x86/ia32/ia32entry.S
> >> > @@ -487,7 +487,7 @@ GLOBAL(\label)
> >> >         ALIGN
> >> >  GLOBAL(stub32_clone)
> >> >         leaq sys_clone(%rip),%rax
> >> > -       mov     %r8, %rcx
> >> > +       xchg %r8, %rcx
> >> >         jmp  ia32_ptregs_common
> >>
> >> Do I understand correct that whatever function this is a stub for just
> >> takes its arguments in the wrong order?  If so, can we just fix it
> >> instead of using xchg here?
> >
> > 32-bit x86 and 64-bit x86 take the arguments to clone in a different
> > order, and stub32_clone fixes up the argument order then calls the
> > 64-bit sys_clone.
> >
> > I'd love to see *all* the 32-on-64 compat stubs for clone rewritten in C
> > under CONFIG_COMPAT.  However, doing so would require encoding the
> > knowledge for each 64-bit architecture for how its corresponding 32-bit
> > architecture accepts arguments to clone, which is information that the
> > current CONFIG_CLONE_BACKWARDS{1,2,3} don't include; it would then
> > require cleaning up all the architecture-specific assembly stubs for
> > 32-bit clone entry points.
> >
> > In the meantime, doing that *just* for 32-bit x86 on 64-bit x86 doesn't
> > seem worth it, since it would require adding a new C entry point for
> > compat_sys_clone under arch/x86 somewhere.
> >
> > One cleanup at a time. :)
> 
> Fine w/ me.

Thanks.

> >
> >> In general, I much prefer C code to new asm where it makes sense to
> >> make this tradeoff.
> >
> > Agreed completely.  However, this is at least conservation-of-asm, or
> > reduction if you consider the pt_regs argument-grabbing hack to be
> > asm-esque code.
> >
> >> Other than that, this is a huge improvement.  You'll have minor
> >> conflicts against -tip, though.
> >
> > Right, I've seen your current changes there.  Should be a trivial merge
> > though.
> >
> > Would you mind providing an ack for the series, or at least for the
> > first two patches?
> 
> I can give you an ok-in-principle on the first two.  I'd need to stare
> at the awful code for a bit to understand the @!*&! clone variants to
> really ack them convincingly.

I'd definitely appreciate the staring. :)

> OTOH, it would be rather surprising if you messed it up in a way that
> still boots on all three variants (native 32-bit, native 64-bit, and
> compat).
> 
> So, for the first two patches:
> 
> Acked-by: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> # assuming all bitnesses boot

I did test all three, not just with booting but with a thread-local
storage test.

- Josh Triplett
