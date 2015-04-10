From: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] audit.h: remove the macro AUDIT_ARCH_ARMEB definition
Date: Fri, 10 Apr 2015 08:21:47 +0800
Message-ID: <CAJFZqHw1++NnL=S4CsHWKOzoQ5ae0ekUtC=qf=wX3ZWJoYRc8w@mail.gmail.com>
References: <1426827329-27976-1-git-send-email-roy.qing.li@gmail.com>
	<CAHC9VhR5VcaCtLG9hdVS2gZRWxVmdnpbK+fJwm6wCA8qyLebUQ@mail.gmail.com>
	<18079199.sKrYvVCScd@x2>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <18079199.sKrYvVCScd@x2>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Grubb <sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Apr 3, 2015 at 8:42 PM, Steve Grubb <sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> Since this #define lives in the user visible headers I don't want to
>> remove it and risk causing a userspace breakage.  Leaving the #define
>> in the header, even if it is unused by modern userspace, is harmless.
>
> This macro doesn't appear to be in use by auditd.


ping ...
