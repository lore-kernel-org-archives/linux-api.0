From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] Documentation/arch: Add kernel feature descriptions
 and arch support status under Documentation/features/
Date: Fri, 15 May 2015 09:38:06 +0200
Message-ID: <20150515073805.GA14993@gmail.com>
References: <20150513094756.GD11030@gmail.com>
 <20150513131835.GJ1517@pd.tnic>
 <20150513134842.GA1657@gmail.com>
 <20150513162757.GA21894@x>
 <20150513150523.ddd65d7cd51f820b78f0c8e3@linux-foundation.org>
 <20150514101518.GA27550@gmail.com>
 <20150514103544.GA7027@gmail.com>
 <20150514123835.1bf436bc35d711f8dbf9bc0f@linux-foundation.org>
 <20150514195925.GA27570@gmail.com>
 <20150515083334.535ad43e@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150515083334.535ad43e-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yoshinori Sato <ysato-Rn4VEauK+AKRv+LV9MX5uooqe+aC9MnS@public.gmane.org>
List-Id: linux-api@vger.kernel.org


* Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org> wrote:

> Hi Ingo,
> 
> Thanks for this.  The concept is certainly good.
> 
> On Thu, 14 May 2015 21:59:25 +0200 Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > The patch that adds a new architecture to all these files would give 
> > us a good overview about how complete an initial port is.
> 
> If you want to test how hard that is (and what sort of patch it
> produces), the h8300 architecture was added to linux-next recently.

I tried this out, this is the resulting feature support matrix for the 
new h8300 architecture:

#
# Kernel feature support matrix of architecture 'h8300':
#
           arch-tick-broadcast:     |       h8300: | TODO |
                       BPF-JIT:     |       h8300: | TODO |
                   clockevents:     |       h8300: |  ok  |
                 cmpxchg-local:     |       h8300: | TODO |
              context-tracking:     |       h8300: | TODO |
                 dma-api-debug:     |       h8300: | TODO |
                dma-contiguous:     |       h8300: | TODO |
                 dma_map_attrs:     |       h8300: |  ok  |
                      ELF-ASLR:     |       h8300: | TODO |
              gcov-profile-all:     |       h8300: | TODO |
           generic-idle-thread:     |       h8300: | TODO |
                     huge-vmap:     |       h8300: | TODO |
                  ioremap_prot:     |       h8300: | TODO |
                 irq-time-acct:     |       h8300: | TODO |
                   jump-labels:     |       h8300: | TODO |
                         KASAN:     |       h8300: | TODO |
                          kgdb:     |       h8300: | TODO |
                       kprobes:     |       h8300: | TODO |
                 kprobes-event:     |       h8300: | TODO |
             kprobes-on-ftrace:     |       h8300: | TODO |
                    kretprobes:     |       h8300: | TODO |
                       lockdep:     |       h8300: | TODO |
            modern-timekeeping:     |       h8300: |  ok  |
                numa-balancing:     |       h8300: |  ..  |
                 numa-memblock:     |       h8300: |  ..  |
                     optprobes:     |       h8300: | TODO |
                     perf-regs:     |       h8300: | TODO |
                perf-stackdump:     |       h8300: | TODO |
                   PG_uncached:     |       h8300: | TODO |
          pmdp_splitting_flush:     |       h8300: | TODO |
                   pte_special:     |       h8300: | TODO |
                queued-rwlocks:     |       h8300: | TODO |
              queued-spinlocks:     |       h8300: | TODO |
               rwsem-optimized:     |       h8300: |  ok  |
                seccomp-filter:     |       h8300: | TODO |
                      sg-chain:     |       h8300: | TODO |
                stackprotector:     |       h8300: | TODO |
                   strncasecmp:     |       h8300: | TODO |
                           THP:     |       h8300: |  ..  |
                     tracehook:     |       h8300: | TODO |
                       uprobes:     |       h8300: | TODO |
             user-ret-profiler:     |       h8300: | TODO |
                  virt-cpuacct:     |       h8300: | TODO |

Thanks,

	Ingo
