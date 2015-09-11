From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH man-pages v2] capabilities.7, prctl.2: Document ambient capabilities
Date: Fri, 11 Sep 2015 10:28:13 +0200
Message-ID: <CAKgNAkhtGSh0ZjfDOzeHUt4zthdtGiEj1WurwYtFc4cTVLOn1g@mail.gmail.com>
References: <f85ae308af4946436e82aaa9dd71bcd4b39bd196.1431672156.git.luto@kernel.org>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f85ae308af4946436e82aaa9dd71bcd4b39bd196.1431672156.git.luto@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, Andrew Morton <akpm@linuxfoundation.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Ted Ts'o <tytso@mit.edu>, "Andrew G. Morgan" <morgan@kernel.org>, Linux API <linux-api@vger.kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-security-module <linux-security-module@vger.kernel.org>, Aaron Jones <aaronmdjones@gmail.com>, Serge Hallyn <serge.hallyn@canonical.com>, LKML <linux-kernel@vger.kernel.org>, Markku Savela <msa@moth.iki.fi>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

Hi Andy,

Not that this has hit mainline, would you be willing to refresh this
man-pages patch?

Thanks,

Michael



On 15 May 2015 at 08:43, Andy Lutomirski <luto@kernel.org> wrote:
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
>
> There was no v1.  I'm calling this v2 to keep it in sync with the kernel
> patch versioning.
>
>  man2/prctl.2        | 10 ++++++++++
>  man7/capabilities.7 | 32 ++++++++++++++++++++++++++------
>  2 files changed, 36 insertions(+), 6 deletions(-)
>
> diff --git a/man2/prctl.2 b/man2/prctl.2
> index b352f6283624..5861e3aefe9a 100644
> --- a/man2/prctl.2
> +++ b/man2/prctl.2
> @@ -949,6 +949,16 @@ had been called.
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
> +from the ambient set.  If arg2 is PR_CAP_AMBIENT_GET, then
> +.BR prctl (2)
> +will return 1 if the capability in arg3 is in the ambient set and 0 if not.
>  .SH RETURN VALUE
>  On success,
>  .BR PR_GET_DUMPABLE ,
> diff --git a/man7/capabilities.7 b/man7/capabilities.7
> index d75ec65de05b..dae62f0be3b7 100644
> --- a/man7/capabilities.7
> +++ b/man7/capabilities.7
> @@ -697,13 +697,26 @@ a program whose associated file capabilities grant that capability).
>  .IR Inheritable :
>  This is a set of capabilities preserved across an
>  .BR execve (2).
> -It provides a mechanism for a process to assign capabilities
> -to the permitted set of the new program during an
> -.BR execve (2).
> +Inheritable capabilities remain inheritable when executing any program,
> +and inheritable capabilities are added to the permitted set when executing
> +a program that has the corresponding bits set in the file inheritable set.
> +When executing programs without file capabilities, ambient capabilities
>  .TP
>  .IR Effective :
>  This is the set of capabilities used by the kernel to
>  perform permission checks for the thread.
> +.TP
> +.IR Ambient " (since Linux 4.2) :"
> +This is a set of capabilities that are preserved across an
> +.BR execve (2)
> +of a program that does not have file capabilities.  The ambient capability
> +set obeys the invariant that no capability can ever be ambient if it is
> +not both permitted and inheritable.  Ambient capabilities are, with some
> +exceptions, preserved in the permitted set and added to the effective
> +set when
> +.BR execve (2)
> +is called.  The ambient capability set is modified using
> +.BR prctl (2).
>  .PP
>  A child created via
>  .BR fork (2)
> @@ -785,10 +798,12 @@ the process using the following algorithm:
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
> @@ -1071,6 +1086,10 @@ an effective or real UID of 0 calls
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
> @@ -1079,8 +1098,9 @@ corresponding "base" flag.
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
> 2.1.0
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
