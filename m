From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH v2 25/27] x86/cet: Add PTRACE interface for CET
Date: Fri, 13 Jul 2018 01:08:23 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1807130102470.1597@nanos.tec.linutronix.de>
References: <20180710222639.8241-1-yu-cheng.yu@intel.com>  <20180710222639.8241-26-yu-cheng.yu@intel.com>  <20180711102035.GB8574@gmail.com> <1531323638.13297.24.camel@intel.com>  <20180712140327.GA7810@gmail.com> <1531435034.2965.15.camel@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1575887918-1531436904=:1597"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1531435034.2965.15.camel@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromiun.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>, Peter Zijlstra <peterz@infr>
List-Id: linux-api@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1575887918-1531436904=:1597
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 12 Jul 2018, Yu-cheng Yu wrote:
> On Thu, 2018-07-12 at 16:03 +0200, Ingo Molnar wrote:
> > * Yu-cheng Yu <yu-cheng.yu@intel.com> wrote:
> > > > > diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
> > > > > index e2ee403865eb..ac2bc3a18427 100644
> > > > > --- a/arch/x86/kernel/ptrace.c
> > > > > +++ b/arch/x86/kernel/ptrace.c
> > > > > @@ -49,7 +49,9 @@ enum x86_regset {
> > > > >  	REGSET_IOPERM64 = REGSET_XFP,
> > > > >  	REGSET_XSTATE,
> > > > >  	REGSET_TLS,
> > > > > +	REGSET_CET64 = REGSET_TLS,
> > > > >  	REGSET_IOPERM32,
> > > > > +	REGSET_CET32,
> > > > >  };
> > > > Why does REGSET_CET64 alias on REGSET_TLS?
> > > In x86_64_regsets[], there is no [REGSET_TLS].  The core dump code
> > > cannot handle holes in the array.
> > Is there a fundamental (ABI) reason for that?
> 
> What I did was, ran Linux with 'slub_debug', and forced a core dump
> (kill -abrt <pid>), then there was a red zone warning in the dmesg.
> My feeling is there could be issues in the core dump code.  These

Kernel development is not about feelings.

Either you can track down the root cause or you cannot. There is no place
for feelings and no place in between. And if you cannot track down the root
cause and explain it proper then the resulting patch is just papering over
the symptoms and will come back to hunt you (or others) sooner than later.

No if, no could, no feelings. Facts is what matters. Really.

Thanks,

	tglx
--8323329-1575887918-1531436904=:1597--
