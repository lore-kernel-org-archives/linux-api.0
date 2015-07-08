From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH V3 3/5] mm: mlock: Introduce VM_LOCKONFAULT and add
 mlock flags to enable it
Date: Wed, 8 Jul 2015 13:23:51 -0600
Message-ID: <20150708132351.61c13db6@lwn.net>
References: <1436288623-13007-1-git-send-email-emunson@akamai.com>
	<1436288623-13007-4-git-send-email-emunson@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1436288623-13007-4-git-send-email-emunson@akamai.com>
Sender: linux-arch-owner@vger.kernel.org
To: Eric B Munson <emunson@akamai.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Vlastimil Babka <vbabka@suse.cz>, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue,  7 Jul 2015 13:03:41 -0400
Eric B Munson <emunson@akamai.com> wrote:

> This patch introduces the ability to request that pages are not
> pre-faulted, but are placed on the unevictable LRU when they are finally
> faulted in.  This can be done area at a time via the
> mlock2(MLOCK_ONFAULT) or the mlockall(MCL_ONFAULT) system calls.  These
> calls can be undone via munlock2(MLOCK_ONFAULT) or
> munlockall2(MCL_ONFAULT).

Quick, possibly dumb question: I've been beating my head against these for
a little bit, and I can't figure out what's supposed to happen in this
case:

	mlock2(addr, len, MLOCK_ONFAULT);
	munlock2(addr, len, MLOCK_LOCKED);

It looks to me like it will clear VM_LOCKED without actually unlocking any
pages.  Is that the intended result?

Thanks,

jon
