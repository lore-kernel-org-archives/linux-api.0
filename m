From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH RFC] mm: add MAP_EXCLUSIVE to create exclusive user
 mappings
Date: Wed, 30 Oct 2019 10:58:49 -0700
Message-ID: <775eb0cf-7189-a314-5dde-f720b56ec3b2@intel.com>
References: <1572171452-7958-1-git-send-email-rppt@kernel.org>
 <1572171452-7958-2-git-send-email-rppt@kernel.org>
 <20191028123124.ogkk5ogjlamvwc2s@box> <20191028130018.GA7192@rapoport-lnx>
 <20191028131623.zwuwguhm4v4s5imh@box>
 <20191028135521.GB4097@hirez.programming.kicks-ass.net>
 <0a35765f7412937c1775daa05177b20113760aee.camel@intel.com>
 <20191028210052.GM4643@worktop.programming.kicks-ass.net>
 <69c57f7fa9a1be145827673b37beff155a3adc3c.camel@intel.com>
 <20191030100418.GV4097@hirez.programming.kicks-ass.net>
 <b4d87f54b02cfccb58442f791485cad1ac080063.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b4d87f54b02cfccb58442f791485cad1ac080063.camel@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "peterz@infradead.org" <peterz@infradead.org>
Cc: "adobriyan@gmail.com" <adobriyan@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "luto@kernel.org" <luto@kernel.org>, "kirill@shutemov.name" <kirill@shutemov.name>, "bp@alien8.de" <bp@alien8.de>, "rppt@linux.ibm.com" <rppt@linux.ibm.com>
List-Id: linux-api@vger.kernel.org

On 10/30/19 10:48 AM, Edgecombe, Rick P wrote:
> On Wed, 2019-10-30 at 11:04 +0100, Peter Zijlstra wrote:
>>> You mean shatter performance?
>>
>> Shatter (all) large pages.
> 
> So it looks like this is already happening then to some degree. It's not just
> BPF either, any module_alloc() user is going to do something similar with the
> direct map alias of the page they got for the text.
> 
> So there must be at least some usages where breaking the direct map down, for
> like a page to store a key or something, isn't totally horrible.

The systems that really need large pages are the large ones.  They have
the same TLBs and data structures as really little systems, but orders
of magnitude more address space.  Modules and BPF are a (hopefully) drop
in the bucket on small systems and they're really inconsequential on
really big systems.

Modules also require privilege.

Allowing random user apps to fracture the direct map for every page of
their memory or *lots* of pages of their memory is an entirely different
kind of problem from modules.  It takes a "drop in the bucket"
fracturing and turns it into the common case.
