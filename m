From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC PATCH v6] Documentation/arch: Add
 Documentation/arch-features.txt
Date: Thu, 14 May 2015 09:08:16 +0200
Message-ID: <20150514070816.GB9347@gmail.com>
References: <20150512213843.GV21418@twins.programming.kicks-ass.net>
 <20150512144910.0b49c9a7a13336773449db33@linux-foundation.org>
 <20150513083441.GA17336@gmail.com>
 <20150513085636.GA11030@gmail.com>
 <20150513092421.GB11030@gmail.com>
 <20150513094622.GC11030@gmail.com>
 <20150513094756.GD11030@gmail.com>
 <20150513131835.GJ1517@pd.tnic>
 <20150513134842.GA1657@gmail.com>
 <20150513162757.GA21894@x>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150513162757.GA21894@x>
Sender: linux-arch-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>
Cc: Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org


* Josh Triplett <josh@joshtriplett.org> wrote:

> On Wed, May 13, 2015 at 03:48:42PM +0200, Ingo Molnar wrote:
> > From 93f6bd67b4348bf4bf27cbac8ffa9f1def4fa6aa Mon Sep 17 00:00:00 2001
> > From: Ingo Molnar <mingo@kernel.org>
> > Date: Wed, 13 May 2015 10:30:11 +0200
> > Subject: [PATCH] Documentation/arch: Add Documentation/arch-features.txt
> > 
> > Add a support matrix for various generic kernel features that need
> > architecture support.
> > 
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> 
> Could you add a column for the bpf JIT?

Added it, it now looks like this (see it in the first column):

                ...
            BPF JIT: HAVE_BPF_JIT

      irq time acct:--------------------------------------------------.
                THP:-------------------------------------------.      |
   gcov profile all:------------------------------------.      |      |
    rwsem optimized:-----------------------------.      |      |      |
   queued spinlocks:----------------------.      |      |      |      |
     queued rwlocks:---------------.      |      |      |      |      |
     numa balancing:--------.      |      |      |      |      |      |
            BPF JIT:-.      |      |      |      |      |      |      |
                     |      |      |      |      |      |      |      |
---------------------------------------------------------------------------
  alpha           | TODO | TODO | TODO | TODO |  ok  | TODO | TODO |  ok  |
  arc             | TODO |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
  arm             |  ok  |  ..  | TODO | TODO | TODO |  ok  |  ok  |  ok  |
  arm64           |  ok  |  ..  | TODO | TODO | TODO |  ok  |  ok  |  ok  |
  avr32           | TODO |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
  blackfin        | TODO |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
  c6x             | TODO |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
  cris            | TODO |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
  frv             | TODO |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
  hexagon         | TODO |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
  ia64            | TODO | TODO | TODO | TODO |  ok  | TODO | TODO |  ok  |
  m32r            | TODO |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
  m68k            | TODO |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
  metag           | TODO |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
  microblaze      | TODO |  ..  | TODO | TODO | TODO |  ok  |  ..  | TODO |
  mips            |  ok  | TODO | TODO | TODO | TODO | TODO |  ok  |  ok  |
  mn10300         | TODO |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
  nios2           | TODO |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
  openrisc        | TODO |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
  parisc          | TODO |  ..  | TODO | TODO | TODO | TODO | TODO |  ok  |
  powerpc         |  ok  |  ok  | TODO | TODO | TODO |  ok  |  ok  |  ok  |
  s390            |  ok  |  ..  | TODO | TODO |  ok  |  ok  |  ok  |  ok  |
  score           | TODO |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
  sh              | TODO |  ..  | TODO | TODO |  ok  |  ok  |  ..  | TODO |
  sparc           |  ok  | TODO | TODO | TODO |  ok  | TODO |  ok  |  ok  |
  tile            | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |
  um              | TODO |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
  unicore32       | TODO |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
  x86             |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
  xtensa          | TODO |  ..  | TODO | TODO |  ok  | TODO |  ..  |  ok  |
---------------------------------------------------------------------------

Thanks,

	Ingo
