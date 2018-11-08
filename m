From: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: RFC: userspace exception fixups
Date: Thu, 8 Nov 2018 11:54:20 -0800
Message-ID: <20181108195420.GA14715@linux.intel.com>
References: <1541518670.7839.31.camel@intel.com>
 <AF4A5C77-0A79-403F-A205-0F93B7CD6E26@amacapital.net>
 <1541524750.7839.51.camel@intel.com>
 <22596E35-F5D1-4935-86AB-B510DCA0FABE@amacapital.net>
 <c9659222-efc6-b73a-ce48-30be8bdc5397@intel.com>
 <CALCETrWBV=1JbAKYn2Jy2LxkGZQvKRtFRnrWUMoejrwQe73VHw@mail.gmail.com>
 <b9c53669-cd27-e3bc-3d62-f47c77029c43@intel.com>
 <1C426267-492F-4AE7-8BE8-C7FE278531F9@amacapital.net>
 <209cf4a5-eda9-2495-539f-fed22252cf02@intel.com>
 <9B76E95B-5745-412E-8007-7FAA7F83D6FB@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9B76E95B-5745-412E-8007-7FAA7F83D6FB@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Dave Hansen <dave.hansen@intel.com>, Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Rich Felker <dalias@libc.org>, Dave Hansen <dave.hansen@linux.intel.com>, Jethro Beekman <jethro@fortanix.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com, npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>I
List-Id: linux-api@vger.kernel.org

On Tue, Nov 06, 2018 at 01:07:54PM -0800, Andy Lutomirski wrote:
> 
> 
> > On Nov 6, 2018, at 1:00 PM, Dave Hansen <dave.hansen@intel.com> wrote:
> > 
> >> On 11/6/18 12:12 PM, Andy Lutomirski wrote:
> >> True, but what if we have a nasty enclave that writes to memory just
> >> below SP *before* decrementing SP?
> > 
> > Yeah, that would be unfortunate.  If an enclave did this (roughly):
> > 
> >    1. EENTER
> >    2. Hardware sets eenter_hwframe->sp = %sp
> >    3. Enclave runs... wants to do out-call
> >    4. Enclave sets up parameters:
> >        memcpy(&eenter_hwframe->sp[-offset], arg1, size);
> >        ...
> >    5. Enclave sets eenter_hwframe->sp -= offset
> > 
> > If we got a signal between 4 and 5, we'd clobber the copy of 'arg1' that
> > was on the stack.  The enclave could easily fix this by moving ->sp first.
> > 
> > But, this is one of those "fun" parts of the ABI that I think we need to
> > talk about.  If we do this, we also basically require that the code
> > which handles asynchronous exits must *not* write to the stack.  That's
> > not hard because it's typically just a single ERESUME instruction, but
> > it *is* a requirement.
> > 
> 
> I was assuming that the async exit stuff was completely hidden by the
> API.  The AEP code would decide whether the exit got fixed up by the
> kernel (which may or may not be easy to tell — can the code even tell
> without kernel help whether it was, say, an IRQ vs #UD?) and then either
> do ERESUME or cause sgx_enter_enclave() to return with an appropriate
> return value.

Ok, SDK folks came up with an idea that would allow them to use vDSO,
albeit with a bit of ugliness and potentially a ROP-attack issue.
Definitely some weirdness, but the weirdness is well contained, unlike
the magic prefix approach.

Provide two enter_enclave() vDSO "functions".  The first is a normal
function with a normal C interface.  The second is a blob of code that
is "called" and "returns" via indirect jmp, and can be used by SGX
runtimes that want to use the untrusted stack for out-calls from the
enclave.

For the indirect jmp "function", use %rbp to stash the return address
of the caller (either in %rbp itself or in memory pointed to by %rbp).
It works because hardware also saves/restores %rbp along with %rsp when
doing enclave transitions, and the SDK can live with %rbp being
off-limits.  Fault info is passed via registers.

Basic idea for the "functions" below.  The fixup stuff is obviously not
wired up correctly, just trying to convey the concept.



struct enclu_fault_info {
	unsigned int	leaf;
	unsigned int	trapnr;
	unsigned int	error_code;
	unsigned long	address;
};

int __vdso_enter_enclave(void *tcs, struct enclu_fault_info *fault_info)
{
	unsigned int leaf, trapnr;

	asm volatile (
		"lea	2f(%%rip), %%rcx\n\t"
		"1:	enclu\n\t"
		"jmp	3f\n\t"

		/* ERESUME trampoline */
		"2:	enclu\n\t"
		"ud2\n\t"

		/* out: */
		"3:\n"

		/* EENTER fixup */
		".pushsection .fixup,\"ax\"\n\t"
		"4:\n\t"
		"mov	%%eax, %%edi\n\t"
		"movl	$"__stringify(SGX_EENTER)", %%eax\n\t"
		"jmp	3b\n\t"
		".popsection\n\t"
		_ASM_EXTABLE_FAULT(1b, 4b)

		/* ERESUME FIXUP */
		".pushsection .fixup,\"ax\"\n\t"
		"5:\n\t"
		"mov	%%eax, %%edi\n\t"
		"movl	$"__stringify(SGX_ERESUME)", %%eax\n\t"
		"jmp	3b\n\t"
		".popsection\n\t"
		_ASM_EXTABLE_FAULT(2b, 5b)

		: "=a"(leaf), "=D" (trapnr)
		: "a" (SGX_EENTER), "b" (tcs)
		: "cc", "memory", "rcx", "rdx", "rsi", "r8", "r9", "r10",
		  "r11", "r12", "r13", "r14", "r15"
	);

	if (leaf == SGX_EEXIT)
		return 0;

	if (fault_info) {
		fault_info->leaf = leaf;
		fault_info->trapnr = trapnr;
		fault_info->error_code = 0;
		fault_info->address = 0;
	}

	return -EFAULT;
}


GLOBAL(__vdso_enter_enclave_no_stack)
        endbr64

        /* %rbp = return target, %rbx = tcs */
        leaq    3f(%rip), %rcx
        movl    $2, %eax
1:      enclu

        /* "return" to "caller" */
2:      jmp     *%rbp

        /* ERESUME trampoline */
3:      enclu
        ud2

        /* EENTER fixup handler */
4:      movq    %rax, %rdi
        movl    $2, %eax
        /* %rsi = error code, %rdx = address */
        jmp     2b

        /* ERESUME fixup handler */
5:      movq    %rax, %rdi
        movl    $3, %eax
        /* %rsi = error code, %rdx = address */
        jmp     2b
