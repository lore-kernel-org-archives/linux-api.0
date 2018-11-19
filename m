From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: RFC: userspace exception fixups
Date: Mon, 19 Nov 2018 16:59:16 +0200
Message-ID: <20181119145916.GA11723@linux.intel.com>
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
 <20181118071548.GA4795@linux.intel.com>
 <20181118130203.GA18934@linux.intel.com>
 <ce304dba-0b02-02e2-4de8-212cd3bd1876@fortanix.com>
 <20181119140543.GF8755@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181119140543.GF8755@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jethro Beekman <jethro@fortanix.com>
Cc: Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, "Christopherson, Sean J" <sean.j.christopherson@intel.com>, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Rich Felker <dalias@libc.org>, "nhorman@redhat.com" <nhorman@redhat.com>, "npmccallum@redhat.com" <npmccallum@redhat.com>, "Ayoun, Serge" <serge.ayoun@intel.com>, "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>, "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.co>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 19, 2018 at 04:05:43PM +0200, Jarkko Sakkinen wrote:
> On Mon, Nov 19, 2018 at 05:17:26AM +0000, Jethro Beekman wrote:
> > On 2018-11-18 18:32, Jarkko Sakkinen wrote:
> > > On Sun, Nov 18, 2018 at 09:15:48AM +0200, Jarkko Sakkinen wrote:
> > > > On Thu, Nov 01, 2018 at 10:53:40AM -0700, Andy Lutomirski wrote:
> > > > > Hi all-
> > > > > 
> > > > > The people working on SGX enablement are grappling with a somewhat
> > > > > annoying issue: the x86 EENTER instruction is used from user code and
> > > > > can, as part of its normal-ish operation, raise an exception.  It is
> > > > > also highly likely to be used from a library, and signal handling in
> > > > > libraries is unpleasant at best.
> > > > > 
> > > > > There's been some discussion of adding a vDSO entry point to wrap
> > > > > EENTER and do something sensible with the exceptions, but I'm
> > > > > wondering if a more general mechanism would be helpful.
> > > > 
> > > > I haven't really followed all of this discussion because I've been busy
> > > > working on the patch set but for me all of these approaches look awfully
> > > > complicated.
> > > > 
> > > > I'll throw my own suggestion and apologize if this has been already
> > > > suggested and discarded: return-to-AEP.
> > > > 
> > > > My idea is to do just a small extension to SGX AEX handling. At the
> > > > moment hardware will RAX, RBX and RCX with ERESUME parameters. We can
> > > > fill extend this by filling other three spare registers with exception
> > > > information.
> > > > 
> > > > AEP handler can then do whatever it wants to do with this information
> > > > or just do ERESUME.
> > > 
> > > A correction here. In practice this will add a requirement to have a bit
> > > more complicated AEP code (check the regs for exceptions) than before
> > > and not just bytes for ENCLU.
> > > 
> > > e.g. AEP handler should be along the lines
> > > 
> > > 1. #PF (or #UD or) happens. Kernel fills the registers when it cannot
> > >     handle the exception and returns back to user space i.e. to the
> > >     AEP handler.
> > > 2. Check the registers containing exception information. If they have
> > >     been filled, take whatever actions user space wants to take.
> > > 3. Otherwise, just ERESUME.
> > > 
> > >  From my point of view this is making the AEP parameter useful. Its
> > > standard use is just weird (always point to a place just containing
> > > ENCLU bytes, why the heck it even exists).
> > 
> > I like this solution. Keeps things simple. One question: when an exception
> > occurs, how does the kernel know whether to set special registers or send a
> > signal?
> 
> Yes, and AFAIK people do in many cases people want to do something else
> than just direct ERESUME in AEP handler so would neither be a major
> bummer for user space. If I remember correctly you have such?
> 
> You can check the cases that we have for SIGSEGV (namely EPCM conflict)
> from Sean's patch 08/23.
> 
> I'm open for expanding the scope. It is the easy part after there is
> consensus for the handling mechanism :-)

Not sure if it a good idea or not but maybe even have new ioctl in
addition to the enclave construction ioctls that you use to specify per
enclave what you want to get. SIGSEGV could be the fallback behavior if
you do not "register" to any exceptions.

/Jarkko
