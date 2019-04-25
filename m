From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V2] mm: Allow userland to request that the kernel clear
 memory on release
Date: Thu, 25 Apr 2019 13:43:57 -0700
Message-ID: <CACdnJuu__NS3Py+heKPDdTJSe53Wr9AP-oArO7mVRky2wqMp2g@mail.gmail.com>
References: <CACdnJuup-y1xAO93wr+nr6ARacxJ9YXgaceQK9TLktE7shab1w@mail.gmail.com>
 <20190424211038.204001-1-matthewgarrett@google.com> <20190425121410.GC1144@dhcp22.suse.cz>
 <CAG48ez0x6QiFpqXbimB9ZV-jS5UJJWhzg9XiAWncQL+phfKkPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez0x6QiFpqXbimB9ZV-jS5UJJWhzg9XiAWncQL+phfKkPA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Michal Hocko <mhocko@kernel.org>, Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 25, 2019 at 5:43 AM Jann Horn <jannh@google.com> wrote:
> An interesting effect of this is that it will be possible to set this
> on a CoW anon VMA in a fork() child, and then the semantics in the
> parent will be subtly different - e.g. if the parent vmsplice()d a
> CoWed page into a pipe, then forked an unprivileged child, the child
> set MADV_WIPEONRELEASE on its VMA, the parent died somehow, and then
> the child died, the page in the pipe would be zeroed out. A child
> should not be able to affect its parent like this, I think. If this
> was an mmap() flag instead of a madvise() command, that issue could be
> avoided. Alternatively, if adding more mmap() flags doesn't work,
> perhaps you could scan the VMA and ensure that it contains no pages
> yet, or something like that?

I /think/ my argument here would be not to do that? I agree that it's
unexpected, but I guess the other alternative would be to force a copy
on any existing COW pages in the VMA at madvise() time, and maybe also
at fork() time (sort of like the behaviour of MADV_WIPEONFORK, but
copying the page rather than providing a new zero page)

> I think all the callers have a reference to the VMA, so perhaps you
> could add a VMA parameter to page_remove_rmap() and then look at the
> VMA in there?

I'll dig into that, thanks!
