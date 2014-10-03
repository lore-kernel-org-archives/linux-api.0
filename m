From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 01/17] mm: gup: add FOLL_TRIED
Date: Fri, 3 Oct 2014 16:55:50 -0400 (EDT)
Message-ID: <357882411.58338047.1412369750145.JavaMail.zimbra@redhat.com>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com> <1412356087-16115-2-git-send-email-aarcange@redhat.com> <CA+55aFwEO9=ieSb0uipfQ+qP9nP1ps=NCTe0HL9arK1cRYaJPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <CA+55aFwEO9=ieSb0uipfQ+qP9nP1ps=NCTe0HL9arK1cRYaJPg@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, qemu-devel@nongnu.org, KVM list <kvm@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, Andres Lagar-Cavilla <andreslc@google.com>, Dave Hansen <dave@sr71.net>, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>, Peter Feiner <pfeiner@google.com>, "\\Dr. David Alan Gilbert" <dgilbert@redhat.com>, Christopher Covington <cov@codeaurora.org>, Johannes Weiner <hannes@cmpxchg.org>, Android Kernel Team <kernel-team@android.com>, Robert Love <rlove@google.com>Dmitry Adamushko <d>
List-Id: linux-api@vger.kernel.org

> This needs more explanation than that one-liner comment. Make the
> commit message explain why the new FOLL_TRIED flag exists.

This patch actually is extracted from a 3.18 commit in the KVM tree,
https://git.kernel.org/cgit/virt/kvm/kvm.git/commit/?h=next&id=234b239b.

Here is how that patch uses the flag:

    /*
     * The previous call has now waited on the IO. Now we can
     * retry and complete. Pass TRIED to ensure we do not re
     * schedule async IO (see e.g. filemap_fault).
     */
    down_read(&mm->mmap_sem);
    npages = __get_user_pages(tsk, mm, addr, 1, flags | FOLL_TRIED,
                              pagep, NULL, NULL);

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
