From: Dave Hansen <dave@sr71.net>
Subject: [PATCH 21/25] mm: implement new mprotect_key() system call
Date: Mon, 28 Sep 2015 12:18:26 -0700
Message-ID: <20150928191826.F1CD5256@viggo.jf.intel.com>
References: <20150928191817.035A64E2@viggo.jf.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150928191817.035A64E2@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dave@sr71.net
Cc: borntraeger@de.ibm.com, x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, dave.hansen@linux.intel.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

mprotect_key() is just like mprotect, except it also takes a
protection key as an argument.  On systems that do not support
protection keys, it still works, but requires that key=0.
Otherwise it does exactly what mprotect does.

I expect it to get used like this, if you want to guarantee that
any mapping you create can *never* be accessed without the right
protection keys set up.

	pkey_deny_access(11); // random pkey
	int real_prot = PROT_READ|PROT_WRITE;
	ptr = mmap(NULL, PAGE_SIZE, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
	ret = mprotect_key(ptr, PAGE_SIZE, real_prot, 11);

This way, there is *no* window where the mapping is accessible
since it was always either PROT_NONE or had a protection key set.

We settled on 'unsigned long' for the type of the key here.  We
only need 4 bits on x86 today, but I figured that other
architectures might need some more space.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-api@vger.kernel.org
---

 b/mm/Kconfig    |    7 +++++++
 b/mm/mprotect.c |   20 +++++++++++++++++---
 2 files changed, 24 insertions(+), 3 deletions(-)

diff -puN mm/Kconfig~pkeys-85-mprotect_pkey mm/Kconfig
--- a/mm/Kconfig~pkeys-85-mprotect_pkey	2015-09-28 11:39:50.527391162 -0700
+++ b/mm/Kconfig	2015-09-28 11:39:50.532391390 -0700
@@ -683,3 +683,10 @@ config FRAME_VECTOR
 
 config ARCH_USES_HIGH_VMA_FLAGS
 	bool
+
+config NR_PROTECTION_KEYS
+	int
+	# Everything supports a _single_ key, so allow folks to
+	# at least call APIs that take keys, but require that the
+	# key be 0.
+	default 1
diff -puN mm/mprotect.c~pkeys-85-mprotect_pkey mm/mprotect.c
--- a/mm/mprotect.c~pkeys-85-mprotect_pkey	2015-09-28 11:39:50.529391253 -0700
+++ b/mm/mprotect.c	2015-09-28 11:39:50.532391390 -0700
@@ -344,8 +344,8 @@ fail:
 	return error;
 }
 
-SYSCALL_DEFINE3(mprotect, unsigned long, start, size_t, len,
-		unsigned long, prot)
+static int do_mprotect_key(unsigned long start, size_t len,
+		unsigned long prot, unsigned long key)
 {
 	unsigned long vm_flags, nstart, end, tmp, reqprot;
 	struct vm_area_struct *vma, *prev;
@@ -365,6 +365,8 @@ SYSCALL_DEFINE3(mprotect, unsigned long,
 		return -ENOMEM;
 	if (!arch_validate_prot(prot))
 		return -EINVAL;
+	if (key >= CONFIG_NR_PROTECTION_KEYS)
+		return -EINVAL;
 
 	reqprot = prot;
 	/*
@@ -373,7 +375,7 @@ SYSCALL_DEFINE3(mprotect, unsigned long,
 	if ((prot & PROT_READ) && (current->personality & READ_IMPLIES_EXEC))
 		prot |= PROT_EXEC;
 
-	vm_flags = calc_vm_prot_bits(prot, 0);
+	vm_flags = calc_vm_prot_bits(prot, key);
 
 	down_write(&current->mm->mmap_sem);
 
@@ -443,3 +445,15 @@ out:
 	up_write(&current->mm->mmap_sem);
 	return error;
 }
+
+SYSCALL_DEFINE3(mprotect, unsigned long, start, size_t, len,
+		unsigned long, prot)
+{
+	return do_mprotect_key(start, len, prot, 0);
+}
+
+SYSCALL_DEFINE4(mprotect_key, unsigned long, start, size_t, len,
+		unsigned long, prot, unsigned long, key)
+{
+	return do_mprotect_key(start, len, prot, key);
+}
_
