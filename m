From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH for 5.2 12/12] rseq/selftests: add -no-integrated-as for clang
Date: Mon, 29 Apr 2019 13:30:14 -0700
Message-ID: <CAKwvOdk1bUgczvUr3OVttFZ4ArO6fSEz6_enPmu+GDDy1yTrTQ@mail.gmail.com>
References: <20190429152803.7719-1-mathieu.desnoyers@efficios.com>
 <20190429152803.7719-13-mathieu.desnoyers@efficios.com> <CAKwvOdnbH0+ju5Ny-mB-Z4kC+ALyCJOU4Q8OCLHHjFAQzJqsXA@mail.gmail.com>
 <712082435.384.1556569697998.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <712082435.384.1556569697998.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: shuah <shuah@kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 29, 2019 at 1:28 PM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> ----- On Apr 29, 2019, at 1:03 PM, ndesaulniers ndesaulniers@google.com wrote:
>
> > On Mon, Apr 29, 2019 at 8:29 AM Mathieu Desnoyers
> > <mathieu.desnoyers@efficios.com> wrote:
> >> diff --git a/tools/testing/selftests/rseq/Makefile
> >> b/tools/testing/selftests/rseq/Makefile
> >> index c30c52e1d0d2..d6469535630a 100644
> >> --- a/tools/testing/selftests/rseq/Makefile
> >> +++ b/tools/testing/selftests/rseq/Makefile
> >> @@ -1,5 +1,11 @@
> >>  # SPDX-License-Identifier: GPL-2.0+ OR MIT
> >> -CFLAGS += -O2 -Wall -g -I./ -I../../../../usr/include/ -L./ -Wl,-rpath=./
> >> +
> >> +ifneq ($(shell $(CC) --version 2>&1 | head -n 1 | grep clang),)
> >> +CLANG_FLAGS += -no-integrated-as
> >> +endif
> >> +
> >> +CFLAGS += -O2 -Wall -g -I./ -I../../../../usr/include/ -L./ -Wl,-rpath=./ \
> >> +         $(CLANG_FLAGS)
> >
> > The top level Makefile exports $(CLANG_FLAGS), which should contain
> > `-no-integrated-as`.  Is that available here?  If so, then you can
> > just add `$(CLANG_FLAGS)`, no compiler check needed.
>
> AFAIU, the makefiles under tools/testing/selftests all end up including
> tools/testing/selftests/lib.mk, which states:
>
> "# This mimics the top-level Makefile. We do it explicitly here so that this
>  # Makefile can operate with or without the kbuild infrastructure."
>
> So I don't think it's using any of the definitions from the toplevel
> Makefile.
>
> > If not, maybe the test for CONFIG_CC_IS_CLANG is cleaner?
>
> A quick test indicates that the toplevel CONFIG_* definitions are unavailable
> from the kernel selftests makefiles.

Ok, in that case...
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Thanks again!

-- 
Thanks,
~Nick Desaulniers
