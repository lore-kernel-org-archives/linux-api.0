From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: RFC: userspace exception fixups
Date: Wed, 7 Nov 2018 12:56:58 -0800
Message-ID: <662fa2c8-c9a8-b2a8-ee8b-92a8a89c0630@intel.com>
References: <209cf4a5-eda9-2495-539f-fed22252cf02@intel.com>
 <9B76E95B-5745-412E-8007-7FAA7F83D6FB@amacapital.net>
 <CALCETrV=iodOQhvXAyjs0TQNbCaFdkhrZqRHvWTnBfo2m0qXpA@mail.gmail.com>
 <1541541565.8854.13.camel@intel.com>
 <7FF4802E-FBC5-4E6D-A8F6-8A65114F18C7@amacapital.net>
 <20181106233515.GB11101@linux.intel.com>
 <CALCETrVySfV64YN7DWf3rsAxfiugJKsRJCNmEn-AKQ4dPYeG4Q@mail.gmail.com>
 <20181107000235.GC11101@linux.intel.com>
 <CALCETrV_sMOeQGRkxoA8KMxEizagB9bD-mB2T-ro3F6O6OX9Xw@mail.gmail.com>
 <20181107153452.GB22972@linux.intel.com>
 <20181107190114.GA26603@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181107190114.GA26603@linux.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Sean Christopherson <sean.j.christopherson@intel.com>, Andy Lutomirski <luto@kernel.org>
Cc: Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Rich Felker <dalias@libc.org>, Dave Hansen <dave.hansen@linux.intel.com>, Jethro Beekman <jethro@fortanix.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com, npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
List-Id: linux-api@vger.kernel.org

On 11/7/18 11:01 AM, Sean Christopherson wrote:
> Going off comments in similar code related to UMIP, we'd need to figure
> out how to handle protection keys.

There are two options:
1. Don't depend on the userspace mapping.  Do get_user_pages() to find
   the instruction in the kernel direct map, and use that.
2. Do a WRPKRU that allows read access, do the read, then put PKRU back.
   This is a pain because of preemption and all that jazz.

Right now, we just let the prefetch instruction detection fail if you
mark it unreadable with pkeys.  Tough cookies, basically.  But, that's
just the kernel being nice, but you need it for functionality, so it's
tougher.
