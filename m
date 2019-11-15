From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: AMD TLB errata, (Was: [PATCH RFC] mm: add MAP_EXCLUSIVE to
 create exclusive user mappings)
Date: Fri, 15 Nov 2019 15:31:14 +0100
Message-ID: <20191115143114.GN4131@hirez.programming.kicks-ass.net>
References: <1572171452-7958-2-git-send-email-rppt@kernel.org>
 <20191028123124.ogkk5ogjlamvwc2s@box>
 <20191028130018.GA7192@rapoport-lnx>
 <20191028131623.zwuwguhm4v4s5imh@box>
 <CAA9_cmd7f2y2AAT6646S=tco3yfyLgCAC4Qp=1iTQaJqrQcOwQ@mail.gmail.com>
 <20191029064318.s4n4gidlfjun3d47@box>
 <20191029085602.GI4114@hirez.programming.kicks-ass.net>
 <20191029110024.yjytp22lhd2vekrv@box>
 <20191029123949.GL4114@hirez.programming.kicks-ass.net>
 <1da1b025-cabc-6f04-bde5-e50830d1ecf0@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1da1b025-cabc-6f04-bde5-e50830d1ecf0@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Dan Williams <dan.j.williams@intel.com>, Mike Rapoport <rppt@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, James Bottomley <jejb@linux.ibm.com>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Linux API <linux-api@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, the arch/x86 maintainers <x86@kernel.org>, Mike Rapoport <rppt@linux.ibm.com>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 15, 2019 at 08:12:52AM -0600, Tom Lendacky wrote:
> I talked with some of the hardware folks and if you maintain the same bits
> in the large and small pages (aside from the large page bit) until the
> flush, then the errata should not occur.

Excellent!

Thanks for digging that out Tom.
