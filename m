From: Dmitry Safonov <0x7f454c46@gmail.com>
Subject: Re: [PATCHv4 03/28] posix-clocks: add another call back to return
 clock time in ktime_t
Date: Fri, 14 Jun 2019 15:39:13 +0100
Message-ID: <af700944-694c-822b-4633-7de945f9d228@gmail.com>
References: <20190612192628.23797-1-dima@arista.com>
 <20190612192628.23797-4-dima@arista.com>
 <alpine.DEB.2.21.1906141511440.1722@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1906141511440.1722@nanos.tec.linutronix.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Dmitry Safonov <dima@arista.com>
Cc: linux-kernel@vger.kernel.org, Andrei Vagin <avagin@gmail.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

Hi Thomas,

Thanks much for the review,

On 6/14/19 2:32 PM, Thomas Gleixner wrote:
> Dmitry,
> 
> On Wed, 12 Jun 2019, Dmitry Safonov wrote:
> 
>> From: Andrei Vagin <avagin@gmail.com>
>>
>> The callsite in common_timer_get() has already a comment:
>>         /*
>>          * The timespec64 based conversion is suboptimal, but it's not
>>          * worth to implement yet another callback.
>>          */
>>         kc->clock_get(timr->it_clock, &ts64);
>>         now = timespec64_to_ktime(ts64);
>>
>> Now we are going to add time namespaces and we need to be able to get:
> 
> Please avoid 'we' and try to describe the changes in a neutral technical
> form, e.g.:
> 
>  The upcoming support for time namespaces requires to have access to:
> 
>> * clock value in a task time namespace to return it from the clock_gettime
>>   syscall.
> 
>   - The time in a tasks time namespace for sys_clock_gettime()
> 
>> * clock valuse in the root time namespace to use it in
>>   common_timer_get().
> 
>   - The time in the root name space for common_timer_get()
> 
>> It looks like another reason why we need a separate callback to return
>> clock value in ktime_t.
> 
>  That adds a valid reason to finally implement a separate callback which
>  returns the time in ktime_t format.
> 
> Hmm?

Agree, the patch has become bigger than wanted and the message could
have been better in technical sense. Will split, add kernel doc and fix
the commit message(s).

[..]
> TBH, this patch is way to big. It changes too many things at once. Can you
> please structure it this way:
> 
>  1) Rename k_clock::clock_get to k_clock::clock_get_timespec and fix up all
>     struct initializers
> 
>  2) Rename the clock_get_timespec functions per instance
> 
>  3) Add the new callback
> 
>  4) Add the new functions per instance and add them to the corresponding
>     struct initializers
> 
>  5) Use the new callback
> 
Thanks,
          Dima
