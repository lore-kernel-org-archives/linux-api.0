From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v2 12/27] x86/mm: Shadow stack page fault error
 checking
Date: Tue, 10 Jul 2018 15:52:55 -0700
Message-ID: <61793360-f37c-ec19-c390-abe3c76a5f5c@linux.intel.com>
References: <20180710222639.8241-1-yu-cheng.yu@intel.com>
 <20180710222639.8241-13-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180710222639.8241-13-yu-cheng.yu@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromiun.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>, Peter Zijlstra <pet>
List-Id: linux-api@vger.kernel.org

On 07/10/2018 03:26 PM, Yu-cheng Yu wrote:
> +++ b/arch/x86/include/asm/traps.h
> @@ -157,6 +157,7 @@ enum {
>   *   bit 3 ==				1: use of reserved bit detected
>   *   bit 4 ==				1: fault was an instruction fetch
>   *   bit 5 ==				1: protection keys block access
> + *   bit 6 ==				1: shadow stack access fault
>   */

Could we document this bit better?

Is this a fault where the *processor* thought it should be a shadow
stack fault?  Or is it also set on faults to valid shadow stack PTEs
that just happen to fault for other reasons, say protection keys?
