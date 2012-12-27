From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/4] proc.5: Document /proc/[pid]/uid_map and /proc/[pid]/gid_map
Date: Thu, 27 Dec 2012 10:03:02 +0100
Message-ID: <CAKgNAkixXmtvQUbwyv=a8mU=gdf-x+w-ou_4N=cNaau+hVoy4Q@mail.gmail.com>
References: <87a9u4rmz0.fsf@xmission.com> <874nkbrhyv.fsf@xmission.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <874nkbrhyv.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Eric,

Thanks for this patch. I have one question and a revised version f the
text that I'd like you to review.

On Tue, Nov 27, 2012 at 1:46 AM, Eric W. Biederman
<ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>
> Document the user namespace files that report the mapping of uids
> and gids between user namespaces.
>
> Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
> ---
>  man5/proc.5 |   50 +++++++++++++++++++++++++++++++++++++++++++++++++=
+
>  1 files changed, 50 insertions(+), 0 deletions(-)
>
> diff --git a/man5/proc.5 b/man5/proc.5
> index fb70d2b..840480d 100644
> --- a/man5/proc.5
> +++ b/man5/proc.5
> @@ -317,6 +317,31 @@ The files in this directory are readable only by=
 the owner of the process.
>  .\" .TP
>  .\" .IR /proc/[pid]/io " (since kernel 2.6.20)"
>  .TP
> +.IR /proc/[pid]/gid_map " (since kernel 3.6)"
> +This file reports the mapping of gids from the user namespace of the=
 process specified by
> +.IR pid
> +to the user namespace of the process that opened
> +.IR /proc/[pid]/gid_map .
> +
> +Each line specifies a 1 to 1 mapping of a range of contiguous gids f=
rom
> +the user namespace of the process specified by
> +.IR pid
> +to the user namespace of the process that opened
> +.IR /proc/[pid]/gid_map.

I want to check the above point. What do you mean by "the process that
opened uid_map"? Does that mean the process that opened uid_map to do
the one-time write of the UID map? I had assumed that uid_map actually
provided a mapping between the namespace of 'pid' and the 'parent'
namespace, where the parent namespace is the namespace of the process
that created this namespace via clone(CLONE_NEWUSER).

> +
> +Each line contains three numbers.  The start of the range of gids in
> +the user namespace of the process specifed by
> +.IR pid.
> +The start of the range of gids in the user namespace of the process =
that
> +opened
> +.IR /proc/[pid]/gid_map.
> +The number of gids in the range of numbers that is mapped between to=
 two
> +user namespaces.
> +
> +After the creation of a new user namespace this file may be written =
to
> +exactly once to specify the mapping of gids in the new user namespac=
e.
> +
> +.TP
>  .IR /proc/[pid]/limits " (since kernel 2.6.24)"
>  This file displays the soft limit, hard limit, and units of measurem=
ent
>  for each of the process's resource limits (see
> @@ -1169,6 +1194,31 @@ directory are not available if the main thread=
 has already terminated
>  (typically by calling
>  .BR pthread_exit (3)).
>  .TP
> +.IR /proc/[pid]/uid_map " (since kernel 3.6)"
> +This file reports the mapping of uids from the user namespace of the=
 process specified by
> +.IR pid
> +to the user namespace of the process that opened
> +.IR /proc/[pid]/uid_map .
> +
> +Each line specifies a 1 to 1 mapping of a range of contiguous uids f=
rom
> +the user namespace of the process specified by
> +.IR pid
> +to the user namespace of the process that opened
> +.IR /proc/[pid]/uid_map.
> +
> +Each line contains three numbers.  The start of the range of uids in
> +the user namespace of the process specifed by
> +.IR pid.
> +The start of the range of uids in the user namespace of the process =
that
> +opened
> +.IR /proc/[pid]/uid_map.
> +The number of uids in the range of numbers that is mapped between to=
 two
> +user namespaces.
> +
> +After the creation of a new user namespace this file may be written =
to
> +exactly once to specify the mapping of uids in the new user namespac=
e.
> +
> +.TP
>  .I /proc/apm
>  Advanced power management version and battery information when
>  .B CONFIG_APM

I revised your text quite a bit, and added a piece on the format od
the uid_map files. Could you please read the following and let me know
of errors:

[[
       /proc/[pid]/uid_map, /proc/[pid]/gid_map (since Linux 3.6)
              These  files  expose the mappings for user and group IDs
              inside the user namespace  for  the  process  pid.   The
              description  here  explains  the  details  for  uid_map;
              gid_map is exactly the same, but each instance of  "user
              ID" is replaced by "group ID".

              The  uid_map  file  exposes the mapping of user IDs from
              the user namespace of the process pid to the user names=E2=
=80=90
              pace of the process that opened uid_map.

              Each  line  in  the file specifies a 1-to-1 mapping of a
              range of contiguous user IDs from the user namespace  of
              the  process  pid  to  the user namespace of the process
              that opened uid_map.

              Each line contains  three  numbers  delimited  by  white
              space:

              (1) The  start  of  the  range  of  user IDs in the user
                  namespace of the process pid.

              (2) The start of the range  of  user  IDs  in  the  user
                  namespace of the process that opened uid_map.

              (3) The  length  of the range of user IDs that is mapped
                  between the two user namespaces.

              After the creation of a new user  namespace,  this  file
              may be written to exactly once to specify the mapping of
              user IDs in the new  user  namespace.   (An  attempt  to
              write  more  than  once to the file fails with the error
              EPERM.)

              The lines written to uid_map must conform to the follow=E2=
=80=90
              ing rules:

              *  The  three fields must be valid numbers, and the last
                 field must be greater than 0.

              *  Lines are terminated by newline characters.

              *  The file can contain a maximum of five lines.

              *  The values in both field 1 and field 2 of  each  line
                 must be in ascending numerical order.

              *  The  range  of user IDs specified in each line cannot
                 overlap with the ranges in any other lines.

              Writes that violate the above rules fail with the  error
              EINVAL.
]]

Thanks,

Michael

--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
