From: Cyril Hrubis <chrubis@suse.cz>
Subject: Re: [PATCH] [RFC] Remove bdflush syscall stub
Date: Tue, 28 May 2019 13:20:23 +0200
Message-ID: <20190528112022.GA16683@rei>
References: <20190528101012.11402-1-chrubis@suse.cz>
 <mvmr28idgfu.fsf@linux-m68k.org>
 <20190528104017.GA11969@rei>
 <87ftoyg7t3.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87ftoyg7t3.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Andreas Schwab <schwab@linux-m68k.org>, lkml <linux-kernel@vger.kernel.org>, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, Michal Simek <monstr@monstr.eu>, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi!
> >> > I've tested the patch on i386. Before the patch calling bdflush() with
> >> > attempt to tune a variable returned 0 and after the patch the syscall
> >> > fails with EINVAL.
> >> 
> >> Should be ENOSYS, doesn't it?
> >
> > My bad, the LTP syscall wrapper handles ENOSYS and produces skipped
> > results based on that.
> >
> > EINVAL is what you get for not yet implemented syscalls, i.e. new
> > syscall on old kernel.
> 
> EINVAL?  Is that a bdflush-specific thing, test-specific, or is itmore
> general?
> 
> glibc has fallback paths that test for ENOSYS only.  EINVAL will be
> passed to the application, skipping fallback.  For missing system calls,
> this is not what we want.

The syscall returns ENOSYS after this change, sorry for the confusion.

-- 
Cyril Hrubis
chrubis@suse.cz
