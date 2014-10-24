From: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3] kernel, add bug_on_warn
Date: Fri, 24 Oct 2014 07:39:21 -0400
Message-ID: <544A3A69.6010302@redhat.com>
References: <1414068794-22788-1-git-send-email-prarit@redhat.com>
 <20141023124034.f835060a667cde2bf6e9190c@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <20141023124034.f835060a667cde2bf6e9190c-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>, isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org



On 10/23/2014 03:40 PM, Andrew Morton wrote:
> On Thu, 23 Oct 2014 08:53:14 -0400 Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
>> There have been several times where I have had to rebuild a kernel to
>> cause a panic when hitting a WARN() in the code in order to get a crash
>> dump from a system.  Sometimes this is easy to do, other times (such as
>> in the case of a remote admin) it is not trivial to send new images to the
>> user.
>>
>> A much easier method would be a switch to change the WARN() over to a
>> BUG().  This makes debugging easier in that I can now test the actual
>> image the WARN() was seen on and I do not have to engage in remote
>> debugging.
>>
>> This patch adds a bug_on_warn kernel parameter, which calls BUG() in the
>> warn_slowpath_common() path.  The function will still print out the
>> location of the warning.
> 
> The changelog doesn't mention /proc/sys/kernel/bug_on_warn?

Oops ... I'll put that into a V4.

> 
> Why do we need both the sysctl and the kernel parameter?  Only to
> trigger BUG for warnings which occur prior to initscripts.  Is there a
> legitimate case for this?  Is kdump even usable at this time?

The kernel parameter is more of a catch-all IMO.  I'm going to be instructing
users to add it as a kernel parameter because I've found that most users are
willing to do that than muck with echo'ing into a file.

As Rusty pointed out, however, there may be cases where we're caught by an early
WARN() in the boot sequence and we want to avoid BUG()'ing there, so that we
catch the "run-time" WARN().

> 
>> --- a/include/asm-generic/bug.h
>> +++ b/include/asm-generic/bug.h
>> @@ -75,10 +75,18 @@ extern void warn_slowpath_null(const char *file, const int line);
>>  #define __WARN_printf_taint(taint, arg...)				\
>>  	warn_slowpath_fmt_taint(__FILE__, __LINE__, taint, arg)
>>  #else
>> -#define __WARN()		__WARN_TAINT(TAINT_WARN)
>> +#define check_bug_on_warn()						\
>> +	do {								\
>> +		if (bug_on_warn)					\
>> +			BUG();						\
>> +	} while (0)
> 
> #define check_bug_on_warn() BUG_ON(bug_on_warn)
> 
> would suffice?
> 

I'll fix that.

>> +#define __WARN()							\
>> +	do { __WARN_TAINT(TAINT_WARN); check_bug_on_warn(); } while (0)
>> +
>>  #define __WARN_printf(arg...)	do { printk(arg); __WARN(); } while (0)
>>  #define __WARN_printf_taint(taint, arg...)				\
>> -	do { printk(arg); __WARN_TAINT(taint); } while (0)
>> +	do { printk(arg); __WARN_TAINT(taint); check_bug_on_warn(); } while (0)
>>  #endif
> 
> What's this code here for anyway?  The changes to
> warn_slowpath_common() aren't sufficient?

Oh ... you're right.  I got confused by the WANT_WARN_ON_SLOWPATH config option.
 I'll clean this up.

> 

>>  #ifndef WARN_ON
>> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
>> index 40728cf..4094a60 100644
>> --- a/include/linux/kernel.h
>> +++ b/include/linux/kernel.h
>> @@ -422,6 +422,7 @@ extern int panic_on_oops;
>>  extern int panic_on_unrecovered_nmi;
>>  extern int panic_on_io_nmi;
>>  extern int sysctl_panic_on_stackoverflow;
>> +extern int bug_on_warn;
>>  /*
>>   * Only to be used by arch init code. If the user over-wrote the default
>>   * CONFIG_PANIC_TIMEOUT, honor it.
>> diff --git a/include/uapi/linux/sysctl.h b/include/uapi/linux/sysctl.h
>> index 43aaba1..2ba0a58 100644
>> --- a/include/uapi/linux/sysctl.h
>> +++ b/include/uapi/linux/sysctl.h
>> @@ -153,6 +153,7 @@ enum
>>  	KERN_MAX_LOCK_DEPTH=74, /* int: rtmutex's maximum lock depth */
>>  	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
>>  	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
>> +	KERN_BUG_ON_WARN=77, /* int: call BUG() in WARN() functions */
>>  };
>>  
>>  
>> diff --git a/kernel/panic.c b/kernel/panic.c
>> index d09dc5c..a6d2e2f 100644
>> --- a/kernel/panic.c
>> +++ b/kernel/panic.c
>> @@ -33,6 +33,7 @@ static int pause_on_oops;
>>  static int pause_on_oops_flag;
>>  static DEFINE_SPINLOCK(pause_on_oops_lock);
>>  static bool crash_kexec_post_notifiers;
>> +int bug_on_warn;
> 
> I suppose this should be __read_mostly.  Assuming __read_mostly is
> useful :(

I'll change this too.

P.

> 
>>
>> ...
>>
