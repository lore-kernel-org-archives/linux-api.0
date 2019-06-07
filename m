From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v7 07/14] x86/cet/ibt: Add arch_prctl functions for IBT
Date: Fri, 7 Jun 2019 10:07:06 +0200
Message-ID: <20190607080706.GS3419@hirez.programming.kicks-ass.net>
References: <20190606200926.4029-1-yu-cheng.yu@intel.com>
 <20190606200926.4029-8-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190606200926.4029-8-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 06, 2019 at 01:09:19PM -0700, Yu-cheng Yu wrote:

> +static int handle_bitmap(unsigned long arg2)
> +{
> +	unsigned long addr, size;
> +
> +	if (get_user(addr, (unsigned long __user *)arg2) ||
> +	    get_user(size, (unsigned long __user *)arg2 + 1))
> +		return -EFAULT;
> +
> +	return cet_setup_ibt_bitmap(addr, size);
> +}


> +	/*
> +	 * Allocate legacy bitmap and return address & size to user.
> +	 */
> +	case ARCH_X86_CET_SET_LEGACY_BITMAP:
> +		return handle_bitmap(arg2);

AFAICT it does exactly the opposite of that comment; it gets the address
and size from userspace and doesn't allocate anything at all.
