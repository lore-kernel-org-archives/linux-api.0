From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 19/21] userfaultfd: remap_pages: UFFDIO_REMAP preparation
Date: Thu, 5 Mar 2015 09:39:48 -0800
Message-ID: <CA+55aFzW=qaO0iKZWK9BWDNHu4eOgiKOJ-=0SvzsmZawuH5_3A@mail.gmail.com>
References: <1425575884-2574-1-git-send-email-aarcange@redhat.com>
	<1425575884-2574-20-git-send-email-aarcange@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1425575884-2574-20-git-send-email-aarcange@redhat.com>
Sender: owner-linux-mm@kvack.org
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: qemu-devel@nongnu.org, KVM list <kvm@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Pavel Emelyanov <xemul@parallels.com>, Sanidhya Kashyap <sanidhya.gatech@gmail.com>, zhang.zhanghailiang@huawei.com, Andres Lagar-Cavilla <andreslc@google.com>, Dave Hansen <dave@sr71.net>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>, Peter Feiner <pfeiner@google.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Christopher Covington <cov@codeaurora.org>, Johannes Weiner <hannes@cmpxchg.>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 5, 2015 at 9:18 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> remap_pages is the lowlevel mm helper needed to implement
> UFFDIO_REMAP.

This function is nasty nasty nasty.

Is this really worth it? On real loads? That people are expected to use?

Considering how we just got rid of one special magic VM remapping
thing that nobody actually used, I'd really hate to add a new one.

The fact is, almost nobody ever uses anything that isn't standard
POSIX. There are no apps, and even for specialized things like
virtualization hypervisors this kind of thing is often simply not
worth it.

Quite frankly, *if* we ever merge userfaultfd, I would *strongly*
argue for not merging the remap parts. I just don't see the point. It
doesn't seem to add anything that is semantically very important -
it's *potentially* a faster copy, but even that is

  (a) questionable in the first place

and

 (b) unclear why anybody would ever care about performance of
infrastructure that nobody actually uses today, and future use isn't
even clear or shown to be particualrly performance-sensitive.

So basically I'd like to see better documentation, a few real use
cases (and by real I very much do *not* mean "you can use it for
this", but actual patches to actual projects that matter and that are
expected to care and merge them), and a simplified series that doesn't
do the remap thing.

Because *every* time we add a new clever interface, we end up with
approximately zero users and just pain down the line. Examples:
splice, mremap, yadda yadda.

                        Linus

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
