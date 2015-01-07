From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 2/2] prctl.2: document SECCOMP_MODE_FILTER vs EFAULT
Date: Wed, 07 Jan 2015 09:43:04 +0100
Message-ID: <54ACF198.4050605@gmail.com>
References: <1411685267-27949-1-git-send-email-keescook@chromium.org> <1411685267-27949-3-git-send-email-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1411685267-27949-3-git-send-email-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: mtk.manpages@gmail.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 09/26/2014 12:47 AM, Kees Cook wrote:
> This notes the distinction made between EINVAL and EFAULT when attempting
> to use SECCOMP_MODE_FILTER with PR_SET_SECCOMP.

Thanks, Kees. Applied.

Cheers,

Michael


> Suggested-by: Andy Lutomirski <luto@amacapital.net>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  man2/prctl.2 | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/man2/prctl.2 b/man2/prctl.2
> index 1199891..b7ddaac 100644
> --- a/man2/prctl.2
> +++ b/man2/prctl.2
> @@ -825,6 +825,19 @@ is set appropriately.
>  .I arg2
>  is an invalid address.
>  .TP
> +.B EFAULT
> +.I option
> +is
> +.BR PR_SET_SECCOMP ,
> +.I arg2
> +is
> +.BR SECCOMP_MODE_FILTER ,
> +the system was built with
> +.BR CONFIG_SECCOMP_FILTER
> +and
> +.I arg3
> +is an invalid address.
> +.TP
>  .B EINVAL
>  The value of
>  .I option
> @@ -859,6 +872,16 @@ and the kernel was not configured with
>  .B EINVAL
>  .I option
>  is
> +.BR PR_SET_SECCOMP ,
> +.I arg2
> +is
> +.BR SECCOMP_MODE_FILTER ,
> +and the kernel was not configured with
> +.BR CONFIG_SECCOMP_FILTER .
> +.TP
> +.B EINVAL
> +.I option
> +is
>  .BR PR_SET_MM ,
>  and one of the following is true
>  .RS
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
