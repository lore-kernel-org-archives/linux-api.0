From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v7 03/14] x86/cet/ibt: Add IBT legacy code bitmap setup
 function
Date: Fri, 14 Jun 2019 15:06:12 -0700
Message-ID: <5d7012f6-7ab9-fd3d-4a11-294258e48fb5@intel.com>
References: <20190606200926.4029-1-yu-cheng.yu@intel.com>
 <7e0b97bf1fbe6ff20653a8e4e147c6285cc5552d.camel@intel.com>
 <25281DB3-FCE4-40C2-BADB-B3B05C5F8DD3@amacapital.net>
 <e26f7d09376740a5f7e8360fac4805488b2c0a4f.camel@intel.com>
 <3f19582d-78b1-5849-ffd0-53e8ca747c0d@intel.com>
 <5aa98999b1343f34828414b74261201886ec4591.camel@intel.com>
 <0665416d-9999-b394-df17-f2a5e1408130@intel.com>
 <5c8727dde9653402eea97bfdd030c479d1e8dd99.camel@intel.com>
 <ac9a20a6-170a-694e-beeb-605a17195034@intel.com>
 <328275c9b43c06809c9937c83d25126a6e3efcbd.camel@intel.com>
 <92e56b28-0cd4-e3f4-867b-639d9b98b86c@intel.com>
 <1b961c71d30e31ecb22da2c5401b1a81cb802d86.camel@intel.com>
 <ea5e333f-8cd6-8396-635f-a9dc580d5364@intel.com>
 <cf0d1470e95e0a8b88742651d06601a53d6655c1.camel@intel.com>
 <5ddf59e2-c701-3741-eaa1-f63ee741ea55@intel.com>
 <b5a915602020a6ce26ea1254f7f60e239c91bc9f.camel@intel.com>
 <598edca7-c36a-a236-3b72-08b2194eb609@intel.com>
 <359e6f64d646d5305c52f393db5296c469630d11.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <359e6f64d646d5305c52f393db5296c469630d11.camel@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>, Andy Lutomirski <luto@amacapital.net>
Cc: Peter Zijlstra <peterz@infradead.org>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
List-Id: linux-api@vger.kernel.org

On 6/14/19 2:34 PM, Yu-cheng Yu wrote:
> On Fri, 2019-06-14 at 13:57 -0700, Dave Hansen wrote:
>>> I have a related question:
>>>
>>> Do we allow the application to read the bitmap, or any fault from the
>>> application on bitmap pages?
>>
>> We have to allow apps to read it.  Otherwise they can't execute
>> instructions.
> 
> What I meant was, if an app executes some legacy code that results in bitmap
> lookup, but the bitmap page is not yet populated, and if we then populate that
> page with all-zero, a #CP should follow.  So do we even populate that zero page
> at all?
> 
> I think we should; a #CP is more obvious to the user at least.

Please make an effort to un-Intel-ificate your messages as much as
possible.  I'd really prefer that folks say "missing end branch fault"
rather than #CP.  I had to Google "#CP".

I *think* you are saying that:  The *only* lookups to this bitmap are on
"missing end branch" conditions.  Normal, proper-functioning code
execution that has ENDBR instructions in it will never even look at the
bitmap.  The only case when we reference the bitmap locations is when
the processor is about do do a "missing end branch fault" so that it can
be suppressed.  Any population with the zero page would be done when
code had already encountered a "missing end branch" condition, and
populating with a zero-filled page will guarantee that a "missing end
branch fault" will result.  You're arguing that we should just figure
this out at fault time and not ever reach the "missing end branch fault"
at all.

Is that right?

If so, that's an architecture subtlety that I missed until now and which
went entirely unmentioned in the changelog and discussion up to this
point.  Let's make sure that nobody else has to walk that path by
improving our changelog, please.

In any case, I don't think this is worth special-casing our zero-fill
code, FWIW.  It's not performance critical and not worth the complexity.
 If apps want to handle the signals and abuse this to fill space up with
boring page table contents, they're welcome to.  There are much easier
ways to consume a lot of memory.

>> We don't have to allow them to (popuating) fault on it.  But, if we
>> don't, we need some kind of kernel interface to avoid the faults.
> 
> The plan is:
> 
> * Move STACK_TOP (and vdso) down to give space to the bitmap.

Even for apps with 57-bit address spaces?

> * Reserve the bitmap space from (mm->start_stack + PAGE_SIZE) to cover a code
> size of TASK_SIZE_LOW, which is (TASK_SIZE_LOW / PAGE_SIZE / 8).

The bitmap size is determined by CR4.LA57, not the app.  If you place
the bitmap here, won't references to it for high addresses go into the
high address space?

Specifically, on a CR4.LA57=0 system, we have 48 bits of address space,
so 128TB for apps.  You are proposing sticking the bitmap above the
stack which is near the top of that 128TB address space.  But on a
5-level paging system with CR4.LA57=1, there could be valid data at
129GB.  Is there something keeping that data from being mistaken for
being part of the bitmap?

Also, if you're limiting it to TASK_SIZE_LOW, please don't forget that
this is yet another thing that probably won't work with the vsyscall
page.  Please make sure you consider it and mention it in your next post.

> * Mmap the space only when the app issues the first mark-legacy prctl.  This
> avoids the core-dump issue for most apps and the accounting problem that
> MAP_NORESERVE probably won't solve completely.

What is this accounting problem?
