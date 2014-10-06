From: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 08/17] mm: madvise MADV_USERFAULT
Date: Mon, 6 Oct 2014 19:24:15 +0200
Message-ID: <20141006172415.GC31075@redhat.com>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
 <1412356087-16115-9-git-send-email-aarcange@redhat.com>
 <20141003231336.GA13528@glandium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20141003231336.GA13528@glandium.org>
Sender: owner-linux-mm@kvack.org
To: Mike Hommey <mh@glandium.org>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Andres Lagar-Cavilla <andreslc@google.com>, Dave Hansen <dave@sr71.net>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>, Peter Feiner <pfeiner@google.com>, "\\\"Dr. David Alan Gilbert\\\"" <dgilbert@redhat.com>, Christopher Covington <cov@codeaurora.org>, Johannes Weiner <hannes@cmpxchg.org>, Android Kernel Team <kernel-team@android.com>, Robert Love <rlove@google.com>, Dmitry Adamushko <dmitry.adamu>
List-Id: linux-api@vger.kernel.org

Hi,

On Sat, Oct 04, 2014 at 08:13:36AM +0900, Mike Hommey wrote:
> On Fri, Oct 03, 2014 at 07:07:58PM +0200, Andrea Arcangeli wrote:
> > MADV_USERFAULT is a new madvise flag that will set VM_USERFAULT in the
> > vma flags. Whenever VM_USERFAULT is set in an anonymous vma, if
> > userland touches a still unmapped virtual address, a sigbus signal is
> > sent instead of allocating a new page. The sigbus signal handler will
> > then resolve the page fault in userland by calling the
> > remap_anon_pages syscall.
> 
> What does "unmapped virtual address" mean in this context?

To clarify this I added this in a second sentence in the commit
header:

"still unmapped virtual address" of the previous sentence in this
context means that the pte/trans_huge_pmd is null. It means it's an
hole inside the anonymous vma (the kind of hole that doesn't account
for RSS but only virtual size of the process). It is the same state
all anonymous virtual memory is, right after mmap. The same state that
if you read from it, will map a zeropage into the faulting virtual
address. If the page is swapped out, it will not trigger userfaults.

If something isn't clear let me know.

Thanks,
Andrea

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
