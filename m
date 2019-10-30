From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC] mm: add MAP_EXCLUSIVE to create exclusive user
 mappings
Date: Wed, 30 Oct 2019 11:04:18 +0100
Message-ID: <20191030100418.GV4097@hirez.programming.kicks-ass.net>
References: <1572171452-7958-1-git-send-email-rppt@kernel.org>
 <1572171452-7958-2-git-send-email-rppt@kernel.org>
 <20191028123124.ogkk5ogjlamvwc2s@box>
 <20191028130018.GA7192@rapoport-lnx>
 <20191028131623.zwuwguhm4v4s5imh@box>
 <20191028135521.GB4097@hirez.programming.kicks-ass.net>
 <0a35765f7412937c1775daa05177b20113760aee.camel@intel.com>
 <20191028210052.GM4643@worktop.programming.kicks-ass.net>
 <69c57f7fa9a1be145827673b37beff155a3adc3c.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <69c57f7fa9a1be145827673b37beff155a3adc3c.camel@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "adobriyan@gmail.com" <adobriyan@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "luto@kernel.org" <luto@kernel.org>, "kirill@shutemov.name" <kirill@shutemov.name>, "bp@alien8.de" <bp@alien8.de>, "rppt@linux.ibm.com" <rppt@linux.ibm.com>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 29, 2019 at 05:27:43PM +0000, Edgecombe, Rick P wrote:
> On Mon, 2019-10-28 at 22:00 +0100, Peter Zijlstra wrote:

> > That should be limited to the module range. Random data maps could
> > shatter the world.
> 
> BPF has one vmalloc space allocation for the byte code and one for the module
> space allocation for the JIT. Both get RO also set on the direct map alias of
> the pages, and reset RW when freed.

Argh, I didn't know they mapped the bytecode RO; why does it do that? It
can throw out the bytecode once it's JIT'ed.

> You mean shatter performance?

Shatter (all) large pages.
