From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: RFC: userspace exception fixups
Date: Sun, 18 Nov 2018 09:15:48 +0200
Message-ID: <20181118071548.GA4795@linux.intel.com>
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, "Christopherson, Sean J" <sean.j.christopherson@intel.com>, Jethro Beekman <jethro@fortanix.com>, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Rich Felker <dalias@libc.org>, nhorman@redhat.com, npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 01, 2018 at 10:53:40AM -0700, Andy Lutomirski wrote:
> Hi all-
> 
> The people working on SGX enablement are grappling with a somewhat
> annoying issue: the x86 EENTER instruction is used from user code and
> can, as part of its normal-ish operation, raise an exception.  It is
> also highly likely to be used from a library, and signal handling in
> libraries is unpleasant at best.
> 
> There's been some discussion of adding a vDSO entry point to wrap
> EENTER and do something sensible with the exceptions, but I'm
> wondering if a more general mechanism would be helpful.

I haven't really followed all of this discussion because I've been busy
working on the patch set but for me all of these approaches look awfully
complicated.

I'll throw my own suggestion and apologize if this has been already
suggested and discarded: return-to-AEP.

My idea is to do just a small extension to SGX AEX handling. At the
moment hardware will RAX, RBX and RCX with ERESUME parameters. We can
fill extend this by filling other three spare registers with exception
information.

AEP handler can then do whatever it wants to do with this information
or just do ERESUME.

In some ways this dummied version of Sean's suggestion.

I think whatever the solution is it should be lightweight and this is
such solution. Why? Because exception handling could be then used to
implement other stuff than just error hadling like syscall wrapper
for the enclaves in nice and lean way.

/Jarkko
