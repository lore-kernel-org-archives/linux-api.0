From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH 7/9] alpha: allocate sys_membarrier system call
 number
Date: Thu, 27 Aug 2015 19:06:40 +0000 (UTC)
Message-ID: <1110771579.30446.1440702400458.JavaMail.zimbra@efficios.com>
References: <1440698215-8355-1-git-send-email-mathieu.desnoyers@efficios.com> <1440698215-8355-8-git-send-email-mathieu.desnoyers@efficios.com> <CAEdQ38HvhvcbmV_zCi=hHBnx7OnuHgX_SvvhEFjs+-hYYaDa_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAEdQ38HvhvcbmV_zCi=hHBnx7OnuHgX_SvvhEFjs+-hYYaDa_w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Turner <mattst88-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Richard Henderson <rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org>, Ivan Kokshaysky <ink-biIs/Y0ymYJMZLIVYojuPNP0rXTJTi09@public.gmane.org>, linux-alpha <linux-alpha-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org



----- On Aug 27, 2015, at 2:34 PM, Matt Turner mattst88-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> On Thu, Aug 27, 2015 at 10:56 AM, Mathieu Desnoyers
> <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>> [ Untested on this architecture. To try it out: fetch linux-next/akpm,
>>   apply this patch, build/run a membarrier-enabled kernel, and do make
>>   kselftest. ]
>>
>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
>> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>> CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> CC: Richard Henderson <rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org>
>> CC: Ivan Kokshaysky <ink-biIs/Y0ymYJMZLIVYojuPNP0rXTJTi09@public.gmane.org>
>> CC: Matt Turner <mattst88-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> CC: linux-alpha-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> ---
>>  arch/alpha/include/uapi/asm/unistd.h | 1 +
>>  arch/alpha/kernel/systbls.S          | 1 +
>>  2 files changed, 2 insertions(+)
>>
>> diff --git a/arch/alpha/include/uapi/asm/unistd.h
>> b/arch/alpha/include/uapi/asm/unistd.h
>> index aa33bf5..7725619 100644
>> --- a/arch/alpha/include/uapi/asm/unistd.h
>> +++ b/arch/alpha/include/uapi/asm/unistd.h
>> @@ -475,5 +475,6 @@
>>  #define __NR_getrandom                 511
>>  #define __NR_memfd_create              512
>>  #define __NR_execveat                  513
>> +#define __NR_membarrier                        514
> 
> NR_SYSCALLS in arch/alpha/include/asm/unistd.h needs to be updated as well.
> 

Will send a v2 with this modif, thanks!

Mathieu

>>
>>  #endif /* _UAPI_ALPHA_UNISTD_H */
>> diff --git a/arch/alpha/kernel/systbls.S b/arch/alpha/kernel/systbls.S
>> index 9b62e3f..1ea64f4 100644
>> --- a/arch/alpha/kernel/systbls.S
>> +++ b/arch/alpha/kernel/systbls.S
>> @@ -532,6 +532,7 @@ sys_call_table:
>>         .quad sys_getrandom
>>         .quad sys_memfd_create
>>         .quad sys_execveat
>> +       .quad sys_membarrier
>>
>>         .size sys_call_table, . - sys_call_table
>>         .type sys_call_table, @object
>> --
>> 1.9.1

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
