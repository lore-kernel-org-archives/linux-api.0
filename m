From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 09/13] Move bp_type_idx to kernel/event/hw_breakpoint.c
Date: Thu, 24 Sep 2015 14:15:25 +0200
Message-ID: <20150924121524.GA6050@lerouge>
References: <1441832902-28993-1-git-send-email-palmer@dabbelt.com>
 <1442271047-4908-10-git-send-email-palmer@dabbelt.com>
 <20150915080607.GW16853@twins.programming.kicks-ass.net>
 <2023922.x7a6gQp0x7@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2023922.x7a6gQp0x7@wuerfel>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Zijlstra <peterz@infradead.org>, mathieu.desnoyers@efficios.com, Palmer Dabbelt <palmer@dabbelt.com>, dhowells@redhat.com, viro@zeniv.linux.org.uk, ast@plumgrid.com, aishchuk@linux.vnet.ibm.com, aarcange@redhat.com, akpm@linux-foundation.org, luto@kernel.org, acme@kernel.org, bhe@redhat.com, 3chas3@gmail.com, chris@zankel.net, dave@sr71.net, dyoung@redhat.com, drysdale@google.com, davem@davemloft.net, ebiederm@xmission.com, geoff@infradead.org, gregkh@linuxfoundation.org, hpa@zytor.com, mingo@kernel.org, iulia.manda21@gmail.com, plagnioj@jcrosoft.com, jikos@kernel.org, josh@joshtriplett.org, kexec@lists.infradead.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, jcmvbkbc@gmail.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de, tomi.valkeinen@ti.com, vgoyal@redhat.com, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Sep 15, 2015 at 11:15:29PM +0200, Arnd Bergmann wrote:
> On Tuesday 15 September 2015 10:06:07 Peter Zijlstra wrote:
> > > diff --git a/include/uapi/linux/hw_breakpoint.h b/include/uapi/linux/hw_breakpoint.h
> > > index b04000a2296a..7a6a5a7f9511 100644
> > > --- a/include/uapi/linux/hw_breakpoint.h
> > > +++ b/include/uapi/linux/hw_breakpoint.h
> > > @@ -17,14 +17,4 @@ enum {
> > >       HW_BREAKPOINT_INVALID   = HW_BREAKPOINT_RW | HW_BREAKPOINT_X,
> > >  };
> > >  
> > > -enum bp_type_idx {
> > > -     TYPE_INST       = 0,
> > > -#ifdef CONFIG_HAVE_MIXED_BREAKPOINTS_REGS
> > > -     TYPE_DATA       = 0,
> > > -#else
> > > -     TYPE_DATA       = 1,
> > > -#endif
> > > -     TYPE_MAX
> > > -};
> > 
> > This is rather unfortunate; you are correct that the naming is too
> > generic (and I tend to agree), but I think these values are required by
> > userspace to fill out:
> > 
> >   perf_event_attr::bp_type
> > 
> > So removing them will break things.
> > 
> > Frederic?
> 
> If user space actually relies on the definition from this header file,
> then it will use the wrong one on x86 and get 'TYPE_DATA = 1', while the
> kernel uses 'TYPE_DATA = 0'.
> 
> That seems unlikely to work, so I suspect it gets a different definition.
> If it uses this definition and it does work, we can probably use
> 
> #if defined(__KERNEL__) && defined(CONFIG_HAVE_MIXED_BREAKPOINTS_REGS)
> 
> but that requires a comment explaining exactly why that works.

I think this TYPE_DATA/TYPE_INST can be safely removed from uapi. This is only
about internal kernel code. Userspace only relies on HW_BREAKPOINT_[R/W/X]
to tell about the nature of the breakpoint.

If userspace ever relies on it, which I have no idea why, it even needs to define
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS. No really there shouldn't be any user of that outside
the kernel.

Thanks.

> 
> 	Arnd
