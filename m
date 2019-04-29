From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH for 5.2 12/12] rseq/selftests: add -no-integrated-as for clang
Date: Mon, 29 Apr 2019 10:03:13 -0700
Message-ID: <CAKwvOdnbH0+ju5Ny-mB-Z4kC+ALyCJOU4Q8OCLHHjFAQzJqsXA@mail.gmail.com>
References: <20190429152803.7719-1-mathieu.desnoyers@efficios.com> <20190429152803.7719-13-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190429152803.7719-13-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Shuah Khan <shuah@kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 29, 2019 at 8:29 AM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> Ongoing work for asm goto support from clang requires the
> -no-integrated-as compiler flag.
>
> This compiler flag is present in the toplevel kernel Makefile,
> but is not replicated for selftests. Add it specifically for
> the rseq selftest which requires asm goto.
>
> Link: https://reviews.llvm.org/D56571
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Nick Desaulniers <ndesaulniers@google.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Joel Fernandes <joelaf@google.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Catalin Marinas <catalin.marinas@arm.com>
> CC: Dave Watson <davejwatson@fb.com>
> CC: Will Deacon <will.deacon@arm.com>
> CC: Shuah Khan <shuah@kernel.org>
> CC: Andi Kleen <andi@firstfloor.org>
> CC: linux-kselftest@vger.kernel.org
> CC: "H . Peter Anvin" <hpa@zytor.com>
> CC: Chris Lameter <cl@linux.com>
> CC: Russell King <linux@arm.linux.org.uk>
> CC: Michael Kerrisk <mtk.manpages@gmail.com>
> CC: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
> CC: Paul Turner <pjt@google.com>
> CC: Boqun Feng <boqun.feng@gmail.com>
> CC: Josh Triplett <josh@joshtriplett.org>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Ben Maurer <bmaurer@fb.com>
> CC: linux-api@vger.kernel.org
> CC: Andy Lutomirski <luto@amacapital.net>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  tools/testing/selftests/rseq/Makefile | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/rseq/Makefile b/tools/testing/selftests/rseq/Makefile
> index c30c52e1d0d2..d6469535630a 100644
> --- a/tools/testing/selftests/rseq/Makefile
> +++ b/tools/testing/selftests/rseq/Makefile
> @@ -1,5 +1,11 @@
>  # SPDX-License-Identifier: GPL-2.0+ OR MIT
> -CFLAGS += -O2 -Wall -g -I./ -I../../../../usr/include/ -L./ -Wl,-rpath=./
> +
> +ifneq ($(shell $(CC) --version 2>&1 | head -n 1 | grep clang),)
> +CLANG_FLAGS += -no-integrated-as
> +endif
> +
> +CFLAGS += -O2 -Wall -g -I./ -I../../../../usr/include/ -L./ -Wl,-rpath=./ \
> +         $(CLANG_FLAGS)

The top level Makefile exports $(CLANG_FLAGS), which should contain
`-no-integrated-as`.  Is that available here?  If so, then you can
just add `$(CLANG_FLAGS)`, no compiler check needed.

If not, maybe the test for CONFIG_CC_IS_CLANG is cleaner?

Thanks for the patch, and helping test asm goto in Clang!
-- 
Thanks,
~Nick Desaulniers
