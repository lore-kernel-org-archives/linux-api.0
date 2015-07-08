From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH V3 0/5] Allow user to request memory to be locked on
 page fault
Date: Wed, 8 Jul 2015 10:00:08 -0700
Message-ID: <20150708100008.e8a000ec.akpm@linux-foundation.org>
References: <1436288623-13007-1-git-send-email-emunson@akamai.com>
	<20150707141613.f945c98279dcb71c9743d5f2@linux-foundation.org>
	<20150708132302.GB4669@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20150708132302.GB4669@akamai.com>
Sender: linux-arch-owner@vger.kernel.org
To: Eric B Munson <emunson@akamai.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, Michal Hocko <mhocko@suse.cz>, Michael Kerrisk <mtk.manpages@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 8 Jul 2015 09:23:02 -0400 Eric B Munson <emunson@akamai.com> wrote:

> > I don't know whether these syscalls should be documented via new
> > manpages, or if we should instead add them to the existing
> > mlock/munlock/mlockall manpages.  Michael, could you please advise?
> > 
> 
> Thanks for adding the series.  I owe you several updates (getting the
> new syscall right for all architectures and a set of tests for the new
> syscalls).  Would you prefer a new pair of patches or I update this set?

It doesn't matter much.  I guess a full update will be more convenient
at your end.
