From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v7 03/14] x86/cet/ibt: Add IBT legacy code bitmap setup
 function
Date: Mon, 10 Jun 2019 10:59:48 -0700
Message-ID: <0e07f346-89c7-ccf1-9d38-854a8e7d25a1@intel.com>
References: <20190606200926.4029-1-yu-cheng.yu@intel.com>
 <20190606200926.4029-4-yu-cheng.yu@intel.com>
 <20190607080832.GT3419@hirez.programming.kicks-ass.net>
 <aa8a92ef231d512b5c9855ef416db050b5ab59a6.camel@intel.com>
 <20190607174336.GM3436@hirez.programming.kicks-ass.net>
 <b3de4110-5366-fdc7-a960-71dea543a42f@intel.com>
 <34E0D316-552A-401C-ABAA-5584B5BC98C5@amacapital.net>
 <7e0b97bf1fbe6ff20653a8e4e147c6285cc5552d.camel@intel.com>
 <4b448cde-ee4e-1c95-0f7f-4fe694be7db6@intel.com>
 <0e505563f7dae3849b57fb327f578f41b760b6f7.camel@intel.com>
 <f6de9073-9939-a20d-2196-25fa223cf3fc@intel.com>
 <5dc357f5858f8036cad5847cfe214401bb9138bf.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5dc357f5858f8036cad5847cfe214401bb9138bf.camel@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>, Andy Lutomirski <luto@amacapital.net>
Cc: Peter Zijlstra <peterz@infradead.org>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
List-Id: linux-api@vger.kernel.org

On 6/10/19 9:05 AM, Yu-cheng Yu wrote:
> On Fri, 2019-06-07 at 14:09 -0700, Dave Hansen wrote:
>> On 6/7/19 1:06 PM, Yu-cheng Yu wrote:
>>>> Huh, how does glibc know about all possible past and future legacy code
>>>> in the application?
>>> When dlopen() gets a legacy binary and the policy allows that, it will
>>> manage
>>> the bitmap:
>>>
>>>   If a bitmap has not been created, create one.
>>>   Set bits for the legacy code being loaded.
>> I was thinking about code that doesn't go through GLIBC like JITs.
> If JIT manages the bitmap, it knows where it is.
> It can always read the bitmap again, right?

Let's just be clear:

The design proposed here is that all code mappers (anybody wanting to
get legacy non-CET code into the address space):

1. Know about CET
2. Know where the bitmap is, and identify the part that needs to be
   changed
3. Be able to mprotect() the bitmap to be writable (undoing glibc's
   PROT_READ)
4. Set the bits in the bitmap for the legacy code
5. mprotect() the bitmap back to PROT_READ

Do the non-glibc code mappers have glibc interfaces for this?
Otherwise, how could a bunch of JITs in a big multi-threaded application
possibly coordinate the mprotect()s?  Won't they race with each other?
