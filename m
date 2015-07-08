From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] ipc: Modify message queue accounting to not take kernel
 data structures into account
Date: Wed, 08 Jul 2015 15:17:52 -0400
Message-ID: <559D7760.1020909@redhat.com>
References: <20150622222546.GA32432@ramsey.localdomain> <1435211229.11852.23.camel@stgolabs.net> <CAKgNAkieR5zdpKm=P2dcTDJ_3X4HMRoeOQ2D8yghYVKOjDsYAg@mail.gmail.com> <1435256484.11852.30.camel@stgolabs.net> <20150706154928.GA19828@ramsey.localdomain> <1436246210.12255.71.camel@stgolabs.net> <CAKgNAkjy-+2TkN=0Fe11bVea4q6uLcUx=++Mf1eFxhmPmZoc9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xXsc2F1spLJgj0U9qhXjv5F5pUVibQt2P"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgNAkjy-+2TkN=0Fe11bVea4q6uLcUx=++Mf1eFxhmPmZoc9w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Cc: Marcus Gelderie <redmnic-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, John Duffy <jb_duffy-FhtRXb7CoQBt1OO0OYaSVA@public.gmane.org>, Arto Bendiken <arto-TQ6thHYR8Svk1uMJSBkQmQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xXsc2F1spLJgj0U9qhXjv5F5pUVibQt2P
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 07/07/2015 09:01 AM, Michael Kerrisk (man-pages) wrote:
> Hi David,
>=20
> On 7 July 2015 at 07:16, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org> wrote:
>> On Mon, 2015-07-06 at 17:49 +0200, Marcus Gelderie wrote:
>>> A while back, the message queue implementation in the kernel was
>>> improved to use btrees to speed up retrieval of messages (commit
>>> d6629859b36). The patch introducing the improved kernel handling of
>>> message queues (using btrees) has, as a by-product, changed the
>>> meaning of the QSIZE field in the pseudo-file created for the queue.
>>> Before, this field reflected the size of the user-data in the queue.
>>> Since, it also takes kernel data structures into account. For
>>> example, if 13 bytes of user data are in the queue, on my machine the=

>>> file reports a size of 61 bytes.
>>>
>>> There was some discussion on this topic before (for example
>>> https://lkml.org/lkml/2014/10/1/115). Commenting on a th lkml, Michae=
l
>>> Kerrisk gave the following background (https://lkml.org/lkml/2015/6/1=
6/74):
>>>
>>>     The pseudofiles in the mqueue filesystem (usually mounted at
>>>     /dev/mqueue) expose fields with metadata describing a message
>>>     queue. One of these fields, QSIZE, as originally implemented,
>>>     showed the total number of bytes of user data in all messages in
>>>     the message queue, and this feature was documented from the
>>>     beginning in the mq_overview(7) page. In 3.5, some other (useful)=

>>>     work happened to break the user-space API in a couple of places,
>>>     including the value exposed via QSIZE, which now includes a measu=
re
>>>     of kernel overhead bytes for the queue, a figure that renders QSI=
ZE
>>>     useless for its original purpose, since there's no way to deduce
>>>     the number of overhead bytes consumed by the implementation.
>>>     (The other user-space breakage was subsequently fixed.)
>>
>> Michael, this breakage was never finally documented in the manpage,
>> right?
>=20
> Right.
>=20
>> I took a look and there is no mention, but it was a quick look.
>> It's just that if this patch goes in, I'd hate ending up with somethin=
g
>> like this in the manpage:
>>
>> as of 3.5
>>   <accounts for kernel overhead>
>>
>> as of 4.3
>>   <behavior reverted back to not include kernel overhead... *sigh*>
>>
>> If there are changes to be made to the manpage, it should probably be
>> posted with this patch, methinks.
>=20
> I think something like the above will have to end up in the man page.
> The only thing I'd add is that the fix also has gone to -stable
> kernels. At least: I think this patch should also be marked for
> -stable. I'll take care of the man page updates as the patch goes
> through.
>=20
>>> This patch removes the accounting of kernel data structures in the
>>> queue. Reporting the size of these data-structures in the QSIZE field=

>>> was a breaking change (see Michael's comment above). Without the QSIZ=
E
>>> field reporting the total size of user-data in the queue, there is no=

>>> way to deduce this number.
>>>
>>> It should be noted that the resource limit RLIMIT_MSGQUEUE is counted=

>>> against the worst-case size of the queue (in both the old and the new=

>>> implementation). Therefore, the kernel overhead accounting in QSIZE i=
s
>>> not necessary to help the user understand the limitations RLIMIT impo=
ses
>>> on the processes.
>>
>> Also, I would suggest adding some comment in struct mqueue_inode_info
>> for future reference, ie:
>>
>> -       unsigned long qsize; /* size of queue in memory (sum of all ms=
gs) */
>> +       /*
>> +        * Size of queue in memory (sum of all msgs). Accounts for
>> +        * only userspace overhead; ignoring any in-kernel rbtree node=
s.
>> +        */
>> +       unsigned long qsize;
>>
>> But no big deal in any case.
>>
>> I think this is the right approach,
>=20
> Me too.
>=20
>> but would still like to know if Doug
>> has any concerns about it.
>=20
> Looking on gmane, Doug does not appear to have been active on any
> lists since late May! Not sure why.

I responded yesterday in the v2 patch thread I believe.  In any case, I
think this patch is fine, and can go to stable.  This patch doesn't
actually change the math related to the rlimit checks (which is the main
thing I wanted to correct in my original patches), instead it corrects a
mistake I made.  At the time, I mistakenly thought that the qsize
included the current message data total + the struct msg_msg size total.
 It didn't, it was just the current user data total.  I added the rbtree
nodes in order to keep the total accurate but I shouldn't have added the
rbtree nodes to this total because none of the other kernel usage was
previously included.

Acked-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>



--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--xXsc2F1spLJgj0U9qhXjv5F5pUVibQt2P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVnXdgAAoJELgmozMOVy/dCfQP/3YC8/pVEHka8+Vi51sutou9
M6gRc9s/kC11mwhpD39jHTf+nErHx9NYq+l4e1h8rmj6Gv+hSUWe26plhe1vtL/d
8MquiawxxS1PuGKh6Pckv4zkAhVnFyY9c0VbNnt2UcYGRk8fp5oLCPwc99acMz/T
plphc58aTya9UO5Dx5KFwKDGuSM/5lyTFPUoINqgway69WEfbvChxrWWAhHj8l2s
Q+tXrgz4D42RAvkxOJ5xevH/vEp5EvYHfREIN0RMriymlVwRSMEwSJDKwh5TBrcB
HU/KouxBbc4cbhuU9HjkShg9Z0Besab0BY0g0IILydXMT05oj6uTCY/X0qdefE0Y
b9FTf95U71EErChI9wgDpizSJ2EmR//P/xmA+hwLGHiFI03xql1racdNZstrBjMV
oAniFFGZ2aHeTAosdmkjTcVQi9vAOJbRFl2+N0js603+XIQv6OmBkatedVjdpGIA
B17imG1KoxH+FEfWphe74XenC9267lJq0jqyFuOVqY4wIiuGnyBmBqgljkzfuH73
NGLC5Rkx/cKBRzPZmCWWs5v1foUPPUJTldZRO3Hu16z59wgmq64rJ2jP1NeRQ/qh
Xq+oiEIKwSt7xQAMFHZ2oKKxm7eXFfB4zQ2GJ/41400KEH+px+/GdTfoTaaT5CiW
lrkKTIjzy2rFy1ymtBx4
=qXYz
-----END PGP SIGNATURE-----

--xXsc2F1spLJgj0U9qhXjv5F5pUVibQt2P--
