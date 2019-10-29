From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH RFC] mm: add MAP_EXCLUSIVE to create exclusive user mappings
Date: Mon, 28 Oct 2019 22:43:51 -0700
Message-ID: <CAA9_cmd7f2y2AAT6646S=tco3yfyLgCAC4Qp=1iTQaJqrQcOwQ@mail.gmail.com>
References: <1572171452-7958-1-git-send-email-rppt@kernel.org>
 <1572171452-7958-2-git-send-email-rppt@kernel.org> <20191028123124.ogkk5ogjlamvwc2s@box>
 <20191028130018.GA7192@rapoport-lnx> <20191028131623.zwuwguhm4v4s5imh@box>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191028131623.zwuwguhm4v4s5imh@box>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Mike Rapoport <rppt@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, James Bottomley <jejb@linux.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Linux API <linux-api@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, the arch/x86 maintainers <x86@kernel.org>, Mike Rapoport <rppt@linux.ibm.com>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 28, 2019 at 6:16 AM Kirill A. Shutemov <kirill@shutemov.name> wrote:
>
> On Mon, Oct 28, 2019 at 02:00:19PM +0100, Mike Rapoport wrote:
> > On Mon, Oct 28, 2019 at 03:31:24PM +0300, Kirill A. Shutemov wrote:
> > > On Sun, Oct 27, 2019 at 12:17:32PM +0200, Mike Rapoport wrote:
> > > > From: Mike Rapoport <rppt@linux.ibm.com>
> > > >
> > > > The mappings created with MAP_EXCLUSIVE are visible only in the context of
> > > > the owning process and can be used by applications to store secret
> > > > information that will not be visible not only to other processes but to the
> > > > kernel as well.
> > > >
> > > > The pages in these mappings are removed from the kernel direct map and
> > > > marked with PG_user_exclusive flag. When the exclusive area is unmapped,
> > > > the pages are mapped back into the direct map.
> > >
> > > I probably blind, but I don't see where you manipulate direct map...
> >
> > __get_user_pages() calls __set_page_user_exclusive() which in turn calls
> > set_direct_map_invalid_noflush() that makes the page not present.
>
> Ah. okay.
>
> I think active use of this feature will lead to performance degradation of
> the system with time.
>
> Setting a single 4k page non-present in the direct mapping will require
> splitting 2M or 1G page we usually map direct mapping with. And it's one
> way road. We don't have any mechanism to map the memory with huge page
> again after the application has freed the page.
>
> It might be okay if all these pages cluster together, but I don't think we
> have a way to achieve it easily.

Still, it would be worth exploring what that would look like if not
for MAP_EXCLUSIVE then set_mce_nospec() that wants to punch out poison
pages from the direct map. In the case of pmem, where those pages are
able to be repaired, it would be nice to also repair the mapping
granularity of the direct map.
