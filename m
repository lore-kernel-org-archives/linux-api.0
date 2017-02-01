From: Helge Deller <deller-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [PATCH] prctl: implement PR_GET_ENDIAN for all architectures
Date: Wed, 1 Feb 2017 20:47:06 +0100
Message-ID: <7c60f97a-4b63-5eff-e837-186f9a31c5a2@gmx.de>
References: <20170128111310.GA13389@ls3530.fritz.box>
 <20170131162624.5a85ec47c6ee22e5cc03c4eb@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170131162624.5a85ec47c6ee22e5cc03c4eb-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-parisc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Andrew,

On 01.02.2017 01:26, Andrew Morton wrote:
> On Sat, 28 Jan 2017 12:13:10 +0100 Helge Deller <deller-Mmb7MZpHnFY@public.gmane.org> wrote:
> 
>> The prctl(PR_GET_ENDIAN) syscall was added to Kernel 2.6.18, but
>> implemented for PowerPC only.
>> This trivial patch adds support for this syscall for all other architectures.
> 
> Seems reasonable.  I guess.

Heck, I did forgot but I submitted a similar patch 8 years ago:
http://www.serverphorums.com/read.php?12,51902

> Why is this needed?

It's not actually needed beside the trivial reason of providing an interface
not just for one single architecture.

After reading the discussion from 2009 again, I'm fine if 
you would simply drop the patch. The decision up to you.

> The man page will need updating.  It says "PowerPC only".

In case you would include the patch I'd send patches to update
the manpage.

Thanks,
Helge

>> diff --git a/kernel/sys.c b/kernel/sys.c
>> index 842914e..5818e5e 100644
>> --- a/kernel/sys.c
>> +++ b/kernel/sys.c
>> @@ -79,9 +79,6 @@
>>  #ifndef GET_FPEXC_CTL
>>  # define GET_FPEXC_CTL(a, b)	(-EINVAL)
>>  #endif
>> -#ifndef GET_ENDIAN
>> -# define GET_ENDIAN(a, b)	(-EINVAL)
>> -#endif
>>  #ifndef SET_ENDIAN
>>  # define SET_ENDIAN(a, b)	(-EINVAL)
>>  #endif
>> @@ -2136,7 +2133,13 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>>  			return -EFAULT;
>>  		break;
>>  	case PR_GET_ENDIAN:
>> +#ifdef GET_ENDIAN
>>  		error = GET_ENDIAN(me, arg2);
>> +#elif defined(__BIG_ENDIAN)
>> +		error = put_user(PR_ENDIAN_BIG, (unsigned int __user *)arg2);
>> +#else
>> +		error = put_user(PR_ENDIAN_LITTLE, (unsigned int __user *)arg2);
>> +#endif
>>  		break;
>>  	case PR_SET_ENDIAN:
>>  		error = SET_ENDIAN(me, arg2);
