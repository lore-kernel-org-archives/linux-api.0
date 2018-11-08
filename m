From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: RFC: userspace exception fixups
Date: Thu, 8 Nov 2018 12:10:30 -0800
Message-ID: <7027c3dc-addb-1b96-027e-a57fccf1f812@intel.com>
References: <1541518670.7839.31.camel@intel.com>
 <AF4A5C77-0A79-403F-A205-0F93B7CD6E26@amacapital.net>
 <1541524750.7839.51.camel@intel.com>
 <22596E35-F5D1-4935-86AB-B510DCA0FABE@amacapital.net>
 <c9659222-efc6-b73a-ce48-30be8bdc5397@intel.com>
 <CALCETrWBV=1JbAKYn2Jy2LxkGZQvKRtFRnrWUMoejrwQe73VHw@mail.gmail.com>
 <b9c53669-cd27-e3bc-3d62-f47c77029c43@intel.com>
 <1C426267-492F-4AE7-8BE8-C7FE278531F9@amacapital.net>
 <209cf4a5-eda9-2495-539f-fed22252cf02@intel.com>
 <9B76E95B-5745-412E-8007-7FAA7F83D6FB@amacapital.net>
 <20181108195420.GA14715@linux.intel.com>
 <CALCETrUCQbPMfBJVRRg=0apEU=2U2ps74UPTrN8bFqi1k0K4VA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrUCQbPMfBJVRRg=0apEU=2U2ps74UPTrN8bFqi1k0K4VA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>, "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Cc: Andrew Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Rich Felker <dalias@libc.org>, Dave Hansen <dave.hansen@linux.intel.com>, Jethro Beekman <jethro@fortanix.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com, npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@>
List-Id: linux-api@vger.kernel.org

On 11/8/18 12:05 PM, Andy Lutomirski wrote:
> Hmm.  The idea being that the SDK preserves RBP but not RSP.  That's
> not the most terrible thing in the world.  But could the SDK live with
> something more like my suggestion where the vDSO supplies a normal
> function that takes a struct containing registers that are visible to
> the enclave?  This would make it extremely awkward for the enclave to
> use the untrusted stack per se, but it would make it quite easy (I
> think) for the untrusted part of the SDK to allocate some extra memory
> and just tell the enclave that *that* memory is the stack.

I really think the enclave should keep its grubby mitts off the
untrusted stack.  There are lots of ways to get memory, even with
stack-like semantics, that don't involve mucking with the stack itself.

I have not heard a good, hard argument for why there is an absolute
*need* to store things on the actual untrusted stack.

We could quite easily have the untrusted code just promise to allocate a
stack-sized virtual area (even derived from the stack rlimit size) and
pass that into the enclave for parameter use.
