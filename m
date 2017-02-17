From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCHv3 33/33] mm, x86: introduce PR_SET_MAX_VADDR and PR_GET_MAX_VADDR
Date: Fri, 17 Feb 2017 09:21:47 -0800
Message-ID: <CALCETrU957t7RQOAUJKWdjcA8t2ScWGkrnou2+cHksetC9aN=A@mail.gmail.com>
References: <20170217141328.164563-1-kirill.shutemov@linux.intel.com>
 <20170217141328.164563-34-kirill.shutemov@linux.intel.com> <ae15457f-731d-bb1b-c60d-14d641c265f0@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <ae15457f-731d-bb1b-c60d-14d641c265f0@intel.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>, linux-arch <linux-arch@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 17, 2017 at 9:19 AM, Dave Hansen <dave.hansen@intel.com> wrote:
> On 02/17/2017 06:13 AM, Kirill A. Shutemov wrote:
>> +/*
>> + * Default maximum virtual address. This is required for
>> + * compatibility with applications that assumes 47-bit VA.
>> + * The limit can be changed with prctl(PR_SET_MAX_VADDR).
>> + */
>> +#define MAX_VADDR_DEFAULT    ((1UL << 47) - PAGE_SIZE)
>
> This is a bit goofy.  It's not the largest virtual adddress that can be
> accessed, but the beginning of the last page.

No, it really is the limit.  We don't allow user code to map the last
page because ti would be a root hole due to SYSRET.  Thanks, Intel.
See the comment near TASK_SIZE_MAX IIRC.

--Andy
