From: Jann Horn <jannhorn-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: How about allowing ptracing processes in the TASK_UNINTERRUPTIBLE
 state?
Date: Fri, 22 Mar 2013 12:47:39 +0100
Message-ID: <20130322114739.GA8496@debjann.fritz.box>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,
I am looking for opinions on an idea: How about allowing ptracing of proces=
ses
in the TASK_UNINTERRUPTIBLE state, at least for processes with CAP_SYS_PTRA=
CE?
I think that it would be useful to be able to grab coredumps of processes t=
hat
are hanging in the TASK_UNINTERRUPTIBLE state, but for that, I think that it
would be necessary to have some way to inspect the registers of processes t=
hat
are hanging there, and the easiest way to allow that that I can see would b=
e to
patch ptrace.

Here's my usecase: I wrote an OpenCL program to run some computations and
estimated the real time it would run for to be around four hours. Now this
program has run for ten hours. I'm relatively sure that it's not hanging, b=
ut
I'd really like to inspect its state with gdb to see how much of the result
buffer is filled with results =E2=80=93 however, that's not possible becaus=
e the OpenCL
implementation has caused my process to go into the D state. I'll have to r=
eboot
the PC to abort the computation or to wait for an unknown amount of time un=
til
it finishes (in case it hasn't deadlocked somewhere). Yes, it's my mistake =
to
send such an amount of work to the GPU without intermediary save steps, but
still, I think that this would be a useful feature for debugging.

The only potential issue I can see with this is that someone might use it f=
or
causing a denial of service by stopping something inside some kind of lock.
Because of this, I'm suggesting to limit this ability to processes with
CAP_SYS_PTRACE. As far as I know, security should not be an issue because
kernel mode and user mode registers are seperate, but I'm not entirely sure
about that =E2=80=93 could anyone here tell me whether that's right?

If you don't tell me that it's a very bad idea or hard to implement for some
reason (I have written nearly no kernel code in the past, so I don't know h=
ow
hard it will be), I'll try to write a patch.

Jann

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRTETbAAoJEGhmizV0f2d1JHAP/iNZ0GUPXZg7siV/jhWxf8Jv
/nkCs86MvOf7rtspKPf/q7uPXUB3tZXkTMY1cLNi/yFalf8h+ipyLikx52VGGGoT
f3tMtn14enafCoQxxB9mTdglPKjelL/8RRZCTJ3thvD4abZCEt4u9z4M2aJoOkG3
ME+6ylxWbxvT4dZ9ZGxZ9iziZnI8eu7JYjtUN3PWKF0tK4ZicYg5boEsj5Acl9IX
sDq41GLq1dwgF3/t4RVpTWvjMdEiEDCi29YQIjtzzx4Kn9z14D8xyZAJ9zie5of5
aAR6x+z7JjxZmdOuwhj8UNdzlkvqngNcbFpeu2GsQK/mhjkozILbCJvHZqeoNOzA
pQRFQ2XsfTQfzLMkS1fkM0jsd/bFSsDhox5gBYZ27WQnUz2Sl40OwaOAToLpGuTO
TmVwUvzhrkiojyIkcJFTx2HDCC1sJ7ZFD8AKsbb2hJs2G7cj6EeskQOLBwCVxTM4
gIIPdHwu4k1RW0eOBzp6aTRR2YFurVHtCt5NmSZjeA7XjxeB3Z317XpJWRBkLUtF
SFkmhW2H/bKeFe9NjakFc9k7vNN+RBgeycoun5qLLPHimqOukIVoa0fyKeoSe5hR
Z6PALfYeHf8mx0bD9zkuM1a4GIDcLPPKwnWGK078gxzzCN40+/bLPRW0KUbkBgqX
CFz6MjSdMP0BdL3OOKBp
=GYGh
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
