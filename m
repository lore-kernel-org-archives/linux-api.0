From: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: RFC: userspace exception fixups
Date: Wed, 7 Nov 2018 11:01:15 -0800
Message-ID: <20181107190114.GA26603@linux.intel.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181107153452.GB22972@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Rich Felker <dalias@libc.org>, Dave Hansen <dave.hansen@linux.intel.com>, Jethro Beekman <jethro@fortanix.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com, npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 07, 2018 at 07:34:52AM -0800, Sean Christopherson wrote:
> On Tue, Nov 06, 2018 at 05:17:14PM -0800, Andy Lutomirski wrote:
> > On Tue, Nov 6, 2018 at 4:02 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > On Tue, Nov 06, 2018 at 03:39:48PM -0800, Andy Lutomirski wrote:
> > > > On Tue, Nov 6, 2018 at 3:35 PM Sean Christopherson
> > > > <sean.j.christopherson@intel.com> wrote:
> > > > >
> > > > > Sorry if I'm beating a dead horse, but what if we only did fixup on ENCLU
> > > > > with a specific (ignored) prefix pattern?  I.e. effectively make the magic
> > > > > fixup opt-in, falling back to signals.  Jamming RIP to skip ENCLU isn't
> > > > > that far off the architecture, e.g. EENTER stuffs RCX with the next RIP so
> > > > > that the enclave can EEXIT to immediately after the EENTER location.
> > > > >
> > > >
> > > > How does that even work, though?  On an AEX, RIP points to the ERESUME
> > > > instruction, not the EENTER instruction, so if we skip it we just end
> > > > up in lala land.
> > >
> > > Userspace would obviously need to be aware of the fixup behavior, but
> > > it actually works out fairly nicely to have a separate path for ERESUME
> > > fixup since a fault on EENTER is generally fatal, whereas as a fault on
> > > ERESUME might be recoverable.
> > >
> > 
> > Hmm.
> > 
> > >
> > > do_eenter:
> > >     mov     tcs, %rbx
> > >     lea     async_exit, %rcx
> > >     mov     $EENTER, %rax
> > >     ENCLU
> > 
> > Or SOME_SILLY_PREFIX ENCLU?
> 
> Yeah, forgot to include that.
> 
> > >
> > > /*
> > >  * EEXIT or EENTER faulted.  In the latter case, %RAX already holds some
> > >  * fault indicator, e.g. -EFAULT.
> > >  */
> > > eexit_or_eenter_fault:
> > >     ret
> > 
> > But userspace wants to know whether it was a fault or not.  So I think
> > we either need two landing pads or we need to hijack a flag bit (are
> > there any known-zeroed flag bits after EEXIT?) to say whether it was a
> > fault.  And, if it was a fault, we should give the vector, the
> > sanitized error code, and possibly CR2.
> 
> As Jethro mentioned, RAX will always be 4 on a successful EEXIT, so we
> can use RAX to indicate a fault.  That's what I was trying to imply with
> EFAULT.  Here's the reg stuffing I use for the POC:
> 
> 	regs->ax = EFAULT;
> 	regs->di = trapnr;
> 	regs->si = error_code;
> 	regs->dx = address;
> 
> 
> Well-known RAX values also means the kernel fault handlers only need to
> look for SOME_SILLY_PREFIX ENCLU if RAX==2 || RAX==3, i.e. the fault
> occurred on EENTER or in an enclave (RAX is set to ERESUME's leaf as
> part of the asynchronous enlcave exit flow).

POC kernel code, 64-bit only.

Limiting this to 64-bit isn't necessary, but it makes the code prettier
and allows using REX as the magic prefix.  I like the idea of using REX
because it seems least likely to be repurposed for yet another new
feature.  I have no idea if 64-bit only will fly with the SDK folks.

Going off comments in similar code related to UMIP, we'd need to figure
out how to handle protection keys.


/* REX with all bits set, ignored by ENCLU. */
#define SGX_DO_ENCLU_FIXUP	0x4F

#define SGX_ENCLU_OPCODE0	0x0F
#define SGX_ENCLU_OPCODE1	0x01
#define SGX_ENCLU_OPCODE2	0xD7

/* ENCLU is a three-byte opcode, plus one byte for the magic prefix. */
#define SGX_ENCLU_FIXUP_INSN_LEN	4

static int sgx_detect_enclu(struct pt_regs *regs)
{
	unsigned char buf[SGX_ENCLU_FIXUP_INSN_LEN];

	/* Look for EENTER or ERESUME in RAX, 64-bit mode only. */
	if (!regs || (regs->ax != 2 && regs->ax != 3) || !user_64bit_mode(regs))
		return 0;

	if (copy_from_user(buf, (void __user *)(regs->ip), sizeof(buf)))
		return 0;

	if (buf[0] == SGX_DO_ENCLU_FIXUP &&
	    buf[1] == SGX_ENCLU_OPCODE0 &&
	    buf[2] == SGX_ENCLU_OPCODE1 &&
	    buf[3] == SGX_ENCLU_OPCODE2)
		return SGX_ENCLU_FIXUP_INSN_LEN;

	return 0;
}

bool sgx_fixup_enclu_fault(struct pt_regs *regs, int trapnr,
			   unsigned long error_code, unsigned long address)
{
	int insn_len;

	insn_len = sgx_detect_enclu(regs);
	if (!insn_len)
		return false;

	regs->ip += insn_len;
	regs->ax = EFAULT;
	regs->di = trapnr;
	regs->si = error_code;
	regs->dx = address;
	return true;
}
