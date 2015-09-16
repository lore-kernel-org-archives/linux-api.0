From: Helge Deller <deller-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [PATCH v2 4/9] parisc: allocate sys_membarrier system call number
Date: Wed, 16 Sep 2015 21:56:48 +0200
Message-ID: <55F9C980.7040406@gmx.de>
References: <1441642556-30972-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1441642556-30972-5-git-send-email-mathieu.desnoyers@efficios.com>
 <1649019858.9290.1442416020165.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1649019858.9290.1442416020165.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, "James E.J. Bottomley" <jejb-6jwH94ZQLHl74goWV3ctuw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-parisc <linux-parisc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 16.09.2015 17:07, Mathieu Desnoyers wrote:
> ----- On Sep 7, 2015, at 12:15 PM, Mathieu Desnoyers mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org wrote:
> 
>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
>> Tested-by: Helge Deller <deller-Mmb7MZpHnFY@public.gmane.org>
>> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>> CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> CC: "James E.J. Bottomley" <jejb-6jwH94ZQLHl74goWV3ctuw@public.gmane.org>
>> CC: linux-parisc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> 
> Hi,
> 
> FYI, sys_membarrier has been pulled into Linux 4.3-rc1. Please
> feel free to wire it up on parisc.

Thanks for the notice.
I'll include your patch with an upcoming parisc pull-request later in the 4.3 cycle.

Helge


>> ---
>> arch/parisc/include/uapi/asm/unistd.h | 3 ++-
>> arch/parisc/kernel/syscall_table.S    | 1 +
>> 2 files changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/parisc/include/uapi/asm/unistd.h
>> b/arch/parisc/include/uapi/asm/unistd.h
>> index 2e639d7..dadcada 100644
>> --- a/arch/parisc/include/uapi/asm/unistd.h
>> +++ b/arch/parisc/include/uapi/asm/unistd.h
>> @@ -358,8 +358,9 @@
>> #define __NR_memfd_create	(__NR_Linux + 340)
>> #define __NR_bpf		(__NR_Linux + 341)
>> #define __NR_execveat		(__NR_Linux + 342)
>> +#define __NR_membarrier		(__NR_Linux + 343)
>>
>> -#define __NR_Linux_syscalls	(__NR_execveat + 1)
>> +#define __NR_Linux_syscalls	(__NR_membarrier + 1)
>>
>>
>> #define __IGNORE_select		/* newselect */
>> diff --git a/arch/parisc/kernel/syscall_table.S
>> b/arch/parisc/kernel/syscall_table.S
>> index 8eefb12..4e77991 100644
>> --- a/arch/parisc/kernel/syscall_table.S
>> +++ b/arch/parisc/kernel/syscall_table.S
>> @@ -438,6 +438,7 @@
>> 	ENTRY_SAME(memfd_create)	/* 340 */
>> 	ENTRY_SAME(bpf)
>> 	ENTRY_COMP(execveat)
>> +	ENTRY_SAME(membarrier)
>>
>>
>> .ifne (. - 90b) - (__NR_Linux_syscalls * (91b - 90b))
>> --
>> 1.9.1
> 
