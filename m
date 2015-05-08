From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 02/12] KVM: define common __KVM_GUESTDBG_USE_SW/HW_BP
 values
Date: Fri, 08 May 2015 13:09:15 +0200
Message-ID: <554C995B.6050907@redhat.com>
References: <1430929407-3487-1-git-send-email-alex.bennee@linaro.org>
 <1430929407-3487-3-git-send-email-alex.bennee@linaro.org>
 <20150508092346.GB24744@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <20150508092346.GB24744@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, =?windows-1252?Q?Alex?= =?windows-1252?Q?_Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, kvmarm@lists.cs.columbia.edu, Nadav Amit <namit@cs.technion.ac.il>, Michael Ellerman <mpe@ellerman.id.au>, "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>, Gleb Natapov <gleb@kernel.org>, Ingo Molnar <mingo@redhat.com>, zhichao.huang@linaro.org, jan.kiszka@siemens.com, bp@suse.de, marc.zyngier@arm.com, r65777@freescale.com, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org, list@lists.cs.columbia.edu, ABI/API <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, dahi@linux.vnet.ibm.com, open@lists.cs.columbia.edu, "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-api@vger.kernel.org



On 08/05/2015 11:23, Christoffer Dall wrote:
> On Wed, May 06, 2015 at 05:23:17PM +0100, Alex Benn=E9e wrote:
>> Currently x86, powerpc and soon arm64 use the same two architecture
>> specific bits for guest debug support for software and hardware
>> breakpoints. This makes the shared values explicit while leaving the
>> gate open for another architecture to use some other value if they
>> really really want to.
>>
>> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
>> Reviewed-by: Andrew Jones <drjones@redhat.com>
>>
>> diff --git a/arch/powerpc/include/uapi/asm/kvm.h b/arch/powerpc/include/=
uapi/asm/kvm.h
>> index ab4d473..1731569 100644
>> --- a/arch/powerpc/include/uapi/asm/kvm.h
>> +++ b/arch/powerpc/include/uapi/asm/kvm.h
>> @@ -310,8 +310,8 @@ struct kvm_guest_debug_arch {
>>   * and upper 16 bits are architecture specific. Architecture specific d=
efines
>>   * that ioctl is for setting hardware breakpoint or software breakpoint.
>>   */
>> -#define KVM_GUESTDBG_USE_SW_BP		0x00010000
>> -#define KVM_GUESTDBG_USE_HW_BP		0x00020000
>> +#define KVM_GUESTDBG_USE_SW_BP		__KVM_GUESTDBG_USE_SW_BP
>> +#define KVM_GUESTDBG_USE_HW_BP		__KVM_GUESTDBG_USE_HW_BP
>>  =

>>  /* definition of registers in kvm_run */
>>  struct kvm_sync_regs {
>> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm=
/kvm.h
>> index d7dcef5..1438202 100644
>> --- a/arch/x86/include/uapi/asm/kvm.h
>> +++ b/arch/x86/include/uapi/asm/kvm.h
>> @@ -250,8 +250,8 @@ struct kvm_debug_exit_arch {
>>  	__u64 dr7;
>>  };
>>  =

>> -#define KVM_GUESTDBG_USE_SW_BP		0x00010000
>> -#define KVM_GUESTDBG_USE_HW_BP		0x00020000
>> +#define KVM_GUESTDBG_USE_SW_BP		__KVM_GUESTDBG_USE_SW_BP
>> +#define KVM_GUESTDBG_USE_HW_BP		__KVM_GUESTDBG_USE_HW_BP
>>  #define KVM_GUESTDBG_INJECT_DB		0x00040000
>>  #define KVM_GUESTDBG_INJECT_BP		0x00080000
>>  =

>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 70ac641..3b6252e 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -570,8 +570,16 @@ struct kvm_s390_irq_state {
>>  =

>>  /* for KVM_SET_GUEST_DEBUG */
>>  =

>> -#define KVM_GUESTDBG_ENABLE		0x00000001
>> -#define KVM_GUESTDBG_SINGLESTEP		0x00000002
>> +#define KVM_GUESTDBG_ENABLE		(1 << 0)
>> +#define KVM_GUESTDBG_SINGLESTEP	(1 << 1)
>> +
>> +/*
>> + * Architecture specific stuff uses the top 16 bits of the field,
> =

> s/stuff/<something more specific>/
> =

>> + * however there is some shared commonality for the common cases
>> + */
>> +#define __KVM_GUESTDBG_USE_SW_BP	(1 << 16)
>> +#define __KVM_GUESTDBG_USE_HW_BP	(1 << 17)
>> +
>>  =

>>  struct kvm_guest_debug {
>>  	__u32 control;
> =

> We sort of left this discussion hanging with me expressing slight
> concern about the usefulness about these defines.
> =

> Paolo, what are your thoughts?

I would just lift these two KVM_GUESTDBG_* defines to
include/uapi/linux/kvm.h and say that architecture specific stuff uses
the top 14 bits of the field. :)

Paolo
