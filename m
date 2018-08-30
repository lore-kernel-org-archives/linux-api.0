From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [RFC PATCH v3 12/24] x86/mm: Modify ptep_set_wrprotect and
 pmdp_set_wrprotect for _PAGE_DIRTY_SW
Date: Thu, 30 Aug 2018 10:26:00 -0700
Message-ID: <1535649960.26689.15.camel@intel.com>
References: <20180830143904.3168-1-yu-cheng.yu@intel.com>
         <20180830143904.3168-13-yu-cheng.yu@intel.com>
         <CAG48ez0Rca0XsdXJZ07c+iGPyep0Gpxw+sxQuACP5gyPaBgDKA@mail.gmail.com>
         <079a55f2-4654-4adf-a6ef-6e480b594a2f@linux.intel.com>
         <CAG48ez2gHOD9hH4+0wek5vUOv9upj79XWoug2SXjdwfXWoQqxw@mail.gmail.com>
         <ce051b5b-feef-376f-e085-11f65a5f2215@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ce051b5b-feef-376f-e085-11f65a5f2215@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@linux.intel.com>, Jann Horn <jannh@google.com>
Cc: the arch/x86 maintainers <x86@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, Linux-MM <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Florian Weimer <fweimer@redhat.com>, hjl.tools@gmail.com, Jonathan Corbet <corbet@lwn.net>, keescook@chromiun.org, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>, Peter Zijlstra <peterz@infradead>
List-Id: linux-api@vger.kernel.org

On Thu, 2018-08-30 at 10:19 -0700, Dave Hansen wrote:
> On 08/30/2018 09:23 AM, Jann Horn wrote:
> > 
> > Three threads (A, B, C) run with the same CR3.
> > 
> > 1. a dirty+writable PTE is placed directly in front of B's shadow
> > stack.
> >    (this can happen, right? or is there a guard page?)
> > 2. C's TLB caches the dirty+writable PTE.
> > 3. A performs some syscall that triggers ptep_set_wrprotect().
> > 4. A's syscall calls clear_bit().
> > 5. B's TLB caches the transient shadow stack.
> > [now C has write access to B's transiently-extended shadow stack]
> > 6. B recurses into the transiently-extended shadow stack
> > 7. C overwrites the transiently-extended shadow stack area.
> > 8. B returns through the transiently-extended shadow stack, giving
> >     the attacker instruction pointer control in B.
> > 9. A's syscall broadcasts a TLB flush.
> Heh, that's a good point.  The shadow stack permissions are *not*
> strictly reduced because a page getting marked as shadow-stack has
> *increased* permissions when being used as a shadow stack.  Fun.
> 
> For general hardening, it seems like we want to ensure that there's
> a
> guard page at the bottom of the shadow stack.  Yu-cheng, do we have
> a
> guard page?

We don't have the guard page now, but there is a shadow stack token
there, which cannot be used as a return address.

Yu-cheng
