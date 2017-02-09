From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [RFC] syscalls: Restore address limit after a syscall
Date: Thu, 9 Feb 2017 11:31:35 -0800
Message-ID: <CAGXu5j+hyXxpyU1R+BeL9RwPhT6HSNE0c_b7MP_V0rYSAepYFw@mail.gmail.com>
References: <20170209183358.103094-1-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170209183358.103094-1-thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org>, Stephen Bates <stephen.bates-PwyqCcigF0Q@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org" <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 9, 2017 at 10:33 AM, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> This patch prevents a syscall to modify the address limit of the
> caller. The address limit is kept by the syscall wrapper and restored
> just after the syscall ends.
>
> For example, it would mitigation this bug:
>
> - https://bugs.chromium.org/p/project-zero/issues/detail?id=990
>
> Signed-off-by: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
> Based on next-20170209
> ---
>  include/linux/syscalls.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 91a740f6b884..a1b6a62a9849 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -198,7 +198,10 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>         asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__));      \
>         asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__))       \
>         {                                                               \
> -               long ret = SYSC##name(__MAP(x,__SC_CAST,__VA_ARGS__));  \
> +               long ret;                                               \
> +               mm_segment_t fs = get_fs();                             \
> +               ret = SYSC##name(__MAP(x,__SC_CAST,__VA_ARGS__));       \
> +               set_fs(fs);                                             \
>                 __MAP(x,__SC_TEST,__VA_ARGS__);                         \
>                 __PROTECT(x, ret,__MAP(x,__SC_ARGS,__VA_ARGS__));       \
>                 return ret;                                             \
> --
> 2.11.0.483.g087da7b7c-goog
>

I have a memory of Andy looking at this before, and there was some
problem with how a bunch of compat code would set fs and then re-call
the syscall... but I can't quite find the conversation. Andy, do you
remember the details?

This seems like an entirely reasonable thing to enforce for syscalls,
though I'm sure there's a gotcha somewhere. :)

-Kees

-- 
Kees Cook
Pixel Security
