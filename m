From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [RFC PATCH v3 05/24] Documentation/x86: Add CET description
Date: Sun, 2 Sep 2018 19:56:55 -0700
Message-ID: <709e5e6c-dab1-7a20-9641-b36a0867c006@infradead.org>
References: <20180830143904.3168-1-yu-cheng.yu@intel.com>
 <20180830143904.3168-6-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180830143904.3168-6-yu-cheng.yu@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromiun.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel
List-Id: linux-api@vger.kernel.org

Hi,

One spello:

On 08/30/2018 07:38 AM, Yu-cheng Yu wrote:

> diff --git a/Documentation/x86/intel_cet.rst b/Documentation/x86/intel_cet.rst
> new file mode 100644
> index 000000000000..337baa1f6980
> --- /dev/null
> +++ b/Documentation/x86/intel_cet.rst
> @@ -0,0 +1,252 @@
> +=========================================
> +Control Flow Enforcement Technology (CET)
> +=========================================
> +
> +[1] Overview
> +============
> +
> +Control Flow Enforcement Technology (CET) provides protection against
> +return/jump-oriented programing (ROP) attacks.  It can be implemented

                        programming

> +to protect both the kernel and applications.  In the first phase,
> +only the user-mode protection is implemented for the 64-bit kernel.
> +Thirty-two bit applications are supported under the compatibility
> +mode.


-- 
~Randy
