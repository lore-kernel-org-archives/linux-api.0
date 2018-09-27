From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] rseq/selftests: fix parametrized test with -fpie
Date: Thu, 27 Sep 2018 14:02:08 -0400 (EDT)
Message-ID: <44897232.11546.1538071328396.JavaMail.zimbra@efficios.com>
References: <20180918135328.32034-1-mathieu.desnoyers@efficios.com> <1367962117.10271.1537897176578.JavaMail.zimbra@efficios.com> <CGME20180927132250epcas4p3d0775cc258f6112d27bdad359fc6e416@epcas4p3.samsung.com> <20180927092235.77282e35@vmware.local.home> <a7bae2ff-1f4d-dbfc-43f8-e7a89f319abb@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a7bae2ff-1f4d-dbfc-43f8-e7a89f319abb@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: shuah kh <shuah.kh@samsung.com>
Cc: rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, Shuah Khan <shuahkh@osg.samsung.com>, linux-kselftest <linux-kselftest@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Josh Triplett <josh@joshtriplett.org>, Linus
List-Id: linux-api@vger.kernel.org

----- On Sep 27, 2018, at 9:58 AM, Shuah Khan shuah.kh@samsung.com wrote:

> On 09/27/2018 07:22 AM, Steven Rostedt wrote:
>> On Tue, 25 Sep 2018 13:39:36 -0400 (EDT)
>> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
>> 
>>> ----- On Sep 18, 2018, at 9:53 AM, Mathieu Desnoyers
>>> mathieu.desnoyers@efficios.com wrote:
>>>
>>>> On x86-64, the parametrized selftest code for rseq crashes with a
>>>> segmentation fault when compiled with -fpie. This happens when the
>>>> param_test binary is loaded at an address beyond 32-bit on x86-64.
>>>>
>>>> The issue is caused by use of a 32-bit register to hold the address
>>>> of the loop counter variable.
>>>>
>>>> Fix this by using a 64-bit register to calculate the address of the
>>>> loop counter variables as an offset from rip.
>>>
>>> Should this fix go through tip or the selftests tree ?
>>>
>> 
>> I usually have changes like this pulled through Shuah's tree with an
>> ack from the maintainer of the code that it tests.
>> 
>> -- Steve
>> 
> 
> Right that is what I prefer. I usually wait for an Ack. I can pull this
> in.

I am maintainer of the code that it tests as well, so being both author
of the selftest patch and giving an ack to it seems a bit silly. :) Other
rseq co-maintainers could weight in though: Peter, Paul, and Boqun.

Thanks,

Mathieu

> 
> thanks,
> -- Shuah
> 
> --
> Shuah Khan
> Sr. Linux Kernel Developer
> Open Source Innovation Group
> Samsung Research America(Silicon Valley)
> shuah.kh@samsung.com

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
