From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: RFC: userspace exception fixups
Date: Tue, 20 Nov 2018 12:11:33 +0200
Message-ID: <20181120101133.GA7319@linux.intel.com>
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
 <20181118071548.GA4795@linux.intel.com>
 <CALCETrXSpn7QGzPgO1BjMRQ75r2i0kmACrbUM+8PyT+xi3f3Hw@mail.gmail.com>
 <20181119160204.GD13298@linux.intel.com>
 <CALCETrWRVgPjnDd-CknskrXfNbke=rSnr_jezszNNWJUM_YJKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWRVgPjnDd-CknskrXfNbke=rSnr_jezszNNWJUM_YJKQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, "Christopherson, Sean J" <sean.j.christopherson@intel.com>, Jethro Beekman <jethro@fortanix.com>, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Rich Felker <dalias@libc.org>, nhorman@redhat.com, npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 19, 2018 at 09:00:08AM -0800, Andy Lutomirski wrote:
> On Mon, Nov 19, 2018 at 8:02 AM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > On Mon, Nov 19, 2018 at 07:29:36AM -0800, Andy Lutomirski wrote:
> > > 1. The kernel needs some way to know *when* to apply this fixup.
> > > Decoding the instruction stream and doing it to all exceptions that
> > > hit an ENCLU instruction seems like a poor design.
> >
> > I'm not sure why you would ever need to do any type of fixup as the idea
> > is to just return to AEP i.e. from chosen exceptions (EPCM, #UD) the AEP
> > would work the same way as for exceptions that the kernel can deal with
> > except filling the exception information to registers.
> 
> Sure, but how does the kernel know when to do that and when to send a
> signal?  I don't really like decoding the instruction stream to figure
> it out.

Hmm... why you have to decode instruction stream to find that out? Would
just depend on exception type (#GP with EPCM, #UD). Or are you saying
that kernel should need to SIGSEGV if there is in fact ENCLU so that
there is no infinite trap loop? Sorry, I'm a bit lost here that where
does this decoding requirement comes from in the first place. I
understand how it is used in Sean's proposal...

Anyway, this option can be probably discarded without further
consideration because apparently single stepping can cause #DB SS fault
if AEP handler is anything else than a single instruction.

For me it seems that by ruling out options, vDSO option is what is
left. I don't like it but at least it works...

/Jarkko
