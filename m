From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: RFC: userspace exception fixups
Date: Thu, 8 Nov 2018 13:50:31 -0800
Message-ID: <7d965299-0402-f730-6e1a-515a836a3956@intel.com>
References: <22596E35-F5D1-4935-86AB-B510DCA0FABE@amacapital.net>
 <c9659222-efc6-b73a-ce48-30be8bdc5397@intel.com>
 <CALCETrWBV=1JbAKYn2Jy2LxkGZQvKRtFRnrWUMoejrwQe73VHw@mail.gmail.com>
 <b9c53669-cd27-e3bc-3d62-f47c77029c43@intel.com>
 <1C426267-492F-4AE7-8BE8-C7FE278531F9@amacapital.net>
 <209cf4a5-eda9-2495-539f-fed22252cf02@intel.com>
 <9B76E95B-5745-412E-8007-7FAA7F83D6FB@amacapital.net>
 <20181108195420.GA14715@linux.intel.com>
 <CALCETrUCQbPMfBJVRRg=0apEU=2U2ps74UPTrN8bFqi1k0K4VA@mail.gmail.com>
 <7027c3dc-addb-1b96-027e-a57fccf1f812@intel.com>
 <20181108211600.GA17167@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181108211600.GA17167@linux.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Andrew Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Rich Felker <dalias@libc.org>, Dave Hansen <dave.hansen@linux.intel.com>, Jethro Beekman <jethro@fortanix.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com, npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-api@vger.kernel.org

On 11/8/18 1:16 PM, Sean Christopherson wrote:
> On Thu, Nov 08, 2018 at 12:10:30PM -0800, Dave Hansen wrote:
>> On 11/8/18 12:05 PM, Andy Lutomirski wrote:
>>> Hmm.  The idea being that the SDK preserves RBP but not RSP.  That's
>>> not the most terrible thing in the world.  But could the SDK live with
>>> something more like my suggestion where the vDSO supplies a normal
>>> function that takes a struct containing registers that are visible to
>>> the enclave?  This would make it extremely awkward for the enclave to
>>> use the untrusted stack per se, but it would make it quite easy (I
>>> think) for the untrusted part of the SDK to allocate some extra memory
>>> and just tell the enclave that *that* memory is the stack.
>>
>> I really think the enclave should keep its grubby mitts off the
>> untrusted stack.  There are lots of ways to get memory, even with
>> stack-like semantics, that don't involve mucking with the stack itself.
>>
>> I have not heard a good, hard argument for why there is an absolute
>> *need* to store things on the actual untrusted stack.
> 
> Convenience and performance are the only arguments I've heard, e.g. so
> that allocating memory doesn't require an extra EEXIT->EENTER round trip.

Well, for the first access, it's going to cost a bunch asynchronous
exits to fault in all the stack pages.  Instead of that, if you had a
single area, or an explicit out-call to allocate and populate the area,
you could do it in a single EEXIT and zero asynchronous exits for demand
page faults.

So, it might be convenient, but I'm rather suspicious of any performance
arguments.
