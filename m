From: Brian Geffon <bgeffon@google.com>
Subject: Re: [PATCH v2] mm: Add MREMAP_DONTUNMAP to mremap().
Date: Mon, 27 Jan 2020 17:35:40 -0800
Message-ID: <CADyq12xCK_3MhGi88Am5P6DVZvrW8vqtyJMHO0zjNhvhYegm1w@mail.gmail.com>
References: <20200123014627.71720-1-bgeffon@google.com> <20200124190625.257659-1-bgeffon@google.com>
 <20200126220650.i4lwljpvohpgvsi2@box>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200126220650.i4lwljpvohpgvsi2@box>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Michael S . Tsirkin" <mst@redhat.com>, Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Andrea Arcangeli <aarcange@redhat.com>, Sonny Rao <sonnyrao@google.com>, Minchan Kim <minchan@kernel.org>, Joel Fernandes <joel@joelfernandes.org>, Yu Zhao <yuzhao@google.com>, Jesse Barnes <jsbarnes@google.com>
List-Id: linux-api@vger.kernel.org

Hi Kirill,
Thanks for taking the time to look at this. I'll update the wording to
make it clear that MREMAP_FIXED is required with MREMAP_DONTUNMAP.

Regarding rmap, you're completely right I'm going to roll a new patch
which will call unlink_anon_vmas() to make sure the rmap is correct,
I'll also explicitly check that the vma is anonymous and not shared
returning EINVAL if not, how does that sound?

Brian

On Sun, Jan 26, 2020 at 2:06 PM Kirill A. Shutemov <kirill@shutemov.name> wrote:
>
> On Fri, Jan 24, 2020 at 11:06:25AM -0800, Brian Geffon wrote:
> > When remapping an anonymous, private mapping, if MREMAP_DONTUNMAP is
> > set, the source mapping will not be removed. Instead it will be
> > cleared as if a brand new anonymous, private mapping had been created
> > atomically as part of the mremap() call.  If a userfaultfd was watching
> > the source, it will continue to watch the new mapping.  For a mapping
> > that is shared or not anonymous, MREMAP_DONTUNMAP will cause the
> > mremap() call to fail. MREMAP_DONTUNMAP implies that MREMAP_FIXED is
> > also used.
>
> Implies? From code it looks like it requires MREMAP_FIXED. And
> MREMAP_FIXED requires MREMAP_MAYMOVE. That's strange flag chaining.
> I don't really see need in such dependencies. It maybe indeed implied, not
> requied.
>
> > The final result is two equally sized VMAs where the
> > destination contains the PTEs of the source.
>
> Could you clarify rmap situation here? How the rmap hierarchy will look
> like before and after the operation. Can the new VMA merge with the old
> one? Sounds fishy to me.
>
> > We hope to use this in Chrome OS where with userfaultfd we could write
> > an anonymous mapping to disk without having to STOP the process or worry
> > about VMA permission changes.
> >
> > This feature also has a use case in Android, Lokesh Gidra has said
> > that "As part of using userfaultfd for GC, We'll have to move the physical
> > pages of the java heap to a separate location. For this purpose mremap
> > will be used. Without the MREMAP_DONTUNMAP flag, when I mremap the java
> > heap, its virtual mapping will be removed as well. Therefore, we'll
> > require performing mmap immediately after. This is not only time consuming
> > but also opens a time window where a native thread may call mmap and
> > reserve the java heap's address range for its own usage. This flag
> > solves the problem."
>
> --
>  Kirill A. Shutemov
