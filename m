From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH v2 18/27] x86/cet/shstk: Introduce WRUSS instruction
Date: Wed, 11 Jul 2018 17:30:44 +0200
Message-ID: <20180711153044.GK2476@hirez.programming.kicks-ass.net>
References: <20180710222639.8241-1-yu-cheng.yu@intel.com>
 <20180710222639.8241-19-yu-cheng.yu@intel.com>
 <20180711094448.GZ2476@hirez.programming.kicks-ass.net>
 <1531321615.13297.9.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1531321615.13297.9.camel@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromiun.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>, Ravi V. Shan
List-Id: linux-api@vger.kernel.org

On Wed, Jul 11, 2018 at 08:06:55AM -0700, Yu-cheng Yu wrote:
> On Wed, 2018-07-11 at 11:44 +0200, Peter Zijlstra wrote:

> > What happened to:
> > 
> >   https://lkml.kernel.org/r/1528729376.4526.0.camel@2b52.sc.intel.com
> 
> Yes, I put that in once and realized we only need to skip the
> instruction and return err.  Do you think we still need a handler for
> that?

I find that other form more readable, but then there's Nadav doing asm
macros to shrink inline asm thingies so maybe he has another suggestion.
