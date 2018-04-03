From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.17 02/21] rseq: Introduce restartable
 sequences system call (v12)
Date: Tue, 3 Apr 2018 16:32:26 -0400 (EDT)
Message-ID: <1649799886.2451.1522787546557.JavaMail.zimbra@efficios.com>
References: <20180327160542.28457-1-mathieu.desnoyers@efficios.com> <20180327160542.28457-3-mathieu.desnoyers@efficios.com> <20180401171356.085a2a33@alans-desktop> <1890356924.1736.1522683188833.JavaMail.zimbra@efficios.com> <17439540.2334.1522773387555.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <17439540.2334.1522773387555.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <cata>
List-Id: linux-api@vger.kernel.org

----- On Apr 3, 2018, at 12:36 PM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

> ----- On Apr 2, 2018, at 11:33 AM, Mathieu Desnoyers
> mathieu.desnoyers@efficios.com wrote:
> 
>> ----- On Apr 1, 2018, at 12:13 PM, One Thousand Gnomes
>> gnomes@lxorguk.ukuu.org.uk wrote:
>> 
[...]
>>> I still like the idea it's just the latencies concern me.
>> 
[...]
> 
> Looking into this a bit more, I notice the following: The pgprot_noncached
> (_PAGE_NOCACHE on x86) pgprot is part of the vma->vm_page_prot. Therefore,
> in order to have userspace provide pointers to noncached pages as input
> to cpu_opv, they need to be part of a userspace vma which has a
> pgprot_noncached vm_page_prot.
> 
> The cpu_opv system call uses get_user_pages_fast() to grab the struct page
> from the userspace addresses, and then passes those pages to vm_map_ram(),
> with a PAGE_KERNEL pgprot. This creates a temporary kernel mapping to those
> pages, which is then used to read/write from/to those pages with preemption
> disabled.
> 
> Therefore, with the proposed cpu_opv implementation, the kernel is not
> touching noncached mappings with preemption disabled, which should take
> care of your latency concern.

[...]

The following extra check should let userspace know it's trying to
provide a pointer to noncached memory by returning -1, errno=EFAULT.

Is the approach acceptable ?

Thanks,

Mathieu

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ad06d42..0245481 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2425,6 +2425,18 @@ static inline struct page *follow_page(struct vm_area_struct *vma,
        return follow_page_mask(vma, address, foll_flags, &unused_page_mask);
 }
 
+static inline bool is_vma_noncached(struct vm_area_struct *vma)
+{
+       pgprot_t pgprot = vma->vm_page_prot;
+
+       /* Check whether architecture implements noncached pages. */
+       if (pgprot_val(pgprot_noncached(PAGE_KERNEL)) == pgprot_val(PAGE_KERNEL))
+               return false;
+       if (pgprot_val(pgprot) != pgprot_val(pgprot_noncached(pgprot)))
+               return false;
+       return true;
+}
+
 #define FOLL_WRITE     0x01    /* check pte is writable */
 #define FOLL_TOUCH     0x02    /* mark page accessed */
 #define FOLL_GET       0x04    /* do get_page on page */
diff --git a/kernel/cpu_opv.c b/kernel/cpu_opv.c
index 197339e..e4395b4 100644
--- a/kernel/cpu_opv.c
+++ b/kernel/cpu_opv.c
@@ -362,7 +362,19 @@ static int cpu_op_pin_pages(unsigned long addr, unsigned long len,
        int ret, nr_pages, nr_put_pages, n;
        unsigned long _vaddr;
        struct vaddr *va;
+       struct vm_area_struct *vma;
 
+       vma = find_vma_intersection(current->mm, addr, addr + len);
+       if (!vma)
+               return -EFAULT;
+       /*
+        * cpu_opv() accesses its own cached mapping of the userspace pages.
+        * Considering that concurrent noncached and cached accesses may yield
+        * to unexpected results in terms of memory consistency, explicitly
+        * disallow cpu_opv on noncached memory.
+        */
+       if (is_vma_noncached(vma))
+               return -EFAULT;
        nr_pages = cpu_op_count_pages(addr, len);
        if (!nr_pages)
                return 0;

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
