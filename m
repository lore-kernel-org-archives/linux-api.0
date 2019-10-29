From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH RFC] mm: add MAP_EXCLUSIVE to create exclusive user
 mappings
Date: Tue, 29 Oct 2019 10:12:04 +0000 (UTC)
Message-ID: <alpine.DEB.2.21.1910291011090.5411@www.lameter.com>
References: <1572171452-7958-1-git-send-email-rppt@kernel.org> <1572171452-7958-2-git-send-email-rppt@kernel.org> <20191028123124.ogkk5ogjlamvwc2s@box> <20191028130018.GA7192@rapoport-lnx> <20191028131623.zwuwguhm4v4s5imh@box> <alpine.DEB.2.21.1910290706360.3769@www.lameter.com>
 <20191029085551.GA18773@rapoport-lnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191029085551.GA18773@rapoport-lnx>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Rapoport <rppt@kernel.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, James Bottomley <jejb@linux.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-api@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org, Mike Rapoport <rppt@linux.ibm.com>
List-Id: linux-api@vger.kernel.org



On Tue, 29 Oct 2019, Mike Rapoport wrote:

> I've talked with Thomas yesterday and he suggested something similar:
>
> When the MAP_EXCLUSIVE request comes for the first time, we allocate a huge
> page for it and then use this page as a pool of 4K pages for subsequent
> requests. Once this huge page is full we allocate a new one and append it
> to the pool. When all the 4K pages that comprise the huge page are freed
> the huge page is collapsed.

Or write a device driver that allows you to mmap a secure area and avoid
all core kernel modifications?

/dev/securemem or so?

It may exist already.
