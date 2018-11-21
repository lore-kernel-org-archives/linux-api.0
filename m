From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: RFC: userspace exception fixups
Date: Wed, 21 Nov 2018 17:17:34 +0200
Message-ID: <20181121151734.GA16564@linux.intel.com>
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
 <20181118071548.GA4795@linux.intel.com>
 <CALCETrXSpn7QGzPgO1BjMRQ75r2i0kmACrbUM+8PyT+xi3f3Hw@mail.gmail.com>
 <20181119160204.GD13298@linux.intel.com>
 <CALCETrWRVgPjnDd-CknskrXfNbke=rSnr_jezszNNWJUM_YJKQ@mail.gmail.com>
 <20181120101133.GA7319@linux.intel.com>
 <CALCETrU2dy7Oh+AHDGZ2omq9p7pNbjFd8ruv5CkfJXCp5nTYBQ@mail.gmail.com>
 <20181120225518.GE8391@linux.intel.com>
 <0a78772e-4f42-254b-d91a-f0f80a24ff90@fortanix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0a78772e-4f42-254b-d91a-f0f80a24ff90@fortanix.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jethro Beekman <jethro@fortanix.com>
Cc: Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, "Christopherson, Sean J" <sean.j.christopherson@intel.com>, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Rich Felker <dalias@libc.org>, "nhorman@redhat.com" <nhorman@redhat.com>, "npmccallum@redhat.com" <npmccallum@redhat.com>, "Ayoun, Serge" <serge.ayoun@intel.com>, "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>, "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.co>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 21, 2018 at 05:17:32AM +0000, Jethro Beekman wrote:
> Jarkko, can you please explain you solution in detail? The CPU receives an
> exception. This will be handled by the kernel exception handler. What
> information does the kernel exception handler use to determine whether to
> deliver the exception as a regular signal to the process, or whether to set
> the special registers values for userspace and just continue executing the
> process manually?

Now we throw SIGSEGV when PF_SGX set, right? In my solution that would
be turned just doing iret to AEP with the extra that three registers get
exception data (type, reason, addr). No decoding or RIP adjusting
involved.

That would mean that you would actually have to implement AEP handler
than just have enclu there.

I've also proposed that perhaps for SGX also #UD should be propagated
this way because for some instructions you need outside help to emulate
"non-enclave" environment.

That is all I have drafted together so far. I'll try to finish v18 this
week with other stuff and refine further next week (unless someone gives
obvious reason why this doesn't work, which might well be because I
haven't went too deep with my analysis yet because of lack of time).

/Jarkko
