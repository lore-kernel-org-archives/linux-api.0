From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: AMD TLB errata, (Was: [PATCH RFC] mm: add MAP_EXCLUSIVE to create
 exclusive user mappings)
Date: Fri, 15 Nov 2019 08:12:52 -0600
Message-ID: <1da1b025-cabc-6f04-bde5-e50830d1ecf0@amd.com>
References: <1572171452-7958-1-git-send-email-rppt@kernel.org>
 <1572171452-7958-2-git-send-email-rppt@kernel.org>
 <20191028123124.ogkk5ogjlamvwc2s@box> <20191028130018.GA7192@rapoport-lnx>
 <20191028131623.zwuwguhm4v4s5imh@box>
 <CAA9_cmd7f2y2AAT6646S=tco3yfyLgCAC4Qp=1iTQaJqrQcOwQ@mail.gmail.com>
 <20191029064318.s4n4gidlfjun3d47@box>
 <20191029085602.GI4114@hirez.programming.kicks-ass.net>
 <20191029110024.yjytp22lhd2vekrv@box>
 <20191029123949.GL4114@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191029123949.GL4114@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Dan Williams <dan.j.williams@intel.com>, Mike Rapoport <rppt@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, James Bottomley <jejb@linux.ibm.com>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Linux API <linux-api@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, the arch/x86 maintainers <x86@kernel.org>, Mike Rapoport <rppt@linux.ibm.com>
List-Id: linux-api@vger.kernel.org

On 10/29/19 7:39 AM, Peter Zijlstra wrote:
> On Tue, Oct 29, 2019 at 02:00:24PM +0300, Kirill A. Shutemov wrote:
>> On Tue, Oct 29, 2019 at 09:56:02AM +0100, Peter Zijlstra wrote:
>>> On Tue, Oct 29, 2019 at 09:43:18AM +0300, Kirill A. Shutemov wrote:
>>>> But some CPUs don't like to have two TLB entries for the same memory with
>>>> different sizes at the same time. See for instance AMD erratum 383.
>>>>
>>>> Getting it right would require making the range not present, flush TLB and
>>>> only then install huge page. That's what we do for userspace.
>>>>
>>>> It will not fly for the direct mapping. There is no reasonable way to
>>>> exclude other CPU from accessing the range while it's not present (call
>>>> stop_machine()? :P). Moreover, the range may contain the code that doing
>>>> the collapse or data required for it...
>>>>
>>>> BTW, looks like current __split_large_page() in pageattr.c is susceptible
>>>> to the errata. Maybe we can get away with the easy way...
>>>
>>> As you write above, there is just no way we can have a (temporary) hole
>>> in the direct map.
>>>
>>> We are careful about that other errata, and make sure both translations
>>> are identical wrt everything else.
>>
>> It's not clear if it is enough to avoid the issue. "under a highly specific
>> and detailed set of conditions" is not very specific set of conditions :P
> 
> Yeah, I know ... :/ Tom is there any chance you could shed a little more
> light on that errata?

I talked with some of the hardware folks and if you maintain the same bits
in the large and small pages (aside from the large page bit) until the
flush, then the errata should not occur.

The errata really applies to mappings that end up with different attribute
bits being set. Even then, it doesn't fail every time. There are other
conditions required to make it fail.

Thanks,
Tom

> 
