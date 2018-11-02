From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: RFC: userspace exception fixups
Date: Fri, 2 Nov 2018 10:13:23 -0700
Message-ID: <a4d2b3ec-43ec-f062-e180-c6e5a0d9fab8@intel.com>
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
 <CAG48ez0vBqL0tyfWwmuc_cq+OAUoEi88=r+t6h64a-Fw8z59zA@mail.gmail.com>
 <20181101185225.GC5150@brightrain.aerifal.cx>
 <CAHk-=wgFo8tuZX5gzCfWGdAwGyn_Ar9JFnnMFNuwr9=vtfDV1g@mail.gmail.com>
 <20181101193107.GE5150@brightrain.aerifal.cx>
 <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
 <CALCETrWe4+apXJNswHAKVVqajGS3jTEKxdd2r3iu-MzGK1v0DA@mail.gmail.com>
 <20181102163034.GB7393@linux.intel.com>
 <7050972d-a874-dc08-3214-93e81181da60@intel.com>
 <20181102170627.GD7393@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181102170627.GD7393@linux.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Rich Felker <dalias@libc.org>, Jann Horn <jannh@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jethro Beekman <jethro@fortanix.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com, npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@al>
List-Id: linux-api@vger.kernel.org

On 11/2/18 10:06 AM, Sean Christopherson wrote:
> On Fri, Nov 02, 2018 at 09:56:44AM -0700, Dave Hansen wrote:
>> On 11/2/18 9:30 AM, Sean Christopherson wrote:
>>> What if rather than having userspace register an address for fixup, the
>>> kernel instead unconditionally does fixup on the ENCLU opcode?
>>
>> The problem is knowing what to do for the fixup.  If we have a simple
>> action to take that's universal, like backing up %RIP, or setting some
>> other register state, it's not bad.
> 
> Isn't the EENTER/RESUME behavior universal?  Or am I missing something?

Could someone write down all the ways we get in and out of the enclave?

I think we always get in from userspace calling EENTER or ERESUME.  We
can't ever enter directly from the kernel, like via an IRET from what I
understand.

We get *out* from exceptions, hardware interrupts, or enclave-explicit
EEXITs.  Did I miss any?  Remind me where the hardware lands the control
flow in each of those exit cases.
