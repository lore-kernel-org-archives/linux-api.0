From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: RFC: userspace exception fixups
Date: Fri, 2 Nov 2018 09:56:44 -0700
Message-ID: <7050972d-a874-dc08-3214-93e81181da60@intel.com>
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
 <CAG48ez0vBqL0tyfWwmuc_cq+OAUoEi88=r+t6h64a-Fw8z59zA@mail.gmail.com>
 <20181101185225.GC5150@brightrain.aerifal.cx>
 <CAHk-=wgFo8tuZX5gzCfWGdAwGyn_Ar9JFnnMFNuwr9=vtfDV1g@mail.gmail.com>
 <20181101193107.GE5150@brightrain.aerifal.cx>
 <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
 <CALCETrWe4+apXJNswHAKVVqajGS3jTEKxdd2r3iu-MzGK1v0DA@mail.gmail.com>
 <20181102163034.GB7393@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181102163034.GB7393@linux.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Sean Christopherson <sean.j.christopherson@intel.com>, Andy Lutomirski <luto@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Rich Felker <dalias@libc.org>, Jann Horn <jannh@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jethro Beekman <jethro@fortanix.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com, npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Carlos O'Donell <carlos@r>
List-Id: linux-api@vger.kernel.org

On 11/2/18 9:30 AM, Sean Christopherson wrote:
> What if rather than having userspace register an address for fixup, the
> kernel instead unconditionally does fixup on the ENCLU opcode?

The problem is knowing what to do for the fixup.  If we have a simple
action to take that's universal, like backing up %RIP, or setting some
other register state, it's not bad.

Think of our prefetch fixups in the page fault code.  We do some
instruction decoding to look for them, and then largely return from the
fault and let the CPU retry.  We know *exactly* what to do for these.

But, if we need to call arbitrary code, or switch stacks, we need an
explicit ABI around it *anyway*, because the action to take isn't clear.

For an enclave exit that's because of a hardware interrupt or page
fault, life is good.  We really *could* just set %RIP to let ERESUME run
again, kinda like we do for (some) syscall situations.  But the
situations for which we can't just call ERESUME, like the out-calls make
this more challenging.  I think we'd need some explicit new interfaces
for those.
