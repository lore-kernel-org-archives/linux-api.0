From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: RFC: userspace exception fixups
Date: Thu, 8 Nov 2018 17:04:05 +0200
Message-ID: <20181108150405.GB14072@linux.intel.com>
References: <CALCETrV=iodOQhvXAyjs0TQNbCaFdkhrZqRHvWTnBfo2m0qXpA@mail.gmail.com>
 <1541541565.8854.13.camel@intel.com>
 <7FF4802E-FBC5-4E6D-A8F6-8A65114F18C7@amacapital.net>
 <20181106233515.GB11101@linux.intel.com>
 <CALCETrVySfV64YN7DWf3rsAxfiugJKsRJCNmEn-AKQ4dPYeG4Q@mail.gmail.com>
 <20181107000235.GC11101@linux.intel.com>
 <CALCETrV_sMOeQGRkxoA8KMxEizagB9bD-mB2T-ro3F6O6OX9Xw@mail.gmail.com>
 <20181107153452.GB22972@linux.intel.com>
 <20181107190114.GA26603@linux.intel.com>
 <662fa2c8-c9a8-b2a8-ee8b-92a8a89c0630@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <662fa2c8-c9a8-b2a8-ee8b-92a8a89c0630@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@intel.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>, Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Rich Felker <dalias@libc.org>, Dave Hansen <dave.hansen@linux.intel.com>, Jethro Beekman <jethro@fortanix.com>, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com, npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav
List-Id: linux-api@vger.kernel.org

On Wed, Nov 07, 2018 at 12:56:58PM -0800, Dave Hansen wrote:
> On 11/7/18 11:01 AM, Sean Christopherson wrote:
> > Going off comments in similar code related to UMIP, we'd need to figure
> > out how to handle protection keys.
> 
> There are two options:
> 1. Don't depend on the userspace mapping.  Do get_user_pages() to find
>    the instruction in the kernel direct map, and use that.
> 2. Do a WRPKRU that allows read access, do the read, then put PKRU back.
>    This is a pain because of preemption and all that jazz.
> 
> Right now, we just let the prefetch instruction detection fail if you
> mark it unreadable with pkeys.  Tough cookies, basically.  But, that's
> just the kernel being nice, but you need it for functionality, so it's
> tougher.

I would go with one because it is the stable way to do it and we are
100% sure to not conflict with pk's.

/Jarkko
