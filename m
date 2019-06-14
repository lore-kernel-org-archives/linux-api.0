From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v7 03/14] x86/cet/ibt: Add IBT legacy code bitmap setup
 function
Date: Fri, 14 Jun 2019 09:13:16 -0700
Message-ID: <5ddf59e2-c701-3741-eaa1-f63ee741ea55@intel.com>
References: <20190606200926.4029-1-yu-cheng.yu@intel.com>
 <aa8a92ef231d512b5c9855ef416db050b5ab59a6.camel@intel.com>
 <20190607174336.GM3436@hirez.programming.kicks-ass.net>
 <b3de4110-5366-fdc7-a960-71dea543a42f@intel.com>
 <34E0D316-552A-401C-ABAA-5584B5BC98C5@amacapital.net>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cf0d1470e95e0a8b88742651d06601a53d6655c1.camel@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>, Andy Lutomirski <luto@amacapital.net>
Cc: Peter Zijlstra <peterz@infradead.org>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
List-Id: linux-api@vger.kernel.org

On 6/14/19 8:25 AM, Yu-cheng Yu wrote:
> On Mon, 2019-06-10 at 15:59 -0700, Dave Hansen wrote:
>> On 6/10/19 3:40 PM, Yu-cheng Yu wrote:
>>> Ok, we will go back to do_mmap() with MAP_PRIVATE, MAP_NORESERVE and
>>> VM_DONTDUMP.  The bitmap will cover only 48-bit address space.
>>
>> Could you make sure to discuss the downsides of only doing a 48-bit
>> address space?
> 
> The downside is that we cannot load legacy lib's above 48-bit address space, but
> currently ld-linux does not do that.  Should ld-linux do that in the future,
> dlopen() fails.  Considering CRIU migration, we probably need to do this anyway?

Again, I was thinking about JITs.  Please remember that not all code in
the system is from files on the disk.  Please.  We need to be really,
really sure that we don't addle this implementation by being narrow
minded about this.

Please don't forget about JITs.

>> What are the reasons behind and implications of VM_DONTDUMP?
> 
> The bitmap is very big.

Really?  It's actually, what, 8*4096=32k, so 1/32,768th of the size of
the libraries legacy libraries you load?  Do our crash dumps really not
know how to represent or deal with sparse mappings?

> In GDB, it should be easy to tell why a control-protection fault occurred
> without the bitmap.

How about why one didn't happen?
