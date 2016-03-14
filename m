From: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] epoll: add exclusive wakeups flag
Date: Mon, 14 Mar 2016 15:32:19 -0400
Message-ID: <56E711C3.8020008@akamai.com>
References: <cover.1449523436.git.jbaron@akamai.com>
 <56A9C03B.7020104@gmail.com> <56AA56A2.3000700@akamai.com>
 <56AB1F6C.7000609@gmail.com> <56E1C2B5.2040905@akamai.com>
 <56E1D1D7.8040000@gmail.com> <56E1DBC2.6040109@akamai.com>
 <CAKgNAkgb-2omfCc=oBr66_CViJjBQ6=3vNfES99m6ZQ7g36p2Q@mail.gmail.com>
 <56E32FC5.4030902@akamai.com> <56E353CF.6050503@gmail.com>
 <56E6D0ED.20609@akamai.com> <56E6F941.9040307@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56E6F941.9040307-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, m@silodev.com, corbet-T1hC0tSOHrs@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hagen-GvnIQ6b/HdU@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org



On 03/14/2016 01:47 PM, Michael Kerrisk (man-pages) wrote:
> [Restoring CC, which I see I accidentally dropped, one iteration back=
=2E]
>=20
> Hi Jason,
>=20
> Thanks for the review. I've tweaked one piece to respond to your
> feedback. But I also have another new question below.
>=20
> On 03/15/2016 03:55 AM, Jason Baron wrote:
>> On 03/11/2016 06:25 PM, Michael Kerrisk (man-pages) wrote:
>>> On 03/11/2016 09:51 PM, Jason Baron wrote:
>>>> On 03/11/2016 03:30 PM, Michael Kerrisk (man-pages) wrote:
>=20
> [...]
>=20
>> Hi Michael,
>>
>> Looks good. One comment below.
>>
>> Thanks,
>>
>>>        EPOLLEXCLUSIVE (since Linux 4.5)
>>>               Sets  an  exclusive  wakeup  mode  for  the  epoll  f=
ile
>>>               descriptor  that  is  being  attached to the target f=
ile
>>>               descriptor, fd.  When a wakeup event occurs and multi=
ple
>>>               epoll  file  descriptors are attached to the same tar=
get
>>>               file using EPOLLEXCLUSIVE, one or more of the epoll f=
ile
>>>               descriptors  will  receive  an event with epoll_wait(=
2).
>>>               The default in this scenario (when EPOLLEXCLUSIVE is =
not
>>>               set)  is  for  all  epoll file descriptors to receive=
 an
>>>               event.  EPOLLEXCLUSIVE is thus useful for avoiding th=
un=E2=80=90
>>>               dering herd problems in certain scenarios.
>>>
>>>               If  the  same  file  descriptor  is  in  multiple  ep=
oll
>>>               instances, some with the EPOLLEXCLUSIVE flag, and oth=
ers
>>>               without,   then   events  will  provided  to  all  ep=
oll
>>>               instances that did not specify  EPOLLEXCLUSIVE,  and =
 at
>>>               least  one  of  the  epoll  instances  that  did spec=
ify
>>>               EPOLLEXCLUSIVE.
>>>
>>>               The following values may  be  specified  in  conjunct=
ion
>>>               with EPOLLEXCLUSIVE: EPOLLIN, EPOLLOUT, EPOLLWAKEUP, =
and
>>>               EPOLLET.  EPOLLHUP and EPOLLERR can also  be  specifi=
ed,
>>>               but  are  ignored (as usual).  Attempts to specify ot=
her
>>
>> I'm not sure 'ignored' is the right wording here. 'EPOLLHUP' and
>> 'EPOLERR' are always included in the set of events when something is
>> added as EPOLLEXCLUSIVE. This is consistent with the non-EPOLLEXCLUS=
IVE
>> add case.=20
>=20
> Yes.
>=20
>> So 'EPOLLHUP' and 'EPOLERR' may be specified but will be
>> included in the set of events on an add, whether they are specified =
or not.
>=20
> Yes. I understand your discomfort with the work "ignored", but the=20
> problem was that, because it made special mention of EPOLLHUP and EPO=
LLERR,
> your proposed text made it sound as though EPOLLEXCLUSIVE somehow was
> special with respect to these two flags. I wanted to clarify that it =
is not.
> How about this:
>=20
>               The following values may  be  specified  in  conjunctio=
n
>               with EPOLLEXCLUSIVE: EPOLLIN, EPOLLOUT, EPOLLWAKEUP, an=
d
>               EPOLLET.  EPOLLHUP and EPOLLERR can also  be  specified=
,
>               but  this  is  not  required: as usual, these events ar=
e
>               always reported if they  occur,  regardless  of  whethe=
r
>               they are specified in events.
> ?

Yes, nothing special here with respect to EPOLLHUP and EPOLLERR. So thi=
s
looks fine to me.

>=20
>>>               values in events yield an error.  EPOLLEXCLUSIVE may =
 be
>>>               used  only  in  an  EPOLL_CTL_ADD operation; attempts=
 to
>>>               employ  it  with  EPOLL_CTL_MOD  yield  an  error.   =
 If
>>>               EPOLLEXCLUSIVE has set using epoll_ctl(2), then a sub=
se=E2=80=90
>>>               quent EPOLL_CTL_MOD on the same epfd, fd pair yields =
 an
> b>>               error.  An epoll_ctl(2) that specifies EPOLLEXCLUSI=
VE in
>>>               events and specifies the target file descriptor fd as=
 an
>>>               epoll  instance will likewise fail.  The error in all=
 of
>>>               these cases is EINVAL.
>>>
>>>    ERRORS
>>>        EINVAL An invalid event type was specified along with  EPOLL=
EX=E2=80=90
>>>               CLUSIVE in events.
>>>
>>>        EINVAL op was EPOLL_CTL_MOD and events included EPOLLEXCLUSI=
VE.
>>>
>>>        EINVAL op  was  EPOLL_CTL_MOD  and  the EPOLLEXCLUSIVE flag =
has
>>>               previously been applied to this epfd, fd pair.
>>>
>>>        EINVAL EPOLLEXCLUSIVE was specified in event and fd  is  ref=
ers
>>>               to an epoll instance.
>=20
> Returning to the second sentence in this description:
>=20
>               When a wakeup event occurs and multiple epoll file desc=
rip=E2=80=90
>               tors are attached to the same target file using EPOLLEX=
CLU=E2=80=90
>               SIVE, one or  more  of  the  epoll  file  descriptors  =
will
>               receive  an  event with epoll_wait(2).
>=20
> There is a point that is unclear to me: what does "target file" refer=
 to?
> Is it an open file description (aka open file table entry) or an inod=
e?
> I suspect the former, but it was not clear in your original text.
>

So from epoll's perspective, the wakeups are associated with a 'wait
queue'. So if the open() and subsequent EPOLL_CTL_ADD (which is done vi=
a
file->poll()) results in adding to the same 'wait queue' then we will
get 'exclusive' wakeup behavior.

So in general, I think the answer here is that its associated with the
inode (I coudn't say with 100% certainty without really looking at all
file->poll() implementations). Certainly, with the 'FIFO' example below=
,
the two scenarios will have the same behavior with respect to
EPOLLEXCLUSIVE.

Also, the 'non-exclusive' mode would be subject to the same question of
which wait queue is the epfd is associated with...

Thanks,

-Jason

> To make this point even clearer, here are two scenarios I'm thinking =
of.
> In each case, we're talking of monitoring the read end of a FIFO.
>=20
> =3D=3D=3D
>=20
> Scenario 1:
>=20
> We have three processes each of which
> 1. Creates an epoll instance
> 2. Opens the read end of the FIFO
> 3. Adds the read end of the FIFO to the epoll instance, specifying
>    EPOLLEXCLUSIVE
>=20
> When input becomes available on the FIFO, how many processes
> get a wakeup?
>=20
> =3D=3D=3D
>=20
> Scenario 3
>=20
> A parent process opens the read end of a FIFO and then calls
> fork() three times to create three children. Each child then:
>=20
> 1. Creates an epoll instance
> 2. Adds the read end of the FIFO to the epoll instance, specifying
> EPOLLEXCLUSIVE
>=20
> When input becomes available on the FIFO, how many processes
> get a wakeup?
>=20
> =3D=3D=3D
>=20
> Cheers,
>=20
> Michael
>=20
