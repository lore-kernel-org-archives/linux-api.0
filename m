From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH 10/17] mm: rmap preparation for remap_anon_pages
Date: Mon, 6 Oct 2014 09:55:41 +0100
Message-ID: <20141006085540.GD2336@work-vm>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
 <1412356087-16115-11-git-send-email-aarcange@redhat.com>
 <CA+55aFx++R42L75ooE=Fmaem73=V=q7f6pYTcALxgrA1y98G-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFx++R42L75ooE=Fmaem73=V=q7f6pYTcALxgrA1y98G-A@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, qemu-devel@nongnu.org, KVM list <kvm@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, Andres Lagar-Cavilla <andreslc@google.com>, Dave Hansen <dave@sr71.net>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>, Peter Feiner <pfeiner@google.com>, "\\Dr. David Alan Gilbert\\" <dgilbert@redhat.com>, Christopher Covington <cov@codeaurora.org>, Johannes Weiner <hannes@cmpxchg.org>, Android Kernel Team <kernel-team@android.com>, Robert
List-Id: linux-api@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> On Fri, Oct 3, 2014 at 10:08 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> >
> > Overall this looks a fairly small change to the rmap code, notably
> > less intrusive than the nonlinear vmas created by remap_file_pages.
> 
> Considering that remap_file_pages() was an unmitigated disaster, and
> -mm has a patch to remove it entirely, I'm not at all convinced this
> is a good argument.
> 
> We thought remap_file_pages() was a good idea, and it really really
> really wasn't. Almost nobody used it, why would the anonymous page
> case be any different?

I've posted code that uses this interface to qemu-devel and it works nicely;
so chalk up at least one user.

For the postcopy case I'm using it for, we need to place a page, atomically
  some thread might try and access it, and must either
     1) get caught by userfault etc or
     2) must succeed in it's access

and we'll have that happening somewhere between thousands and millions of times
to pages in no particular order, so we need to avoid creating millions of mappings.

Dave



> 
>             Linus
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
