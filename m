From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v7 03/14] x86/cet/ibt: Add IBT legacy code bitmap setup
 function
Date: Fri, 7 Jun 2019 11:58:19 -0700
Message-ID: <352e6172-938d-f8e4-c195-9fd1b881bdee@intel.com>
References: <20190606200926.4029-1-yu-cheng.yu@intel.com>
 <20190606200926.4029-4-yu-cheng.yu@intel.com>
 <20190607080832.GT3419@hirez.programming.kicks-ass.net>
 <aa8a92ef231d512b5c9855ef416db050b5ab59a6.camel@intel.com>
 <20190607174336.GM3436@hirez.programming.kicks-ass.net>
 <b3de4110-5366-fdc7-a960-71dea543a42f@intel.com>
 <34E0D316-552A-401C-ABAA-5584B5BC98C5@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <34E0D316-552A-401C-ABAA-5584B5BC98C5@amacapital.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>
List-Id: linux-api@vger.kernel.org

On 6/7/19 11:29 AM, Andy Lutomirski wrote:
...
>> I think this new MSR probably needs to get included in oops output when
>> CET is enabled.
> 
> This shouldn’t be able to OOPS because it only happens at CPL 3,
> right?  We should put it into core dumps, though.

Good point.

Yu-cheng, can you just confirm that the bitmap can't be referenced in
ring-0, no matter what?  We should also make sure that no funny business
happens if we put an address in the bitmap that faults, or is
non-canonical.  Do we have any self-tests for that?

Let's say userspace gets a fault on this.  Do they have the
introspection capability to figure out why they faulted, say in their
signal handler?

>> Why don't we require that a VMA be in place for the entire bitmap?
>> Don't we need a "get" prctl function too in case something like a JIT is
>> running and needs to find the location of this bitmap to set bits itself?
>>
>> Or, do we just go whole-hog and have the kernel manage the bitmap
>> itself. Our interface here could be:
>>
>>    prctl(PR_MARK_CODE_AS_LEGACY, start, size);
>>
>> and then have the kernel allocate and set the bitmap for those code
>> locations.
> 
> Given that the format depends on the VA size, this might be a good
> idea.

Yeah, making userspace know how large the address space is or could be
is rather nasty, especially if we ever get any fancy CPU features that
eat up address bits (a la ARM top-byte-ignore or SPARC ADI).

> Hmm.  Can we be creative and skip populating it with zeros?  The CPU
should only ever touch a page if we miss an ENDBR on it, so, in normal
operation, we don’t need anything to be there.  We could try to prevent
anyone from *reading* it outside of ENDBR tracking if we want to avoid
people accidentally wasting lots of memory by forcing it to be fully
populated when the read it.

Won't reads on a big, contiguous private mapping get the huge zero page
anyway?

> The one downside is this forces it to be per-mm, but that seems like
> a generally reasonable model anyway.

Yeah, practically, you could only make it shared if you shared the
layout of all code in the address space.  I'm sure the big database(s)
do that cross-process, but I bet nobody else does.  User ASLR
practically guarantees that nobody can do this.

> This also gives us an excellent opportunity to make it read-only as
> seen from userspace to prevent exploits from just poking it full of
> ones before redirecting execution.

That would be fun.
