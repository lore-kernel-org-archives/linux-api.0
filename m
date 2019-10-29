From: Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH RFC] mm: add MAP_EXCLUSIVE to create exclusive user
 mappings
Date: Tue, 29 Oct 2019 10:32:55 +0100
Message-ID: <20191029093254.GE18773@rapoport-lnx>
References: <1572171452-7958-1-git-send-email-rppt@kernel.org>
 <CA5C22D9-BC3E-4B69-8DD9-4D3B75E40BD5@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA5C22D9-BC3E-4B69-8DD9-4D3B75E40BD5@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, James Bottomley <jejb@linux.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-api@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org, Mike Rapoport <rppt@linux.ibm.com>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 28, 2019 at 02:44:23PM -0600, Andy Lutomirski wrote:
> 
> > On Oct 27, 2019, at 4:17 AM, Mike Rapoport <rppt@kernel.org> wrote:
> > 
> > ﻿From: Mike Rapoport <rppt@linux.ibm.com>
> > 
> > Hi,
> > 
> > The patch below aims to allow applications to create mappins that have
> > pages visible only to the owning process. Such mappings could be used to
> > store secrets so that these secrets are not visible neither to other
> > processes nor to the kernel.
> > 
> > I've only tested the basic functionality, the changes should be verified
> > against THP/migration/compaction. Yet, I'd appreciate early feedback.
> 
> I’ve contemplated the concept a fair amount, and I think you should
> consider a change to the API. In particular, rather than having it be a
> MAP_ flag, make it a chardev.  You can, at least at first, allow only
> MAP_SHARED, and admins can decide who gets to use it.  It might also play
> better with the VM overall, and you won’t need a VM_ flag for it — you
> can just wire up .fault to do the right thing.

I think mmap()/mprotect()/madvise() are the natural APIs for such
interface. Switching to a chardev doesn't solve the major problem of direct
map fragmentation and defeats the ability to use exclusive memory mappings
with the existing allocators, while mprotect() and madvise() do not.

-- 
Sincerely yours,
Mike.
