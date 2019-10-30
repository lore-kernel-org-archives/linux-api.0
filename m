From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH RFC] mm: add MAP_EXCLUSIVE to create exclusive user mappings
Date: Wed, 30 Oct 2019 11:52:49 -0700
Message-ID: <CAADnVQJe+dxsuhxzLvK-g1roiUh5-L0+9s9Xm5PM5CAYVNLfKg@mail.gmail.com>
References: <1572171452-7958-2-git-send-email-rppt@kernel.org>
 <20191028123124.ogkk5ogjlamvwc2s@box> <20191028130018.GA7192@rapoport-lnx>
 <20191028131623.zwuwguhm4v4s5imh@box> <20191028135521.GB4097@hirez.programming.kicks-ass.net>
 <0a35765f7412937c1775daa05177b20113760aee.camel@intel.com>
 <20191028210052.GM4643@worktop.programming.kicks-ass.net> <69c57f7fa9a1be145827673b37beff155a3adc3c.camel@intel.com>
 <20191030100418.GV4097@hirez.programming.kicks-ass.net> <CAADnVQ+3LeLWv-rpATyfAbdS1w9L=sCQFuyy=paCZVBUr0rK6Q@mail.gmail.com>
 <20191030183944.GV4114@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191030183944.GV4114@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "adobriyan@gmail.com" <adobriyan@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "luto@kernel.org" <luto@kernel.org>, "kirill@shutemov.name" <kirill@shutemov.name>, "bp@alien8.de" <bp@alien8.de>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 30, 2019 at 11:39 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Wed, Oct 30, 2019 at 08:35:09AM -0700, Alexei Starovoitov wrote:
> > On Wed, Oct 30, 2019 at 3:06 AM Peter Zijlstra <peterz@infradead.org> wrote:
> > >
> > > On Tue, Oct 29, 2019 at 05:27:43PM +0000, Edgecombe, Rick P wrote:
> > > > On Mon, 2019-10-28 at 22:00 +0100, Peter Zijlstra wrote:
> > >
> > > > > That should be limited to the module range. Random data maps could
> > > > > shatter the world.
> > > >
> > > > BPF has one vmalloc space allocation for the byte code and one for the module
> > > > space allocation for the JIT. Both get RO also set on the direct map alias of
> > > > the pages, and reset RW when freed.
> > >
> > > Argh, I didn't know they mapped the bytecode RO; why does it do that? It
> > > can throw out the bytecode once it's JIT'ed.
> >
> > because of endless security "concerns" that some folks had.
> > Like what if something can exploit another bug in the kernel
> > and modify bytecode that was already verified
> > then interpreter will execute that modified bytecode.
>
> But when it's JIT'ed the bytecode is no longer of relevance, right? So
> any scenario with a JIT on can then toss the bytecode and certainly
> doesn't need to map it RO.

We keep so called "xlated" bytecode around for debugging.
It's the one that is actually running. It was modified through
several stages of the verifier before being runnable by interpreter.
When folks debug stuff in production they want to see
the whole thing. Both x86 asm and xlated bytecode.
xlated bytecode also sanitized before it's returned
back to user space.

> > Sort of similar reasoning why .text is read-only.
> > I think it's not a realistic attack, but I didn't bother to argue back then.
> > The mere presence of interpreter itself is a real security concern.
> > People that care about speculation attacks should
> > have CONFIG_BPF_JIT_ALWAYS_ON=y,
>
> This isn't about speculation attacks, it is about breaking buffer limits
> and being able to write to memory. And in that respect being able to
> change the current task state (write it's effective PID to 0) is much
> simpler than writing to text or bytecode, but if you cannot reach/find
> the task struct but can reach/find text..

exactly. that's why RO bytecode was dubious to me from the beginning.
For an attacker to write meaningful bytecode they need to know
quite a few other kernel internal pointers.
If an exploit can write into memory there are plenty of easier targets.

> > so modifying bytecode via another exploit will be pointless.
> > Getting rid of RO for bytecode will save a ton of memory too,
> > since we won't need to allocate full page for each small programs.
>
> So I'm thinking we can get rid of that for any scenario that has the JIT
> enabled -- not only JIT_ALWAYS_ON.

Sounds good to me. Happy to do that. Will add it to our todo list.
