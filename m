From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2] Documentation/arch: Add kernel feature descriptions
 and arch support status under Documentation/features/
Date: Fri, 15 May 2015 11:37:50 +0200
Message-ID: <20150515093750.GA4665@gmail.com>
References: <20150513094622.GC11030@gmail.com>
 <20150513094756.GD11030@gmail.com>
 <20150513131835.GJ1517@pd.tnic>
 <20150513134842.GA1657@gmail.com>
 <20150513162757.GA21894@x>
 <20150513150523.ddd65d7cd51f820b78f0c8e3@linux-foundation.org>
 <20150514101518.GA27550@gmail.com>
 <20150514103544.GA7027@gmail.com>
 <20150514123835.1bf436bc35d711f8dbf9bc0f@linux-foundation.org>
 <20150514195925.GA27570@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150514195925.GA27570@gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josh Triplett <josh@joshtriplett.org>, Borislav Petkov <bp@alien8.de>, Jonathan Corbet <corbet@lwn.net>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> > > This directory structure can be used in the future to add other 
> > > files - such as porting guides, testing description, etc.
> > 
> > I suppose so.  Having a great bunch of directories, each 
> > containing a single file is a bit odd.
> 
> It's a starting point and nicely extensible. I was thinking about 
> one more intermediate level:
> 
>    Documentation/features/locking/lockdep/
>    Documentation/features/locking/rwsem-optimized/
>    Documentation/features/locking/queued-rwlocks/
>    Documentation/features/locking/queued-spinlocks/
>    ...
> 
>    Documentation/features/vm/PG_uncached/
>    Documentation/features/vm/pmdp_splitting_flush/
>    Documentation/features/vm/pte_special/
>    ...
> 
> The advantage of this, beyond more structure, would be that I'd 
> probably move most of the Documentation/locking/*.txt files into 
> Documentation/features/locking/, for example lockdep-design.txt 
> would go into Documentation/features/locking/lockdep/.
> 
> I'd keep the hierarchy at a predictable depth though, i.e.:
> 
>    Documentation/features/<subsystem>/<feature_name>/

So I've implemented this, the high level structure now looks like 
this:

 triton:~/tip/Documentation/features> ls -l
 total 48
 -rw-rw-r--  1 mingo mingo  396 May 15 11:26 arch-support.txt
 drwxrwxr-x  6 mingo mingo 4096 May 15 11:26 core
 drwxrwxr-x 12 mingo mingo 4096 May 15 11:26 debug
 drwxrwxr-x  6 mingo mingo 4096 May 15 11:26 io
 drwxrwxr-x  3 mingo mingo 4096 May 15 11:26 lib
 -rwxrwxr-x  1 mingo mingo  692 May 15 11:31 list-arch.sh
 drwxrwxr-x  7 mingo mingo 4096 May 15 11:26 locking
 drwxrwxr-x  5 mingo mingo 4096 May 15 11:26 perf
 drwxrwxr-x  3 mingo mingo 4096 May 15 11:26 sched
 drwxrwxr-x  3 mingo mingo 4096 May 15 11:26 seccomp
 drwxrwxr-x  8 mingo mingo 4096 May 15 11:26 time
 drwxrwxr-x 10 mingo mingo 4096 May 15 11:26 vm
 triton:~/tip/Documentation/features> 

 triton:~/tip/Documentation/features> ls -l locking/
 total 20
 drwxrwxr-x 2 mingo mingo 4096 May 15 11:26 cmpxchg-local
 drwxrwxr-x 2 mingo mingo 4096 May 15 11:26 lockdep
 drwxrwxr-x 2 mingo mingo 4096 May 15 11:26 queued-rwlocks
 drwxrwxr-x 2 mingo mingo 4096 May 15 11:26 queued-spinlocks
 drwxrwxr-x 2 mingo mingo 4096 May 15 11:26 rwsem-optimized

 triton:~/tip/Documentation/features> ls -l vm/
 total 32
 drwxrwxr-x 2 mingo mingo 4096 May 15 11:26 ELF-ASLR
 drwxrwxr-x 2 mingo mingo 4096 May 15 11:26 huge-vmap
 drwxrwxr-x 2 mingo mingo 4096 May 15 11:26 ioremap_prot
 drwxrwxr-x 2 mingo mingo 4096 May 15 11:26 numa-memblock
 drwxrwxr-x 2 mingo mingo 4096 May 15 11:26 PG_uncached
 drwxrwxr-x 2 mingo mingo 4096 May 15 11:26 pmdp_splitting_flush
 drwxrwxr-x 2 mingo mingo 4096 May 15 11:26 pte_special
 drwxrwxr-x 2 mingo mingo 4096 May 15 11:26 THP

And this structure, beyond making it easier to navigate, can be 
utilized to improve the visualization output as well:

 triton:~/tip/Documentation/features> ./list-arch.sh
 #
 # Kernel feature support matrix of the 'x86' architecture:
 #
      core/ BPF-JIT              :  ok  |                        HAVE_BPF_JIT #  arch supports BPF JIT optimizations
      core/ generic-idle-thread  :  ok  |             GENERIC_SMP_IDLE_THREAD #  arch makes use of the generic SMP idle thread facility
      core/ jump-labels          :  ok  |                HAVE_ARCH_JUMP_LABEL #  arch supports live patched, high efficiency branches
      core/ tracehook            :  ok  |                 HAVE_ARCH_TRACEHOOK #  arch supports tracehook (ptrace) register handling APIs
     debug/ gcov-profile-all     :  ok  |           ARCH_HAS_GCOV_PROFILE_ALL #  arch supports whole-kernel GCOV code coverage profiling
     debug/ KASAN                :  ok  |                     HAVE_ARCH_KASAN #  arch supports the KASAN runtime memory checker
     debug/ kgdb                 :  ok  |                      HAVE_ARCH_KGDB #  arch supports the kGDB kernel debugger
     debug/ kprobes              :  ok  |                        HAVE_KPROBES #  arch supports live patched kernel probe
     debug/ kprobes-on-ftrace    :  ok  |              HAVE_KPROBES_ON_FTRACE #  arch supports combined kprobes and ftrace live patching
     debug/ kretprobes           :  ok  |                     HAVE_KRETPROBES #  arch supports kernel function-return probes
     debug/ optprobes            :  ok  |                      HAVE_OPTPROBES #  arch supports live patched optprobes
     debug/ stackprotector       :  ok  |              HAVE_CC_STACKPROTECTOR #  arch supports compiler driven stack overflow protection
     debug/ uprobes              :  ok  |               ARCH_SUPPORTS_UPROBES #  arch supports live patched user probes
     debug/ user-ret-profiler    :  ok  |           HAVE_USER_RETURN_NOTIFIER #  arch supports user-space return from system call profiler
        io/ dma-api-debug        :  ok  |                  HAVE_DMA_API_DEBUG #  arch supports DMA debug facilities
        io/ dma-contiguous       :  ok  |                 HAVE_DMA_CONTIGUOUS #  arch supports the DMA CMA (continuous memory allocator)
        io/ dma_map_attrs        :  ok  |                      HAVE_DMA_ATTRS #  arch provides dma_*map*_attrs() APIs
        io/ sg-chain             :  ok  |                   ARCH_HAS_SG_CHAIN #  arch supports chained scatter-gather lists
       lib/ strncasecmp          : TODO |             __HAVE_ARCH_STRNCASECMP #  arch provides an optimized strncasecmp() function
   locking/ cmpxchg-local        :  ok  |                  HAVE_CMPXCHG_LOCAL #  arch supports the this_cpu_cmpxchg() API
   locking/ lockdep              :  ok  |                     LOCKDEP_SUPPORT #  arch supports the runtime locking correctness debug facility
   locking/ queued-rwlocks       :  ok  |             ARCH_USE_QUEUED_RWLOCKS #  arch supports queued rwlocks
   locking/ queued-spinlocks     :  ok  |           ARCH_USE_QUEUED_SPINLOCKS #  arch supports queued spinlocks
   locking/ rwsem-optimized      :  ok  |               Optimized asm/rwsem.h #  arch provides optimized rwsem APIs
      perf/ kprobes-event        :  ok  |      HAVE_REGS_AND_STACK_ACCESS_API #  arch supports kprobes with perf events
      perf/ perf-regs            :  ok  |                      HAVE_PERF_REGS #  arch supports perf events register access
      perf/ perf-stackdump       :  ok  |           HAVE_PERF_USER_STACK_DUMP #  arch supports perf events stack dumps
     sched/ numa-balancing       :  ok  |        ARCH_SUPPORTS_NUMA_BALANCING #  arch supports NUMA balancing
   seccomp/ seccomp-filter       :  ok  |            HAVE_ARCH_SECCOMP_FILTER #  arch supports seccomp filters
      time/ arch-tick-broadcast  : TODO |             ARCH_HAS_TICK_BROADCAST #  arch provides tick_broadcast()
      time/ clockevents          :  ok  |                 GENERIC_CLOCKEVENTS #  arch support generic clock events
      time/ context-tracking     :  ok  |               HAVE_CONTEXT_TRACKING #  arch supports context tracking for NO_HZ_FULL
      time/ irq-time-acct        :  ok  |            HAVE_IRQ_TIME_ACCOUNTING #  arch supports precise IRQ time accounting
      time/ modern-timekeeping   :  ok  |            !ARCH_USES_GETTIMEOFFSET #  arch does not use arch_gettimeoffset() anymore
      time/ virt-cpuacct         :  ok  |            HAVE_VIRT_CPU_ACCOUNTING #  arch supports precise virtual CPU time accounting
        vm/ ELF-ASLR             :  ok  |              ARCH_HAS_ELF_RANDOMIZE #  arch randomizes the stack, heap and binary images of ELF binaries
        vm/ huge-vmap            :  ok  |                 HAVE_ARCH_HUGE_VMAP #  arch supports the ioremap_pud_enabled() and ioremap_pmd_enabled() VM APIs
        vm/ ioremap_prot         :  ok  |                   HAVE_IOREMAP_PROT #  arch has ioremap_prot()
        vm/ numa-memblock        :  ok  |              HAVE_MEMBLOCK_NODE_MAP #  arch supports NUMA aware memblocks
        vm/ PG_uncached          :  ok  |               ARCH_USES_PG_UNCACHED #  arch supports the PG_uncached page flag
        vm/ pmdp_splitting_flush :  ok  |    __HAVE_ARCH_PMDP_SPLITTING_FLUSH #  arch supports the pmdp_splitting_flush() VM API
        vm/ pte_special          :  ok  |             __HAVE_ARCH_PTE_SPECIAL #  arch supports the pte_special()/pte_mkspecial() VM APIs
        vm/ THP                  :  ok  |      HAVE_ARCH_TRANSPARENT_HUGEPAGE #  arch supports transparent hugepages

See the first column, the subsystem prefixes - this organizes the 
feature list in a natural way as well, per subsystem.

Seems to work out well.

Thanks,

	Ingo
