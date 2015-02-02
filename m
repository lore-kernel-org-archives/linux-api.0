From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 1/2] proc.5: Document /proc/[pid]/setgroups
Date: Mon, 02 Feb 2015 16:36:53 +0100
Message-ID: <54CF9995.1050409@gmail.com>
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>	<CALCETrXWx2-ZejEHmOi7aSoF-qJMRGR5yseeMhuurZwJRrQbUg@mail.gmail.com>	<87h9x5re41.fsf_-_@x220.int.ebiederm.org>	<87mw6xpzb0.fsf_-_@x220.int.ebiederm.org>	<CALCETrU-o5mPr1jCaLXDuuF6J2N470zAtx=8Fa-SjF=ZpdE8mQ@mail.gmail.com>	<87ppbtn4mv.fsf@x220.int.ebiederm.org>	<CALCETrXSScp77BUJR5NSTh5-RnEZ9rqELSGJBeEzgdQ-OtohuQ@mail.gmail.com>	<87a92xn2io.fsf@x220.int.ebiederm.org>	<87r3w8liw4.fsf@x220.int.ebiederm.org>	<87iohklfvj.fsf_-_@x220.int.ebiederm.org>	<87fvcok11h.fsf_-_@x220.int.ebiederm.org>	<CALCETrVfKiXuY=KY_=nHpkTyLWgpy_3DK=4Mr2mhpyX9z1TzrA@mail.gmail.com>	<971ad3f6-90fd-4e3f-916c-8988af3c826d@email.android.com>	<CALCETrWpzvNm=fjOa3_+4QOqYP8qZUJvQAd6AsRZ71xyHZQRCg@mail.gmail.com>	<87wq5zf83t.fsf@x220.in
 t.ebiederm.org>	<87iohh3c9c.fsf@x220.int.ebiederm.org>	<8761dh3b7k.fsf_-_@x220.int.ebiederm.org>	<878uicy1r9.fsf_-_@x220.int.ebiederm.org> <87vblg1qme.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <87vblg1qme.fsf@x220.int.ebiederm.org>
Sender: linux-security-module-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: mtk.manpages@gmail.com, Linux Containers <containers@lists.linux-foundation.org>, Josh Triplett <josh@joshtriplett.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Linux API <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, LSM <linux-security-module@vger.kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, "Serge E. Hallyn" <serge@hallyn.com>, Richard Weinberger <richard@nod.at>, Kenton Varda <kenton@sandstorm.io>, stable <stable@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>Josh Triplett <josh@joshtriplett.org>
List-Id: linux-api@vger.kernel.org

[Adding Josh to CC in case he has anything to add.]

On 12/12/2014 10:54 PM, Eric W. Biederman wrote:
>=20
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  man5/proc.5 | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>=20
> diff --git a/man5/proc.5 b/man5/proc.5
> index 96077d0dd195..d661e8cfeac9 100644
> --- a/man5/proc.5
> +++ b/man5/proc.5
> @@ -1097,6 +1097,21 @@ are not available if the main thread has alrea=
dy terminated
>  .\"       Added in 2.6.9
>  .\"       CONFIG_SCHEDSTATS
>  .TP
> +.IR /proc/[pid]/setgroups " (since Linux 3.19-rc1)"
> +This file reports
> +.BR allow
> +if the setgroups system call is allowed in the current user namespac=
e.
> +This file reports
> +.BR deny
> +if the setgroups system call is not allowed in the current user name=
space.
> +This file may be written to with values of
> +.BR allow
> +and
> +.BR deny
> +before
> +.IR /proc/[pid]/gid_map
> +is written to (enabling setgroups) in a user namespace.
> +.TP
>  .IR /proc/[pid]/smaps " (since Linux 2.6.14)"
>  This file shows memory consumption for each of the process's mapping=
s.
>  (The

Hi Eric,

Thanks for this patch. I applied it, and then tried to work in
quite a few other details gleaned from the source code and commit=20
message, and Jon Corbet's article at http://lwn.net/Articles/626665/.
Could you please let me know if the following is correct:

    /proc/[pid]/setgroups (since Linux 3.19)
           This file displays the string "allow"  if  processes  in=20
           the  user  namespace  that  contains the process pid are
           permitted to employ the setgroups(2)  system  call,  and
           "deny"  if  setgroups(2)  is  not permitted in that user
           namespace.

           A privileged process (one with the  CAP_SYS_ADMIN  capa=E2=80=
=90
           bility in the namespace) may write either of the strings
           "allow" or "deny" to this file before writing a group ID=20
           mapping   for   this   user   namespace   to   the  file
           /proc/[pid]/gid_map.  Writing the string "deny" prevents
           any  process  in  the user namespace from employing set=E2=80=
=90
           groups(2).

           The default value of  this  file  in  the  initial  user
           namespace is "allow".

           Once  /proc/[pid]/gid_map has been written to (which has
           the effect of enabling setgroups(2) in the  user  names=E2=80=
=90
           pace),  it is no longer possible to deny setgroups(2) by=20
           writing to /proc/[pid]/setgroups.

           A child user namespace inherits the  /proc/[pid]/gid_map
           setting from its parent.

           If  the  setgroups  file  has the value "deny", then the
           setgroups(2) system call can't subsequently be reenabled
           (by writing "allow" to the file) in this user namespace.
           This restriction also propagates down to all child  user
           namespaces of this user namespace.

Thanks,

Michael

--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
