From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v8 15/27] mm: Handle shadow stack page fault
Date: Wed, 14 Aug 2019 09:48:08 -0700
Message-ID: <bf8a6390-97a6-1ab6-90ef-6399437ed38c@intel.com>
References: <20190813205225.12032-1-yu-cheng.yu@intel.com>
 <20190813205225.12032-16-yu-cheng.yu@intel.com>
 <CALCETrVKbqzivPfUOiGi5efHUpEsfPkNzP0CrmAZzcwUgf7quA@mail.gmail.com>
 <eabd0c16bd2028ad9fef8d10ddf570b3a10d5680.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <eabd0c16bd2028ad9fef8d10ddf570b3a10d5680.camel@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>, Andy Lutomirski <luto@kernel.org>
Cc: X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@or>
List-Id: linux-api@vger.kernel.org

On 8/14/19 9:27 AM, Yu-cheng Yu wrote:
> On Tue, 2019-08-13 at 15:55 -0700, Andy Lutomirski wrote:
>> On Tue, Aug 13, 2019 at 2:02 PM Yu-cheng Yu <yu-cheng.yu@intel.com> wrote:
>>> When a task does fork(), its shadow stack (SHSTK) must be duplicated
>>> for the child.  This patch implements a flow similar to copy-on-write
>>> of an anonymous page, but for SHSTK.
>>>
>>> A SHSTK PTE must be RO and dirty.  This dirty bit requirement is used
>>> to effect the copying.  In copy_one_pte(), clear the dirty bit from a
>>> SHSTK PTE to cause a page fault upon the next SHSTK access.  At that
>>> time, fix the PTE and copy/re-use the page.
>> Is using VM_SHSTK and special-casing all of this really better than
>> using a special mapping or other pseudo-file-backed VMA and putting
>> all the magic in the vm_operations?
> A special mapping is cleaner.  However, we also need to exclude normal [RO +
> dirty] pages from shadow stack.

I don't understand what you are saying.

Are you saying that we need this VM_SHSTK flag in order to exclude
RO+HW-Dirty pages from being created in non-shadow-stack VMAs?
