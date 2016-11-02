From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH] mm: only enable sys_pkey* when ARCH_HAS_PKEYS
Date: Wed, 2 Nov 2016 12:15:50 -0700
Message-ID: <c716d515-409f-4092-73d2-1a81db6c1ba3@linux.intel.com>
References: <1477958904-9903-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1477958904-9903-1-git-send-email-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Russell King <rmk+kernel@armlinux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org, torvalds@linux-foundation.org
List-Id: linux-api@vger.kernel.org

On 10/31/2016 05:08 PM, Mark Rutland wrote:
> When an architecture does not select CONFIG_ARCH_HAS_PKEYS, the pkey_alloc
> syscall will return -ENOSPC for all (otherwise well-formed) requests, as the
> generic implementation of mm_pkey_alloc() returns -1. The other pkey syscalls
> perform some work before always failing, in a similar fashion.
> 
> This implies the absence of keys, but otherwise functional pkey support. This
> is odd, since the architecture provides no such support. Instead, it would be
> preferable to indicate that the syscall is not implemented, since this is
> effectively the case.

This makes the behavior of an x86 cpu without pkeys and an arm cpu
without pkeys differ.  Is that what we want?  An application that
_wants_ to use protection keys but can't needs to handle -ENOSPC anyway.

On an architecture that will never support pkeys, it makes sense to do
-ENOSYS, but that's not the case for arm, right?
