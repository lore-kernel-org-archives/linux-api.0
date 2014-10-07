From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 10/17] mm: rmap preparation for remap_anon_pages
Date: Tue, 07 Oct 2014 19:14:31 +0200
Message-ID: <54341F77.6060400@redhat.com>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com> <1412356087-16115-11-git-send-email-aarcange@redhat.com> <CA+55aFx++R42L75ooE=Fmaem73=V=q7f6pYTcALxgrA1y98G-A@mail.gmail.com> <20141006085540.GD2336@work-vm> <20141006164156.GA31075@redhat.com> <CA+55aFxAOYBny+QwXfkPy-P3rs-RPr5SLYLcPNBiFO3waBXtQA@mail.gmail.com> <20141007170731.GO2404@work-vm>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20141007170731.GO2404@work-vm>
Sender: owner-linux-mm@kvack.org
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, qemu-devel@nongnu.org, KVM list <kvm@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, Andres Lagar-Cavilla <andreslc@google.com>, Dave Hansen <dave@sr71.net>, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>, Peter Feiner <pfeiner@google.com>, Christopher Covington <cov@codeaurora.org>, Johannes Weiner <hannes@cmpxchg.org>, Android Kernel Team <kernel-team@android.com>, Robert Love <rlove@google.com>, Dmitry Adamushko <dmitry.adamushko@gmail.com>, Neil Brown <neilb@suse>
List-Id: linux-api@vger.kernel.org

Il 07/10/2014 19:07, Dr. David Alan Gilbert ha scritto:
>> > 
>> > So I'd *much* rather have a "write()" style interface (ie _copying_
>> > bytes from user space into a newly allocated page that gets mapped)
>> > than a "remap page" style interface
> Something like that might work for the postcopy case; it doesn't work
> for some of the other uses that need to stop a page being changed by the
> guest, but then need to somehow get a copy of that page internally to QEMU,
> and perhaps provide it back later.

I cannot parse this.  Which uses do you have in mind?  Is it for
QEMU-specific or is it for other applications of userfaults?

As long as the page is atomically mapped, I'm not sure what the
difference from remap_anon_pages are (as far as the destination page is
concerned).  Are you thinking of having userfaults enabled on the source
as well?

Paolo

> remap_anon_pages worked for those cases
> as well; I can't think of another current way of doing it in userspace.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
