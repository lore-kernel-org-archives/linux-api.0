From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH v2 16/27] mm: Modify can_follow_write_pte/pmd for
 shadow stack
Date: Wed, 11 Jul 2018 11:29:51 +0200
Message-ID: <20180711092951.GW2476@hirez.programming.kicks-ass.net>
References: <20180710222639.8241-1-yu-cheng.yu@intel.com>
 <20180710222639.8241-17-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180710222639.8241-17-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromiun.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>, Ravi V. Shan
List-Id: linux-api@vger.kernel.org

On Tue, Jul 10, 2018 at 03:26:28PM -0700, Yu-cheng Yu wrote:
> There are three possible shadow stack PTE settings:
> 
>   Normal SHSTK PTE: (R/O + DIRTY_HW)
>   SHSTK PTE COW'ed: (R/O + DIRTY_HW)
>   SHSTK PTE shared as R/O data: (R/O + DIRTY_SW)

I count _2_ distinct states there.

> Update can_follow_write_pte/pmd for the shadow stack.

So the below disallows can_follow_write when shstk && _PAGE_DIRTY_SW,
but this here Changelog doesn't explain why. Doesn't even get close.

Also, the code is a right mess :/ Can't we try harder to not let this
shadow stack stuff escape arch code.
