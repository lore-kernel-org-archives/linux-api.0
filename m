From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [RFC PATCH v6 00/26] Control-flow Enforcement: Shadow Stack
Date: Mon, 26 Nov 2018 10:29:40 -0800
Message-ID: <CALCETrV4BP6gTgVZos19WZrbgEH7t4PqPOeP2VJte1kE=ehokg@mail.gmail.com>
References: <20181119214809.6086-1-yu-cheng.yu@intel.com> <CALCETrWLtpfkecfUAXJ64Z5xDeHPJxTQSci+T4RCem7vCqorTw@mail.gmail.com>
 <35b33f293bc392df71710102f38fa6a40d0bb996.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <35b33f293bc392df71710102f38fa6a40d0bb996.camel@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: Andrew Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Carlos O'Donell <carlos@redhat.com>, Rich Felker <dalias@libc.org>, X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, "H. J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbe>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 26, 2018 at 9:44 AM Yu-cheng Yu <yu-cheng.yu@intel.com> wrote:
>
> On Thu, 2018-11-22 at 08:53 -0800, Andy Lutomirski wrote:
> > [cc some more libc folks]

>
> >
> > 2. I want to be able to modify the signal context from a signal
> > handler such that, when the signal handler returns, it will return to
> > a frame higher up on the call stack than where the signal started and
> > to a different RIP value.  How can I do this?  I guess I can modify
> > the shadow stack with WRSS if WR_SHSTK_EN=1, but how do I tell the
> > kernel to kindly skip the frames I want to skip when I do sigreturn()?
> >
> > The reason I'm asking #2 is that I think it's time to resurrect my old
> > vDSO syscall cancellation helper series here:
> >
> > https://lwn.net/Articles/679434/
>
> If tools/testing/selftests/x86/unwind_vdso.c passes, can we say the kernel does
> the right thing?  Or do you have other tests that I can run?

I haven't written the relevant test yet.  Hopefully soon :)
