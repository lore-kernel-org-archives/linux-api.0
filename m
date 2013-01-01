From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/4] clone.2: Describe the user namespace
Date: Tue, 1 Jan 2013 10:30:17 +0100
Message-ID: <CAKgNAkgPET9jex1DO=1Z3HRQqO_WVD8qmG-UaH1DQB6wDGqO5A@mail.gmail.com>
References: <87a9u4rmz0.fsf@xmission.com> <87y5hnq3d5.fsf@xmission.com>
 <CAKgNAkgXWp49wXKom9hMm9fajKVOAwOmFzPdKWBesbBhfZEssA@mail.gmail.com> <87r4mbv2c9.fsf@xmission.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87r4mbv2c9.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Eric,

On Thu, Dec 27, 2012 at 6:20 PM, Eric W. Biederman
<ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
> "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>
>> Hi Eric,
>>
>> On Tue, Nov 27, 2012 at 1:46 AM, Eric W. Biederman
>> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>>
>>> Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
>>> ---
>>>  man2/clone.2 |   39 +++++++++++++++++++++++++++++++++++++++
>>>  1 files changed, 39 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/man2/clone.2 b/man2/clone.2
>>> index 0582057..4566677 100644
>>> --- a/man2/clone.2
>>> +++ b/man2/clone.2
>>> @@ -366,6 +366,45 @@ in the same
>>>  .BR clone ()
>>>  call.
>>>  .TP
>>> +.BR CLONE_NEWUSER " (since Linux 3.6)"
>>
>> Why "since Linux 3.6"? As fas as I can see, CLONE_NEWUSER first gain=
ed
>> some meaning in 2.6.29.
>
> Looking at it where I have said 3.6 that is wrong.  I meant 3.5.

Okay.

> I think I made the same mistake in one or two other manpages.  Nothin=
g
> was merged in 3.6 unfortunately.

I think the other cases have been fixed by now.

> My intent was these are the semantics of user namespaces since 3.5,
> when my rework/refocusing of them was merged.
>
> Since 3.5 all that has really happened with user namespaces is the
> uid/gid to kuid/kgid conversion, permission checks have been relaxed,
> and a few bugs have been fixed.
>
> 3.8 is huge from a usability standpoint.  3.8 is huge because setns()=
,
> and unshare() are now complete from a namespace perspective, and beca=
use
> enough permission checks have been relaxed in user namespaces that yo=
u
> can really start using them.
>
> But semantically from a user namespace perspective nothing really has
> changed in 3.8.
>
[...]

>> I reworked your text somewhat. Could you please review the following=
:
>>
>> [[
>>        CLONE_NEWUSER
>>               (This  flag first became meaningful for clone() in Lin=
ux
>>               2.6.29, but the implementation of  user  namespaces  w=
as
>>               only  completed in Linux 3.8.)
>
> Long rant about 2.6.29 vs 3.8 above.  I think what we need to say is:
>
>                 (This  flag first became meaningful for clone() in Li=
nux
>                 2.6.29, the current semantics were merged present in
>                 3.5, and user namespaces only really became usable in=
 3.8.)

Yup. I've done something like that now.

>>                                               If CLONE_NEWUSER is se=
t,
>>               then create the process in a  new  user  namespace.   =
If
>>               this flag is not set, then (as with fork(2)) the proce=
ss
>>               is created in the same user  namespace  as  the  calli=
ng
>>               process.
>>
>>               A  user  namespace  provides an isolated environment f=
or
>>               security related identifiers, in particular,  user  ID=
s,
>>               group IDs, keys (see keyctl(2)), and capabilities.
>>
>>               When  a user namespace is created, it starts out witho=
ut
>>               a mapping of user IDs (group IDs)  to  the  parent  us=
er
>>               namespace.   The desired mapping of user IDs (group ID=
s)
>>               to the parent user namespace may be set by writing  in=
to
>>               /proc/[pid]/uid_map (/proc/[pid]/gid_map); see proc(5)=
=2E
>
>                 /proc/[pid]/projid_map deserves a mention.  Not that
>                 I am a fan of project is or that xfs where the are
>                 implemented has been converted yet but....

Would you be able to send a patch documenting this in proc(5)?

>>               The  first process in a user namespace starts out with=
 a
>>               complete set of capabilities with  respect  to  the  n=
ew
>>               user namespace.
>>
>>               System  calls  that  return  user  IDs  (group IDs) wi=
ll
>>               return either the user ID (group  ID)  mapped  into  t=
he
>>               current  user  namespace  if  there is a mapping, or t=
he
>>               overflow user ID (group ID); the default value  for  t=
he
>>               overflow  user ID (group ID) is 65534.  See the descri=
p=E2=80=90
>>               tions of /proc/sys/kernel/overflowuid and /proc/sys/ke=
r=E2=80=90
>>               nel/overflowgid in proc(5).
>>
>>               Starting  with  Linux  3.8,  no privileges are needed =
to
>>               create a user namespace, and mount, PID, IPC,  net,  a=
nd
>>               UTS   namespaces   can   be   created   with   just  t=
he
>>               CAP_SYS_ADMIN capability in the caller's user namespac=
e.
>>
>>               Over the years, there have been a lot of  features  th=
at
>>               have been added to the Linux kernel that are only avai=
l=E2=80=90
>>               able to privileged users because of their  potential  =
to
>>               confuse  set-user-ID-root  applications.  In general, =
it
>>               becomes safe to allow the root user in a user  namespa=
ce
>>               to use those features because it is impossible, while =
in
>>               a user namespace, to gain more privilege than  the  ro=
ot
>>               user of a user namespace has.
>
> I don't have any problems with this bit of text.
>
> It occurs to me that what is going on with capabilities and user
> namespaces needs to be documented better.  There was a minor bug with
> them this release cycle and I realized while the current definition
> makes sense and isn't hard to understand in general.  In detail the
> interaction of capabilities and user namespaces are hard to describe.
>
> I think capabilities and user namespaces are the work of a future pat=
ch
> however.

Okay. So, below, a new iteration of the text. Could you please check
it over, and note any errors to be fixed or improvements to be made.

Thanks,

Michael

       CLONE_NEWUSER
              (This  flag first became meaningful for clone() in Linux
              2.6.23, the current clone()  semantics  were  merged  in
              Linux  3.5, and the final pieces to make the user names=E2=
=80=90
              paces completely usable were merged in Linux 3.8.)

              If CLONE_NEWUSER is set, then create the  process  in  a
              new  user  namespace.  If this flag is not set, then (as
              with fork(2)) the process is created in  the  same  user
              namespace as the calling process.

              A  user  namespace  provides an isolated environment for
              security related identifiers, in particular,  user  IDs,
              group IDs, keys (see keyctl(2)), and capabilities.

              When  a user namespace is created, it starts out without
              a mapping of user IDs (group IDs)  to  the  parent  user
              namespace.   The desired mapping of user IDs (group IDs)
              to the parent user namespace may be set by writing  into
              /proc/[pid]/uid_map (/proc/[pid]/gid_map); see proc(5).

              The  first process in a user namespace starts out with a
              complete set of capabilities with  respect  to  the  new
              user namespace.

              System  calls  that  return  user  IDs  (group IDs) will
              return either the user ID (group  ID)  mapped  into  the
              current  user  namespace  if  there is a mapping, or the
              overflow user ID (group ID); the default value  for  the
              overflow  user ID (group ID) is 65534.  See the descrip=E2=
=80=90
              tions of /proc/sys/kernel/overflowuid and /proc/sys/ker=E2=
=80=90
              nel/overflowgid in proc(5).

              Use  of  this flag requires a kernel configured with the
              CONFIG_USER_NS  option.   Before  Linux  3.8,   use   of
              CLONE_NEWUSER  required that the caller have three capa=E2=
=80=90
              bilities:  CAP_SYS_ADMIN,  CAP_SETUID,  and  CAP_SETGID.
              Starting  with  Linux  3.8,  no privileges are needed to
              create a user namespace, and mount, PID, IPC,  net,  and
              UTS   namespaces   can   be   created   with   just  the
              CAP_SYS_ADMIN capability in the caller's user namespace.

              Over the years, there have been a lot of  features  that
              have been added to the Linux kernel that are only avail=E2=
=80=90
              able to privileged users because of their  potential  to
              confuse  set-user-ID-root  applications.  In general, it
              becomes safe to allow the root user in a user  namespace
              to use those features because it is impossible, while in
              a user namespace, to gain more privilege than  the  root
              user of a user namespace has.


--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
