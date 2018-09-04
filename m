From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [RFC PATCH v3 00/24] Control Flow Enforcement: Shadow Stack
Date: Tue, 04 Sep 2018 07:47:58 -0700
Message-ID: <1536072478.12366.2.camel@intel.com>
References: <20180830143904.3168-1-yu-cheng.yu@intel.com>
         <20180902081350.GF28695@350D>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180902081350.GF28695@350D>
Sender: linux-kernel-owner@vger.kernel.org
To: Balbir Singh <bsingharora@gmail.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>, Peter Zijlstra <peterz@infradead.org>, Ravi V. Sha
List-Id: linux-api@vger.kernel.org

On Sun, 2018-09-02 at 18:13 +1000, Balbir Singh wrote:
> On Thu, Aug 30, 2018 at 07:38:40AM -0700, Yu-cheng Yu wrote:
> > 
> > The previous version of CET patches can be found in the following
> > link.
> > 
> >   https://lkml.org/lkml/2018/7/10/1031
> > 
> > Summary of changes from v2:
> > 
> >   Move Shadow Stack page fault handling logic to arch/x86.
> >   Update can_follow_write_pte/pmd; move logic to arch/x86.
> >   Fix problems in WRUSS in-line assembly.
> >   Fix issues in ELF parser.
> >   Split out IBT/PTRACE patches to a second set.
> >   Other small fixes.
> > 
> Quick question -- is there a simulator or some other way you've
> been testing this? Just curious, if it's possible to run these
> patches or just a review and internal hardware/simulator where
> they are run and posted
> 
> Balbir Singh.

Currently only for review.

Yu-cheng
