From: Jann Horn <jannh@google.com>
Subject: Re: [RFC PATCH v3 12/24] x86/mm: Modify ptep_set_wrprotect and
 pmdp_set_wrprotect for _PAGE_DIRTY_SW
Date: Thu, 30 Aug 2018 18:23:47 +0200
Message-ID: <CAG48ez2gHOD9hH4+0wek5vUOv9upj79XWoug2SXjdwfXWoQqxw@mail.gmail.com>
References: <20180830143904.3168-1-yu-cheng.yu@intel.com> <20180830143904.3168-13-yu-cheng.yu@intel.com>
 <CAG48ez0Rca0XsdXJZ07c+iGPyep0Gpxw+sxQuACP5gyPaBgDKA@mail.gmail.com> <079a55f2-4654-4adf-a6ef-6e480b594a2f@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <079a55f2-4654-4adf-a6ef-6e480b594a2f@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: yu-cheng.yu@intel.com, the arch/x86 maintainers <x86@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, Linux-MM <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Florian Weimer <fweimer@redhat.com>, hjl.tools@gmail.com, Jonathan Corbet <corbet@lwn.net>, keescook@chromiun.org, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>Peter
List-Id: linux-api@vger.kernel.org

On Thu, Aug 30, 2018 at 6:09 PM Dave Hansen <dave.hansen@linux.intel.com> wrote:
>
> On 08/30/2018 08:49 AM, Jann Horn wrote:
> >> @@ -1203,7 +1203,28 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
> >>  static inline void ptep_set_wrprotect(struct mm_struct *mm,
> >>                                       unsigned long addr, pte_t *ptep)
> >>  {
> >> +       pte_t pte;
> >> +
> >>         clear_bit(_PAGE_BIT_RW, (unsigned long *)&ptep->pte);
> >> +       pte = *ptep;
> >> +
> >> +       /*
> >> +        * Some processors can start a write, but ending up seeing
> >> +        * a read-only PTE by the time they get to the Dirty bit.
> >> +        * In this case, they will set the Dirty bit, leaving a
> >> +        * read-only, Dirty PTE which looks like a Shadow Stack PTE.
> >> +        *
> >> +        * However, this behavior has been improved and will not occur
> >> +        * on processors supporting Shadow Stacks.  Without this
> >> +        * guarantee, a transition to a non-present PTE and flush the
> >> +        * TLB would be needed.
> >> +        *
> >> +        * When change a writable PTE to read-only and if the PTE has
> >> +        * _PAGE_DIRTY_HW set, we move that bit to _PAGE_DIRTY_SW so
> >> +        * that the PTE is not a valid Shadow Stack PTE.
> >> +        */
> >> +       pte = pte_move_flags(pte, _PAGE_DIRTY_HW, _PAGE_DIRTY_SW);
> >> +       set_pte_at(mm, addr, ptep, pte);
> >>  }
> > I don't understand why it's okay that you first atomically clear the
> > RW bit, then atomically switch from DIRTY_HW to DIRTY_SW. Doesn't that
> > mean that between the two atomic writes, another core can incorrectly
> > see a shadow stack?
>
> Good point.
>
> This could result in a spurious shadow-stack fault, or allow a
> shadow-stack write to the page in the transient state.
>
> But, the shadow-stack permissions are more restrictive than what could
> be in the TLB at this point, so I don't think there's a real security
> implication here.

How about this:

Three threads (A, B, C) run with the same CR3.

1. a dirty+writable PTE is placed directly in front of B's shadow stack.
   (this can happen, right? or is there a guard page?)
2. C's TLB caches the dirty+writable PTE.
3. A performs some syscall that triggers ptep_set_wrprotect().
4. A's syscall calls clear_bit().
5. B's TLB caches the transient shadow stack.
[now C has write access to B's transiently-extended shadow stack]
6. B recurses into the transiently-extended shadow stack
7. C overwrites the transiently-extended shadow stack area.
8. B returns through the transiently-extended shadow stack, giving
    the attacker instruction pointer control in B.
9. A's syscall broadcasts a TLB flush.

Sure, it's not exactly an easy race and probably requires at least
some black timing magic to exploit, if it's exploitable at all - but
still. This seems suboptimal.

> The only trouble is handling the spurious shadow-stack fault.  The
> alternative is to go !Present for a bit, which we would probably just
> handle fine in the existing page fault code.
