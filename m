From: Michele Curti <michele.curti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v5] Documentation/arch: Add Documentation/arch-TODO
Date: Wed, 13 May 2015 16:09:45 +0200
Message-ID: <20150513140945.GA8376@dellaz>
References: <20150511192918.GA11361@jtriplet-mobl1>
 <20150512142250.dcb053da81855ae1b5861173@linux-foundation.org>
 <20150512213843.GV21418@twins.programming.kicks-ass.net>
 <20150512144910.0b49c9a7a13336773449db33@linux-foundation.org>
 <20150513083441.GA17336@gmail.com>
 <20150513085636.GA11030@gmail.com>
 <20150513092421.GB11030@gmail.com>
 <20150513094622.GC11030@gmail.com>
 <20150513094756.GD11030@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150513094756.GD11030-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, May 13, 2015 at 11:47:56AM +0200, Ingo Molnar wrote:
> 
> (fixed the subject.)
> 
> So this is the final version for now:
> 
>  - add a fourth table
> 
>  - fix errors in earlier tables, in particular I missed some PowerPC 
>    Kconfigs
> 
>  - introduce the '..' denotion (in the final table) to show features 
>    that cannot be supported by an architecture due to hardware 
>    dependencies:
> 
> 		   gcov-profile-all:---------------.
> 				THP:--------.      |
> 		      irq-time-acct:-.      |      |
> 				     |      |      |
> 		----------------------------------------
> 		  alpha           | TODO | TODO | TODO |
> 		  arc             | TODO |  ..  | TODO |
> 		  arm             |  ok  |  ok  |  ok  |
> 		  arm64           | TODO |  ok  |  ok  |
> 		  avr32           | TODO |  ..  | TODO |
> 		  blackfin        | TODO |  ..  | TODO |
> 		  c6x             | TODO |  ..  | TODO |
> 
>    so in the 'THP' column, if an architecture could in theory support 
>    THP, it's listed as 'TODO', if it cannot, it's listed as '..'.
> 
> Please let me know about errors in these tables, and I can also add 
> more features/facilities as well if I missed any.
> 
> Thanks,
>

Tried to transpose rows with columns, to avoid architecture name duplication
and to get only one table while keeping 80 char width, but result seems less
readable :p


                                                m                              
                                                i                         u    
                              b                 c       o                 n    
                              l       h         r   m   p   p             i    
                              a       e         o   n   e p o             c   x
                    a     a a c       x       m b   1 n n a w   s   s     o   t
                    l     r v k   c   a i m m e l m 0 i r r e s c   p t   r   e
                    p a a m r f c r f g a 3 6 t a i 3 o i i r 3 o   a i   e x n
                    h r r 6 3 i 6 i r o 6 2 8 a z p 0 s s s p 9 r s r l u 3 8 s
                    a c m 4 2 n x s v n 4 r k g e s 0 2 c c c 0 e h c e m 2 6 a
-------------------------------------------------------------------------------
            lockdep T K K K K K T T T K T T T K K K T T T T K K K K K K K K K K
     stackprotector T T K K T T T T T T T T T T T K T T T T T T T K T T T T K T
        jump-labels T T K K T T T T T T T T T T T K T T T T K K T T K T T T K T
     seccomp-filter T T K K T T T T T T T T T T T K T T T T T K T T T T T T K T
   context-tracking T T K K T T T T T T T T T T T K T T T T K T T T K K T T K T
               kgdb T K K K T K T T T K T T T T K K K K T T K T T K K K T T K T
 modern-timekeeping K K T K K T K T K K K T T K K K K K K K K K K K K K K K K K
        clockevents K K K K K K K K T K T T K K K K K K K T K K K K K K K K K K
           ELF-ASLR T T K K T T T T T T T T T T T K T T T T K K T T T T T T K T
arch-tick-broadcast T T K K T T T T T T T T T T T K T T T T K T T T T T T T T T
            kprobes T K K T K T T T T T K T T T T K T T T T K K T K K K T T K T
          optprobes T T K T T T T T T T T T T T T T T T T T T T T T T K T T K T
  kprobes-on-ftrace T T T T T T T T T T T T T T T T T T T T T T T T T T T T K T
            uprobes T T K T T T T T T T T T T T T T T T T T K K T T T T T T K T
         kretprobes T K K T T T T T T T K T T T T K T T T T K K T K K K T T K T
  user-ret-profiler T T T T T T T T T T T T T T T T T T T T T T T T T K T T K T
     ioremap_prot() T K T T T T T T T T T T T T T T T T T T K T T K T K T T K T
          tracehook T K K K T K K T K K K T T K T K K K K T K K T K K K T T K T
generic-idle-thread K K K K T K T T T K K T T K T K T T T K K K T K K T T T K K
  dma_*map*_attrs() K T K K T T T T T K K T T T K K T T K T K K T K K K T K K T
     dma-contiguous T T K K T T T T T T T T T T T K T T T T T T T T T T T T K T
      kprobes-event T T K T T T T T T K T T T T T T T T T T K K T K T K T T K T
      dma-api-debug T T K K T T K T T T K T T T K K T T T T K K T K K K T T K T
          perf-regs T T K K T T T T T T T T T T T T T T T T T T T T T T T T K T
     perf-stackdump T T K K T T T T T T T T T T T T T T T T T T T T T T T T K T
      cmpxchg-local T T T T T T T T T T T T T T T T T T T T T K T T T T T T K T
       virt-cpuacct K T K K T T T T T T K T T T T K T T T K K K T T K K T T K T
      irq-time-acct T T K T T T T T T T T T T T T K T T T T T T T T T T T T K K
                THP T - K K - - - - - - T - - - - K - - - T K K - - K T - - K -
   gcov-profile-all T T K K T T T T T T T T T T K T T T T T K K T K T T T T K T

Legend:
    K = ok
    T = TODO
    - = cannot

Michele
