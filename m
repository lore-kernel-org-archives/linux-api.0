From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: RFC: userspace exception fixups
Date: Mon, 26 Nov 2018 14:06:27 -0800
Message-ID: <20181126220627.GD868@linux.intel.com>
References: <20181118071548.GA4795@linux.intel.com>
 <CALCETrXSpn7QGzPgO1BjMRQ75r2i0kmACrbUM+8PyT+xi3f3Hw@mail.gmail.com>
 <20181119160204.GD13298@linux.intel.com>
 <CALCETrWRVgPjnDd-CknskrXfNbke=rSnr_jezszNNWJUM_YJKQ@mail.gmail.com>
 <20181120101133.GA7319@linux.intel.com>
 <CALCETrU2dy7Oh+AHDGZ2omq9p7pNbjFd8ruv5CkfJXCp5nTYBQ@mail.gmail.com>
 <20181120225518.GE8391@linux.intel.com>
 <0a78772e-4f42-254b-d91a-f0f80a24ff90@fortanix.com>
 <20181121151734.GA16564@linux.intel.com>
 <20181126143534.GA25719@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181126143534.GA25719@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Jethro Beekman <jethro@fortanix.com>, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Rich Felker <dalias@libc.org>, "nhorman@redhat.com" <nhorman@redhat.com>, "npmccallum@redhat.com" <npmccallum@redhat.com>, "Ayoun, Serge" <serge.ayoun@intel.com>, "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>, "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas
List-Id: linux-api@vger.kernel.org

On Mon, Nov 26, 2018 at 06:35:34AM -0800, Sean Christopherson wrote:
> And how would you determine the #UD is related to SGX?  Hardware doesn't
> provide any indication that a #UD (or any other fault) is related to SGX
> or occurred in an enclave.  The only fault that is special-cased in a
> non-virtualized environment is #PF signaled by the EPCM, which gets the
> PF_SGX bit set in the error code.

Could you not detect #UD from address where it happened? Kernel knows
where enclaves are mapped. BTW, how does Intel run-time emulate opcodes
currently?

Anyway, I've fully discarded the whole idea because implementing single
stepping w/o well defined AEP handler is nasty. I think vDSO's are the
only viable path that at least I'm aware off...

/Jarkko
