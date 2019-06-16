From: Dmitry Safonov <0x7f454c46@gmail.com>
Subject: Re: [PATCHv4 06/28] timerfd/timens: Take into account ns clock
 offsets
Date: Sun, 16 Jun 2019 18:43:49 +0100
Message-ID: <bf28eefd-390b-5209-09c1-db9874030369@gmail.com>
References: <20190612192628.23797-1-dima@arista.com>
 <20190612192628.23797-7-dima@arista.com>
 <alpine.DEB.2.21.1906141534090.1722@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1906141534090.1722@nanos.tec.linutronix.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Dmitry Safonov <dima@arista.com>
Cc: linux-kernel@vger.kernel.org, Andrei Vagin <avagin@gmail.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On 6/14/19 2:37 PM, Thomas Gleixner wrote:
> On Wed, 12 Jun 2019, Dmitry Safonov wrote:
>> ---
>>  fs/timerfd.c                   |  3 +++
>>  include/linux/time_namespace.h | 18 ++++++++++++++++++
>>  kernel/time_namespace.c        | 27 +++++++++++++++++++++++++++
>>  3 files changed, 48 insertions(+)
> 
> Again, please split that into:
> 
>    1) Introduce the new function
> 
>    2) Make use of it

Will do

> 
>> diff --git a/fs/timerfd.c b/fs/timerfd.c
>> index 6a6fc8aa1de7..9b0c2f65e7e8 100644
>> --- a/fs/timerfd.c
>> +++ b/fs/timerfd.c
>> @@ -26,6 +26,7 @@
>>  #include <linux/syscalls.h>
>>  #include <linux/compat.h>
>>  #include <linux/rcupdate.h>
>> +#include <linux/time_namespace.h>
>>  
>>  struct timerfd_ctx {
>>  	union {
>> @@ -196,6 +197,8 @@ static int timerfd_setup(struct timerfd_ctx *ctx, int flags,
>>  	}
>>  
>>  	if (texp != 0) {
>> +		if (flags & TFD_TIMER_ABSTIME)
>> +			texp = timens_ktime_to_host(clockid, texp);
>>  		if (isalarm(ctx)) {
>>  			if (flags & TFD_TIMER_ABSTIME)
>>  				alarm_start(&ctx->t.alarm, texp);
>> diff --git a/include/linux/time_namespace.h b/include/linux/time_namespace.h
>> index 1dda8af6b9fe..d32b55fad953 100644
>> --- a/include/linux/time_namespace.h
>> +++ b/include/linux/time_namespace.h
>> @@ -56,6 +56,19 @@ static inline void timens_add_boottime(struct timespec64 *ts)
>>                  *ts = timespec64_add(*ts, ns_offsets->boottime);
>>  }
>>  
>> +ktime_t do_timens_ktime_to_host(clockid_t clockid, ktime_t tim,
>> +				struct timens_offsets *offsets);
>> +static inline ktime_t timens_ktime_to_host(clockid_t clockid, ktime_t tim)
>> +{
>> +	struct timens_offsets *offsets = current->nsproxy->time_ns->offsets;
>> +
>> +	if (!offsets) /* fast-path for the root time namespace */
> 
> Can you please avoid tail comments. They break the reading flow. Aside of
> that I don't see the value of documenting the obvious.
> 
>> +ktime_t do_timens_ktime_to_host(clockid_t clockid, ktime_t tim, struct timens_offsets *ns_offsets)
> 
> Please line break the arguments
> 
> ktime_t do_timens_ktime_to_host(clockid_t clockid, ktime_t tim,
> 				struct timens_offsets *ns_offsets)

Sure

> 
>> +{
>> +	ktime_t koff;
>> +
>> +	switch (clockid) {
>> +	case CLOCK_MONOTONIC:
>> +		koff = timespec64_to_ktime(ns_offsets->monotonic);
>> +		break;
>> +	case CLOCK_BOOTTIME:
>> +	case CLOCK_BOOTTIME_ALARM:
>> +		koff = timespec64_to_ktime(ns_offsets->boottime);
>> +		break;
>> +	default:
>> +		return tim;
>> +	}
>> +
>> +	/* tim - off has to be in [0, KTIME_MAX) */
> 
> Please be more elaborate why the below conditions can happen at all.
> 
>> +	if (tim < koff)
>> +		tim = 0;
>> +	else if (KTIME_MAX - tim < -koff)
>> +		tim = KTIME_MAX;
>> +	else
>> +		tim = ktime_sub(tim, koff);

Thanks,
          Dmitry
