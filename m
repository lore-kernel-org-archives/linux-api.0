From: Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH RFC] mm: add MAP_EXCLUSIVE to create exclusive user
 mappings
Date: Wed, 30 Oct 2019 08:11:37 +0100
Message-ID: <20191030071136.GA20624@rapoport-lnx>
References: <1572171452-7958-1-git-send-email-rppt@kernel.org>
 <1572171452-7958-2-git-send-email-rppt@kernel.org>
 <20191028123124.ogkk5ogjlamvwc2s@box>
 <20191028130018.GA7192@rapoport-lnx>
 <20191028131623.zwuwguhm4v4s5imh@box>
 <alpine.DEB.2.21.1910290706360.3769@www.lameter.com>
 <20191029085551.GA18773@rapoport-lnx>
 <alpine.DEB.2.21.1910291011090.5411@www.lameter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1910291011090.5411@www.lameter.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christopher Lameter <cl@linux.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, James Bottomley <jejb@linux.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-api@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org, Mike Rapoport <rppt@linux.ibm.com>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 29, 2019 at 10:12:04AM +0000, Christopher Lameter wrote:
> 
> 
> On Tue, 29 Oct 2019, Mike Rapoport wrote:
> 
> > I've talked with Thomas yesterday and he suggested something similar:
> >
> > When the MAP_EXCLUSIVE request comes for the first time, we allocate a huge
> > page for it and then use this page as a pool of 4K pages for subsequent
> > requests. Once this huge page is full we allocate a new one and append it
> > to the pool. When all the 4K pages that comprise the huge page are freed
> > the huge page is collapsed.
> 
> Or write a device driver that allows you to mmap a secure area and avoid
> all core kernel modifications?
> 
> /dev/securemem or so?

A device driver will need to remove the secure area from the direct map and
then we back to square one.
 
> It may exist already.
> 

-- 
Sincerely yours,
Mike.
