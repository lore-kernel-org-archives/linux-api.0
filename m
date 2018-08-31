From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH v3 12/24] x86/mm: Modify ptep_set_wrprotect and
 pmdp_set_wrprotect for _PAGE_DIRTY_SW
Date: Fri, 31 Aug 2018 11:53:00 +0200
Message-ID: <20180831095300.GF24124@hirez.programming.kicks-ass.net>
References: <ce051b5b-feef-376f-e085-11f65a5f2215@linux.intel.com>
 <1535649960.26689.15.camel@intel.com>
 <33d45a12-513c-eba2-a2de-3d6b630e928e@linux.intel.com>
 <1535651666.27823.6.camel@intel.com>
 <CAG48ez3ixWROuQc6WZze6qPL6q0e_gCnMU4XF11JUWziePsBJg@mail.gmail.com>
 <1535660494.28258.36.camel@intel.com>
 <CAG48ez0yOuDhqxB779aO3Kss3gQ3cZTJL1VphDXQm+_M9jFPvQ@mail.gmail.com>
 <1535662366.28781.6.camel@intel.com>
 <CAG48ez0mkr95_TbLQnDGuGUd6G+eJVLZ-fEjDkwA6dSrm+9tLw@mail.gmail.com>
 <CAG48ez3S3+DzAyo_SnoUW1GO0Cpd_x0A83MOx2p_MkogoAatLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG48ez3S3+DzAyo_SnoUW1GO0Cpd_x0A83MOx2p_MkogoAatLQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: yu-cheng.yu@intel.com, Dave Hansen <dave.hansen@linux.intel.com>, the arch/x86 maintainers <x86@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, Linux-MM <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Florian Weimer <fweimer@redhat.com>, hjl.tools@gmail.com, Jonathan Corbet <corbet@lwn.net>, keescook@chromiun.org, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.c>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 30, 2018 at 11:47:16PM +0200, Jann Horn wrote:
>         do {
>                 pte = pte_wrprotect(pte);
>                 /* note: relies on _PAGE_DIRTY_HW < _PAGE_DIRTY_SW */
>                 /* dirty direct bit-twiddling; you can probably write
> this in a nicer way */
>                 pte.pte |= (pte.pte & _PAGE_DIRTY_HW) >>
> _PAGE_BIT_DIRTY_HW << _PAGE_BIT_DIRTY_SW;
>                 pte.pte &= ~_PAGE_DIRTY_HW;
>                 pte = cmpxchg(ptep, pte, new_pte);
>         } while (pte != new_pte);

Please use the form:

	pte_t new_pte, pte = READ_ONCE(*ptep);
	do {
		new_pte = /* ... */;
	} while (!try_cmpxchg(ptep, &pte, new_pte);

Also, this will fail to build on i386-PAE, but I suspect this code will
be under some CONFIG option specific to x86_64 anyway.
