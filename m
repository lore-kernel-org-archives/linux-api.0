From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH] userfaultfd: register syscall numbers for x86 32bit and
 x86-64 64bit
Date: Fri, 31 Jul 2015 10:13:52 +0100
Message-ID: <20150731091351.GC2272@work-vm>
References: <1438270467-13324-1-git-send-email-aarcange@redhat.com>
 <20150731083130.GA24624@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150731083130.GA24624@gmail.com>
Sender: linux-next-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>, "\\\"H. Peter Anvin\\\"" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Eric B Munson <emunson@akamai.com>, Pavel Emelyanov <xemul@parallels.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-Id: linux-api@vger.kernel.org

* Ingo Molnar (mingo@kernel.org) wrote:
> 
> * Andrea Arcangeli <aarcange@redhat.com> wrote:
> 
> > This registers the official numbers of the userfaultfd syscall for x86
> > 32bit and x86-64 64bit. This registration allows to ship kernels in
> > production using these two syscall numbers for userfaultfd.
> > 
> > Acked-by: Pavel Emelyanov <xemul@parallels.com>
> > Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> > ---
> >  arch/x86/entry/syscalls/syscall_32.tbl | 1 +
> >  arch/x86/entry/syscalls/syscall_64.tbl | 1 +
> >  include/linux/syscalls.h               | 1 +
> >  kernel/sys_ni.c                        | 1 +
> >  4 files changed, 4 insertions(+)
> 
> Hm, is there consensus on the upstream desirability of this sytem call?

I hope so:
   a) It's generic enough that there's interest in using it in
      a range of projects - there's nothing QEMU specific in it.
   b) It's worked very well on the QEMU code that I wrote that uses it
      for postcopy, and has been solid doing that for many months now.
   c) I'm not aware of any suggestions for a different, generic solution
      to solve the same set of problems.
   d) It's got a good self test, that's survived heavy testing.
   e) I think Andrea has addressed all previous comments on it.

Dave

> 
> Thanks,
> 
> 	Ingo
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
