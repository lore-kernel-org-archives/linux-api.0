From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [RFC PATCH v2 20/27] x86/cet/shstk: ELF header parsing of CET
Date: Wed, 11 Jul 2018 13:12:57 +0200
Message-ID: <10c224e9-933a-20d8-a286-5065a6cb10f1@redhat.com>
References: <20180710222639.8241-1-yu-cheng.yu@intel.com>
 <20180710222639.8241-21-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180710222639.8241-21-yu-cheng.yu@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromiun.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>Peter
List-Id: linux-api@vger.kernel.org

On 07/11/2018 12:26 AM, Yu-cheng Yu wrote:
> +	/*
> +	 * PT_NOTE segment is small.  Read at most
> +	 * PAGE_SIZE.
> +	 */
> +	if (note_size > PAGE_SIZE)
> +		note_size = PAGE_SIZE;

That's not really true.  There are some huge PT_NOTE segments out there.

Why can't you check the notes after the executable has been mapped?

Thanks,
Florian
