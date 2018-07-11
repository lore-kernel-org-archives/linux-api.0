From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v2 22/27] x86/cet/ibt: User-mode indirect branch
 tracking support
Date: Wed, 11 Jul 2018 16:16:44 -0700
Message-ID: <25675609-9ea7-55fb-6e73-b4a4c49b6c35@linux.intel.com>
References: <20180710222639.8241-1-yu-cheng.yu@intel.com>
 <20180710222639.8241-23-yu-cheng.yu@intel.com>
 <3a7e9ce4-03c6-cc28-017b-d00108459e94@linux.intel.com>
 <1531347019.15351.89.camel@intel.com>
 <f97ce234-52fa-e666-2250-098925cf3c39@linux.intel.com>
 <1531350028.15351.102.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1531350028.15351.102.camel@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromiun.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>, Peter Zijlstra <pet>
List-Id: linux-api@vger.kernel.org

On 07/11/2018 04:00 PM, Yu-cheng Yu wrote:
> On Wed, 2018-07-11 at 15:40 -0700, Dave Hansen wrote:
>> On 07/11/2018 03:10 PM, Yu-cheng Yu wrote:
>>>
>>> On Tue, 2018-07-10 at 17:11 -0700, Dave Hansen wrote:
>>>>
>>>> Is this feature *integral* to shadow stacks?  Or, should it just
>>>> be
>>>> in a
>>>> different series?
>>> The whole CET series is mostly about SHSTK and only a minority for
>>> IBT.
>>> IBT changes cannot be applied by itself without first applying
>>> SHSTK
>>> changes.  Would the titles help, e.g. x86/cet/ibt, x86/cet/shstk,
>>> etc.?
>> That doesn't really answer what I asked, though.
>>
>> Do shadow stacks *require* IBT?  Or, should we concentrate on merging
>> shadow stacks themselves first and then do IBT at a later time, in a
>> different patch series?
>>
>> But, yes, better patch titles would help, although I'm not sure
>> that's
>> quite the format that Ingo and Thomas prefer.
> 
> Shadow stack does not require IBT, but they complement each other.  If
> we can resolve the legacy bitmap, both features can be merged at the
> same time.

As large as this patch set is, I'd really prefer to see you get shadow
stacks merged and then move on to IBT.  I say separate them.

> GLIBC does the bitmap setup.  It sets bits in there.
> I thought you wanted a smaller bitmap?  One way is forcing legacy libs
> to low address, or not having the bitmap at all, i.e. turn IBT off.

I'm concerned with two things:
1. the virtual address space consumption, especially the *default* case
   which will be apps using 4-level address space amounts, but having
   5-level-sized tables.
2. the driving a truck-sized hole in the address space limits

You can force legacy libs to low addresses, but you can't stop anyone
from putting code into a high address *later*, at least with the code we
have today.

>>>>> +	rdmsrl(MSR_IA32_U_CET, r);
>>>>> +	r &= ~(MSR_IA32_CET_ENDBR_EN | MSR_IA32_CET_LEG_IW_EN
>>>>> |
>>>>> +	       MSR_IA32_CET_NO_TRACK_EN);
>>>>> +	wrmsrl(MSR_IA32_U_CET, r);
>>>>> +	current->thread.cet.ibt_enabled = 0;
>>>>> +}
>>>> What's the locking for current->thread.cet?
>>> Now CET is not locked until the application calls ARCH_CET_LOCK.
>> No, I mean what is the in-kernel locking for the current->thread.cet
>> data structure?  Is there none because it's only every modified via
>> current->thread and it's entirely thread-local?
> 
> Yes, that is the case.
