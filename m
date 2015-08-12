From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v7 3/6] mm: Introduce VM_LOCKONFAULT
Date: Wed, 12 Aug 2015 13:59:09 +0200
Message-ID: <20150812115909.GA5182@dhcp22.suse.cz>
References: <1439097776-27695-1-git-send-email-emunson@akamai.com>
 <1439097776-27695-4-git-send-email-emunson@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1439097776-27695-4-git-send-email-emunson@akamai.com>
Sender: owner-linux-mm@kvack.org
To: Eric B Munson <emunson@akamai.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, Jonathan Corbet <corbet@lwn.net>, "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sun 09-08-15 01:22:53, Eric B Munson wrote:
> The cost of faulting in all memory to be locked can be very high when
> working with large mappings.  If only portions of the mapping will be
> used this can incur a high penalty for locking.
> 
> For the example of a large file, this is the usage pattern for a large
> statical language model (probably applies to other statical or graphical
> models as well).  For the security example, any application transacting
> in data that cannot be swapped out (credit card data, medical records,
> etc).
> 
> This patch introduces the ability to request that pages are not
> pre-faulted, but are placed on the unevictable LRU when they are finally
> faulted in.  The VM_LOCKONFAULT flag will be used together with
> VM_LOCKED and has no effect when set without VM_LOCKED.

I do not like this very much to be honest. We have only few bits
left there and it seems this is not really necessary. I thought that
LOCKONFAULT acts as a modifier to the mlock call to tell whether to
poppulate or not. The only place we have to persist it is
mlockall(MCL_FUTURE) AFAICS. And this can be handled by an additional
field in the mm_struct. This could be handled at __mm_populate level.
So unless I am missing something this would be much more easier
in the end we no new bit in VM flags would be necessary.

This would obviously mean that the LOCKONFAULT couldn't be exported to
the userspace but is this really necessary?
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
