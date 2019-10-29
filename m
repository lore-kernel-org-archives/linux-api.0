From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH RFC] mm: add MAP_EXCLUSIVE to create exclusive user
 mappings
Date: Tue, 29 Oct 2019 13:07:00 -0700
Message-ID: <5108fe32-df25-eb93-32d6-a02fba76e707@intel.com>
References: <1572171452-7958-1-git-send-email-rppt@kernel.org>
 <1572171452-7958-2-git-send-email-rppt@kernel.org>
 <20191028123124.ogkk5ogjlamvwc2s@box> <20191028130018.GA7192@rapoport-lnx>
 <20191028131623.zwuwguhm4v4s5imh@box>
 <CAA9_cmd7f2y2AAT6646S=tco3yfyLgCAC4Qp=1iTQaJqrQcOwQ@mail.gmail.com>
 <20191029064318.s4n4gidlfjun3d47@box>
 <CAPcyv4hDPdmHxhMF753Jt5Dk6V9bTAkGqzkyYHCiG6xowT4Ncg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4hDPdmHxhMF753Jt5Dk6V9bTAkGqzkyYHCiG6xowT4Ncg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Mike Rapoport <rppt@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, James Bottomley <jejb@linux.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Linux API <linux-api@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, the arch/x86 maintainers <x86@kernel.org>, Mike Rapoport <rppt@linux.ibm.com>
List-Id: linux-api@vger.kernel.org

On 10/29/19 12:43 PM, Dan Williams wrote:
>> But some CPUs don't like to have two TLB entries for the same memory with
>> different sizes at the same time. See for instance AMD erratum 383.
> That basic description would seem to defeat most (all?) interesting
> huge page use cases. For example dax makes no attempt to make sure
> aliased mappings of pmem are the same size between the direct map that
> the driver uses, and userspace dax mappings. So I assume there are
> more details than "all aliased mappings must be the same size".

These are about when large and small TLB entries could be held in the
TLB at the same time for the same virtual address in the same process.
It doesn't matter that two *different* mappings are using different page
size.

Imagine you were *just* changing the page size.  Without these errata,
you could just skip flushing the TLB.  You might use the old hardware
page size for a while, but it will be functionally OK.  With these
errata, we need to ensure in software that the old TLB entries for the
old page size are flushed before the new page size is established.
