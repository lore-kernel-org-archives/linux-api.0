From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: [PATCH RFC] mm: add MAP_EXCLUSIVE to create exclusive user mappings
Date: Thu, 31 Oct 2019 14:52:46 -0700
Message-ID: <CAA9_cmdCmiu5wVs=Jo4c6VNw6N1raPTDXg4d9OuUj3w0+e5JHQ@mail.gmail.com>
References: <1572171452-7958-1-git-send-email-rppt@kernel.org>
 <1572171452-7958-2-git-send-email-rppt@kernel.org> <085ed07e-e646-f7a4-0370-06f33a2a4e4a@redhat.com>
 <20191030081529.GB20624@rapoport-lnx> <9eae3941-64cf-4ea1-0287-0e64bab192c6@redhat.com>
 <20191031191651.GA26165@rapoport-lnx>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191031191651.GA26165@rapoport-lnx>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, James Bottomley <jejb@linux.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Linux API <linux-api@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, the arch/x86 maintainers <x86@kernel.org>, Mike Rapoport <rppt@linux.ibm.com>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 31, 2019 at 12:17 PM Mike Rapoport <rppt@kernel.org> wrote:
>
> On Wed, Oct 30, 2019 at 09:19:33AM +0100, David Hildenbrand wrote:
> > On 30.10.19 09:15, Mike Rapoport wrote:
> > >On Tue, Oct 29, 2019 at 12:02:34PM +0100, David Hildenbrand wrote:
> > >>On 27.10.19 11:17, Mike Rapoport wrote:
> > >>>From: Mike Rapoport <rppt@linux.ibm.com>
> > >>>
> > >>>The mappings created with MAP_EXCLUSIVE are visible only in the context of
> > >>>the owning process and can be used by applications to store secret
> > >>>information that will not be visible not only to other processes but to the
> > >>>kernel as well.
> > >>>
> > >>>The pages in these mappings are removed from the kernel direct map and
> > >>>marked with PG_user_exclusive flag. When the exclusive area is unmapped,
> > >>>the pages are mapped back into the direct map.
> > >>>
> > >>
> > >>Just a thought, the kernel is still able to indirectly read the contents of
> > >>these pages by doing a kdump from kexec environment, right?
> > >
> > >Right.
> > >
> > >>Also, I wonder
> > >>what would happen if you map such pages via /dev/mem into another user space
> > >>application and e.g., use them along with kvm [1].
> > >
> > >Do you mean that one application creates MAP_EXCLUSIVE and another
> > >applications accesses the same physical pages via /dev/mem?
> >
> > Exactly.
> >
> > >
> > >With /dev/mem all physical memory is visible...
> >
> > Okay, so the statement "information that will not be visible not only to
> > other processes but to the kernel as well" is not correct. There are easy
> > ways to access that information if you really want to (might require root
> > permissions, though).
>
> Right, but /dev/mem is an easy way to extract any information in any
> environment if one has root permissions...
>

I don't understand this concern with /dev/mem. Just add these pages to
the growing list of the things /dev/mem is not allowed to touch.
