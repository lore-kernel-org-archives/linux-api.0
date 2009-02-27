From: Greg Kurz <gkurz-NmTC/0ZBporQT0dZR+AlfA@public.gmane.org>
Subject: Re: How much of a mess does OpenVZ make? ;) Was: What can OpenVZ
 do?
Date: Fri, 27 Feb 2009 10:19:09 +0100
Message-ID: <1235726349.4570.7.camel@bahia>
References: <20090211141434.dfa1d079.akpm@linux-foundation.org>
	 <1234462282.30155.171.camel@nimitz> <1234467035.3243.538.camel@calx>
	 <20090212114207.e1c2de82.akpm@linux-foundation.org>
	 <1234475483.30155.194.camel@nimitz>
	 <20090212141014.2cd3d54d.akpm@linux-foundation.org>
	 <1234479845.30155.220.camel@nimitz>
	 <20090226162755.GB1456@x200.localdomain> <20090226173302.GB29439@elte.hu>
	 <1235673016.5877.62.camel@bahia>  <20090226221709.GA2924@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090226221709.GA2924-2ev+ksY9ol182hYKe6nXyg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 2009-02-27 at 01:17 +0300, Alexey Dobriyan wrote:
> On Thu, Feb 26, 2009 at 07:30:16PM +0100, Greg Kurz wrote:
> > On Thu, 2009-02-26 at 18:33 +0100, Ingo Molnar wrote:
> > > I think the main question is: will we ever find ourselves in the 
> > > future saying that "C/R sucks, nobody but a small minority uses 
> > > it, wish we had never merged it"? I think the likelyhood of that 
> > > is very low. I think the current OpenVZ stuff already looks very 
> > 
> > We've been maintaining for some years now a C/R middleware with only a
> > few hooks in the kernel. Our strategy is to leverage existing kernel
> > paths as they do most of the work right.
> > 
> > Most of the checkpoint is performed from userspace, using regular
> > syscalls in a signal handler or /proc parsing. Restart is a bit trickier
> > and needs some kernel support to bypass syscall checks and enforce a
> > specific id for a resource. At the end, we support C/R and live
> > migration of networking apps (websphere application server for example).
> > 
> > >From our experience, we can tell:
> > 
> > Pros: mostly not-so-tricky userland code, independent from kernel
> > internals
> > Cons: sub-optimal for some resources
> 
> How do you restore struct task_struct::did_exec ?

With sys_execve().

-- 
Gregory Kurz                                     gkurz-NmTC/0ZBporQT0dZR+AlfA@public.gmane.org
Software Engineer @ IBM/Meiosys                  http://www.ibm.com
Tel +33 (0)534 638 479                           Fax +33 (0)561 400 420

"Anarchy is about taking complete responsibility for yourself."
        Alan Moore.

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
