From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH] epoll: add exclusive wakeups flag
Date: Tue, 15 Mar 2016 06:47:45 +1300
Message-ID: <56E6F941.9040307@gmail.com>
References: <cover.1449523436.git.jbaron@akamai.com>
 <56A9C03B.7020104@gmail.com> <56AA56A2.3000700@akamai.com>
 <56AB1F6C.7000609@gmail.com> <56E1C2B5.2040905@akamai.com>
 <56E1D1D7.8040000@gmail.com> <56E1DBC2.6040109@akamai.com>
 <CAKgNAkgb-2omfCc=oBr66_CViJjBQ6=3vNfES99m6ZQ7g36p2Q@mail.gmail.com>
 <56E32FC5.4030902@akamai.com> <56E353CF.6050503@gmail.com>
 <56E6D0ED.20609@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56E6D0ED.20609@akamai.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Baron <jbaron@akamai.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: mtk.manpages@gmail.com, mingo@kernel.org, peterz@infradead.org, viro@ftp.linux.org.uk, normalperson@yhbt.net, m@silodev.com, corbet@lwn.net, luto@amacapital.net, torvalds@linux-foundation.org, hagen@jauu.net, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

[Restoring CC, which I see I accidentally dropped, one iteration back.]

Hi Jason,

Thanks for the review. I've tweaked one piece to respond to your
feedback. But I also have another new question below.

On 03/15/2016 03:55 AM, Jason Baron wrote:
> On 03/11/2016 06:25 PM, Michael Kerrisk (man-pages) wrote:
>> On 03/11/2016 09:51 PM, Jason Baron wrote:
>>> On 03/11/2016 03:30 PM, Michael Kerrisk (man-pages) wrote:

[...]

> Hi Michael,
>=20
> Looks good. One comment below.
>=20
> Thanks,
>=20
>>        EPOLLEXCLUSIVE (since Linux 4.5)
>>               Sets  an  exclusive  wakeup  mode  for  the  epoll  fi=
le
>>               descriptor  that  is  being  attached to the target fi=
le
>>               descriptor, fd.  When a wakeup event occurs and multip=
le
>>               epoll  file  descriptors are attached to the same targ=
et
>>               file using EPOLLEXCLUSIVE, one or more of the epoll fi=
le
>>               descriptors  will  receive  an event with epoll_wait(2=
).
>>               The default in this scenario (when EPOLLEXCLUSIVE is n=
ot
>>               set)  is  for  all  epoll file descriptors to receive =
an
>>               event.  EPOLLEXCLUSIVE is thus useful for avoiding thu=
n=E2=80=90
>>               dering herd problems in certain scenarios.
>>
>>               If  the  same  file  descriptor  is  in  multiple  epo=
ll
>>               instances, some with the EPOLLEXCLUSIVE flag, and othe=
rs
>>               without,   then   events  will  provided  to  all  epo=
ll
>>               instances that did not specify  EPOLLEXCLUSIVE,  and  =
at
>>               least  one  of  the  epoll  instances  that  did speci=
fy
>>               EPOLLEXCLUSIVE.
>>
>>               The following values may  be  specified  in  conjuncti=
on
>>               with EPOLLEXCLUSIVE: EPOLLIN, EPOLLOUT, EPOLLWAKEUP, a=
nd
>>               EPOLLET.  EPOLLHUP and EPOLLERR can also  be  specifie=
d,
>>               but  are  ignored (as usual).  Attempts to specify oth=
er
>=20
> I'm not sure 'ignored' is the right wording here. 'EPOLLHUP' and
> 'EPOLERR' are always included in the set of events when something is
> added as EPOLLEXCLUSIVE. This is consistent with the non-EPOLLEXCLUSI=
VE
> add case.=20

Yes.

> So 'EPOLLHUP' and 'EPOLERR' may be specified but will be
> included in the set of events on an add, whether they are specified o=
r not.

Yes. I understand your discomfort with the work "ignored", but the=20
problem was that, because it made special mention of EPOLLHUP and EPOLL=
ERR,
your proposed text made it sound as though EPOLLEXCLUSIVE somehow was
special with respect to these two flags. I wanted to clarify that it is=
 not.
How about this:

              The following values may  be  specified  in  conjunction
              with EPOLLEXCLUSIVE: EPOLLIN, EPOLLOUT, EPOLLWAKEUP, and
              EPOLLET.  EPOLLHUP and EPOLLERR can also  be  specified,
              but  this  is  not  required: as usual, these events are
              always reported if they  occur,  regardless  of  whether
              they are specified in events.
?

>>               values in events yield an error.  EPOLLEXCLUSIVE may  =
be
>>               used  only  in  an  EPOLL_CTL_ADD operation; attempts =
to
>>               employ  it  with  EPOLL_CTL_MOD  yield  an  error.    =
If
>>               EPOLLEXCLUSIVE has set using epoll_ctl(2), then a subs=
e=E2=80=90
>>               quent EPOLL_CTL_MOD on the same epfd, fd pair yields  =
an
b>>               error.  An epoll_ctl(2) that specifies EPOLLEXCLUSIVE=
 in
>>               events and specifies the target file descriptor fd as =
an
>>               epoll  instance will likewise fail.  The error in all =
of
>>               these cases is EINVAL.
>>
>>    ERRORS
>>        EINVAL An invalid event type was specified along with  EPOLLE=
X=E2=80=90
>>               CLUSIVE in events.
>>
>>        EINVAL op was EPOLL_CTL_MOD and events included EPOLLEXCLUSIV=
E.
>>
>>        EINVAL op  was  EPOLL_CTL_MOD  and  the EPOLLEXCLUSIVE flag h=
as
>>               previously been applied to this epfd, fd pair.
>>
>>        EINVAL EPOLLEXCLUSIVE was specified in event and fd  is  refe=
rs
>>               to an epoll instance.

Returning to the second sentence in this description:

              When a wakeup event occurs and multiple epoll file descri=
p=E2=80=90
              tors are attached to the same target file using EPOLLEXCL=
U=E2=80=90
              SIVE, one or  more  of  the  epoll  file  descriptors  wi=
ll
              receive  an  event with epoll_wait(2).

There is a point that is unclear to me: what does "target file" refer t=
o?
Is it an open file description (aka open file table entry) or an inode?
I suspect the former, but it was not clear in your original text.

To make this point even clearer, here are two scenarios I'm thinking of=
=2E
In each case, we're talking of monitoring the read end of a FIFO.

=3D=3D=3D

Scenario 1:

We have three processes each of which
1. Creates an epoll instance
2. Opens the read end of the FIFO
3. Adds the read end of the FIFO to the epoll instance, specifying
   EPOLLEXCLUSIVE

When input becomes available on the FIFO, how many processes
get a wakeup?

=3D=3D=3D

Scenario 3

A parent process opens the read end of a FIFO and then calls
fork() three times to create three children. Each child then:

1. Creates an epoll instance
2. Adds the read end of the FIFO to the epoll instance, specifying
EPOLLEXCLUSIVE

When input becomes available on the FIFO, how many processes
get a wakeup?

=3D=3D=3D

Cheers,

Michael

--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
