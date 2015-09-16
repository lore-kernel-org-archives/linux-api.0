From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC PATCH v2 7/9] arm64: allocate sys_membarrier system call
 number
Date: Wed, 16 Sep 2015 17:39:45 +0100
Message-ID: <20150916163945.GQ28771@arm.com>
References: <1441642556-30972-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1441642556-30972-8-git-send-email-mathieu.desnoyers@efficios.com>
 <4692929.9334.1442416719904.JavaMail.zimbra@efficios.com>
 <20150916163527.GO28771@arm.com>
 <2075941251.9404.1442421484155.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2075941251.9404.1442421484155.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Sep 16, 2015 at 05:38:04PM +0100, Mathieu Desnoyers wrote:
> ----- On Sep 16, 2015, at 12:35 PM, Will Deacon will.deacon-5wv7dgnIgG8@public.gmane.org wrote:
> 
> > Hi Mathieu,
> > 
> > On Wed, Sep 16, 2015 at 04:18:39PM +0100, Mathieu Desnoyers wrote:
> >> ----- On Sep 7, 2015, at 12:15 PM, Mathieu Desnoyers
> >> mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org wrote:
> >> 
> >> > arm64 sys_membarrier number is already wired for arm64 through
> >> > asm-generic/unistd.h, but needs to be allocated separately for
> >> > the 32-bit compability layer of arm64.
> >> > 
> >> > [ Untested on this architecture. To try it out: fetch linux-next/akpm,
> >> >  apply this patch, build/run a membarrier-enabled kernel, and do make
> >> >  kselftest. ]
> >> 
> >> sys_membarrier has been merged into Linux 4.3-rc1. sys_membarrier can therefore
> >> be tested on top of Linus' master.
> > 
> > Just to say that I'm happy to merge this once arch/arm/ also has the
> > syscall wired up. It'd be a bit weird to have the support in the arm64
> > compat layer but not the arch/arm/ native kernel!
> 
> Sounds good! We're currently testing sys_membarrier on a wandboard. We'll
> provide feedback by replying to the ARM patch thread soon.

Ok. I was about to kick the selftest on my Juno board (arm64).

Will
