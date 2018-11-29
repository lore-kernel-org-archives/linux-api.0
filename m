From: Florian Weimer <fweimer@redhat.com>
Subject: Re: pkeys: Reserve PKEY_DISABLE_READ
Date: Thu, 29 Nov 2018 12:37:15 +0100
Message-ID: <87va4g5d3o.fsf@oldenburg.str.redhat.com>
References: <877ehnbwqy.fsf@oldenburg.str.redhat.com>
 <2d62c9e2-375b-2791-32ce-fdaa7e7664fd@intel.com>
 <87bm6zaa04.fsf@oldenburg.str.redhat.com>
 <6f9c65fb-ea7e-8217-a4cc-f93e766ed9bb@intel.com>
 <87k1ln8o7u.fsf@oldenburg.str.redhat.com>
 <20181108201231.GE5481@ram.oc3035372033.ibm.com>
 <87bm6z71yw.fsf@oldenburg.str.redhat.com>
 <20181109180947.GF5481@ram.oc3035372033.ibm.com>
 <87efbqqze4.fsf@oldenburg.str.redhat.com>
 <20181127102350.GA5795@ram.oc3035372033.ibm.com>
 <87zhtuhgx0.fsf@oldenburg.str.redhat.com>
 <58e263a6-9a93-46d6-c5f9-59973064d55e@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <58e263a6-9a93-46d6-c5f9-59973064d55e@intel.com> (Dave Hansen's
 message of "Tue, 27 Nov 2018 07:31:38 -0800")
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-mm@kvack.org, Ram Pai <linuxram@us.ibm.com>, linuxppc-dev@lists.ozlabs.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

* Dave Hansen:

> On 11/27/18 3:57 AM, Florian Weimer wrote:
>> I would have expected something that translates PKEY_DISABLE_WRITE |
>> PKEY_DISABLE_READ into PKEY_DISABLE_ACCESS, and also accepts
>> PKEY_DISABLE_ACCESS | PKEY_DISABLE_READ, for consistency with POWER.
>> 
>> (My understanding is that PKEY_DISABLE_ACCESS does not disable all
>> access, but produces execute-only memory.)
>
> Correct, it disables all data access, but not execution.

So I would expect something like this (completely untested, I did not
even compile this):

diff --git a/arch/powerpc/include/asm/pkeys.h b/arch/powerpc/include/asm/pkeys.h
index 20ebf153c871..bed23f9e8336 100644
--- a/arch/powerpc/include/asm/pkeys.h
+++ b/arch/powerpc/include/asm/pkeys.h
@@ -199,6 +199,11 @@ static inline bool arch_pkeys_enabled(void)
 	return !static_branch_likely(&pkey_disabled);
 }
 
+static inline bool arch_pkey_access_rights_valid(unsigned long rights)
+{
+	return (rights & ~(unsigned long)PKEY_ACCESS_MASK) == 0;
+}
+
 extern void pkey_mm_init(struct mm_struct *mm);
 extern bool arch_supports_pkeys(int cap);
 extern unsigned int arch_usable_pkeys(void);
diff --git a/arch/x86/include/asm/pkeys.h b/arch/x86/include/asm/pkeys.h
index 19b137f1b3be..e3e1d5a316e8 100644
--- a/arch/x86/include/asm/pkeys.h
+++ b/arch/x86/include/asm/pkeys.h
@@ -14,6 +14,17 @@ static inline bool arch_pkeys_enabled(void)
 	return boot_cpu_has(X86_FEATURE_OSPKE);
 }
 
+static inline bool arch_pkey_access_rights_valid(unsigned long rights)
+{
+	if (rights & ~(unsigned long)PKEY_ACCESS_MASK)
+		return false;
+	if (rights & PKEY_DISABLE_READ) {
+		/* x86 can only disable read access along with write access. */
+		return rights & (PKEY_DISABLE_WRITE | PKEY_DISABLE_ACCESS);
+	}
+	return true;
+}
+
 /*
  * Try to dedicate one of the protection keys to be used as an
  * execute-only protection key.
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 87a57b7642d3..b9b78145017f 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -928,7 +928,13 @@ int arch_set_user_pkey_access(struct task_struct *tsk, int pkey,
 		return -EINVAL;
 
 	/* Set the bits we need in PKRU:  */
-	if (init_val & PKEY_DISABLE_ACCESS)
+	if (init_val & (PKEY_DISABLE_ACCESS | PKEY_DISABLE_READ))
+		/*
+		 * arch_pkey_access_rights_valid checked that
+		 * PKEY_DISABLE_READ is actually representable on x86
+		 * (that is, it comes with PKEY_DISABLE_ACCESS or
+		 * PKEY_DISABLE_WRITE).
+		 */
 		new_pkru_bits |= PKRU_AD_BIT;
 	if (init_val & PKEY_DISABLE_WRITE)
 		new_pkru_bits |= PKRU_WD_BIT;
diff --git a/include/linux/pkeys.h b/include/linux/pkeys.h
index 2955ba976048..2c330fabbe55 100644
--- a/include/linux/pkeys.h
+++ b/include/linux/pkeys.h
@@ -48,6 +48,11 @@ static inline void copy_init_pkru_to_fpregs(void)
 {
 }
 
+static inline bool arch_pkey_access_rights_valid(unsigned long rights)
+{
+	return false;
+}
+
 #endif /* ! CONFIG_ARCH_HAS_PKEYS */
 
 #endif /* _LINUX_PKEYS_H */
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 6d331620b9e5..f4cefc3540df 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -597,7 +597,7 @@ SYSCALL_DEFINE2(pkey_alloc, unsigned long, flags, unsigned long, init_val)
 	if (flags)
 		return -EINVAL;
 	/* check for unsupported init values */
-	if (init_val & ~PKEY_ACCESS_MASK)
+	if (!arch_pkey_access_rights_valid(init_val))
 		return -EINVAL;
 
 	down_write(&current->mm->mmap_sem);

Thanks,
Florian
