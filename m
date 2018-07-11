From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH v2 10/27] x86/mm: Introduce _PAGE_DIRTY_SW
Date: Wed, 11 Jul 2018 11:21:17 +0200
Message-ID: <20180711092117.GV2476@hirez.programming.kicks-ass.net>
References: <20180710222639.8241-1-yu-cheng.yu@intel.com>
 <20180710222639.8241-11-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180710222639.8241-11-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromiun.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>, Ravi V. Shan
List-Id: linux-api@vger.kernel.org

On Tue, Jul 10, 2018 at 03:26:22PM -0700, Yu-cheng Yu wrote:
> +static inline bool is_shstk_pte(pte_t pte)
> +{
> +	pteval_t val;
> +
> +	val = pte_flags(pte) & (_PAGE_RW | _PAGE_DIRTY_HW);
> +	return (val == _PAGE_DIRTY_HW);
> +}

That's against naming convention here.

static inline bool pte_shstk(pte_t pte)
{
	return pte_flags(pte) & (_PAGE_RW | _PAGE_DIRTY_HW) == _PAGE_DIRTY_HW;
}

would be more in style with the rest of this code.
