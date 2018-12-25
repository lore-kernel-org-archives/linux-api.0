From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v2] signal: add procfd_signal() syscall
Date: Tue, 25 Dec 2018 23:07:57 +1100
Message-ID: <20181225120757.37w37lmyhxo6kekl@yavin>
References: <746B7C49-CC7B-4040-A7EF-82491796D360@brauner.io>
 <20181202100304.labt63mzrlr5utdl@brauner.io>
 <8736rebl9s.fsf@oldenburg.str.redhat.com>
 <20181203180224.fkvw4kajtbvru2ku@brauner.io>
 <874lbtjvtd.fsf@oldenburg2.str.redhat.com>
 <CALCETrViXJ0gD34yVd8QpB-CSeKZzzncvkPHReycTiQin4r4WQ@mail.gmail.com>
 <87y392h4b7.fsf@oldenburg2.str.redhat.com>
 <C5E71146-DE79-4145-B54B-E161E7372D95@brauner.io>
 <CAJhGHyC=Zc=iG+iL+Ny8GsMd-5xypxdk4Et_1ZViMao5aXreCw@mail.gmail.com>
 <CAJhGHyAHKm0q4FtHBgbbfaB3g4oix76vJWgjqLYoaHvKCD3gvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="q4jdymnvoez454lh"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJhGHyAHKm0q4FtHBgbbfaB3g4oix76vJWgjqLYoaHvKCD3gvA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Cc: Christian Brauner <christian@brauner.io>, Florian Weimer <fweimer@redhat.com>, Andy Lutomirski <luto@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Daniel Colascione <dancol@google.com>, Tim Murray <timmurray@google.com>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org


--q4jdymnvoez454lh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2018-12-25, Lai Jiangshan <jiangshanlai+lkml@gmail.com> wrote:
> On Tue, Dec 25, 2018 at 1:32 PM Lai Jiangshan
> <jiangshanlai+lkml@gmail.com> wrote:
> >
> > Is it possible to avoid adding any syscall?
> >
> > Since holding /proc/pid/reg_file can also hold the pid.
> > With this guarantee, /proc/pid/uuid (universally unique identifier ) ca=
n be
> > introduced to identify tasks, the kernel generates
> > a uuid for every task when created.
> >
> > save_pid_uuid_pair_for_later_kill(int pid) {
> >   /* save via /proc/$pid/uuid */
> >   /* don't need to keep any fd after save */
> > }
> >
> > safe_kill(pid, uuid, sig) {
> >     fd =3D open(/proc/$pid/uuid); /* also hold the pid until close() if
> > open() successes */
> >     if (open successes and read uuid from fd and if it equals to uuid)
> >         kill(pid, sig)
> >     close(fd)
> > }
> >
> > All things needed to be done is to implement /proc/pid/uuid. And if pid=
 can't
> > be recycled within 1 ticket, or the user can ensure it. The user can use
> > starttime(in /proc/pid/stat) instead.
> >
> > save_pid_starttime_pair_for_later_kill(int pid) {
> >   /* save via /proc/$pid/stat */
> >   /* don't need to keep any fd after save or keep it for 1 ticket at mo=
st */
> > }
> >
> > safe_kill(pid, starttime, sig) {
> >     fd =3D open(/proc/$pid/stat); /* also hold the pid until close() if
> > open() successes */
> >     if (open successes and read starttime from fd and if it equals to s=
tarttime)
> >         kill(pid, sig)
> >     close(fd)
> > }
> >
> > In this case, zero LOC is added in the kernel. All of it depends on
> > the guarantee that holding /proc/pid/reg_file also holds the pid,
> > one of which I haven't checked carefully either.
> >
>=20
> Oh, Sorry, I was wrong, the pid isn't reserved even when
> the fd is kept in the user space. And I'm sorry that I had
> replied to an "old" email thread.

Don't worry, this was a common point of confusion during this (and
sister) threads. All the fd ensures is that access through that fd will
give you -ESRCH if the process is gone (and if the PID is reused it will
still give you -ESRCH).


--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--q4jdymnvoez454lh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb6Gz4/mhjNy+aiz1Snvnv3Dem58FAlwiHZ0ACgkQSnvnv3De
m591UxAAsfeV1mki8pGjp8ePXOEqSApU/bV4+S6N+8Xt7yZIAdzAMspeaibxXJ3r
zSqflUgH/KeYH72gaRSseAk14R30jt9jjf/Q5P7aPuN97kZsf/0+j+il5wj2mTDa
vXnopUyCeQpbcTcM4YktBvgZC1ZjTj99Jhy94petxRfFtQOurW+wblx4MF/6+/y3
3rpf8TyFTez9FCV+LLvwNekIyLVlG8QeuWl1N14qgdyNE+NWOETZup2QxhKBsoDj
fxZmNKD1ChwzQaKQNm/zSGlh1Xkm9R/SnM2Nr3YWsxdbboyigeRceDv5HDqltz/9
AN0s12V7iGcg5n4s4hyj+wWQKW7VJHEvxZ0aVjD+zPeSCwM6w2oTH3QcV7oCz3gN
tj5i1hOnFrsC/HszxFsXdQAYgaidAmO5lPpULasoTonsTNNRSUOnMuUMZ3CnAowB
OxmWrAKubLCzI0k4SqMlaQtbHkeqB3nlUBgTEgOUfLaXUYW1xQYNgmlZvbT5OG1e
ytQc/5E+2PaSLTLp6S/2AuBm8a7JOm13DZ341p+pWVGLrN5/L19CSTrtpJfIzMqT
SUKC7nkRse557h96bZnc38t/G0u7Ec4QIdNYqqrIcUFelyoS0WkBWcdpwi+ZH5n6
V1jLxVD3OonKoPqcTSZOBDwaw9k0QVbk/exxn9GM41NJI9fc78k=
=3gq/
-----END PGP SIGNATURE-----

--q4jdymnvoez454lh--
