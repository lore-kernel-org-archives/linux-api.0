From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH man-pages v2] capabilities.7, prctl.2: Document ambient
 capabilities
Date: Tue, 19 May 2015 09:56:51 +0200
Message-ID: <555AECC3.4040408@gmail.com>
References: <f85ae308af4946436e82aaa9dd71bcd4b39bd196.1431672156.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f85ae308af4946436e82aaa9dd71bcd4b39bd196.1431672156.git.luto@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>, Serge Hallyn <serge.hallyn@ubuntu.com>, Andrew Morton <akpm@linuxfoundation.org>
Cc: mtk.manpages@gmail.com, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Ted Ts'o <tytso@mit.edu>, "Andrew G. Morgan" <morgan@kernel.org>, Linux API <linux-api@vger.kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-security-module <linux-security-module@vger.kernel.org>, Aaron Jones <aaronmdjones@gmail.com>, Serge Hallyn <serge.hallyn@canonical.com>, LKML <linux-kernel@vger.kernel.org>, Markku Savela <msa@moth.iki.fi>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

Hi Andy,

Thanks for this patch. There are some broken pieces though. Also,
I have some minor questions about the API design. See below.

On 05/15/2015 08:43 AM, Andy Lutomirski wrote:
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

Some API design questions:

1. We already have prctl() operations that work on some capability sets:
   PR_CAPBSET_READ and PR_CAPBSET_DROP. These don't use arg3; the operation 
   is directly encoded in the first argument of prctl(). Just to keep some
   consistency, why not do things the same way for these new operations?

   Also, you could opt for some consistency in the naming, so using "READ"
   rather than "GET", for example. On the other hand, both "READ" and "GET" 
   are suboptimal names: this is really a test operation. So, maybe a
   clean break to a good name, PR_CAP_AMBIENT_IS_SET, is best?

   Thus:

     prctl(PR_CAP_AMBIENT_READ, cap, 0, 0, 0);  // or PR_CAP_AMBIENT_IS_SET?
     prctl(PR_CAP_AMBIENT_RAISE, cap, 0, 0, 0);
     prctl(PR_CAP_AMBIENT_LOWER, cap, 0, 0, 0);

2. In terms of the API design, would it be useful to have a prctl() operation
   that clears the entire ambient set?

     prctl(PR_CAP_AMBIENT_ZERO, 0, 0, 0, 0);    // or PR_CAP_AMBIENT_EMPTY?

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

That last line is incomplete. Something needs adding/removing.

>  .TP
>  .IR Effective :
>  This is the set of capabilities used by the kernel to
>  perform permission checks for the thread.
> +.TP
> +.IR Ambient " (since Linux 4.2) :"

Minor knit: s/ :/:/ for next version.

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

I think it would be helpful to add a couple of sentences here on why the
ambient set is useful (i.e., explain what deficiencies in the pre-existing
API are addressed by the addition of this set--a brief piece from your
1/2 patch, for example).

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

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
