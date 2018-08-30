From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [RFC PATCH v3 12/24] x86/mm: Modify ptep_set_wrprotect and
 pmdp_set_wrprotect for _PAGE_DIRTY_SW
Date: Thu, 30 Aug 2018 13:21:34 -0700
Message-ID: <1535660494.28258.36.camel@intel.com>
References: <20180830143904.3168-1-yu-cheng.yu@intel.com>
         <20180830143904.3168-13-yu-cheng.yu@intel.com>
         <CAG48ez0Rca0XsdXJZ07c+iGPyep0Gpxw+sxQuACP5gyPaBgDKA@mail.gmail.com>
         <079a55f2-4654-4adf-a6ef-6e480b594a2f@linux.intel.com>
         <CAG48ez2gHOD9hH4+0wek5vUOv9upj79XWoug2SXjdwfXWoQqxw@mail.gmail.com>
         <ce051b5b-feef-376f-e085-11f65a5f2215@linux.intel.com>
         <1535649960.26689.15.camel@intel.com>
         <33d45a12-513c-eba2-a2de-3d6b630e928e@linux.intel.com>
         <1535651666.27823.6.camel@intel.com>
         <CAG48ez3ixWROuQc6WZze6qPL6q0e_gCnMU4XF11JUWziePsBJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez3ixWROuQc6WZze6qPL6q0e_gCnMU4XF11JUWziePsBJg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, the arch/x86 maintainers <x86@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, Linux-MM <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Florian Weimer <fweimer@redhat.com>, hjl.tools@gmail.com, Jonathan Corbet <corbet@lwn.net>, keescook@chromiun.org, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pave>
List-Id: linux-api@vger.kernel.org

On Thu, 2018-08-30 at 19:59 +0200, Jann Horn wrote:
> On Thu, Aug 30, 2018 at 7:58 PM Yu-cheng Yu <yu-cheng.yu@intel.com>
> wrote:
> > 
> > 
> > On Thu, 2018-08-30 at 10:33 -0700, Dave Hansen wrote:
> > > 
> > > On 08/30/2018 10:26 AM, Yu-cheng Yu wrote:
> > > > 
> > > > 
> > > > We don't have the guard page now, but there is a shadow stack
> > > > token
> > > > there, which cannot be used as a return address.
> > > The overall concern is that we could overflow into a page that
> > > we
> > > did
> > > not intend.  Either another actual shadow stack or something
> > > that a
> > > page
> > > that the attacker constructed, like the transient scenario Jann
> > > described.
> > > 
> > A task could go beyond the bottom of its shadow stack by doing
> > either
> > 'ret' or 'incssp'.  If it is the 'ret' case, the token prevents
> > it.
> >  If it is the 'incssp' case, a guard page cannot prevent it
> > entirely,
> > right?
> I mean the other direction, on "call".

In the flow you described, if C writes to the overflow page before B
gets in with a 'call', the return address is still correct for B.  To
make an attack, C needs to write again before the TLB flush.  I agree
that is possible.

Assume we have a guard page, can someone in the short window do
recursive calls in B, move ssp to the end of the guard page, and
trigger the same again?  He can simply take the incssp route.
