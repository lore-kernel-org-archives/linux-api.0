From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 1/4] proc.5: Document /proc/[pid]/uid_map and /proc/[pid]/gid_map
Date: Thu, 27 Dec 2012 08:58:56 -0800
Message-ID: <87obhfxwhb.fsf@xmission.com>
References: <87a9u4rmz0.fsf@xmission.com> <874nkbrhyv.fsf@xmission.com>
	<CAKgNAkixXmtvQUbwyv=a8mU=gdf-x+w-ou_4N=cNaau+hVoy4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgNAkixXmtvQUbwyv=a8mU=gdf-x+w-ou_4N=cNaau+hVoy4Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Michael Kerrisk's message of "Thu, 27 Dec 2012 10:03:02 +0100")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:

> Hi Eric,
>
> Thanks for this patch. I have one question and a revised version f th=
e
> text that I'd like you to review.
>
> On Tue, Nov 27, 2012 at 1:46 AM, Eric W. Biederman
> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>
>> Document the user namespace files that report the mapping of uids
>> and gids between user namespaces.
>>
>> Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
>> ---
>>  man5/proc.5 |   50 ++++++++++++++++++++++++++++++++++++++++++++++++=
++
>>  1 files changed, 50 insertions(+), 0 deletions(-)
>>
>> diff --git a/man5/proc.5 b/man5/proc.5
>> index fb70d2b..840480d 100644
>> --- a/man5/proc.5
>> +++ b/man5/proc.5
>> @@ -317,6 +317,31 @@ The files in this directory are readable only b=
y the owner of the process.
>>  .\" .TP
>>  .\" .IR /proc/[pid]/io " (since kernel 2.6.20)"
>>  .TP
>> +.IR /proc/[pid]/gid_map " (since kernel 3.6)"
>> +This file reports the mapping of gids from the user namespace of th=
e process specified by
>> +.IR pid
>> +to the user namespace of the process that opened
>> +.IR /proc/[pid]/gid_map .
>> +
>> +Each line specifies a 1 to 1 mapping of a range of contiguous gids =
from
>> +the user namespace of the process specified by
>> +.IR pid
>> +to the user namespace of the process that opened
>> +.IR /proc/[pid]/gid_map.
>
> I want to check the above point. What do you mean by "the process tha=
t
> opened uid_map"? Does that mean the process that opened uid_map to do
> the one-time write of the UID map? I had assumed that uid_map actuall=
y
> provided a mapping between the namespace of 'pid' and the 'parent'
> namespace, where the parent namespace is the namespace of the process
> that created this namespace via clone(CLONE_NEWUSER).

I mean the process that opens uid_map for read or write.

=46or writing you are correct about the mapping to the parent (but that=
 is
not an exception that is a restriction on who can write to the file).

The complete rule is for the user namespace of the second value is:

- If the user namespace of the opener of the file and the user namespac=
e
  of the process do not match.  The user namespace of the opener of the
  file is used.

- If the user namespace of the opener of the file and the user namespac=
e
  of the process are the same.  The parent user namespace of the proces=
s
  is used for the second value.

While very wordy I think the rule makes a lot of intuitive and practica=
l
sense.  Especially since it is non-trivial to come up with the chain of
user namespaces a process is in.

>> +Each line contains three numbers.  The start of the range of gids i=
n
>> +the user namespace of the process specifed by
>> +.IR pid.
>> +The start of the range of gids in the user namespace of the process=
 that
>> +opened
>> +.IR /proc/[pid]/gid_map.
>> +The number of gids in the range of numbers that is mapped between t=
o two
>> +user namespaces.
>> +
>> +After the creation of a new user namespace this file may be written=
 to
>> +exactly once to specify the mapping of gids in the new user namespa=
ce.
>> +
>> +.TP
>>  .IR /proc/[pid]/limits " (since kernel 2.6.24)"
>>  This file displays the soft limit, hard limit, and units of measure=
ment
>>  for each of the process's resource limits (see
>> @@ -1169,6 +1194,31 @@ directory are not available if the main threa=
d has already terminated
>>  (typically by calling
>>  .BR pthread_exit (3)).
>>  .TP
>> +.IR /proc/[pid]/uid_map " (since kernel 3.6)"
>> +This file reports the mapping of uids from the user namespace of th=
e process specified by
>> +.IR pid
>> +to the user namespace of the process that opened
>> +.IR /proc/[pid]/uid_map .
>> +
>> +Each line specifies a 1 to 1 mapping of a range of contiguous uids =
from
>> +the user namespace of the process specified by
>> +.IR pid
>> +to the user namespace of the process that opened
>> +.IR /proc/[pid]/uid_map.
>> +
>> +Each line contains three numbers.  The start of the range of uids i=
n
>> +the user namespace of the process specifed by
>> +.IR pid.
>> +The start of the range of uids in the user namespace of the process=
 that
>> +opened
>> +.IR /proc/[pid]/uid_map.
>> +The number of uids in the range of numbers that is mapped between t=
o two
>> +user namespaces.
>> +
>> +After the creation of a new user namespace this file may be written=
 to
>> +exactly once to specify the mapping of uids in the new user namespa=
ce.
>> +
>> +.TP
>>  .I /proc/apm
>>  Advanced power management version and battery information when
>>  .B CONFIG_APM
>
> I revised your text quite a bit, and added a piece on the format od
> the uid_map files. Could you please read the following and let me kno=
w
> of errors:
>
> [[
>        /proc/[pid]/uid_map, /proc/[pid]/gid_map (since Linux 3.6)
>               These  files  expose the mappings for user and group ID=
s
>               inside the user namespace  for  the  process  pid.   Th=
e
>               description  here  explains  the  details  for  uid_map=
;
>               gid_map is exactly the same, but each instance of  "use=
r
>               ID" is replaced by "group ID".
>
>               The  uid_map  file  exposes the mapping of user IDs fro=
m
>               the user namespace of the process pid to the user names=
=E2=80=90
>               pace of the process that opened uid_map.
>
>               Each  line  in  the file specifies a 1-to-1 mapping of =
a
>               range of contiguous user IDs from the user namespace  o=
f
>               the  process  pid  to  the user namespace of the proces=
s
>               that opened uid_map.
>
>               Each line contains  three  numbers  delimited  by  whit=
e
>               space:
>
>               (1) The  start  of  the  range  of  user IDs in the use=
r
>                   namespace of the process pid.
>
>               (2) The start of the range  of  user  IDs  in  the  use=
r
>                   namespace of the process that opened uid_map.
>
>               (3) The  length  of the range of user IDs that is mappe=
d
>                   between the two user namespaces.
>
>               After the creation of a new user  namespace,  this  fil=
e
>               may be written to exactly once to specify the mapping o=
f
>               user IDs in the new  user  namespace.   (An  attempt  t=
o
>               write  more  than  once to the file fails with the erro=
r
>               EPERM.)
>
>               The lines written to uid_map must conform to the follow=
=E2=80=90
>               ing rules:
>
>               *  The  three fields must be valid numbers, and the las=
t
>                  field must be greater than 0.
>
>               *  Lines are terminated by newline characters.
>
>               *  The file can contain a maximum of five lines.

A maximum of 5 lines is important to Document but it is a current
arbitrary limit that may be changed in the future.  Right now 5 extents
are more than enough for any conceivable use case, and fit nicely withi=
n
a single cache line.

It is probably better to say writes that exceed an arbitrary maximum
length fail with -EINVAL.  Currently the arbitrary maximum length is
five lines.

>               *  The values in both field 1 and field 2 of  each  lin=
e
>                  must be in ascending numerical order.

The rule is that the extents need to be non-overlapping.  Ascending
numerical order is how that is implemented but that is a misfeature,
and there has already been one request to fix that.  Removing the
ascending numerical order limitation is on my todo list.

>               *  The  range  of user IDs specified in each line canno=
t
>                  overlap with the ranges in any other lines.
>
>               Writes that violate the above rules fail with the  erro=
r
>               EINVAL.
> ]]
>
> Thanks,
>
> Michael
