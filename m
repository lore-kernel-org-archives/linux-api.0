From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v2 16/27] mm: Modify can_follow_write_pte/pmd for
 shadow stack
Date: Wed, 18 Jul 2018 17:06:33 -0700
Message-ID: <f4c90626-51d8-5551-5b77-baaff81f16bb@linux.intel.com>
References: <20180710222639.8241-1-yu-cheng.yu@intel.com>
 <20180710222639.8241-17-yu-cheng.yu@intel.com>
 <de510df6-7ea9-edc6-9c49-2f80f16472b4@linux.intel.com>
 <1531328731.15351.3.camel@intel.com>
 <45a85b01-e005-8cb6-af96-b23ce9b5fca7@linux.intel.com>
 <1531868610.3541.21.camel@intel.com>
 <fa9db8c5-41c8-05e9-ad8d-dc6aaf11cb04@linux.intel.com>
 <1531944882.10738.1.camel@intel.com>
 <3f158401-f0b6-7bf7-48ab-2958354b28ad@linux.intel.com>
 <1531955428.12385.30.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1531955428.12385.30.camel@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromiun.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>, Peter Zijlstra <pet>
List-Id: linux-api@vger.kernel.org

>>> -static inline bool can_follow_write_pte(pte_t pte, unsigned int flags)
>>> +static inline bool can_follow_write(pte_t pte, unsigned int flags,
>>> +				    struct vm_area_struct *vma)
>>>  {
>>> -	return pte_write(pte) ||
>>> -		((flags & FOLL_FORCE) && (flags & FOLL_COW) && pte_dirty(pte));
>>> +	if (!is_shstk_mapping(vma->vm_flags)) {
>>> +		if (pte_write(pte))
>>> +			return true;
>> Let me see if I can say this another way.
>>
>> The bigger issue is that these patches change the semantics of
>> pte_write().  Before these patches, it meant that you *MUST* have this
>> bit set to write to the page controlled by the PTE.  Now, it means: you
>> can write if this bit is set *OR* the shadowstack bit combination is set.
> 
> Here, we only figure out (1) if the page is pointed by a writable PTE; or
> (2) if the page is pointed by a RO PTE (data or SHSTK) and it has been
> copied and it still exists.  We are not trying to
> determine if the
> SHSTK PTE is writable (we know it is not).

Please think about the big picture.  I'm not just talking about this
patch, but about every use of pte_write() in the kernel.

>> That's the fundamental problem.  We need some code in the kernel that
>> logically represents the concept of "is this PTE a shadowstack PTE or a
>> PTE with the write bit set", and we will call that pte_write(), or maybe
>> pte_writable().
>>
>> You *have* to somehow rectify this situation.  We can absolutely no
>> leave pte_write() in its current, ambiguous state where it has no real
>> meaning or where it is used to mean _both_ things depending on context.
> 
> True, the processor can always write to a page through a shadow stack
> PTE, but it must do that with a CALL instruction.  Can we define a 
> write operation as: MOV r1, *(r2).  Then we don't have any doubt on
> pte_write() any more.

No, we can't just move the target. :)

You can define it this way, but then you also need to go to every spot
in the kernel that calls pte_write() (and _PAGE_RW in fact) and audit it
to ensure it means "mov ..." and not push.
