From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3] capabilities.7, prctl.2: Document ambient capabilities
Date: Fri, 04 Dec 2015 16:08:00 +0100
Message-ID: <5661AC50.3070300@gmail.com>
References: <3721cd96525af4cb0a671e9a36ac6402c8e5379a.1446594067.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3721cd96525af4cb0a671e9a36ac6402c8e5379a.1446594067.git.luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Andy,

I have applied your patch (below). Thanks for writing it.
But I have a question or two and a request.

=3D=3D=3D

In the capabilities(7) page tehre is the longstanding text:

       An  application  can use the following call to lock itself, and
       all of its descendants, into an environment where the only  way
       of  gaining capabilities is by executing a program with associ=E2=
=80=90
       ated file capabilities:

           prctl(PR_SET_SECUREBITS,
                   SECBIT_KEEP_CAPS_LOCKED |
                   SECBIT_NO_SETUID_FIXUP |
                   SECBIT_NO_SETUID_FIXUP_LOCKED |
                   SECBIT_NOROOT |
                   SECBIT_NOROOT_LOCKED);

As far as I can estimate, no changes are needed here to include=20
SECBIT_NO_CAP_AMBIENT_RAISE and SECBIT_NO_CAP_AMBIENT_RAISE_LOCKED
in the above prctl() call, but could you confirm please?

=3D=3D=3D

In the message for kernel commit=20
58319057b7847667f0c9585b9de0e8932b0fdb08
you included this text:

[[
Because capability inheritance is so
broken, setting KEEPCAPS, using setresuid to switch to nonroot uids, an=
d
then calling execve effectively drops capabilities.  Therefore,
setresuid from root to nonroot conditionally clears pA unless
SECBIT_NO_SETUID_FIXUP is set.  Processes that don't like this can
re-add bits to pA afterwards.
]]

I'm struggling to understand the significance of this text,
especially as your man-pages patch makes no mention of this point.

The thing is, that text ("Therefore...") implies that there's
something special going on beyond the rules already documented
elsewhere. I mean, according to the rules aly documented elsewhere
in the page:

(1) If a process with UIDs of 0 sets all its UIDs
nonzero, then, the permitted and effective sets are cleared
(that's the classical behavior), and because the permitted
set is cleared, then so is the ambient set.

(2) And if we set SECBIT_NO_SETUID_FIXUP then
a UID 0 =3D=3D> nonzero transition doesn't clear permitted and
effective sets, and then of course the ambient set is not
cleared.

So, what additional point were you meaning to convey in
the commit message? (Maybe it was just cruft in the commit
message, but if not, can you explain precisely the arguments=20
for setresuid() that are supposed to generate the special
behavior described by the above text.)

=3D=3D=3D

I did quite a bit of tweaking of the text that you added for
the capabilities page. Could you please check the following
to make sure I added no errors:

       Ambient (since Linux 4.3):
              This  is a set of capabilities that are preserved across
              an execve(2) of a program that is not  privileged.   The
              ambient capability set obeys the invariant that no capa=E2=
=80=90
              bility can ever be ambient if it is not  both  permitted
              and inheritable.

              The  ambient  capability  set  can  be directly modified
              using prctl(2).  Ambient capabilities are  automatically
              lowered  if  either  of  the  corresponding permitted or
              inheritable capabilities is lowered.

              Executing a program that changes UID or GID due  to  the
              set-user-ID  or set-group-ID bits or executing a program
              that has any file capabilities set will clear the  ambi=E2=
=80=90
              ent  set.  Ambient capabilities are added to the permit=E2=
=80=90
              ted set and assigned to the effective set when execve(2)
              is called.

Cheers,

Michael

On 11/04/2015 12:42 AM, Andy Lutomirski wrote:
> Reviewed-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Signed-off-by: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>=20
> Changes from v2: Add a note about arg3 =3D=3D 0 in CLEAR_ALL.
>=20
> man2/prctl.2        | 13 +++++++++++++
>  man7/capabilities.7 | 40 ++++++++++++++++++++++++++++++++++------
>  2 files changed, 47 insertions(+), 6 deletions(-)
>=20
> diff --git a/man2/prctl.2 b/man2/prctl.2
> index e743a6305969..bf8680f3b62d 100644
> --- a/man2/prctl.2
> +++ b/man2/prctl.2
> @@ -954,6 +954,19 @@ had been called.
>  For further information on Intel MPX, see the kernel source file
>  .IR Documentation/x86/intel_mpx.txt .
>  .\"
> +.TP
> +.BR PR_CAP_AMBIENT " (since Linux 4.2)"
> +Reads or changes the ambient capability set.  If arg2 is PR_CAP_AMBI=
ENT_RAISE,
> +then the capability specified in arg3 is added to the ambient set.  =
This will
> +fail, returning EPERM, if the capability is not already both permitt=
ed and
> +inheritable or if the SECBIT_NO_CAP_AMBIENT_RAISE securebit is set. =
 If arg2
> +is PR_CAP_AMBIENT_LOWER, then the capability specified in arg3 is re=
moved
> +from the ambient set.  If arg2 is PR_CAP_AMBIENT_IS_SET, then
> +.BR prctl (2)
> +will return 1 if the capability in arg3 is in the ambient set and 0 =
if not.
> +If arg2 is PR_CAP_AMBIENT_CLEAR_ALL, then all capabilities will
> +be removed from the ambient set.  (Using PR_CAP_AMBIENT_CLEAR_ALL re=
quires
> +setting arg3 to zero.)
>  .SH RETURN VALUE
>  On success,
>  .BR PR_GET_DUMPABLE ,
> diff --git a/man7/capabilities.7 b/man7/capabilities.7
> index 616189c881e4..8934d05a5b07 100644
> --- a/man7/capabilities.7
> +++ b/man7/capabilities.7
> @@ -700,13 +700,34 @@ a program whose associated file capabilities gr=
ant that capability).
>  .IR Inheritable :
>  This is a set of capabilities preserved across an
>  .BR execve (2).
> -It provides a mechanism for a process to assign capabilities
> -to the permitted set of the new program during an
> -.BR execve (2).
> +Inheritable capabilities remain inheritable when executing any progr=
am,
> +and inheritable capabilities are added to the permitted set when exe=
cuting
> +a program that has the corresponding bits set in the file inheritabl=
e set.
> +.IP
> +Because inheritable capabilities are not generally preserved across
> +.BR execve (2)
> +when running as a non-root user, applications that wish to run helpe=
r
> +programs with elevated capabilities should consider using ambient ca=
pabilities,
> +described below.
>  .TP
>  .IR Effective :
>  This is the set of capabilities used by the kernel to
>  perform permission checks for the thread.
> +.TP
> +.IR Ambient " (since Linux 4.3):"
> +This is a set of capabilities that are preserved across an
> +.BR execve (2)
> +of a program that does not have file capabilities.  The ambient capa=
bility
> +set obeys the invariant that no capability can ever be ambient if it=
 is
> +not both permitted and inheritable.  Ambient capabilities are
> +preserved in the permitted set and added to the effective
> +set when
> +.BR execve (2)
> +is called.  The ambient capability set is modified using
> +.BR prctl (2).
> +Executing a program that changes uid or gid due to the setuid or set=
gid
> +bits or executing a program that has any file capabilities set will =
clear
> +the ambient set.
>  .PP
>  A child created via
>  .BR fork (2)
> @@ -788,10 +809,12 @@ the process using the following algorithm:
>  .in +4n
>  .nf
> =20
> +P'(ambient) =3D (file has capabilities or is setuid or setgid) ? 0 :=
 P(ambient)
> +
>  P'(permitted) =3D (P(inheritable) & F(inheritable)) |
> -                (F(permitted) & cap_bset)
> +                (F(permitted) & cap_bset) | P'(ambient)
> =20
> -P'(effective) =3D F(effective) ? P'(permitted) : 0
> +P'(effective) =3D F(effective) ? P'(permitted) : P'(ambient)
> =20
>  P'(inheritable) =3D P(inheritable)    [i.e., unchanged]
> =20
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
>=20


--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
