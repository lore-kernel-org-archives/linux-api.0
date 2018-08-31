From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH v3 12/24] x86/mm: Modify ptep_set_wrprotect and
 pmdp_set_wrprotect for _PAGE_DIRTY_SW
Date: Fri, 31 Aug 2018 18:29:20 +0200
Message-ID: <20180831162920.GQ24124@hirez.programming.kicks-ass.net>
References: <1535660494.28258.36.camel@intel.com>
 <CAG48ez0yOuDhqxB779aO3Kss3gQ3cZTJL1VphDXQm+_M9jFPvQ@mail.gmail.com>
 <1535662366.28781.6.camel@intel.com>
 <CAG48ez0mkr95_TbLQnDGuGUd6G+eJVLZ-fEjDkwA6dSrm+9tLw@mail.gmail.com>
 <CAG48ez3S3+DzAyo_SnoUW1GO0Cpd_x0A83MOx2p_MkogoAatLQ@mail.gmail.com>
 <20180831095300.GF24124@hirez.programming.kicks-ass.net>
 <1535726032.32537.0.camel@intel.com>
 <f5a36e32-7c5f-91fe-9e98-fb44867fda11@linux.intel.com>
 <1535730524.501.13.camel@intel.com>
 <6d31bd30-6d5b-bbde-1e97-1d8255eff76d@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6d31bd30-6d5b-bbde-1e97-1d8255eff76d@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>, Jann Horn <jannh@google.com>, the arch/x86 maintainers <x86@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, Linux-MM <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Florian Weimer <fweimer@redhat.com>, hjl.tools@gmail.com, Jonathan Corbet <corbet@lwn.net>, keescook@chromiun.org, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.>
List-Id: linux-api@vger.kernel.org

On Fri, Aug 31, 2018 at 08:58:39AM -0700, Dave Hansen wrote:
> On 08/31/2018 08:48 AM, Yu-cheng Yu wrote:
> > To trigger a race in ptep_set_wrprotect(), we need to fork from one of
> > three pthread siblings.
> > 
> > Or do we measure only how much this affects fork?
> > If there is no racing, the effect should be minimal.
> 
> We don't need a race.
> 
> I think the cmpxchg will be slower, even without a race, than the code
> that was there before.  The cmpxchg is a simple, straightforward
> solution, but we're putting it in place of a plain memory write, which
> is suboptimal.

Note quite, the clear_bit() is LOCK prefixed.
