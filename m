From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [RFC PATCH 1/1] mm/mremap: add MREMAP_MIRROR flag for existing
 mirroring functionality
Date: Fri, 7 Jul 2017 20:45:34 +0300
Message-ID: <20170707174534.wdfbciyfpovi52dy@node.shutemov.name>
References: <1499357846-7481-1-git-send-email-mike.kravetz@oracle.com>
 <1499357846-7481-2-git-send-email-mike.kravetz@oracle.com>
 <20170707102324.kfihkf72sjcrtn5b@node.shutemov.name>
 <e328ff6a-2c4b-ec26-cc28-e24b7b35a463@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <e328ff6a-2c4b-ec26-cc28-e24b7b35a463@oracle.com>
Sender: owner-linux-mm@kvack.org
To: Mike Kravetz <mike.kravetz@oracle.com>
Cc: linux-mm@kvack.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Andrea Arcangeli <aarcange@redhat.com>, Michal Hocko <mhocko@suse.com>, Aaron Lu <aaron.lu@intel.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 07, 2017 at 10:29:52AM -0700, Mike Kravetz wrote:
> On 07/07/2017 03:23 AM, Kirill A. Shutemov wrote:
> > On Thu, Jul 06, 2017 at 09:17:26AM -0700, Mike Kravetz wrote:
> >> The mremap system call has the ability to 'mirror' parts of an existing
> >> mapping.  To do so, it creates a new mapping that maps the same pages as
> >> the original mapping, just at a different virtual address.  This
> >> functionality has existed since at least the 2.6 kernel.
> >>
> >> This patch simply adds a new flag to mremap which will make this
> >> functionality part of the API.  It maintains backward compatibility with
> >> the existing way of requesting mirroring (old_size == 0).
> >>
> >> If this new MREMAP_MIRROR flag is specified, then new_size must equal
> >> old_size.  In addition, the MREMAP_MAYMOVE flag must be specified.
> > 
> > The patch breaks important invariant that anon page can be mapped into a
> > process only once.
> 
> Actually, the patch does not add any new functionality.  It only provides
> a new interface to existing functionality.
> 
> Is it not possible to have an anon page mapped twice into the same process
> via system V shared memory?  shmget(anon), shmat(), shmat.  
> Of course, those are shared rather than private anon pages.

By anon pages I mean, private anon or file pages. These are subject to CoW.

> > What is going to happen to mirrored after CoW for instance?
> > 
> > In my opinion, it shouldn't be allowed for anon/private mappings at least.
> > And with this limitation, I don't see much sense in the new interface --
> > just create mirror by mmap()ing the file again.
> 
> The code today works for anon shared mappings.  See simple program below.
> 
> You are correct in that it makes little or no sense for private mappings.
> When looking closer at existing code, mremap() creates a new private
> mapping in this case.  This is most likely a bug.

IIRC, existing code doesn't create mirrors of private pages as it requires
old_len to be zero. There's no way to get private pages mapped twice this
way.

-- 
 Kirill A. Shutemov

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
