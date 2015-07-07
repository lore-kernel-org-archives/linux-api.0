From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] ipc: Modify message queue accounting to reflect both total user data and auxiliary kernel data
Date: Tue, 7 Jul 2015 14:49:09 -0400
Message-ID: <1C4A1632-4031-4B2B-B489-57C410973285@redhat.com>
References: <20150622222546.GA32432@ramsey.localdomain> <1435211229.11852.23.camel@stgolabs.net> <CAKgNAkieR5zdpKm=P2dcTDJ_3X4HMRoeOQ2D8yghYVKOjDsYAg@mail.gmail.com> <20150625185019.GA17933@ramsey.Speedport_W_724V_09011603_00_009>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: multipart/signed; boundary="Apple-Mail=_8EF88879-368A-4CB6-AC2A-3990342A8F36"; protocol="application/pgp-signature"; micalg=pgp-sha512
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150625185019.GA17933-dYYy/5+rgCadFe0WYshgmA@public.gmane.org_W_724V_09011603_00_009>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marcus Gelderie <redmnic-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, John Duffy <jb_duffy-FhtRXb7CoQBt1OO0OYaSVA@public.gmane.org>, Arto Bendiken <arto-TQ6thHYR8Svk1uMJSBkQmQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--Apple-Mail=_8EF88879-368A-4CB6-AC2A-3990342A8F36
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Jun 25, 2015, at 2:50 PM, Marcus Gelderie <redmnic-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =
wrote:
>=20
> Hey all,
>=20
> answers in text below...
>=20
> TLDR: I can remove the QKERSIZE field, as I believe that it does not =
affect he
> RLIMIT accounting (details [=3Dcode] below). Question is: Should it?
>=20
> Before I provide another patch, I would appreciate another round of =
feedback, though.
>=20
> So=E2=80=A6
> On Thu, Jun 25, 2015 at 09:23:33AM +0200, Michael Kerrisk (man-pages) =
wrote:
>> On 25 June 2015 at 07:47, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org> wrote:
>>> Good catch, and a nice opportunity to make the mq manpage more =
specific
>>> wrt to queue sizes.
>>>=20
>>> [...]
>>>=20
> ACK, I can write a patch for the manpage once we figure out what to do
> here.
>>>> Reporting the size of the message queue in kernel has its merits, =
but
>>>> doing so in the QSIZE field of the pseudo file corresponding to the
>>>> queue is a breaking change, as mentioned above. This patch =
therefore
>>>> returns the QSIZE  field to its original meaning. At the same time,
>>>> it introduces a new field QKERSIZE that reflects the size of the =
queue
>>>> in kernel (user data + kernel data).
>>>=20
>>> Hmmm I'm not sure about this. What are the specific benefits of =
having
>>> QKERSIZE? We don't export in-kernel data like this in any other ipc
>>> (posix or sysv) mechanism, afaik. Plus, we do not compromise kernel =
data
>>> structures like this, as we would break userspace if later we change
>>> posix_msg_tree_node. So NAK to this.
>>>=20
>>> I would just remove the extra
>>> +       info->qsize +=3D sizeof(struct posix_msg_tree_node);
>>>=20
>>> bits from d6629859b36 (along with -stable v3.5), plus a patch =
updating
>>> the manpage that this field only reflects user data.
>>=20
> This can be done if the RLIMIT accounting is not done against that
> value (more below).
>=20
>> I've been hoping that Doug would jump into this discussion=E2=80=A6

Sorry to have been quiet so far.  PTO interfered.

>> If I recall/understand Doug correctly (see
>> http://thread.gmane.org/gmane.linux.man/7050/focus=3D1797645 ), his
>> rationale for the QSIZE change was that it then revealed a value that
>> was closer to what was being used to account against the
>> RLIMIT_MSGQUEUE resource limit. (Even with these changes, the QSIZE
>> value was not 100% accurate for accounting against RLIMIT_MSGQUEUE,
>> since some pieces of kernel overhead were still not being accounted
>> for. Nevertheless, it's much closer than the old (pre 3.5) QSIZE for
>> some corner cases.) Thus, Marcus's rationale for preserving this info
>> as QKERSIZE.

Yes.  A bit more rationale was that the change to use an rbtree for =
priorities made the worst case scenario for queue size grow quite a lot. =
 This is especially true when dealing with queues with a very small =
message size.  If we didn=E2=80=99t account for some of this growth in =
size, we opened ourselves up to a DDoS type attack where a malicious =
user could create lots of queues with very small message sizes and lots =
of messages and then just create enough messages of different priorities =
to force allocating all of these structs.  Since they would be allowed =
to create 1 byte messages in the queue, and could easily create a 1024 =
element queue, that would be a 1k accounting for user data that in worst =
case scenario used up something like 96k of kernel memory.  With the =
default RLIMIT for msg queues being something like 800K, let=E2=80=99s =
just assume one user id can create 800 * 96k of kernel memory =
allocations, so 72MB of kernel memory used per user id.  Given a few =
user ids, it can actually be significant.  And all the while the =
sysadmin is scratching his head going =E2=80=9Cwhere the hell is all my =
memory going?=E2=80=9D because there is no clear indication that a 1 =
byte message in the POSIX mqueue subsystem is consuming 96bytes or so of =
kernel memory.

So, just to be clear, my rationale here is =E2=80=9CBreaking =
expectations is bad, but leaving a possible DDoS style exploit is =
worse=E2=80=9D.  That=E2=80=99s why I changed the accounting.  I had one =
or two users complain that they had to administratively adjust the =
RLIMIT_MSGQUEUE setting on their servers to compensate, but that=E2=80=99s=
 as it should be.  Now they *know* where their memory is being used =
instead of having a lurking memory black hole in their system.  For =
those users that use large message sizes, they didn=E2=80=99t even =
notice the change, it was just lost in the noise.

>=20
> Actually, looking at the code, it seems to me that the QKERSIZE
> (a.k.a. the current qsize field) is actually not used for the purpose =
of
> accounting at all. =46rom ipc/mqueue.c (line 281 ff, comments added by =
me):
>=20
> 		/* worst case estimate for the btree in memory */
>=20
> 		mq_treesize =3D info->attr.mq_maxmsg * sizeof(struct =
msg_msg) +
> 			min_t(unsigned int, info->attr.mq_maxmsg, =
MQ_PRIO_MAX) *
> 			sizeof(struct posix_msg_tree_node);
>=20
> 		/* worst case estimate for the user data in the queue */
>=20
> 		mq_bytes =3D mq_treesize + (info->attr.mq_maxmsg *
> 					  info->attr.mq_msgsize);
>=20
> 		spin_lock(&mq_lock);
>=20
> 		    /* acutal accounting; u->mq_bytes is the other
> 		     * message queus for this user (computed in the way
> 		     * above (i.e. worst-case estimates)
> 		     */
>=20
> 		if (u->mq_bytes + mq_bytes < u->mq_bytes ||
> 		    u->mq_bytes + mq_bytes > rlimit(RLIMIT_MSGQUEUE)) {
> 			[....]
> 			ret =3D -EMFILE;
> 			[.....]
>=20
> So, I think that if the RLIMIT should take the actual size (not the
> worst case) into account, then we have a bug. I can write a patch, but =
that
> should be separate from this... meaning I'll turn this into a =
patchset.
>=20
> However, we should decide what we want first: If I read the manpage =
(mq_overview), I
> am inclined to think that the RLIMIT should use the acutal amount of
> data occupied by the queue (or at least the user data). But it does =
not
> necessarily rule out an accounting against worst-case estimation (to =
me
> at least).

You have to use worst case.  You don=E2=80=99t have a choice.  The =
reason is that the check is only performed at queue creation time (and =
the user API expects this), so once the queue is created and the user is =
allowed to use it, failure due to RLIMIT issues is no longer allowed.  =
We therefore must use whatever worst case scenario we wish to use when =
we test the size during creation and then we have to be OK with the =
variance we might get from that during real world usage.  My tests/maths =
were intended to be =E2=80=9Cclose enough=E2=80=9D that they couldn=E2=80=99=
t be fooled with small message sizes and large queue sizes, but not =
intended to be perfect.

>> Now whether QKERSIZE is actually useful or used by anyone is another
>> question. As far as I know, there was no user request that drove the
>> change. But Doug can perhaps say something to this. QSIZE should I
>> think definitely be fixed (reverted to pre-3.5 behavior). I'm =
agnostic
>> about QKERSIZE.

Here=E2=80=99s what I would prefer to see happen:

1) Keep the maths as they are.  We need to account worst case because =
apps don=E2=80=99t expect run time checks/failures.
2) Keep accounting for kernel data size as part of queue size and adding =
both before checking it against the rlimit for the user.
3) Create a new mq_create call that take a new mq_attr struct.  This =
struct should add a field for max_priorities.  For existing apps, the =
current default of 32,768 priorities can be used.  For other apps, let =
them select their requested number of priorities.  By selecting lower =
numbers of priorities, that worst case scenario gets much better (as =
long as their queue size is larger than their number of priorities).

Or, as an alternative:

1) Change the maths to account for the msg struct, but ignore the rbtree =
structs.  This is still different from when I made my change in that the =
maths used to only account for a msg struct *.  This would put the =
overall total change somewhere in between real memory usage and memory =
queue size.  For instance, if you had a 1k queue of 1 byte messages, =
here=E2=80=99s how it lays out:

Pre-3.5 math: 1k * (1byte + (sizeof *)) =3D 5k or 9k (32/64bit arch)
Pre-3.5 reality: 1k * (1byte + (sizeof *) + sizeof (struct msg_msg) + =
unaccounted stuff) =3D 50ishk

Post-3.5 math: 1k * (1byte + sizeof (struct msg_msg) + sizeof (struct =
msg_node)) =3D 90ishk
Post-3.5 reality: 90ishk

Proposed math: 1k * (qbyte + sizeof (struc msg_msg)) =3D 50ishk
Proposed reality: 90ishk

The reason I suggest this is that the real world usage I=E2=80=99ve seen =
does not use lots of priorities.  So, even though the *worst case* =
reality is 90k, the common case will be in the 50k range like the math.  =
Given that we are less than a 2 to 1 ratio of worst case to math, a DDoS =
is unlikely to go undetected.  The only real problem here is that if you =
have an admin that wants to create lots of queues and use as much ram as =
possible, and they use lots of priorities, then they might get confused =
when their calculated sizes of mqueues fills RAM faster than they =
expected and the actually run out of RAM in use.

=E2=80=94
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
	GPG Key ID: 0E572FDD






--Apple-Mail=_8EF88879-368A-4CB6-AC2A-3990342A8F36
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJVnB8mAAoJELgmozMOVy/d/hcQALEMcMFugFLdDsiUROzVWdRW
1MPQqwwNuZCprbC/j0PG1P3OhntoTzFoSMbYU610X5Po5XLpTgKJOgQ5gsHLB5E0
DaFoaFwX0nMP5oDNy6pCT+ub+yZRF/7GhbHxhxsWhUPlyhXdA2V+PBwQeW1yJ5wK
l101Lv+XfTNqjh43Yd6Pph+yMLt8tE3dbNNlt8tP/hqo9cIH3TpJ4ewIzqo9HLqO
t5uxkqNTxIqSGONiEmY48GdfKIScBFL3C/SjuTxNVzeV2Mf1lPxywjqrEKcdid1Z
3WVEilx2t6nWwP2Us/tx8MjbTsPoEjArQHyy2E+L57s7M6KJ5AyM3mekoig56+1u
Ob224KvpfuBuD4LMy2jCbezpNS13go1RPpOTLOfOHGoLrwAZQUG804/M3Dx2HZuc
eCGnHQLQRQBVKh4jNFS7LxmtozGuWVqgblb3dS5cNTm5jZL4iHGs/T2QwYkBphMf
BUYgQhOQsN/p1Rw2hvIRVefFKn9qf02x+s8i5lx7wbtBzpUPQdrn34Zk1qkoq4in
WDA+JllT34KonM+eOpovMUiUgeqEcDl5rQ/iyM8EOAgUTNvdW4HvIM3pFqMaD8EI
25C6bD7AFun4minrSuvx4MuFHrylZdsoLniA52F+jVHX3Z680gTx+0GgrQxBCcJD
f/pljbOJ8wrTKMm+QgO6
=OWyW
-----END PGP SIGNATURE-----

--Apple-Mail=_8EF88879-368A-4CB6-AC2A-3990342A8F36--
