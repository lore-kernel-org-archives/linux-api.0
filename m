From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v2] capabilities.7, prctl.2: Document ambient capabilities
Date: Tue, 29 Sep 2015 10:47:45 -0700
Message-ID: <CAGXu5jJw9dDOQRwLCGXhTjii6tZkLC2C+O3MV8tBoh3OV9mFNQ@mail.gmail.com>
References: <5552a36c5511348a90806f9661a9382c2d362603.1443488521.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5552a36c5511348a90806f9661a9382c2d362603.1443488521.git.luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Sep 28, 2015 at 6:03 PM, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Signed-off-by: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  man2/prctl.2        | 12 ++++++++++++
>  man7/capabilities.7 | 40 ++++++++++++++++++++++++++++++++++------
>  2 files changed, 46 insertions(+), 6 deletions(-)
>
> diff --git a/man2/prctl.2 b/man2/prctl.2
> index e743a6305969..5bcec391c110 100644
> --- a/man2/prctl.2
> +++ b/man2/prctl.2
> @@ -954,6 +954,18 @@ had been called.
>  For further information on Intel MPX, see the kernel source file
>  .IR Documentation/x86/intel_mpx.txt .
>  .\"
> +.TP
> +.BR PR_CAP_AMBIENT " (since Linux 4.2)"
> +Reads or changes the ambient capability set.  If arg2 is PR_CAP_AMBIENT_RAISE,
> +then the capability specified in arg3 is added to the ambient set.  This will
> +fail, returning EPERM, if the capability is not already both permitted and
> +inheritable or if the SECBIT_NO_CAP_AMBIENT_RAISE securebit is set.  If arg2
> +is PR_CAP_AMBIENT_LOWER, then the capability specified in arg3 is removed
> +from the ambient set.  If arg2 is PR_CAP_AMBIENT_IS_SET, then
> +.BR prctl (2)
> +will return 1 if the capability in arg3 is in the ambient set and 0 if not.
> +If arg2 is PR_CAP_AMBIENT_CLEAR_ALL, then all capabilities will
> +be removed from the ambient set.

In the case of CLEAR_ALL, is arg3 "don't care", or must it be set to 0?

>  .SH RETURN VALUE
>  On success,
>  .BR PR_GET_DUMPABLE ,
> diff --git a/man7/capabilities.7 b/man7/capabilities.7
> index 616189c881e4..8934d05a5b07 100644
> --- a/man7/capabilities.7
> +++ b/man7/capabilities.7
> @@ -700,13 +700,34 @@ a program whose associated file capabilities grant that capability).
>  .IR Inheritable :
>  This is a set of capabilities preserved across an
>  .BR execve (2).
> -It provides a mechanism for a process to assign capabilities
> -to the permitted set of the new program during an
> -.BR execve (2).
> +Inheritable capabilities remain inheritable when executing any program,
> +and inheritable capabilities are added to the permitted set when executing
> +a program that has the corresponding bits set in the file inheritable set.
> +.IP
> +Because inheritable capabilities are not generally preserved across
> +.BR execve (2)
> +when running as a non-root user, applications that wish to run helper
> +programs with elevated capabilities should consider using ambient capabilities,
> +described below.
>  .TP
>  .IR Effective :
>  This is the set of capabilities used by the kernel to
>  perform permission checks for the thread.
> +.TP
> +.IR Ambient " (since Linux 4.3):"
> +This is a set of capabilities that are preserved across an
> +.BR execve (2)
> +of a program that does not have file capabilities.  The ambient capability
> +set obeys the invariant that no capability can ever be ambient if it is
> +not both permitted and inheritable.  Ambient capabilities are
> +preserved in the permitted set and added to the effective
> +set when
> +.BR execve (2)
> +is called.  The ambient capability set is modified using
> +.BR prctl (2).
> +Executing a program that changes uid or gid due to the setuid or setgid
> +bits or executing a program that has any file capabilities set will clear
> +the ambient set.
>  .PP
>  A child created via
>  .BR fork (2)
> @@ -788,10 +809,12 @@ the process using the following algorithm:
>  .in +4n
>  .nf
>
> +P'(ambient) = (file has capabilities or is setuid or setgid) ? 0 : P(ambient)
> +
>  P'(permitted) = (P(inheritable) & F(inheritable)) |
> -                (F(permitted) & cap_bset)
> +                (F(permitted) & cap_bset) | P'(ambient)
>
> -P'(effective) = F(effective) ? P'(permitted) : 0
> +P'(effective) = F(effective) ? P'(permitted) : P'(ambient)
>
>  P'(inheritable) = P(inheritable)    [i.e., unchanged]
>
> @@ -1074,6 +1097,10 @@ an effective or real UID of 0 calls
>  .BR execve (2).
>  (See the subsection
>  .IR "Capabilities and execution of programs by root" .)
> +.TP
> +.B SECBIT_NO_CAP_AMBIENT_RAISE
> +Setting this flag disallows
> +.BR PR_CAP_AMBIENT_RAISE .
>  .PP
>  Each of the above "base" flags has a companion "locked" flag.
>  Setting any of the "locked" flags is irreversible,
> @@ -1082,8 +1109,9 @@ corresponding "base" flag.
>  The locked flags are:
>  .BR SECBIT_KEEP_CAPS_LOCKED ,
>  .BR SECBIT_NO_SETUID_FIXUP_LOCKED ,
> +.BR SECBIT_NOROOT_LOCKED ,
>  and
> -.BR SECBIT_NOROOT_LOCKED .
> +.BR SECBIT_NO_CAP_AMBIENT_RAISE .
>  .PP
>  The
>  .I securebits
> --
> 2.4.3
>

Looks great, thanks!

Reviewed-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

-Kees

-- 
Kees Cook
Chrome OS Security
