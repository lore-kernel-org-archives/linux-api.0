From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH] epoll: add exclusive wakeups flag
Date: Tue, 15 Mar 2016 09:01:24 +1300
Message-ID: <56E71894.4090607@gmail.com>
References: <cover.1449523436.git.jbaron@akamai.com>
 <56A9C03B.7020104@gmail.com> <56AA56A2.3000700@akamai.com>
 <56AB1F6C.7000609@gmail.com> <56E1C2B5.2040905@akamai.com>
 <56E1D1D7.8040000@gmail.com> <56E1DBC2.6040109@akamai.com>
 <CAKgNAkgb-2omfCc=oBr66_CViJjBQ6=3vNfES99m6ZQ7g36p2Q@mail.gmail.com>
 <56E32FC5.4030902@akamai.com> <56E353CF.6050503@gmail.com>
 <56E6D0ED.20609@akamai.com> <56E6F941.9040307@gmail.com>
 <56E711C3.8020008@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <56E711C3.8020008@akamai.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jason Baron <jbaron@akamai.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: mtk.manpages@gmail.com, mingo@kernel.org, peterz@infradead.org, viro@ftp.linux.org.uk, normalperson@yhbt.net, m@silodev.com, corbet@lwn.net, luto@amacapital.net, torvalds@linux-foundation.org, hagen@jauu.net, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Jason,

On 03/15/2016 08:32 AM, Jason Baron wrote:
>=20
>=20
> On 03/14/2016 01:47 PM, Michael Kerrisk (man-pages) wrote:
>> [Restoring CC, which I see I accidentally dropped, one iteration bac=
k.]

[...]

>>>>               values in events yield an error.  EPOLLEXCLUSIVE may=
  be
>>>>               used  only  in  an  EPOLL_CTL_ADD operation; attempt=
s to
>>>>               employ  it  with  EPOLL_CTL_MOD  yield  an  error.  =
  If
>>>>               EPOLLEXCLUSIVE has set using epoll_ctl(2), then a su=
bse=E2=80=90
>>>>               quent EPOLL_CTL_MOD on the same epfd, fd pair yields=
  an
>> b>>               error.  An epoll_ctl(2) that specifies EPOLLEXCLUS=
IVE in
>>>>               events and specifies the target file descriptor fd a=
s an
>>>>               epoll  instance will likewise fail.  The error in al=
l of
>>>>               these cases is EINVAL.
>>>>
>>>>    ERRORS
>>>>        EINVAL An invalid event type was specified along with  EPOL=
LEX=E2=80=90
>>>>               CLUSIVE in events.
>>>>
>>>>        EINVAL op was EPOLL_CTL_MOD and events included EPOLLEXCLUS=
IVE.
>>>>
>>>>        EINVAL op  was  EPOLL_CTL_MOD  and  the EPOLLEXCLUSIVE flag=
 has
>>>>               previously been applied to this epfd, fd pair.
>>>>
>>>>        EINVAL EPOLLEXCLUSIVE was specified in event and fd  is  re=
fers
>>>>               to an epoll instance.
>>
>> Returning to the second sentence in this description:
>>
>>               When a wakeup event occurs and multiple epoll file des=
crip=E2=80=90
>>               tors are attached to the same target file using EPOLLE=
XCLU=E2=80=90
>>               SIVE, one or  more  of  the  epoll  file  descriptors =
 will
>>               receive  an  event with epoll_wait(2).
>>
>> There is a point that is unclear to me: what does "target file" refe=
r to?
>> Is it an open file description (aka open file table entry) or an ino=
de?
>> I suspect the former, but it was not clear in your original text.
>>
>=20
> So from epoll's perspective, the wakeups are associated with a 'wait
> queue'. So if the open() and subsequent EPOLL_CTL_ADD (which is done =
via
> file->poll()) results in adding to the same 'wait queue' then we will
> get 'exclusive' wakeup behavior.
>=20
> So in general, I think the answer here is that its associated with th=
e
> inode (I coudn't say with 100% certainty without really looking at al=
l
> file->poll() implementations). Certainly, with the 'FIFO' example bel=
ow,
> the two scenarios will have the same behavior with respect to
> EPOLLEXCLUSIVE.

So, in both scenarios, *one or more* processes will get a wakeup?
(I'll try to add something to the text to clarify the detail we're=20
discussing.)

> Also, the 'non-exclusive' mode would be subject to the same question =
of
> which wait queue is the epfd is associated with...

I'm not sure of the point you are trying to make here?

Cheers,

Michael


>> To make this point even clearer, here are two scenarios I'm thinking=
 of.
>> In each case, we're talking of monitoring the read end of a FIFO.
>>
>> =3D=3D=3D
>>
>> Scenario 1:
>>
>> We have three processes each of which
>> 1. Creates an epoll instance
>> 2. Opens the read end of the FIFO
>> 3. Adds the read end of the FIFO to the epoll instance, specifying
>>    EPOLLEXCLUSIVE
>>
>> When input becomes available on the FIFO, how many processes
>> get a wakeup?
>>
>> =3D=3D=3D
>>
>> Scenario 3
>>
>> A parent process opens the read end of a FIFO and then calls
>> fork() three times to create three children. Each child then:
>>
>> 1. Creates an epoll instance
>> 2. Adds the read end of the FIFO to the epoll instance, specifying
>> EPOLLEXCLUSIVE
>>
>> When input becomes available on the FIFO, how many processes
>> get a wakeup?
>>
>> =3D=3D=3D
>>
>> Cheers,
>>
>> Michael
>>
>=20


--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
