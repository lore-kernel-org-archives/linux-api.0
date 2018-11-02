From: Jann Horn <jannh@google.com>
Subject: Re: RFC: userspace exception fixups
Date: Fri, 2 Nov 2018 20:02:23 +0100
Message-ID: <CAG48ez0x7ZPcKvLt01WS-VrLm59WfvYE3nE1xbnyn3Qsp5T2rA@mail.gmail.com>
References: <CAHk-=wgFo8tuZX5gzCfWGdAwGyn_Ar9JFnnMFNuwr9=vtfDV1g@mail.gmail.com>
 <20181101193107.GE5150@brightrain.aerifal.cx> <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
 <CALCETrWe4+apXJNswHAKVVqajGS3jTEKxdd2r3iu-MzGK1v0DA@mail.gmail.com>
 <20181102163034.GB7393@linux.intel.com> <7050972d-a874-dc08-3214-93e81181da60@intel.com>
 <20181102170627.GD7393@linux.intel.com> <a4d2b3ec-43ec-f062-e180-c6e5a0d9fab8@intel.com>
 <20181102173350.GF7393@linux.intel.com> <CALCETrUQVPN0LSEz+5aNsbfFc=rQ33JHiOoRXVbvEEb9is9DDQ@mail.gmail.com>
 <20181102182712.GG7393@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181102182712.GG7393@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: sean.j.christopherson@intel.com
Cc: Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, dalias@libc.org, Dave Hansen <dave.hansen@linux.intel.com>, jethro@fortanix.com, jarkko.sakkinen@linux.intel.com, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, andriy.shevchenko@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, carlos@redhat.com, adhemerval.za
List-Id: linux-api@vger.kernel.org

On Fri, Nov 2, 2018 at 7:27 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
> On Fri, Nov 02, 2018 at 10:48:38AM -0700, Andy Lutomirski wrote:
> > This whole mechanism seems very complicated, and it's not clear
> > exactly what behavior user code wants.
>
> No argument there.  That's why I like the approach of dumping the
> exception to userspace without trying to do anything intelligent in
> the kernel.  Userspace can then do whatever it wants AND we don't
> have to worry about mucking with stacks.
>
> One of the hiccups with the VDSO approach is that the enclave may
> want to use the untrusted stack, i.e. the stack that has the VDSO's
> stack frame.  For example, Intel's SDK uses the untrusted stack to
> pass parameters for EEXIT, which means an AEX might occur with what
> is effectively a bad stack from the VDSO's perspective.

What exactly does "uses the untrusted stack to pass parameters for
EEXIT" mean? I guess you're saying that the enclave is writing to
RSP+[0...some_positive_offset], and the written data needs to be
visible to the code outside the enclave afterwards?

In other words, the vDSO helper would have to not touch the stack
pointer (only using the 128-byte redzone to store spilled data, at
least across the enclave entry), and return by decrementing the stack
pointer by 8 immediately before returning (storing the return pointer
in the redzone)?

So you'd call the vDSO helper with a normal "call
vdso_helper_address", then the vDSO helper does "add rsp, 8", then the
vDSO helper does its magic, and then it returns with "sub rsp, 8" and
"ret"? That way you don't touch anything on the high-address side of
RSP while still avoiding running into CET problems. (I'm assuming that
you can use CET in a process that is hosting SGX enclaves?)
