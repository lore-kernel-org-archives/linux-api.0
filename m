From: Ram Pai <linuxram@us.ibm.com>
Subject: Re: pkeys: Reserve PKEY_DISABLE_READ
Date: Tue, 27 Nov 2018 02:23:50 -0800
Message-ID: <20181127102350.GA5795@ram.oc3035372033.ibm.com>
References: <877ehnbwqy.fsf@oldenburg.str.redhat.com>
 <2d62c9e2-375b-2791-32ce-fdaa7e7664fd@intel.com>
 <87bm6zaa04.fsf@oldenburg.str.redhat.com>
 <6f9c65fb-ea7e-8217-a4cc-f93e766ed9bb@intel.com>
 <87k1ln8o7u.fsf@oldenburg.str.redhat.com>
 <20181108201231.GE5481@ram.oc3035372033.ibm.com>
 <87bm6z71yw.fsf@oldenburg.str.redhat.com>
 <20181109180947.GF5481@ram.oc3035372033.ibm.com>
 <87efbqqze4.fsf@oldenburg.str.redhat.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <87efbqqze4.fsf@oldenburg.str.redhat.com>
Content-Disposition: inline
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
To: Florian Weimer <fweimer@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 12, 2018 at 01:00:19PM +0100, Florian Weimer wrote:
> * Ram Pai:
> 
> > On Thu, Nov 08, 2018 at 09:23:35PM +0100, Florian Weimer wrote:
> >> * Ram Pai:
> >> 
> >> > Florian,
> >> >
> >> > 	I can. But I am struggling to understand the requirement. Why is
> >> > 	this needed?  Are we proposing a enhancement to the sys_pkey_alloc(),
> >> > 	to be able to allocate keys that are initialied to disable-read
> >> > 	only?
> >> 
> >> Yes, I think that would be a natural consequence.
> >> 
> >> However, my immediate need comes from the fact that the AMR register can
> >> contain a flag combination that is not possible to represent with the
> >> existing PKEY_DISABLE_WRITE and PKEY_DISABLE_ACCESS flags.  User code
> >> could write to AMR directly, so I cannot rule out that certain flag
> >> combinations exist there.
> >> 
> >> So I came up with this:
> >> 
> >> int
> >> pkey_get (int key)
> >> {
> >>   if (key < 0 || key > PKEY_MAX)
> >>     {
> >>       __set_errno (EINVAL);
> >>       return -1;
> >>     }
> >>   unsigned int index = pkey_index (key);
> >>   unsigned long int amr = pkey_read ();
> >>   unsigned int bits = (amr >> index) & 3;
> >> 
> >>   /* Translate from AMR values.  PKEY_AMR_READ standing alone is not
> >>      currently representable.  */
> >>   if (bits & PKEY_AMR_READ)
> >
> > this should be
> >    if (bits & (PKEY_AMR_READ|PKEY_AMR_WRITE))
> 
> This would return zero for PKEY_AMR_READ alone.
> 
> >>     return PKEY_DISABLE_ACCESS;
> >
> >
> >>   else if (bits == PKEY_AMR_WRITE)
> >>     return PKEY_DISABLE_WRITE;
> >>   return 0;
> >> }
> 
> It's hard to tell whether PKEY_DISABLE_ACCESS is better in this case.
> Which is why I want PKEY_DISABLE_READ.
> 
> >> And this is not ideal.  I would prefer something like this instead:
> >> 
> >>   switch (bits)
> >>     {
> >>       case PKEY_AMR_READ | PKEY_AMR_WRITE:
> >>         return PKEY_DISABLE_ACCESS;
> >>       case PKEY_AMR_READ:
> >>         return PKEY_DISABLE_READ;
> >>       case PKEY_AMR_WRITE:
> >>         return PKEY_DISABLE_WRITE;
> >>       case 0:
> >>         return 0;
> >>     }
> >
> > yes.
> >  and on x86 it will be something like:
> >    switch (bits)
> >      {
> >        case PKEY_PKRU_ACCESS :
> >          return PKEY_DISABLE_ACCESS;
> >        case PKEY_AMR_WRITE:
> >          return PKEY_DISABLE_WRITE;
> >        case 0:
> >          return 0;
> >      }
> 
> x86 returns the PKRU bits directly, including the nonsensical case
> (PKEY_DISABLE_ACCESS | PKEY_DISABLE_WRITE).
> 
> > But for this to work, why do you need to enhance the sys_pkey_alloc()
> > interface?  Not that I am against it. Trying to understand if the
> > enhancement is really needed.
> 
> sys_pkey_alloc performs an implicit pkey_set for the newly allocated key
> (that is, it updates the PKRU/AMR register).  It makes sense to match
> the behavior of the userspace implementation.

Here is a untested patch. Does this meet your needs?
It defines the new flags. Each architecture will than define the set of flags
it supports through PKEY_ACCESS_MASK.


Signed-off-by: Ram Pai <linuxram@us.ibm.com>

diff --git a/arch/powerpc/include/asm/pkeys.h b/arch/powerpc/include/asm/pkeys.h
index 92a9962..724ef43 100644
--- a/arch/powerpc/include/asm/pkeys.h
+++ b/arch/powerpc/include/asm/pkeys.h
@@ -21,11 +21,6 @@
 #define ARCH_VM_PKEY_FLAGS (VM_PKEY_BIT0 | VM_PKEY_BIT1 | VM_PKEY_BIT2 | \
 			    VM_PKEY_BIT3 | VM_PKEY_BIT4)
 
-/* Override any generic PKEY permission defines */
-#define PKEY_DISABLE_EXECUTE   0x4
-#define PKEY_ACCESS_MASK       (PKEY_DISABLE_ACCESS | \
-				PKEY_DISABLE_WRITE  | \
-				PKEY_DISABLE_EXECUTE)
 
 static inline u64 pkey_to_vmflag_bits(u16 pkey)
 {
diff --git a/arch/powerpc/include/uapi/asm/mman.h b/arch/powerpc/include/uapi/asm/mman.h
index 65065ce..76237b3 100644
--- a/arch/powerpc/include/uapi/asm/mman.h
+++ b/arch/powerpc/include/uapi/asm/mman.h
@@ -31,9 +31,9 @@
 #define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
 /* Override any generic PKEY permission defines */
-#define PKEY_DISABLE_EXECUTE   0x4
 #undef PKEY_ACCESS_MASK
 #define PKEY_ACCESS_MASK       (PKEY_DISABLE_ACCESS |\
 				PKEY_DISABLE_WRITE  |\
+				PKEY_DISABLE_READ  |\
 				PKEY_DISABLE_EXECUTE)
 #endif /* _UAPI_ASM_POWERPC_MMAN_H */
diff --git a/arch/powerpc/mm/pkeys.c b/arch/powerpc/mm/pkeys.c
index 4860acd..c8b2540 100644
--- a/arch/powerpc/mm/pkeys.c
+++ b/arch/powerpc/mm/pkeys.c
@@ -62,14 +62,6 @@ int pkey_initialize(void)
 	int os_reserved, i;
 
 	/*
-	 * We define PKEY_DISABLE_EXECUTE in addition to the arch-neutral
-	 * generic defines for PKEY_DISABLE_ACCESS and PKEY_DISABLE_WRITE.
-	 * Ensure that the bits a distinct.
-	 */
-	BUILD_BUG_ON(PKEY_DISABLE_EXECUTE &
-		     (PKEY_DISABLE_ACCESS | PKEY_DISABLE_WRITE));
-
-	/*
 	 * pkey_to_vmflag_bits() assumes that the pkey bits are contiguous
 	 * in the vmaflag. Make sure that is really the case.
 	 */
@@ -259,6 +251,8 @@ int __arch_set_user_pkey_access(struct task_struct *tsk, int pkey,
 		new_amr_bits |= AMR_RD_BIT | AMR_WR_BIT;
 	else if (init_val & PKEY_DISABLE_WRITE)
 		new_amr_bits |= AMR_WR_BIT;
+	else if (init_val & PKEY_DISABLE_READ)
+		new_amr_bits |= AMR_RD_BIT;
 
 	init_amr(pkey, new_amr_bits);
 	return 0;
diff --git a/arch/x86/include/uapi/asm/mman.h b/arch/x86/include/uapi/asm/mman.h
index d4a8d04..e9b121b 100644
--- a/arch/x86/include/uapi/asm/mman.h
+++ b/arch/x86/include/uapi/asm/mman.h
@@ -24,6 +24,11 @@
 		((key) & 0x2 ? VM_PKEY_BIT1 : 0) |      \
 		((key) & 0x4 ? VM_PKEY_BIT2 : 0) |      \
 		((key) & 0x8 ? VM_PKEY_BIT3 : 0))
+
+/* Override any generic PKEY permission defines */
+#undef PKEY_ACCESS_MASK
+#define PKEY_ACCESS_MASK       (PKEY_DISABLE_ACCESS |\
+				PKEY_DISABLE_WRITE)
 #endif
 
 #include <asm-generic/mman.h>
diff --git a/include/uapi/asm-generic/mman-common.h b/include/uapi/asm-generic/mman-common.h
index e7ee328..61168e4 100644
--- a/include/uapi/asm-generic/mman-common.h
+++ b/include/uapi/asm-generic/mman-common.h
@@ -71,7 +71,8 @@
 
 #define PKEY_DISABLE_ACCESS	0x1
 #define PKEY_DISABLE_WRITE	0x2
-#define PKEY_ACCESS_MASK	(PKEY_DISABLE_ACCESS |\
-				 PKEY_DISABLE_WRITE)
-
+#define PKEY_DISABLE_EXECUTE	0x4
+#define PKEY_DISABLE_READ	0x8
+#define PKEY_ACCESS_MASK	0x0	/* arch can override and define its own
+					   mask bits */
 #endif /* __ASM_GENERIC_MMAN_COMMON_H */
