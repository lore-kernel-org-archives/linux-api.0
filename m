From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH V4 5/6] mm: mmap: Add mmap flag to request VM_LOCKONFAULT
Date: Wed, 22 Jul 2015 18:45:29 +0300
Message-ID: <20150722154529.GA9107@node.dhcp.inet.fi>
References: <1437508781-28655-1-git-send-email-emunson@akamai.com>
 <1437508781-28655-6-git-send-email-emunson@akamai.com>
 <20150722112558.GC8630@node.dhcp.inet.fi>
 <20150722143220.GB3203@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150722143220.GB3203@akamai.com>
Sender: linux-arch-owner@vger.kernel.org
To: Eric B Munson <emunson@akamai.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Vlastimil Babka <vbabka@suse.cz>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@ezchip.com>, Guenter Roeck <linux@roeck-us.net>, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Jul 22, 2015 at 10:32:20AM -0400, Eric B Munson wrote:
> On Wed, 22 Jul 2015, Kirill A. Shutemov wrote:
> 
> > On Tue, Jul 21, 2015 at 03:59:40PM -0400, Eric B Munson wrote:
> > > The cost of faulting in all memory to be locked can be very high when
> > > working with large mappings.  If only portions of the mapping will be
> > > used this can incur a high penalty for locking.
> > > 
> > > Now that we have the new VMA flag for the locked but not present state,
> > > expose it as an mmap option like MAP_LOCKED -> VM_LOCKED.
> > 
> > What is advantage over mmap() + mlock(MLOCK_ONFAULT)?
> 
> There isn't one, it was added to maintain parity with the
> mlock(MLOCK_LOCK) -> mmap(MAP_LOCKED) set.  I think not having will lead
> to confusion because we have MAP_LOCKED so why don't we support
> LOCKONFAULT from mmap as well.

I don't think it's ia good idea to spend bits in flags unless we have a
reason for that.

BTW, you have typo on sparc: s/0x8000/0x80000/.


-- 
 Kirill A. Shutemov
