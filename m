From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [RFC PATCH v6] Documentation/arch: Add
 Documentation/arch-features.txt
Date: Wed, 13 May 2015 09:27:57 -0700
Message-ID: <20150513162757.GA21894@x>
References: <20150512142250.dcb053da81855ae1b5861173@linux-foundation.org>
 <20150512213843.GV21418@twins.programming.kicks-ass.net>
 <20150512144910.0b49c9a7a13336773449db33@linux-foundation.org>
 <20150513083441.GA17336@gmail.com>
 <20150513085636.GA11030@gmail.com>
 <20150513092421.GB11030@gmail.com>
 <20150513094622.GC11030@gmail.com>
 <20150513094756.GD11030@gmail.com>
 <20150513131835.GJ1517@pd.tnic>
 <20150513134842.GA1657@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150513134842.GA1657@gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, May 13, 2015 at 03:48:42PM +0200, Ingo Molnar wrote:
> From 93f6bd67b4348bf4bf27cbac8ffa9f1def4fa6aa Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@kernel.org>
> Date: Wed, 13 May 2015 10:30:11 +0200
> Subject: [PATCH] Documentation/arch: Add Documentation/arch-features.txt
> 
> Add a support matrix for various generic kernel features that need
> architecture support.
> 
> Signed-off-by: Ingo Molnar <mingo@kernel.org>

Could you add a column for the bpf JIT?

Should this file track syscalls not wired up on architectures?

How likely is this to get out of date?  Are people going to remember to
patch this when they add a feature to their architecture?  If
they found out they had work to do by reading this file, which is the
goal, then they'll likely remember to edit the file; however, if they
find the feature and fix it without knowing about the file, will someone
notice?

Is there any way we can *generate* this file from Kconfig?  Can we
extract the necessary "this is possible to enable" or "this arch selects
this symbol" information from Kconfig, and together with the list of
symbols for features needing architecture support, generate the table?

If we can't generate this, then the ASCII-art style and right-aligned
feature names seems *really* likely to produce spurious conflicts,
especially when adding a feature to the list.  Even though it would
produce a much longer file, would you consider dropping the tables and
just having a section per feature?  That also avoids the need to
abbreviate as much.  For instance:

Transparent huge pages
HAVE_ARCH_TRANSPARENT_HUGEPAGE && 64BIT

alpha		TODO
arc		..
arm		ok
arm64		ok
avr32		..
blackfin	..
c6x		..
cris		..
frv		..
hexagon		..
ia64		TODO
m32r		..
m68k		..
metag		..
microblaze	..
mips		ok
mn10300		..
nios2		..
openrisc	..
parisc		TODO
powerpc		ok
s390		ok
score		..
sh		..
sparc		ok
tile		TODO
um		..
unicore32	..
x86		ok
xtensa		..

Or alternatively:

Transparent huge pages
HAVE_ARCH_TRANSPARENT_HUGEPAGE && 64BIT

TODO:
alpha
ia64
parisc
tile

Done:
arm
arm64
mips
powerpc
s390
sparc
x86

Not possible:
arc
avr32
blackfin
c6x
cris
frv
hexagon
m32r
m68k
metag
microblaze
mn10300
nios2
openrisc
score
sh
um
unicore32
xtensa


After all, the point of this document isn't to look at, it's to use as a
TODO list and actively edit.  So anything that makes it prettier but
more painful to edit seems like a bug.

>  Documentation/arch-features.txt | 222 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 222 insertions(+)
> 
> diff --git a/Documentation/arch-features.txt b/Documentation/arch-features.txt
> new file mode 100644
> index 000000000000..4f6430bc552b
> --- /dev/null
> +++ b/Documentation/arch-features.txt
> @@ -0,0 +1,222 @@
> +
> +For generic kernel features that need architecture support, this is
> +the feature support matrix, for all upstream Linux architectures.
> +
> +Meaning of entries in the tables:
> +
> +    ' ok ': feature supported by the architecture
> +    'TODO': feature not yet supported by the architecture
> +    ' .. ': feature cannot be supported by the hardware
> +
> +
> +
> +            lockdep: LOCKDEP_SUPPORT
> +     stackprotector: HAVE_CC_STACKPROTECTOR
> +        jump labels: HAVE_ARCH_JUMP_LABEL
> +     seccomp filter: HAVE_ARCH_SECCOMP_FILTER
> +   context tracking: HAVE_CONTEXT_TRACKING
> +               kgdb: HAVE_ARCH_KGDB
> + modern timekeeping: !ARCH_USES_GETTIMEOFFSET
> +        clockevents: GENERIC_CLOCKEVENTS
> +           ELF ASLR: ARCH_HAS_ELF_RANDOMIZE
> +
> +            lockdep:---------------------------------------------------------.
> +     stackprotector:--------------------------------------------------.      |
> +        jump labels:-------------------------------------------.      |      |
> +     seccomp filter:------------------------------------.      |      |      |
> +   context tracking:-----------------------------.      |      |      |      |
> +               kgdb:----------------------.      |      |      |      |      |
> + modern timekeeping:---------------.      |      |      |      |      |      |
> +        clockevents:--------.      |      |      |      |      |      |      |
> +           ELF ASLR:-.      |      |      |      |      |      |      |      |
> +                     |      |      |      |      |      |      |      |      |
> +----------------------------------------------------------------------------------
> +  alpha           | TODO |  ok  |  ok  | TODO | TODO | TODO | TODO | TODO | TODO |
> +  arc             | TODO |  ok  |  ok  |  ok  | TODO | TODO | TODO | TODO |  ok  |
> +  arm             |  ok  |  ok  | TODO |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> +  arm64           |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> +  avr32           | TODO |  ok  |  ok  | TODO | TODO | TODO | TODO | TODO |  ok  |
> +  blackfin        | TODO |  ok  | TODO |  ok  | TODO | TODO | TODO | TODO |  ok  |
> +  c6x             | TODO |  ok  |  ok  | TODO | TODO | TODO | TODO | TODO | TODO |
> +  cris            | TODO |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +  frv             | TODO | TODO |  ok  | TODO | TODO | TODO | TODO | TODO | TODO |
> +  hexagon         | TODO |  ok  |  ok  |  ok  | TODO | TODO | TODO | TODO |  ok  |
> +  ia64            | TODO | TODO |  ok  | TODO | TODO | TODO | TODO | TODO | TODO |
> +  m32r            | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +  m68k            | TODO |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +  metag           | TODO |  ok  |  ok  | TODO | TODO | TODO | TODO | TODO |  ok  |
> +  microblaze      | TODO |  ok  |  ok  |  ok  | TODO | TODO | TODO | TODO |  ok  |
> +  mips            |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> +  mn10300         | TODO |  ok  |  ok  |  ok  | TODO | TODO | TODO | TODO | TODO |
> +  nios2           | TODO |  ok  |  ok  |  ok  | TODO | TODO | TODO | TODO | TODO |
> +  openrisc        | TODO |  ok  |  ok  | TODO | TODO | TODO | TODO | TODO | TODO |
> +  parisc          | TODO | TODO |  ok  | TODO | TODO | TODO | TODO | TODO | TODO |
> +  powerpc         |  ok  |  ok  |  ok  |  ok  |  ok  | TODO |  ok  | TODO |  ok  |
> +  s390            |  ok  |  ok  |  ok  | TODO | TODO |  ok  |  ok  | TODO |  ok  |
> +  score           | TODO |  ok  |  ok  | TODO | TODO | TODO | TODO | TODO |  ok  |
> +  sh              | TODO |  ok  |  ok  |  ok  | TODO | TODO | TODO |  ok  |  ok  |
> +  sparc           | TODO |  ok  |  ok  |  ok  |  ok  | TODO |  ok  | TODO |  ok  |
> +  tile            | TODO |  ok  |  ok  |  ok  |  ok  | TODO | TODO | TODO |  ok  |
> +  um              | TODO |  ok  |  ok  | TODO | TODO | TODO | TODO | TODO |  ok  |
> +  unicore32       | TODO |  ok  |  ok  | TODO | TODO | TODO | TODO | TODO |  ok  |
> +  x86             |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> +  xtensa          | TODO |  ok  |  ok  | TODO | TODO | TODO | TODO | TODO |  ok  |
> +----------------------------------------------------------------------------------
> +
> +
> +arch tick broadcast: ARCH_HAS_TICK_BROADCAST
> +            kprobes: HAVE_KPROBES
> +          optprobes: HAVE_OPTPROBES
> +  kprobes on ftrace: HAVE_KPROBES_ON_FTRACE
> +            uprobes: ARCH_SUPPORTS_UPROBES
> +         kretprobes: HAVE_KRETPROBES
> +  user ret profiler: HAVE_USER_RETURN_NOTIFIER
> +     ioremap_prot(): HAVE_IOREMAP_PROT
> +          tracehook: HAVE_ARCH_TRACEHOOK
> +
> +arch tick broadcast:---------------------------------------------------------.
> +            kprobes:--------------------------------------------------.      |
> +          optprobes:-------------------------------------------.      |      |
> +  kprobes on ftrace:------------------------------------.      |      |      |
> +            uprobes:-----------------------------.      |      |      |      |
> +         kretprobes:----------------------.      |      |      |      |      |
> +  user ret profiler:---------------.      |      |      |      |      |      |
> +     ioremap_prot():--------.      |      |      |      |      |      |      |
> +          tracehook:-.      |      |      |      |      |      |      |      |
> +                     |      |      |      |      |      |      |      |      |
> +----------------------------------------------------------------------------------
> +  alpha           | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +  arc             |  ok  |  ok  | TODO |  ok  | TODO | TODO | TODO |  ok  | TODO |
> +  arm             |  ok  | TODO | TODO |  ok  |  ok  | TODO |  ok  |  ok  |  ok  |
> +  arm64           |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |
> +  avr32           | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  | TODO |
> +  blackfin        |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +  c6x             |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +  cris            | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +  frv             |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +  hexagon         |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +  ia64            |  ok  | TODO | TODO |  ok  | TODO | TODO | TODO |  ok  | TODO |
> +  m32r            | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +  m68k            | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +  metag           |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +  microblaze      | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +  mips            |  ok  | TODO | TODO |  ok  | TODO | TODO | TODO |  ok  |  ok  |
> +  mn10300         |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +  nios2           |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +  openrisc        |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +  parisc          | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +  powerpc         |  ok  |  ok  | TODO |  ok  |  ok  | TODO | TODO |  ok  |  ok  |
> +  s390            |  ok  | TODO | TODO |  ok  |  ok  | TODO | TODO |  ok  | TODO |
> +  score           | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +  sh              |  ok  |  ok  | TODO |  ok  | TODO | TODO | TODO |  ok  | TODO |
> +  sparc           |  ok  | TODO | TODO |  ok  | TODO | TODO | TODO |  ok  | TODO |
> +  tile            |  ok  |  ok  |  ok  |  ok  | TODO | TODO |  ok  |  ok  | TODO |
> +  um              | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +  unicore32       | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +  x86             |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  | TODO |
> +  xtensa          | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +----------------------------------------------------------------------------------
> +
> +
> +generic idle thread: GENERIC_SMP_IDLE_THREAD
> +  dma_*map*_attrs(): HAVE_DMA_ATTRS
> +     dma contiguous: HAVE_DMA_CONTIGUOUS
> +      kprobes event: HAVE_REGS_AND_STACK_ACCESS_API
> +      dma api debug: HAVE_DMA_API_DEBUG
> +          perf regs: HAVE_PERF_REGS
> +     perf stackdump: HAVE_PERF_USER_STACK_DUMP
> +      cmpxchg local: HAVE_CMPXCHG_LOCAL
> +       virt cpuacct: HAVE_VIRT_CPU_ACCOUNTING || 64BIT
> +
> +generic idle thread:---------------------------------------------------------.
> +  dma_*map*_attrs():--------------------------------------------------.      |
> +     dma contiguous:-------------------------------------------.      |      |
> +      kprobes event:------------------------------------.      |      |      |
> +      dma api debug:-----------------------------.      |      |      |      |
> +          perf regs:----------------------.      |      |      |      |      |
> +     perf stackdump:---------------.      |      |      |      |      |      |
> +      cmpxchg local:--------.      |      |      |      |      |      |      |
> +       virt cpuacct:-.      |      |      |      |      |      |      |      |
> +                     |      |      |      |      |      |      |      |      |
> +----------------------------------------------------------------------------------
> +  alpha           |  ok  | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |  ok  |
> +  arc             | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |
> +  arm             |  ok  | TODO |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> +  arm64           |  ok  | TODO |  ok  |  ok  |  ok  | TODO |  ok  |  ok  |  ok  |
> +  avr32           | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +  blackfin        | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |
> +  c6x             | TODO | TODO | TODO | TODO |  ok  | TODO | TODO | TODO | TODO |
> +  cris            | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +  frv             | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +  hexagon         | TODO | TODO | TODO | TODO | TODO |  ok  | TODO |  ok  |  ok  |
> +  ia64            |  ok  | TODO | TODO | TODO |  ok  | TODO | TODO |  ok  |  ok  |
> +  m32r            | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +  m68k            | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +  metag           | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |
> +  microblaze      | TODO | TODO | TODO | TODO |  ok  | TODO | TODO |  ok  | TODO |
> +  mips            |  ok  | TODO | TODO | TODO |  ok  | TODO |  ok  |  ok  |  ok  |
> +  mn10300         | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +  nios2           | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +  openrisc        | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  | TODO |
> +  parisc          |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |
> +  powerpc         |  ok  | TODO | TODO | TODO |  ok  |  ok  | TODO |  ok  |  ok  |
> +  s390            |  ok  |  ok  | TODO | TODO |  ok  |  ok  | TODO |  ok  |  ok  |
> +  score           | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +  sh              | TODO | TODO | TODO | TODO |  ok  |  ok  | TODO |  ok  |  ok  |
> +  sparc           |  ok  | TODO | TODO | TODO |  ok  | TODO | TODO |  ok  |  ok  |
> +  tile            |  ok  | TODO | TODO | TODO |  ok  |  ok  | TODO |  ok  | TODO |
> +  um              | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +  unicore32       | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  | TODO |
> +  x86             |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> +  xtensa          | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |
> +----------------------------------------------------------------------------------
> +
> +
> +      irq time acct: HAVE_IRQ_TIME_ACCOUNTING
> +                THP: HAVE_ARCH_TRANSPARENT_HUGEPAGE && 64BIT
> +   gcov profile all: ARCH_HAS_GCOV_PROFILE_ALL
> +    rwsem optimized: Optimized asm/rwsem.h
> +   queued spinlocks: ARCH_USE_QUEUED_SPINLOCKS
> +     queued rwlocks: ARCH_USE_QUEUED_RWLOCKS
> +     numa balancing: ARCH_SUPPORTS_NUMA_BALANCING && 64BIT && NUMA
> +
> +      irq time acct:-------------------------------------------.
> +                THP:------------------------------------.      |
> +   gcov profile all:-----------------------------.      |      |
> +    rwsem optimized:----------------------.      |      |      |
> +   queued spinlocks:---------------.      |      |      |      |
> +     queued rwlocks:--------.      |      |      |      |      |
> +     numa balancing:-.      |      |      |      |      |      |
> +                     |      |      |      |      |      |      |
> +--------------------------------------------------------------------
> +  alpha           | TODO | TODO | TODO |  ok  | TODO | TODO | TODO |
> +  arc             |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
> +  arm             |  ..  | TODO | TODO | TODO |  ok  |  ok  |  ok  |
> +  arm64           |  ..  | TODO | TODO | TODO |  ok  |  ok  | TODO |
> +  avr32           |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
> +  blackfin        |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
> +  c6x             |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
> +  cris            |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
> +  frv             |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
> +  hexagon         |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
> +  ia64            | TODO | TODO | TODO |  ok  | TODO | TODO | TODO |
> +  m32r            |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
> +  m68k            |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
> +  metag           |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
> +  microblaze      |  ..  | TODO | TODO | TODO |  ok  |  ..  | TODO |
> +  mips            | TODO | TODO | TODO | TODO | TODO |  ok  |  ok  |
> +  mn10300         |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
> +  nios2           |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
> +  openrisc        |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
> +  parisc          |  ..  | TODO | TODO | TODO | TODO | TODO | TODO |
> +  powerpc         |  ok  | TODO | TODO | TODO |  ok  |  ok  | TODO |
> +  s390            |  ..  | TODO | TODO |  ok  |  ok  |  ok  | TODO |
> +  score           |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
> +  sh              |  ..  | TODO | TODO |  ok  |  ok  |  ..  | TODO |
> +  sparc           | TODO | TODO | TODO |  ok  | TODO |  ok  | TODO |
> +  tile            | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
> +  um              |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
> +  unicore32       |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
> +  x86             |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> +  xtensa          |  ..  | TODO | TODO |  ok  | TODO |  ..  |  ok  |
> +--------------------------------------------------------------------
