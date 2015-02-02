From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] user_namespaces.7: Update the documention to reflect
 the fixes for negative groups
Date: Mon, 02 Feb 2015 16:37:35 +0100
Message-ID: <54CF99BF.8050401@gmail.com>
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>	<CALCETrXWx2-ZejEHmOi7aSoF-qJMRGR5yseeMhuurZwJRrQbUg@mail.gmail.com>	<87h9x5re41.fsf_-_@x220.int.ebiederm.org>	<87mw6xpzb0.fsf_-_@x220.int.ebiederm.org>	<CALCETrU-o5mPr1jCaLXDuuF6J2N470zAtx=8Fa-SjF=ZpdE8mQ@mail.gmail.com>	<87ppbtn4mv.fsf@x220.int.ebiederm.org>	<CALCETrXSScp77BUJR5NSTh5-RnEZ9rqELSGJBeEzgdQ-OtohuQ@mail.gmail.com>	<87a92xn2io.fsf@x220.int.ebiederm.org>	<87r3w8liw4.fsf@x220.int.ebiederm.org>	<87iohklfvj.fsf_-_@x220.int.ebiederm.org>	<87fvcok11h.fsf_-_@x220.int.ebiederm.org>	<CALCETrVfKiXuY=KY_=nHpkTyLWgpy_3DK=4Mr2mhpyX9z1TzrA@mail.gmail.com>	<971ad3f6-90fd-4e3f-916c-8988af3c826d@email.android.com>	<CALCETrWpzvNm=fjOa3_+4QOqYP8qZUJvQAd6AsRZ71xyHZQRCg@mail.gmail.com>	<87wq5zf83t.fsf@x220.in
 t.ebiederm.org>	<87iohh3c9c.fsf@x220.int.ebiederm.org>	<8761dh3b7k.fsf_-_@x220.int.ebiederm.org>	<878uicy1r9.fsf_-_@x220.int.ebiederm.org> <87ppbo1ql4.fsf_-_@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87ppbo1ql4.fsf_-_-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Eric,

Thanks for writing this up!

On 12/12/2014 10:54 PM, Eric W. Biederman wrote:
> 
> Files with access permissions such as ---rwx---rwx give fewer
> permissions to their group then they do to everyone else.  Which means
> dropping groups with setgroups(0, NULL) actually grants a process
> privileges.
> 
> The uprivileged setting of gid_map turned out not to be safe after
> this change.  Privilege setting of gid_map can be interpreted as
> meaning yes it is ok to drop groups.

I had trouble to parse that sentence (and I'd like to make sure that
the right sentence ends up in the commit message). Did you mean: 

    "*Unprivileged* setting of gid_map can be interpreted as meaning
     yes it is ok to drop groups"

?

Or something else?

> To prevent this problem and future problems user namespaces were
> changed in such a way as to guarantee a user can not obtain
> credentials without privilege they could not obtain without the
> help of user namespaces.
> 
> This meant testing the effective user ID and not the filesystem user
> ID as setresuid and setregid allow setting any process uid or gid
> (except the supplemental groups) to the effective ID.
> 
> Furthermore to preserve in some form the useful applications that have
> been setting gid_map without privilege the file /proc/[pid]/setgroups
> was added to allow disabling setgroups.  With the setgroups system
> call permanently disabled in a user namespace it again becomes safe to
> allow writes to gid_map without privilege.
> 
> Here is my meager attempt to update user_namespaces.7 to reflect these
> issues.

It looked pretty serviceable as patch, IMO. So, thanks again. I've applied,
tweaking some wordings afterward, but changing nothing essential. See below
for a question.

> Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
> ---
>  man7/user_namespaces.7 | 52 +++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 49 insertions(+), 3 deletions(-)
> 
> diff --git a/man7/user_namespaces.7 b/man7/user_namespaces.7
> index d76721d9a0a1..f8333a762308 100644
> --- a/man7/user_namespaces.7
> +++ b/man7/user_namespaces.7
> @@ -533,11 +533,16 @@ One of the following is true:
>  The data written to
>  .I uid_map
>  .RI ( gid_map )
> -consists of a single line that maps the writing process's filesystem user ID
> +consists of a single line that maps the writing process's effective user ID
>  (group ID) in the parent user namespace to a user ID (group ID)
>  in the user namespace.
> -The usual case here is that this single line provides a mapping for user ID
> -of the process that created the namespace.
> +The writing process must have the same effective user ID as the process
> +that created the user namespace.
> +In the case of
> +.I gid_map
> +the
> +.I setgroups
> +file must have been written to earlier and disabled the setgroups system call.
>  .IP * 3
>  The opening process has the
>  .BR CAP_SETUID
> @@ -552,6 +557,47 @@ Writes that violate the above rules fail with the error
>  .\"
>  .\" ============================================================
>  .\"
> +.SS Interaction with system calls that change the uid or gid values
> +When in a user namespace where the
> +.I uid_map
> +or
> +.I gid_map
> +file has not been written the system calls that change user IDs
> +or group IDs respectively will fail.  After the
> +.I uid_map
> +and
> +.I gid_map
> +file have been written only the mapped values may be used in
> +system calls that change user IDs and group IDs.
> +
> +For user IDs these system calls include
> +.BR setuid ,
> +.BR setfsuid ,
> +.BR setreuid ,
> +and
> +.BR setresuid .
> +
> +For group IDs these system calls include
> +.BR setgid ,
> +.BR setfsgid ,
> +.BR setregid ,
> +.BR setresgid ,
> +and
> +.BR setgroups.
> +
> +Writing
> +.BR deny
> +to the
> +.I /proc/[pid]/setgroups
> +file before writing to
> +.I /proc/[pid]/gid_map
> +will permanently disable the setgroups system call in a user namespace
> +and allow writing to
> +.I /proc/[pid]/gid_map
> +without
> +.BR CAP_SETGID
> +in the parent user namespace.

I just want to double check: you really did mean to write "*parent* namespace"
above, right?

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
