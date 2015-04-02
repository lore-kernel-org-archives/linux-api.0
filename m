From: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] audit.h: remove the macro AUDIT_ARCH_ARMEB definition
Date: Thu, 2 Apr 2015 08:52:38 +0800
Message-ID: <CAJFZqHxos3WUS4O9By0MLh-0GOTyk+BRvDJczwW=xjt393u=sQ@mail.gmail.com>
References: <1426827329-27976-1-git-send-email-roy.qing.li@gmail.com>
	<CAHC9VhR5VcaCtLG9hdVS2gZRWxVmdnpbK+fJwm6wCA8qyLebUQ@mail.gmail.com>
	<CAJFZqHxdPEhX+9z-FYUMvTF_6LVgK=gOetq0zT4UTZSgUGRqCQ@mail.gmail.com>
	<CAJFZqHxfq0DSjKn-uqhT+pAeJ9u8ym2Mr=wsqvPyX7sCicPGZA@mail.gmail.com>
	<CAHC9VhTbxf_u2FXkcdqofkhywbgrrjjUo_W7yqWXFm=wSJBOAQ@mail.gmail.com>
	<CAJFZqHzxXyuzi7Z9WawYKfFnTMfYfsRL0Qnt276p_t-AV9GB2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJFZqHzxXyuzi7Z9WawYKfFnTMfYfsRL0Qnt276p_t-AV9GB2A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Cc: Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 25, 2015 at 8:01 AM, Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Wed, Mar 25, 2015 at 5:16 AM, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org> wrote:
>> [NOTE: Adding the linux-arm folks to this thread just in case they are
>> interested.]
>>
>> I'm not an ARM expert, but the kernel #define for AUDIT_ARCH_ARMEB
>> (below) seems reasonable to me based on the other audit machine
>> definitions.  There is clearly a mismatch between the kernel and the
>> audit userspace, but I wonder if the issue should be addressed in the
>> userspace tools.  Further, you mention kernel 3.14, what happens with
>> kernel 3.19 and the most recent audit userspace tools?
>>
>>   > grep "AUDIT_ARCH_ARMEB" include/uapi/linux/audit.h
>>   #define AUDIT_ARCH_ARMEB        (EM_ARM)
>
>


ping...

-Roy
