From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v7 03/14] x86/cet/ibt: Add IBT legacy code bitmap setup
 function
Date: Fri, 7 Jun 2019 14:05:29 -0700
Message-ID: <74620397-a839-cb8c-8c8b-fe72b921803c@intel.com>
References: <20190606200926.4029-1-yu-cheng.yu@intel.com>
 <20190606200926.4029-4-yu-cheng.yu@intel.com>
 <20190607080832.GT3419@hirez.programming.kicks-ass.net>
 <aa8a92ef231d512b5c9855ef416db050b5ab59a6.camel@intel.com>
 <20190607174336.GM3436@hirez.programming.kicks-ass.net>
 <b3de4110-5366-fdc7-a960-71dea543a42f@intel.com>
 <34E0D316-552A-401C-ABAA-5584B5BC98C5@amacapital.net>
 <352e6172-938d-f8e4-c195-9fd1b881bdee@intel.com>
 <D10B5B59-1BE7-44DC-8E91-C8E4292DC6FB@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <D10B5B59-1BE7-44DC-8E91-C8E4292DC6FB@amacapital.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>
List-Id: linux-api@vger.kernel.org

On 6/7/19 1:40 PM, Andy Lutomirski wrote:
>>> Hmm.  Can we be creative and skip populating it with zeros?  The
>>> CPU
>> should only ever touch a page if we miss an ENDBR on it, so, in
>> normal operation, we don’t need anything to be there.  We could try
>> to prevent anyone from *reading* it outside of ENDBR tracking if we
>> want to avoid people accidentally wasting lots of memory by forcing
>> it to be fully populated when the read it.
>> 
>> Won't reads on a big, contiguous private mapping get the huge zero
>> page anyway?
> 
> The zero pages may be free, but the page tables could be decently
large.  Does the core mm code use huge, immense, etc huge zero pages?
Or can it synthesize them by reusing page table pages that map zeros?

IIRC, we only ever fill single PMDs, even though we could gang a pmd
page up and do it for 1GB areas too.

I guess the page table consumption could really suck if we had code all
over the 57-bit address space and that code moved around and the process
ran for a long long time.  Pathologically, we need a ulong/pmd_t for
each 2MB of address space which is 8*2^56-30=512GB per process.  Yikes.
 Right now, we'd at least detect the memory consumption and OOM-kill the
process(es) eventually.  But, that's not really _this_ patch's problem.
 It's a general problem, and doesn't even require the zero page to be
mapped all over.

Longer-term, I'd much rather see us add some page table reclaim
mechanism that new how to go after things like excessive page tables  in
MAP_NORESERVE areas.
