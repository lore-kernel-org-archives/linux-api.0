From: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: RFC: userspace exception fixups
Date: Fri, 2 Nov 2018 10:12:51 -0700
Message-ID: <20181102171251.GE7393@linux.intel.com>
References: <CAG48ez0vBqL0tyfWwmuc_cq+OAUoEi88=r+t6h64a-Fw8z59zA@mail.gmail.com>
 <20181101185225.GC5150@brightrain.aerifal.cx>
 <CAHk-=wgFo8tuZX5gzCfWGdAwGyn_Ar9JFnnMFNuwr9=vtfDV1g@mail.gmail.com>
 <20181101193107.GE5150@brightrain.aerifal.cx>
 <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
 <CALCETrWe4+apXJNswHAKVVqajGS3jTEKxdd2r3iu-MzGK1v0DA@mail.gmail.com>
 <20181102163034.GB7393@linux.intel.com>
 <7e14ee0e-ce15-1e88-7ae9-4d0f40cb3d84@fortanix.com>
 <20181102165204.GC7393@linux.intel.com>
 <dd455b30-b586-bf5b-2195-cf20c1af9890@fortanix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dd455b30-b586-bf5b-2195-cf20c1af9890@fortanix.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jethro Beekman <jethro@fortanix.com>
Cc: Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Rich Felker <dalias@libc.org>, Jann Horn <jannh@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "nhorman@redhat.com" <nhorman@redhat.com>, "npmccallum@redhat.com" <npmccallum@redhat.com>, "Ayoun, Serge" <serge.ayoun@intel.com>, "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>, "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas
List-Id: linux-api@vger.kernel.org

On Fri, Nov 02, 2018 at 04:56:36PM +0000, Jethro Beekman wrote:
> On 2018-11-02 09:52, Sean Christopherson wrote:
> >On Fri, Nov 02, 2018 at 04:37:10PM +0000, Jethro Beekman wrote:
> >>On 2018-11-02 09:30, Sean Christopherson wrote:
> >>>... The intended convention for EENTER is to have an ENCLU at the AEX target ...
> >>>
> >>>... to further enforce that the AEX target needs to be ENCLU.
> >>
> >>Some SGX runtimes may want to use a different AEX target.
> >
> >To what end?  Userspace gets no indication as to why the AEX occurred.
> >And if exceptions are getting transfered to userspace the trampoline
> >would effectively be handling only INTR, NMI, #MC and EPC #PF.
> >
> 
> Various reasons...
> 
> Userspace may have established an exception handling convention with the
> enclave (by setting TCS.NSSA > 1) and may want to call EENTER instead of
> ERESUME.

The ERESUME trampoline would only be invoked for exceptions that aren't
transferred to userspace.  On #BR, #UD, etc..., the kernel would fixup
%RIP to effectively point at @fault_handler.  Userspace can then do
whatever it wants to handle the fault, e.g. do EENTER if the fault needs
to be serviced by the enclave.

> Userspace may want fine-grained control over enclave scheduling (e.g.
> SGX-Step)

Uh, isn't SGX-Step an attack on SGX?  Preventing userspace from playing
games with enclave scheduling seems like a good thing.
