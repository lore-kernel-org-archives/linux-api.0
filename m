From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC] mm: add MAP_EXCLUSIVE to create exclusive user
 mappings
Date: Mon, 28 Oct 2019 22:00:52 +0100
Message-ID: <20191028210052.GM4643@worktop.programming.kicks-ass.net>
References: <1572171452-7958-1-git-send-email-rppt@kernel.org>
 <1572171452-7958-2-git-send-email-rppt@kernel.org>
 <20191028123124.ogkk5ogjlamvwc2s@box>
 <20191028130018.GA7192@rapoport-lnx>
 <20191028131623.zwuwguhm4v4s5imh@box>
 <20191028135521.GB4097@hirez.programming.kicks-ass.net>
 <0a35765f7412937c1775daa05177b20113760aee.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0a35765f7412937c1775daa05177b20113760aee.camel@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kirill@shutemov.name" <kirill@shutemov.name>, "adobriyan@gmail.com" <adobriyan@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "luto@kernel.org" <luto@kernel.org>, "rppt@linux.ibm.com" <rppt@linux.ibm.com>, "bp@alien8.de" <bp@alien8.de>, arnd@arn
List-Id: linux-api@vger.kernel.org

On Mon, Oct 28, 2019 at 07:59:25PM +0000, Edgecombe, Rick P wrote:
> On Mon, 2019-10-28 at 14:55 +0100, Peter Zijlstra wrote:
> > On Mon, Oct 28, 2019 at 04:16:23PM +0300, Kirill A. Shutemov wrote:
> > 
> > > I think active use of this feature will lead to performance degradation of
> > > the system with time.
> > > 
> > > Setting a single 4k page non-present in the direct mapping will require
> > > splitting 2M or 1G page we usually map direct mapping with. And it's one
> > > way road. We don't have any mechanism to map the memory with huge page
> > > again after the application has freed the page.
> > 
> > Right, we recently had a 'bug' where ftrace triggered something like
> > this and facebook ran into it as a performance regression. So yes, this
> > is a real concern.
> 
> Don't e/cBPF filters also break the direct map down to 4k pages when calling
> set_memory_ro() on the filter for 64 bit x86 and arm?
> 
> I've been wondering if the page allocator should make some effort to find a
> broken down page for anything that can be known will have direct map permissions
> changed (or if it already groups them somehow). But also, why any potential
> slowdown of 4k pages on the direct map hasn't been noticed for apps that do a
> lot of insertions and removals of BPF filters, if this is indeed the case.

That should be limited to the module range. Random data maps could
shatter the world.
