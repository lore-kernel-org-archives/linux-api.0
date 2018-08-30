From: Jann Horn <jannh@google.com>
Subject: Re: [RFC PATCH v3 12/24] x86/mm: Modify ptep_set_wrprotect and
 pmdp_set_wrprotect for _PAGE_DIRTY_SW
Date: Thu, 30 Aug 2018 23:01:26 +0200
Message-ID: <CAG48ez0mkr95_TbLQnDGuGUd6G+eJVLZ-fEjDkwA6dSrm+9tLw@mail.gmail.com>
References: <20180830143904.3168-1-yu-cheng.yu@intel.com> <20180830143904.3168-13-yu-cheng.yu@intel.com>
 <CAG48ez0Rca0XsdXJZ07c+iGPyep0Gpxw+sxQuACP5gyPaBgDKA@mail.gmail.com>
 <079a55f2-4654-4adf-a6ef-6e480b594a2f@linux.intel.com> <CAG48ez2gHOD9hH4+0wek5vUOv9upj79XWoug2SXjdwfXWoQqxw@mail.gmail.com>
 <ce051b5b-feef-376f-e085-11f65a5f2215@linux.intel.com> <1535649960.26689.15.camel@intel.com>
 <33d45a12-513c-eba2-a2de-3d6b630e928e@linux.intel.com> <1535651666.27823.6.camel@intel.com>
 <CAG48ez3ixWROuQc6WZze6qPL6q0e_gCnMU4XF11JUWziePsBJg@mail.gmail.com>
 <1535660494.28258.36.camel@intel.com> <CAG48ez0yOuDhqxB779aO3Kss3gQ3cZTJL1VphDXQm+_M9jFPvQ@mail.gmail.com>
 <1535662366.28781.6.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1535662366.28781.6.camel@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: yu-cheng.yu@intel.com
Cc: Dave Hansen <dave.hansen@linux.intel.com>, the arch/x86 maintainers <x86@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, Linux-MM <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Florian Weimer <fweimer@redhat.com>, hjl.tools@gmail.com, Jonathan Corbet <corbet@lwn.net>, keescook@chromiun.org, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>Pavel Machek <pa>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 30, 2018 at 10:57 PM Yu-cheng Yu <yu-cheng.yu@intel.com> wrote:
>
> On Thu, 2018-08-30 at 22:44 +0200, Jann Horn wrote:
> > On Thu, Aug 30, 2018 at 10:25 PM Yu-cheng Yu <yu-cheng.yu@intel.com>
> > wrote:
> ...
> > > In the flow you described, if C writes to the overflow page before
> > > B
> > > gets in with a 'call', the return address is still correct for
> > > B.  To
> > > make an attack, C needs to write again before the TLB flush.  I
> > > agree
> > > that is possible.
> > >
> > > Assume we have a guard page, can someone in the short window do
> > > recursive calls in B, move ssp to the end of the guard page, and
> > > trigger the same again?  He can simply take the incssp route.
> > I don't understand what you're saying. If the shadow stack is
> > between
> > guard pages, you should never be able to move SSP past that area's
> > guard pages without an appropriate shadow stack token (not even with
> > INCSSP, since that has a maximum range of PAGE_SIZE/2), and
> > therefore,
> > it shouldn't matter whether memory outside that range is incorrectly
> > marked as shadow stack. Am I missing something?
>
> INCSSP has a range of 256, but we can do multiple of that.
> But I realize the key is not to have the transient SHSTK page at all.
> The guard page is !pte_write() and even we have flaws in
> ptep_set_wrprotect(), there will not be any transient SHSTK pages. I
> will add guard pages to both ends.
>
> Still thinking how to fix ptep_set_wrprotect().

cmpxchg loop? Or is that slow?
