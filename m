From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC, PATCHv2 29/29] mm, x86: introduce RLIMIT_VADDR
Date: Thu, 5 Jan 2017 09:53:54 -0800
Message-ID: <CALCETrXTD97Sk-AThhN8myfY5+pL9memi2RQfhFNjv1mFoiALw@mail.gmail.com>
References: <20161227015413.187403-1-kirill.shutemov@linux.intel.com>
 <20161227015413.187403-30-kirill.shutemov@linux.intel.com>
 <2736959.3MfCab47fD@wuerfel> <CALCETrV_qejd-Ozqo4vTqz=LuukMUPeQ7EVUQbfTxs_xNbO3oQ@mail.gmail.com>
 <20170103160457.GB17319@node.shutemov.name> <CALCETrW3=SsQeC-gWOVqwTtg022+gHei=xfUc2ei3kkX0CACpg@mail.gmail.com>
 <20170104141959.GC17319@node.shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170104141959.GC17319@node.shutemov.name>
Sender: owner-linux-mm@kvack.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Arnd Bergmann <arnd@arndb.de>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>, linux-arch <linux-arch@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 4, 2017 at 6:19 AM, Kirill A. Shutemov <kirill@shutemov.name> wrote:
> On Tue, Jan 03, 2017 at 10:27:22AM -0800, Andy Lutomirski wrote:
>> On Tue, Jan 3, 2017 at 8:04 AM, Kirill A. Shutemov <kirill@shutemov.name> wrote:
>> > And what about stack? I'm not sure that everybody would be happy with
>> > stack in the middle of address space.
>>
>> I would, personally.  I think that, for very large address spaces, we
>> should allocate a large block of stack and get rid of the "stack grows
>> down forever" legacy idea.  Then we would never need to worry about
>> the stack eventually hitting some other allocation.  And 2^57 bytes is
>> hilariously large for a default stack.
>
> The stack in the middle of address space can prevent creating other huuuge
> contiguous mapping. Databases may want this.

Fair enough.  OTOH, 2^47 is nowhere near the middle if we were to put
it near the top of the legacy address space.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
