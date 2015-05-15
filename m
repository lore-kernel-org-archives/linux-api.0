From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] Documentation/arch: Add kernel feature descriptions
 and arch support status under Documentation/features/
Date: Fri, 15 May 2015 09:49:49 +0200
Message-ID: <20150515074949.GB14993@gmail.com>
References: <20150513094622.GC11030@gmail.com>
 <20150513094756.GD11030@gmail.com>
 <20150513131835.GJ1517@pd.tnic>
 <20150513134842.GA1657@gmail.com>
 <20150513162757.GA21894@x>
 <20150513150523.ddd65d7cd51f820b78f0c8e3@linux-foundation.org>
 <20150514101518.GA27550@gmail.com>
 <20150514103544.GA7027@gmail.com>
 <20150514123835.1bf436bc35d711f8dbf9bc0f@linux-foundation.org>
 <1431644248.2981.1.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1431644248.2981.1.camel-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


* Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org> wrote:

> On Thu, 2015-05-14 at 12:38 -0700, Andrew Morton wrote:
> > > Add arch support matrices for more than 40 generic kernel features
> > > that need per architecture support.
> > > 
> > > Each feature has its own directory under Documentation/features/feature_name/,
> > > and the arch-support.txt file shows its current arch porting status.
> > 
> > It would be nice to provide people with commit IDs to look at, but the
> > IDs won't be known at the time the documentation file is created.  We
> > could provide patch titles.
> 
> +1 on patch titles.

Ok, I'll solve this.

> > But still, let's not overdo it - get something in there, see how 
> > well it works, evolve it over time.
> > 
> > I don't think we've heard from any (non-x86) arch maintainers?  Do 
> > they consider this useful at all?  Poke.
> 
> Yes it is. I have my own version I've cobbled together for powerpc, 
> but this is much better.

Please double check the PowerPC support matrix for correctness (if you 
haven't yet):

#
# Kernel feature support matrix of architecture 'powerpc':
#
   arch-tick-broadcast:  |  ok  |                            ARCH_HAS_TICK_BROADCAST #  arch provides tick_broadcast()
               BPF-JIT:  |  ok  |                                       HAVE_BPF_JIT #  arch supports BPF JIT optimizations
           clockevents:  |  ok  |                                GENERIC_CLOCKEVENTS #  arch support generic clock events
         cmpxchg-local:  | TODO |                                 HAVE_CMPXCHG_LOCAL #  arch supports the this_cpu_cmpxchg() API
      context-tracking:  |  ok  |                              HAVE_CONTEXT_TRACKING #  arch supports context tracking for NO_HZ_FULL
         dma-api-debug:  |  ok  |                                 HAVE_DMA_API_DEBUG #  arch supports DMA debug facilities
        dma-contiguous:  | TODO |                                HAVE_DMA_CONTIGUOUS #  arch supports the DMA CMA (continuous memory allocator)
         dma_map_attrs:  |  ok  |                                     HAVE_DMA_ATTRS #  arch provides dma_*map*_attrs() APIs
              ELF-ASLR:  |  ok  |                             ARCH_HAS_ELF_RANDOMIZE #  arch randomizes the stack, heap and binary images of ELF binaries
      gcov-profile-all:  |  ok  |                          ARCH_HAS_GCOV_PROFILE_ALL #  arch supports whole-kernel GCOV code coverage profiling
   generic-idle-thread:  |  ok  |                            GENERIC_SMP_IDLE_THREAD #  arch makes use of the generic SMP idle thread facility
             huge-vmap:  | TODO |                                HAVE_ARCH_HUGE_VMAP #  arch supports the ioremap_pud_enabled() and ioremap_pmd_enabled() VM APIs
          ioremap_prot:  |  ok  |                                  HAVE_IOREMAP_PROT #  arch has ioremap_prot()
         irq-time-acct:  |  ok  |                           HAVE_IRQ_TIME_ACCOUNTING #  arch supports precise IRQ time accounting
           jump-labels:  |  ok  |                               HAVE_ARCH_JUMP_LABEL #  arch supports live patched high efficiency branches
                 KASAN:  | TODO |                                    HAVE_ARCH_KASAN #  arch supports the KASAN runtime memory checker
                  kgdb:  |  ok  |                                     HAVE_ARCH_KGDB #  arch supports the kGDB kernel debugger
               kprobes:  |  ok  |                                       HAVE_KPROBES #  arch supports live patched kernel probe
         kprobes-event:  |  ok  |                     HAVE_REGS_AND_STACK_ACCESS_API #  arch supports kprobes with perf events
     kprobes-on-ftrace:  | TODO |                             HAVE_KPROBES_ON_FTRACE #  arch supports combined kprobes and ftrace live patching
            kretprobes:  |  ok  |                                    HAVE_KRETPROBES #  arch supports kernel function-return probes
               lockdep:  |  ok  |                                    LOCKDEP_SUPPORT #  arch supports the runtime locking correctness debug facility
    modern-timekeeping:  |  ok  |                           !ARCH_USES_GETTIMEOFFSET #  arch does not use arch_gettimeoffset() anymore
        numa-balancing:  |  ok  |      ARCH_SUPPORTS_NUMA_BALANCING && 64BIT && NUMA #  arch supports NUMA balancing
         numa-memblock:  |  ok  |                             HAVE_MEMBLOCK_NODE_MAP #  arch supports NUMA aware memblocks
             optprobes:  | TODO |                                     HAVE_OPTPROBES #  arch supports live patched optprobes
             perf-regs:  | TODO |                                     HAVE_PERF_REGS #  arch supports perf events register access
        perf-stackdump:  | TODO |                          HAVE_PERF_USER_STACK_DUMP #  arch supports perf events stack dumps
           PG_uncached:  | TODO |                              ARCH_USES_PG_UNCACHED #  arch supports the PG_uncached page flag
  pmdp_splitting_flush:  |  ok  |           #define __HAVE_ARCH_PMDP_SPLITTING_FLUSH #  arch supports the pmdp_splitting_flush() VM API
           pte_special:  |  ok  |                    #define __HAVE_ARCH_PTE_SPECIAL #  arch supports the pte_special()/pte_mkspecial() VM APIs
        queued-rwlocks:  | TODO |                            ARCH_USE_QUEUED_RWLOCKS #  arch supports queued rwlocks
      queued-spinlocks:  | TODO |                          ARCH_USE_QUEUED_SPINLOCKS #  arch supports queued spinlocks
       rwsem-optimized:  |  ok  |                              Optimized asm/rwsem.h #  arch provides optimized rwsem APIs
        seccomp-filter:  | TODO |                           HAVE_ARCH_SECCOMP_FILTER #  arch supports seccomp filters
              sg-chain:  |  ok  |                                  ARCH_HAS_SG_CHAIN #  arch supports chained scatter-gather lists
        stackprotector:  | TODO |                             HAVE_CC_STACKPROTECTOR #  arch supports compiler driven stack overflow protection
           strncasecmp:  | TODO |                            __HAVE_ARCH_STRNCASECMP #  arch provides an optimized strncasecmp() function
                   THP:  |  ok  |            HAVE_ARCH_TRANSPARENT_HUGEPAGE && 64BIT #  arch supports transparent hugepages
             tracehook:  |  ok  |                                HAVE_ARCH_TRACEHOOK #  arch supports tracehook (ptrace) register handling APIs
               uprobes:  |  ok  |                              ARCH_SUPPORTS_UPROBES #  arch supports live patched user probes
     user-ret-profiler:  | TODO |                          HAVE_USER_RETURN_NOTIFIER #  arch supports user-space return from system call profiler
          virt-cpuacct:  |  ok  |                  HAVE_VIRT_CPU_ACCOUNTING || 64BIT #  arch supports precise virtual CPU time accounting


> I'd like to see more description in the individual files of what the 
> feature is, and preferably some pointers to what's needed to 
> implement it.

Yeah, so I tried to add a short description to the feature file 
itself, and for many of these features that single sentence is the 
only documentation we have in the kernel source ...

More comprehensive description can be added both to the Kconfig and to 
the feature description as well, by the maintainers of the individual 
features.

> The kconfig for HAVE_ARCH_SECCOMP_FILTER is a good example of what I 
> mean.

Yes, that's a positive example. It's the exception.

> I realise retrofitting that for all these existing features is quite 
> time consuming, but for new features hopefully the bar can be raised 
> a little in terms of that description.

Yeah.

Thanks,

	Ingo
