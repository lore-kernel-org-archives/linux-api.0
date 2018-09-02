From: Balbir Singh <bsingharora@gmail.com>
Subject: Re: [RFC PATCH v3 00/24] Control Flow Enforcement: Shadow Stack
Date: Sun, 2 Sep 2018 18:13:50 +1000
Message-ID: <20180902081350.GF28695@350D>
References: <20180830143904.3168-1-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180830143904.3168-1-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromiun.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>, Peter Zijlstra <peterz@infradead.org>, Ravi V. Sha
List-Id: linux-api@vger.kernel.org

On Thu, Aug 30, 2018 at 07:38:40AM -0700, Yu-cheng Yu wrote:
> The previous version of CET patches can be found in the following
> link.
> 
>   https://lkml.org/lkml/2018/7/10/1031
> 
> Summary of changes from v2:
> 
>   Move Shadow Stack page fault handling logic to arch/x86.
>   Update can_follow_write_pte/pmd; move logic to arch/x86.
>   Fix problems in WRUSS in-line assembly.
>   Fix issues in ELF parser.
>   Split out IBT/PTRACE patches to a second set.
>   Other small fixes.
>

Quick question -- is there a simulator or some other way you've
been testing this? Just curious, if it's possible to run these
patches or just a review and internal hardware/simulator where
they are run and posted

Balbir Singh.
