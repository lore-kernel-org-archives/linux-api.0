From: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH] audit.h: remove the macro AUDIT_ARCH_ARMEB definition
Date: Tue, 24 Mar 2015 17:16:45 -0400
Message-ID: <CAHC9VhTbxf_u2FXkcdqofkhywbgrrjjUo_W7yqWXFm=wSJBOAQ@mail.gmail.com>
References: <1426827329-27976-1-git-send-email-roy.qing.li@gmail.com>
	<CAHC9VhR5VcaCtLG9hdVS2gZRWxVmdnpbK+fJwm6wCA8qyLebUQ@mail.gmail.com>
	<CAJFZqHxdPEhX+9z-FYUMvTF_6LVgK=gOetq0zT4UTZSgUGRqCQ@mail.gmail.com>
	<CAJFZqHxfq0DSjKn-uqhT+pAeJ9u8ym2Mr=wsqvPyX7sCicPGZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJFZqHxfq0DSjKn-uqhT+pAeJ9u8ym2Mr=wsqvPyX7sCicPGZA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, Mar 22, 2015 at 8:55 PM, Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Mon, Mar 23, 2015 at 8:51 AM, Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On Fri, Mar 20, 2015 at 9:29 PM, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org> wrote:
>>> On Fri, Mar 20, 2015 at 12:55 AM,  <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>> From: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>>
>>>> After 2f9783669 [ARM: 7412/1: audit: use only AUDIT_ARCH_ARM regardless
>>>> of endianness], no kernel user uses this macro;
>>>>
>>>> Keeping this macro, only makes the compiling old version audit [before
>>>> changeset 931 Improve ARM and AARCH64 support] success, but the audit
>>>> program can not work with the kernel after 2f9783669 still,
>>>> since no syscall entry is enabled for AUDIT_ARCH_ARMEB in kernel.
>>>>
>>>> so remove it to force to use the latest audit program
>>>>
>>>> Signed-off-by: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>> ---
>>>> other workaround is to define AUDIT_ARCH_ARMEB as AUDIT_ARCH_ARM,
>>>> but it seems very strange
>>>>
>>>>  include/uapi/linux/audit.h | 1 -
>>>>  1 file changed, 1 deletion(-)
>>>
>>> Since this #define lives in the user visible headers I don't want to
>>> remove it and risk causing a userspace breakage.  Leaving the #define
>>> in the header, even if it is
>
>
> it is harm, when I compile the audit-2.3.2 for a arm machine, whose linux kernel
> is 3.14; no compile error, but audit does not work;  spend one day debug to find
> the root cause is  the audit used MACH_ARMEB, but kernel replaced MACH_ARMEB
>  with MACH_ARM
>
>  grep WITH_ARMEB ./lib/machinetab.h -A10
> #ifdef WITH_ARMEB
> _S(MACH_ARMEB,   "armeb"  )
> _S(MACH_ARMEB,   "armv5tejl")
> _S(MACH_ARMEB,   "armv5tel")
> _S(MACH_ARMEB,   "armv6l")
> _S(MACH_ARMEB,   "armv7l")
> #endif
>
> removal of MACH_ARMEB will let the user find this issue when compile, not
> run.

[NOTE: Adding the linux-arm folks to this thread just in case they are
interested.]

I'm not an ARM expert, but the kernel #define for AUDIT_ARCH_ARMEB
(below) seems reasonable to me based on the other audit machine
definitions.  There is clearly a mismatch between the kernel and the
audit userspace, but I wonder if the issue should be addressed in the
userspace tools.  Further, you mention kernel 3.14, what happens with
kernel 3.19 and the most recent audit userspace tools?

  > grep "AUDIT_ARCH_ARMEB" include/uapi/linux/audit.h
  #define AUDIT_ARCH_ARMEB        (EM_ARM)

-Paul

-- 
paul moore
www.paul-moore.com
