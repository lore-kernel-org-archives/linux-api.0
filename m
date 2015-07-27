From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH V5 5/7] mm: mmap: Add mmap flag to request VM_LOCKONFAULT
Date: Mon, 27 Jul 2015 10:31:29 +0300
Message-ID: <20150727073129.GE11657@node.dhcp.inet.fi>
References: <1437773325-8623-1-git-send-email-emunson@akamai.com>
 <1437773325-8623-6-git-send-email-emunson@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1437773325-8623-6-git-send-email-emunson@akamai.com>
Sender: linux-arch-owner@vger.kernel.org
To: Eric B Munson <emunson@akamai.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Vlastimil Babka <vbabka@suse.cz>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@ezchip.com>, Guenter Roeck <linux@roeck-us.net>, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jul 24, 2015 at 05:28:43PM -0400, Eric B Munson wrote:
> The cost of faulting in all memory to be locked can be very high when
> working with large mappings.  If only portions of the mapping will be
> used this can incur a high penalty for locking.
> 
> Now that we have the new VMA flag for the locked but not present state,
> expose it as an mmap option like MAP_LOCKED -> VM_LOCKED.

As I mentioned before, I don't think this interface is justified.

MAP_LOCKED has known issues[1]. The MAP_LOCKED problem is not necessary
affects MAP_LOCKONFAULT, but still.

Let's not add new interface unless it's demonstrably useful.

[1] http://lkml.kernel.org/g/20150114095019.GC4706@dhcp22.suse.cz

-- 
 Kirill A. Shutemov
