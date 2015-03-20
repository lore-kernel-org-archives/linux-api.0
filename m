From: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH] audit.h: remove the macro AUDIT_ARCH_ARMEB definition
Date: Fri, 20 Mar 2015 09:29:14 -0400
Message-ID: <CAHC9VhR5VcaCtLG9hdVS2gZRWxVmdnpbK+fJwm6wCA8qyLebUQ@mail.gmail.com>
References: <1426827329-27976-1-git-send-email-roy.qing.li@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426827329-27976-1-git-send-email-roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Mar 20, 2015 at 12:55 AM,  <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> After 2f9783669 [ARM: 7412/1: audit: use only AUDIT_ARCH_ARM regardless
> of endianness], no kernel user uses this macro;
>
> Keeping this macro, only makes the compiling old version audit [before
> changeset 931 Improve ARM and AARCH64 support] success, but the audit
> program can not work with the kernel after 2f9783669 still,
> since no syscall entry is enabled for AUDIT_ARCH_ARMEB in kernel.
>
> so remove it to force to use the latest audit program
>
> Signed-off-by: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> other workaround is to define AUDIT_ARCH_ARMEB as AUDIT_ARCH_ARM,
> but it seems very strange
>
>  include/uapi/linux/audit.h | 1 -
>  1 file changed, 1 deletion(-)

Since this #define lives in the user visible headers I don't want to
remove it and risk causing a userspace breakage.  Leaving the #define
in the header, even if it is unused by modern userspace, is harmless.

> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> index d3475e1..125aa49 100644
> --- a/include/uapi/linux/audit.h
> +++ b/include/uapi/linux/audit.h
> @@ -351,7 +351,6 @@ enum {
>  #define AUDIT_ARCH_AARCH64     (EM_AARCH64|__AUDIT_ARCH_64BIT|__AUDIT_ARCH_LE)
>  #define AUDIT_ARCH_ALPHA       (EM_ALPHA|__AUDIT_ARCH_64BIT|__AUDIT_ARCH_LE)
>  #define AUDIT_ARCH_ARM         (EM_ARM|__AUDIT_ARCH_LE)
> -#define AUDIT_ARCH_ARMEB       (EM_ARM)
>  #define AUDIT_ARCH_CRIS                (EM_CRIS|__AUDIT_ARCH_LE)
>  #define AUDIT_ARCH_FRV         (EM_FRV)
>  #define AUDIT_ARCH_I386                (EM_386|__AUDIT_ARCH_LE)
> --
> 2.1.0
>



-- 
paul moore
www.paul-moore.com
