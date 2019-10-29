From: Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH RFC] mm: add MAP_EXCLUSIVE to create exclusive user
 mappings
Date: Tue, 29 Oct 2019 09:55:53 +0100
Message-ID: <20191029085551.GA18773@rapoport-lnx>
References: <1572171452-7958-1-git-send-email-rppt@kernel.org>
 <1572171452-7958-2-git-send-email-rppt@kernel.org>
 <20191028123124.ogkk5ogjlamvwc2s@box>
 <20191028130018.GA7192@rapoport-lnx>
 <20191028131623.zwuwguhm4v4s5imh@box>
 <alpine.DEB.2.21.1910290706360.3769@www.lameter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1910290706360.3769@www.lameter.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christopher Lameter <cl@linux.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, James Bottomley <jejb@linux.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-api@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org, Mike Rapoport <rppt@linux.ibm.com>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 29, 2019 at 07:08:42AM +0000, Christopher Lameter wrote:
> On Mon, 28 Oct 2019, Kirill A. Shutemov wrote:
> 
> > Setting a single 4k page non-present in the direct mapping will require
> > splitting 2M or 1G page we usually map direct mapping with. And it's one
> > way road. We don't have any mechanism to map the memory with huge page
> > again after the application has freed the page.
> >
> > It might be okay if all these pages cluster together, but I don't think we
> > have a way to achieve it easily.
> 
> Set aside a special physical memory range for this and migrate the
> page to that physical memory range when MAP_EXCLUSIVE is specified?

I've talked with Thomas yesterday and he suggested something similar:

When the MAP_EXCLUSIVE request comes for the first time, we allocate a huge
page for it and then use this page as a pool of 4K pages for subsequent
requests. Once this huge page is full we allocate a new one and append it
to the pool. When all the 4K pages that comprise the huge page are freed
the huge page is collapsed.

And then on top of this we can look into compaction of the direct map.

Of course, this would work if the easy way of collapsing direct map pages
Kirill mentioned on other mail will work.
 
> Maybe some processors also have hardware ranges that offer additional
> protection for stuff like that?
> 

-- 
Sincerely yours,
Mike.
