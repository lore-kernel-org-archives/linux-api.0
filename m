From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] seccomp.2: Add note about alarm(2) not being sufficient
 to limit runtime
Date: Sun, 22 Mar 2015 20:28:14 +0100
Message-ID: <550F17CE.5080400@gmail.com>
References: <20150311174204.GA5712@pc.thejh.net> <21760.46870.338764.599348@gargle.gargle.HOWL> <20150312130701.GA11073@pc.thejh.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150312130701.GA11073-J1fxOzX/cBvk1uMJSBkQmQ@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Mikael Pettersson <mikpelinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Jann,

On 03/12/2015 02:07 PM, Jann Horn wrote:
> On Wed, Mar 11, 2015 at 10:43:50PM +0100, Mikael Pettersson wrote:
>> Jann Horn writes:
>>  > Or should I throw this patch away and write a patch
>>  > for the prctl() manpage instead that documents that
>>  > being able to call sigreturn() implies being able to
>>  > effectively call sigprocmask(), at least on some
>>  > architectures like X86?
>>
>> Well, that is the semantics of sigreturn().  It is essentially
>> setcontext() [which includes the actions of sigprocmask()], but
>> with restrictions on parameter placement (at least on x86).
>>
>> You could introduce some setting to restrict that aspect for
>> seccomp processes, but you can't change this for normal processes
>> without breaking things.
> 
> Then I think it's probably better and easier to just document the existing
> behavior? If a new setting would have to be introduced and developers would
> need to be aware of that, it's probably easier to just tell everyone to use
> SIGKILL.
> 
> Does this manpage patch look good?

Patch applied, with Acks from Andy, Mikael, and Kees (I don't
usually get patches whose pedigree is that good. Thanks!)

I tweaked a few wordings. You can find the changes in Git [1]

Cheers,

Michael

[1] 
http://git.kernel.org/cgit/docs/man-pages/man-pages.git/commit/?id=65be1b46fb88e14f0af494ac6b53a2d6a63bb860

> ---
>  man2/seccomp.2 | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/man2/seccomp.2 b/man2/seccomp.2
> index 702ceb8..f762d07 100644
> --- a/man2/seccomp.2
> +++ b/man2/seccomp.2
> @@ -64,6 +64,31 @@ Strict secure computing mode is useful for number-crunching
>  applications that may need to execute untrusted byte code, perhaps
>  obtained by reading from a pipe or socket.
>  
> +Note that although the calling thread can no longer call
> +.BR sigprocmask (2),
> +it can use
> +.BR sigreturn (2)
> +to block all signals apart from
> +.BR SIGKILL
> +and
> +.BR SIGSTOP .
> +Therefore, to reliably terminate it,
> +.BR SIGKILL
> +has to be used, meaning that e.g.
> +.BR alarm (2)
> +is not sufficient for restricting its runtime. Instead, use
> +.BR timer_create (2)
> +with
> +.BR SIGEV_SIGNAL
> +and
> +.BR sigev_signo
> +set to
> +.BR SIGKILL
> +or use
> +.BR setrlimit (2)
> +to set the hard limit for
> +.BR RLIMIT_CPU .
> +
>  This operation is available only if the kernel is configured with
>  .BR CONFIG_SECCOMP
>  enabled.
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
