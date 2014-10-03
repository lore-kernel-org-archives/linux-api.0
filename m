From: Mike Hommey <mh@glandium.org>
Subject: Re: [PATCH 08/17] mm: madvise MADV_USERFAULT
Date: Sat, 4 Oct 2014 08:13:36 +0900
Message-ID: <20141003231336.GA13528@glandium.org>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
 <1412356087-16115-9-git-send-email-aarcange@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1412356087-16115-9-git-send-email-aarcange@redhat.com>
Sender: owner-linux-mm@kvack.org
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Andres Lagar-Cavilla <andreslc@google.com>, Dave Hansen <dave@sr71.net>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>, Peter Feiner <pfeiner@google.com>, "\\\"Dr. David Alan Gilbert\\\"" <dgilbert@redhat.com>, Christopher Covington <cov@codeaurora.org>, Johannes Weiner <hannes@cmpxchg.org>, Android Kernel Team <kernel-team@android.com>, Robert Love <rlove@google.com>, Dmitry Adamushko <dmitry.adamushko@gmail.com>, Neil Brown <neilb@suse.de>, Taras Glek <tglek@mozilla.com>, Jan Kara <jack@suse.cz>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 03, 2014 at 07:07:58PM +0200, Andrea Arcangeli wrote:
> MADV_USERFAULT is a new madvise flag that will set VM_USERFAULT in the
> vma flags. Whenever VM_USERFAULT is set in an anonymous vma, if
> userland touches a still unmapped virtual address, a sigbus signal is
> sent instead of allocating a new page. The sigbus signal handler will
> then resolve the page fault in userland by calling the
> remap_anon_pages syscall.

What does "unmapped virtual address" mean in this context?

Mike

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
