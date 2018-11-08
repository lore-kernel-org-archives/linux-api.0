From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: RFC: userspace exception fixups
Date: Thu, 8 Nov 2018 17:11:56 +0200
Message-ID: <20181108151156.GC14072@linux.intel.com>
References: <1541518670.7839.31.camel@intel.com>
 <AF4A5C77-0A79-403F-A205-0F93B7CD6E26@amacapital.net>
 <1541524750.7839.51.camel@intel.com>
 <22596E35-F5D1-4935-86AB-B510DCA0FABE@amacapital.net>
 <c9659222-efc6-b73a-ce48-30be8bdc5397@intel.com>
 <CALCETrWBV=1JbAKYn2Jy2LxkGZQvKRtFRnrWUMoejrwQe73VHw@mail.gmail.com>
 <20181106231730.GR5150@brightrain.aerifal.cx>
 <20181106232616.GA11101@linux.intel.com>
 <20181107212758.GU5150@brightrain.aerifal.cx>
 <20181107214058.GG27170@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181107214058.GG27170@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Rich Felker <dalias@libc.org>, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Hansen <dave.hansen@linux.intel.com>, Jethro Beekman <jethro@fortanix.com>, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com, npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 07, 2018 at 01:40:59PM -0800, Sean Christopherson wrote:
> > In that case it seems like the only way to use SGX that's not a gaping
> > security hole is to run the SGX enclave in its own fully-seccomp (or
> > equivalent) process, with no host application in the same address
> > space. Since the host application can't see the contents of the
> > enclave to make any determination of whether it's safe to run, running
> > it in the same address space only makes sense if the cpu provides
> > protection against unwanted accesses to the host's memory from the
> > enclave -- and according to you, it doesn't.
> 
> The enclave's code (and any initial data) isn't encrypted until the
> pages are loaded into the Enclave Page Cache (EPC), which can only
> be done by the kernel (via ENCLS[EADD]).  In other words, both the
> kernel and userspace can vet the code/data before running an enclave.
> 
> Practically speaking, an enclave will be coupled with an untrusted
> userspace runtime, i.e. it's loader.  Enclaves are also measured
> as part of their build process, and so the enclave loader needs to
> know which pages to add to the measurement, and in what order.  I
> guess technically speaking an enclave could have zero pages added
> to its measurement, but that'd probably be a big red flag that said
> enclave is up to something fishy.

IMHO the whole idea adds too much policy into kernel even if it would
be doable. You can easily spawn untrusted run-time and enclave to its
own process.

Seccomp limits the syscall space and enclaves cannot do syscalls in the
first place. It is the URT that will do them behalf of the enclave.

/Jarkko
