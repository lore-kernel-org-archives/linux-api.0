From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] mm: only enable sys_pkey* when ARCH_HAS_PKEYS
Date: Tue, 8 Nov 2016 10:30:42 +0100
Message-ID: <20161108093042.GC3528@osiris>
References: <1477958904-9903-1-git-send-email-mark.rutland@arm.com>
 <c716d515-409f-4092-73d2-1a81db6c1ba3@linux.intel.com>
 <20161104234459.GA18760@remoulade>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161104234459.GA18760@remoulade>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Russell King <rmk+kernel@armlinux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org, torvalds@linux-foundation.org
List-Id: linux-api@vger.kernel.org

On Fri, Nov 04, 2016 at 11:44:59PM +0000, Mark Rutland wrote:
> On Wed, Nov 02, 2016 at 12:15:50PM -0700, Dave Hansen wrote:
> > On 10/31/2016 05:08 PM, Mark Rutland wrote:
> > > When an architecture does not select CONFIG_ARCH_HAS_PKEYS, the pkey_alloc
> > > syscall will return -ENOSPC for all (otherwise well-formed) requests, as the
> > > generic implementation of mm_pkey_alloc() returns -1. The other pkey syscalls
> > > perform some work before always failing, in a similar fashion.
> > > 
> > > This implies the absence of keys, but otherwise functional pkey support. This
> > > is odd, since the architecture provides no such support. Instead, it would be
> > > preferable to indicate that the syscall is not implemented, since this is
> > > effectively the case.
> > 
> > This makes the behavior of an x86 cpu without pkeys and an arm cpu
> > without pkeys differ.  Is that what we want?
> 
> My rationale was that we have no idea whether architectures will have pkey
> support in future, and if/when they do, we may have to apply additional checks
> anyhow. i.e. in cases we'd return -ENOSPC today, we might want to return
> another error code.
> 
> Returning -ENOSYS retains the current behaviour, and allows us to handle that
> ABI issue when we know what architecture support looks like.
> 
> Other architectures not using the generic syscalls seem to handle this with
> -ENOSYS, e.g. parisc with commit 18088db042dd9ae2, so there's differing
> behaviour regardless of arm specifically.

The three system calls won't return -ENOSYS on architectures which decided
to ignore them (like with with above mentioned commit), since they haven't
allocated a system call number at all.

Right now we have one architecture where these three system calls work if
the cpu supports the feature (x86).

Two architectures (arm, mips) have wired them up and thus allocated system
call numbers, even though they don't have ARCH_HAS_PKEYS set. Which seems a
bit pointless.

Three architectures (parisc, powerpc, s390) decided to ignore the system
calls completely, but still have the pkey code linked into the kernel
image.

imho the generic pkey code should be ifdef'ed with CONFIG_ARCH_HAS_PKEYS.
Otherwise only dead code will be linked and increase the kernel image size
for no good reason.
