From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] proc.5: Document /proc/[pid]/setgroups
Date: Tue, 3 Mar 2015 12:39:48 +0100
Message-ID: <CAKgNAkh5GVr6iK2FXOJ4BVbGLNcgyAyWcvJ8AN3WVutR4rGCtA@mail.gmail.com>
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>
 <CALCETrU-o5mPr1jCaLXDuuF6J2N470zAtx=8Fa-SjF=ZpdE8mQ@mail.gmail.com>
 <87ppbtn4mv.fsf@x220.int.ebiederm.org> <CALCETrXSScp77BUJR5NSTh5-RnEZ9rqELSGJBeEzgdQ-OtohuQ@mail.gmail.com>
 <87a92xn2io.fsf@x220.int.ebiederm.org> <87r3w8liw4.fsf@x220.int.ebiederm.org>
 <87iohklfvj.fsf_-_@x220.int.ebiederm.org> <87fvcok11h.fsf_-_@x220.int.ebiederm.org>
 <CALCETrVfKiXuY=KY_=nHpkTyLWgpy_3DK=4Mr2mhpyX9z1TzrA@mail.gmail.com>
 <971ad3f6-90fd-4e3f-916c-8988af3c826d@email.android.com> <CALCETrWpzvNm=fjOa3_+4QOqYP8qZUJvQAd6AsRZ71xyHZQRCg@mail.gmail.com>
 <87wq5zf83t.fsf@x220.int.ebiederm.org> <87iohh3c9c.fsf@x220.int.ebiederm.org>
 <8761dh3b7k.fsf_-_@x220.int.ebiederm.org> <878uicy1r9.fsf_-_@x220.int.ebiederm.org>
 <87vblg1qme.fsf@x220.int.ebiederm.org> <54CF9995.1050409@gmail.com>
 <CAKgNAkgWnZ=7E4bk3JhzFS88CJ32szYCYcm_Sx166yVuWKhhUA@mail.gmail.com>
 <8761b8lfoz.fsf@x220.int.ebiederm.org> <54DCB059.2020305@gmail.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54DCB059.2020305-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Eric

Ping^2!

Cheers,

Michael


On 12 February 2015 at 14:53, Michael Kerrisk (man-pages)
<mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hello Eric,
>
> On 02/11/2015 02:51 PM, Eric W. Biederman wrote:
>> "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>>
>>> Hi Eric,
>>>
>>> Ping!
>>>
>>> Cheers,
>>>
>>> Michael
>>
>> My apologies.  You description wasn't wrong but it may be a bit
>> misleading, explanation below.  You will have to figure out how to w=
ork
>> that into your proposed text.
>>
>>> On 2 February 2015 at 16:36, Michael Kerrisk (man-pages)
>>> <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>> [Adding Josh to CC in case he has anything to add.]
>>>>
>>>> On 12/12/2014 10:54 PM, Eric W. Biederman wrote:
>>>>>
>>>>> Signed-off-by: Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
>>>>> ---
>>>>>  man5/proc.5 | 15 +++++++++++++++
>>>>>  1 file changed, 15 insertions(+)
>>>>>
>>>>> diff --git a/man5/proc.5 b/man5/proc.5
>>>>> index 96077d0dd195..d661e8cfeac9 100644
>>>>> --- a/man5/proc.5
>>>>> +++ b/man5/proc.5
>>>>> @@ -1097,6 +1097,21 @@ are not available if the main thread has a=
lready terminated
>>>>>  .\"       Added in 2.6.9
>>>>>  .\"       CONFIG_SCHEDSTATS
>>>>>  .TP
>>>>> +.IR /proc/[pid]/setgroups " (since Linux 3.19-rc1)"
>>>>> +This file reports
>>>>> +.BR allow
>>>>> +if the setgroups system call is allowed in the current user name=
space.
>>>>> +This file reports
>>>>> +.BR deny
>>>>> +if the setgroups system call is not allowed in the current user =
namespace.
>>>>> +This file may be written to with values of
>>>>> +.BR allow
>>>>> +and
>>>>> +.BR deny
>>>>> +before
>>>>> +.IR /proc/[pid]/gid_map
>>>>> +is written to (enabling setgroups) in a user namespace.
>>>>> +.TP
>>>>>  .IR /proc/[pid]/smaps " (since Linux 2.6.14)"
>>>>>  This file shows memory consumption for each of the process's map=
pings.
>>>>>  (The
>>>>
>>>> Hi Eric,
>>>>
>>>> Thanks for this patch. I applied it, and then tried to work in
>>>> quite a few other details gleaned from the source code and commit
>>>> message, and Jon Corbet's article at http://lwn.net/Articles/62666=
5/.
>>>> Could you please let me know if the following is correct:
>>
>> It is close but it may be misleading.
>>
>>>>     /proc/[pid]/setgroups (since Linux 3.19)
>>>>            This file displays the string "allow"  if  processes  i=
n
>>>>            the  user  namespace  that  contains the process pid ar=
e
>>>>            permitted to employ the setgroups(2)  system  call,  an=
d
>>>>            "deny"  if  setgroups(2)  is  not permitted in that use=
r
>>>>            namespace.
>>
>> With the caveat that when gid_map is not set that setgroups is also =
not
>> allowed.
>
> Okay -- Iadded that point.
>
>>>>            A privileged process (one with the  CAP_SYS_ADMIN  capa=
=E2=80=90
>>>>            bility in the namespace) may write either of the string=
s
>>>>            "allow" or "deny" to this file before writing a group I=
D
>>>>            mapping   for   this   user   namespace   to   the  fil=
e
>>>>            /proc/[pid]/gid_map.  Writing the string "deny" prevent=
s
>>>>            any  process  in  the user namespace from employing set=
=E2=80=90
>>>>            groups(2).
>>
>> Or more succintly.  You are allowed to write to /proc/[pid]/setgroup=
s
>> when calling setgroups is not allowed because gid_map is unset.  Thi=
s
>> ensures we do not have any transitions from a state where setgroups
>> is allowed to a state where setgroups is denied.  There are only
>> transitions from setgroups not-allowed to setgroups allowed.
>
> And I've worked in the above point, rewording a bit along the way.
> So, how does the following look (only the first two paragraphs have
> changed)?
>
>        /proc/[pid]/setgroups (since Linux 3.19)
>               This file displays the string "allow"  if  processes  i=
n
>               the  user  namespace  that  contains the process pid ar=
e
>               permitted to employ the setgroups(2)  system  call,  an=
d
>               "deny"  if  setgroups(2)  is  not permitted in that use=
r
>               namespace.  (Note, however, that calls  to  setgroups(2=
)
>               are  also  not  permitted if /proc/[pid]/gid_map has no=
t
>               yet been set.)
>
>               A privileged process (one with the  CAP_SYS_ADMIN  capa=
=E2=80=90
>               bility in the namespace) may write either of the string=
s
>               "allow" or "deny" to this file before writing a group I=
D
>               mapping   for   this   user   namespace   to   the  fil=
e
>               /proc/[pid]/gid_map.  Writing the string "deny" prevent=
s
>               any  process  in  the user namespace from employing set=
=E2=80=90
>               groups(2).  In other words, it is permitted to write  t=
o
>               /proc/[pid]/setgroups so long as calling setgroups(2) i=
s
>               not allowed because /proc/[pid]gid_map has not been set=
=2E
>               This  ensures  that  a  process cannot transition from =
a
>               state where setgroups(2) is allowed  to  a  state  wher=
e
>               setgroups(2)  is  denied;  a process can only trabsitio=
n
>               from setgroups(2) being disallowed to setgroups(2) bein=
g
>               allowed.
>
>               The  default  value  of  this  file  in the initial use=
r
>               namespace is "allow".
>
>               Once /proc/[pid]/gid_map has been written to (which  ha=
s
>               the  effect  of enabling setgroups(2) in the user names=
=E2=80=90
>               pace), it is no longer possible to deny setgroups(2)  b=
y
>               writing to /proc/[pid]/setgroups.
>
>               A  child user namespace inherits the /proc/[pid]/gid_ma=
p
>               setting from its parent.
>
>               If the setgroups file has the  value  "deny",  then  th=
e
>               setgroups(2) system call can't subsequently be reenable=
d
>               (by writing "allow" to the file) in this user namespace=
=2E
>               This  restriction also propagates down to all child use=
r
>               namespaces of this user namespace.
>
> Cheers,
>
> Michael
>
>
>
> --
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> Linux/UNIX System Programming Training: http://man7.org/training/



--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
