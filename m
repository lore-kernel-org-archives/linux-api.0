From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [RFC][v7][PATCH 8/9]: Define clone2() syscall
Date: Wed, 30 Sep 2009 12:14:23 -0700 (PDT)
Message-ID: <alpine.LFD.2.01.0909301208410.6996@localhost.localdomain>
References: <20090924165548.GA16586@us.ibm.com> <200909301815.45211.arnd@arndb.de> <alpine.LFD.2.01.0909300925170.6996@localhost.localdomain> <200909301959.41706.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <200909301959.41706.arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, mingo-X9Un+BFzKDI@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org
List-Id: linux-api@vger.kernel.org



On Wed, 30 Sep 2009, Arnd Bergmann wrote:
> 
> Right, you still need to save all the registers from the entry code.
> I was under the wrong assumption that task_pt_regs(current)
> would give the full register set on all architectures.
> 
> However, I'd still hope that a new system call can be defined in
> a way that you only need to have an assembly wrapper to save
> the full pt_regs, but no arch specific code to get the syscall arguments
> out of that again. In do_clone(), you need a pointer to pt_regs and
> the user stack pointer, but that can be generated from
> user_stack_pointer(regs).

I don't think it can. You don't know what the system call stack layout is. 

> Does task_pt_regs(current) give the right pointer on all architectures
> or do we also need to pass the regs into the syscall?

I do not believe that it gives the right pointer in general. In fact, I 
can guarantee it doesn't. Even on x86 it only works for certain contexts 
(non-vm86 mode at a minimum), and on architectures like alpha it's not at 
all sufficient, because even if you can locate the 'pt_regs' structure, 
you _also_ need the extra guarantees of the pt_regs being next to the 
extended signal state register structure - and that only happens for magic 
sequences like signal handling and explicit setups like fork/clone.

So I do repeat: if you think you can do all of this in generic code, then 
you're sadly and totally mistaken. Don't even try. It may work on some 
architectures, but it's simply fundamentally _wrong_.

		Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
