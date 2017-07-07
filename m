From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 0/1] mm/mremap: add MREMAP_MIRROR flag
Date: Fri, 7 Jul 2017 13:49:46 +0530
Message-ID: <6f1460ef-a896-aef4-c0dc-66227232e025@linux.vnet.ibm.com>
References: <1499357846-7481-1-git-send-email-mike.kravetz@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1499357846-7481-1-git-send-email-mike.kravetz@oracle.com>
Sender: owner-linux-mm@kvack.org
To: Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Andrea Arcangeli <aarcange@redhat.com>, Michal Hocko <mhocko@suse.com>, Aaron Lu <aaron.lu@intel.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On 07/06/2017 09:47 PM, Mike Kravetz wrote:
> The mremap system call has the ability to 'mirror' parts of an existing
> mapping.  To do so, it creates a new mapping that maps the same pages as
> the original mapping, just at a different virtual address.  This
> functionality has existed since at least the 2.6 kernel [1].  A comment
> was added to the code to help preserve this feature.


Is this the comment ? If yes, then its not very clear.

	/*
	 * We allow a zero old-len as a special case
	 * for DOS-emu "duplicate shm area" thing. But
	 * a zero new-len is nonsensical.
	 */


> 
> The Oracle JVM team has discovered this feature and used it while
> prototyping a new garbage collection model.  This new model shows promise,
> and they are considering its use in a future release.  However, since
> the only mention of this functionality is a single comment in the kernel,
> they are concerned about its future.
> 
> I propose the addition of a new MREMAP_MIRROR flag to explicitly request
> this functionality.  The flag simply provides the same functionality as
> the existing undocumented 'old_size == 0' interface.  As an alternative,
> we could simply document the 'old_size == 0' interface in the man page.
> In either case, man page modifications would be needed.

Right. Adding MREMAP_MIRROR sounds cleaner from application programming
point of view. But it extends the interface.

> 
> Future Direction
> 
> After more formally adding this to the API (either new flag or documenting
> existing interface), the mremap code could be enhanced to optimize this
> case.  Currently, 'mirroring' only sets up the new mapping.  It does not
> create page table entries for new mapping.  This could be added as an
> enhancement.

Then how it achieves mirroring, both the pointers should see the same
data, that can happen with page table entries pointing to same pages,
right ?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
