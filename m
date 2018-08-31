From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v3 12/24] x86/mm: Modify ptep_set_wrprotect and
 pmdp_set_wrprotect for _PAGE_DIRTY_SW
Date: Fri, 31 Aug 2018 09:29:51 -0700
Message-ID: <db8d4682-9ee0-b667-35ee-acedc64d9c1a@linux.intel.com>
References: <20180830143904.3168-1-yu-cheng.yu@intel.com>
 <20180830143904.3168-13-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180830143904.3168-13-yu-cheng.yu@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromiun.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>, Peter Zijlstra <pet>
List-Id: linux-api@vger.kernel.org

On 08/30/2018 07:38 AM, Yu-cheng Yu wrote:
> +	 * Some processors can start a write, but ending up seeing
> +	 * a read-only PTE by the time they get to the Dirty bit.
> +	 * In this case, they will set the Dirty bit, leaving a
> +	 * read-only, Dirty PTE which looks like a Shadow Stack PTE.
> +	 *
> +	 * However, this behavior has been improved and will not occur
> +	 * on processors supporting Shadow Stacks.  Without this
> +	 * guarantee, a transition to a non-present PTE and flush the
> +	 * TLB would be needed.

Did we publicly document this behavior anywhere?  I can't seem to find it.
