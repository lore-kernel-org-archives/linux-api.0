From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCHv3 33/33] mm, x86: introduce PR_SET_MAX_VADDR and
 PR_GET_MAX_VADDR
Date: Tue, 21 Feb 2017 12:46:55 -0800
Message-ID: <0d05ac45-a139-6f8e-f98b-71876fbb509d@intel.com>
References: <20170217141328.164563-1-kirill.shutemov@linux.intel.com>
 <20170217141328.164563-34-kirill.shutemov@linux.intel.com>
 <CA+55aFwgbHxV-Ha2n1H=Z7P6bgcQ3D8aW=fr8ZrQ5OnvZ1vOYg@mail.gmail.com>
 <20170218092133.GA17471@node.shutemov.name>
 <20170220131515.GA9502@node.shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170220131515.GA9502@node.shutemov.name>
Sender: owner-linux-mm@kvack.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, the arch/x86 maintainers <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>, linux-mm <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Let me make sure I'm grokking what you're trying to do here.

On 02/20/2017 05:15 AM, Kirill A. Shutemov wrote:
> +/* MPX cannot handle addresses above 47-bits yet. */
> +unsigned long mpx_unmapped_area_check(unsigned long addr, unsigned long len,
> +		unsigned long flags)
> +{
> +	if (!kernel_managing_mpx_tables(current->mm))
> +		return addr;
> +	if (addr + len <= DEFAULT_MAP_WINDOW)
> +		return addr;

At this point, we know MPX management is on and the hint is for memory
above DEFAULT_MAP_WINDOW?

> +	if (flags & MAP_FIXED)
> +		return -ENOMEM;

... and if it's a MAP_FIXED request, fail it.

> +	if (len > DEFAULT_MAP_WINDOW)
> +		return -ENOMEM;

What is this case for?  If addr+len wraps?

> +	/* Look for unmap area within DEFAULT_MAP_WINDOW */
> +	return 0;
> +}

Otherwise, blow away the hint, which we know is high and needs to
be discarded?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
