From: James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCHv3 0/2] capability controlled user-namespaces
Date: Sat, 30 Dec 2017 19:31:43 +1100 (AEDT)
Message-ID: <alpine.LFD.2.20.1712301931360.24310@localhost>
References: <20171205223052.12687-1-mahesh@bandewar.net> <CAF2d9jit74_VCdD-pEFy3bJo2W1-0cDo0BOJC5beJiy8yFPCWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-624254867-1514622714=:24310"
Return-path: <kernel-hardening-return-11040-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CAF2d9jit74_VCdD-pEFy3bJo2W1-0cDo0BOJC5beJiy8yFPCWg@mail.gmail.com>
To: =?UTF-8?Q?Mahesh_Bandewar_=28=E0=A4=AE=E0=A4=B9=E0=A5=87=E0=A4=B6_=E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=B0=29?= <maheshb@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Kernel-hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Serge Hallyn <serge@hallyn.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>, Mahesh Bandewar <mahesh@bandewar.net>
List-Id: linux-api@vger.kernel.org

--8323328-624254867-1514622714=:24310
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 27 Dec 2017, Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=87=E0=A4=B6 =
=E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=B0) wrote:

> Hello James,
>=20
> Seems like I missed your name to be added into the review of this
> patch series. Would you be willing be pull this into the security
> tree? Serge Hallyn has already ACKed it.

Sure!


>=20
> Thanks,
> --mahesh..
>=20
> On Tue, Dec 5, 2017 at 2:30 PM, Mahesh Bandewar <mahesh@bandewar.net> wro=
te:
> > From: Mahesh Bandewar <maheshb@google.com>
> >
> > TL;DR version
> > -------------
> > Creating a sandbox environment with namespaces is challenging
> > considering what these sandboxed processes can engage into. e.g.
> > CVE-2017-6074, CVE-2017-7184, CVE-2017-7308 etc. just to name few.
> > Current form of user-namespaces, however, if changed a bit can allow
> > us to create a sandbox environment without locking down user-
> > namespaces.
> >
> > Detailed version
> > ----------------
> >
> > Problem
> > -------
> > User-namespaces in the current form have increased the attack surface a=
s
> > any process can acquire capabilities which are not available to them (b=
y
> > default) by performing combination of clone()/unshare()/setns() syscall=
s.
> >
> >     #define _GNU_SOURCE
> >     #include <stdio.h>
> >     #include <sched.h>
> >     #include <netinet/in.h>
> >
> >     int main(int ac, char **av)
> >     {
> >         int sock =3D -1;
> >
> >         printf("Attempting to open RAW socket before unshare()...\n");
> >         sock =3D socket(AF_INET6, SOCK_RAW, IPPROTO_RAW);
> >         if (sock < 0) {
> >             perror("socket() SOCK_RAW failed: ");
> >         } else {
> >             printf("Successfully opened RAW-Sock before unshare().\n");
> >             close(sock);
> >             sock =3D -1;
> >         }
> >
> >         if (unshare(CLONE_NEWUSER | CLONE_NEWNET) < 0) {
> >             perror("unshare() failed: ");
> >             return 1;
> >         }
> >
> >         printf("Attempting to open RAW socket after unshare()...\n");
> >         sock =3D socket(AF_INET6, SOCK_RAW, IPPROTO_RAW);
> >         if (sock < 0) {
> >             perror("socket() SOCK_RAW failed: ");
> >         } else {
> >             printf("Successfully opened RAW-Sock after unshare().\n");
> >             close(sock);
> >             sock =3D -1;
> >         }
> >
> >         return 0;
> >     }
> >
> > The above example shows how easy it is to acquire NET_RAW capabilities
> > and once acquired, these processes could take benefit of above mentione=
d
> > or similar issues discovered/undiscovered with malicious intent. Note
> > that this is just an example and the problem/solution is not limited
> > to NET_RAW capability *only*.
> >
> > The easiest fix one can apply here is to lock-down user-namespaces whic=
h
> > many of the distros do (i.e. don't allow users to create user namespace=
s),
> > but unfortunately that prevents everyone from using them.
> >
> > Approach
> > --------
> > Introduce a notion of 'controlled' user-namespaces. Every process on
> > the host is allowed to create user-namespaces (governed by the limit
> > imposed by per-ns sysctl) however, mark user-namespaces created by
> > sandboxed processes as 'controlled'. Use this 'mark' at the time of
> > capability check in conjunction with a global capability whitelist.
> > If the capability is not whitelisted, processes that belong to
> > controlled user-namespaces will not be allowed.
> >
> > Once a user-ns is marked as 'controlled'; all its child user-
> > namespaces are marked as 'controlled' too.
> >
> > A global whitelist is list of capabilities governed by the
> > sysctl which is available to (privileged) user in init-ns to modify
> > while it's applicable to all controlled user-namespaces on the host.
> >
> > Marking user-namespaces controlled without modifying the whitelist is
> > equivalent of the current behavior. The default value of whitelist incl=
udes
> > all capabilities so that the compatibility is maintained. However it gi=
ves
> > admins fine-grained ability to control various capabilities system wide
> > without locking down user-namespaces.
> >
> > Please see individual patches in this series.
> >
> > Mahesh Bandewar (2):
> >   capability: introduce sysctl for controlled user-ns capability whitel=
ist
> >   userns: control capabilities of some user namespaces
> >
> >  Documentation/sysctl/kernel.txt | 21 +++++++++++++++++
> >  include/linux/capability.h      |  7 ++++++
> >  include/linux/user_namespace.h  | 25 ++++++++++++++++++++
> >  kernel/capability.c             | 52 +++++++++++++++++++++++++++++++++=
++++++++
> >  kernel/sysctl.c                 |  5 ++++
> >  kernel/user_namespace.c         |  4 ++++
> >  security/commoncap.c            |  8 +++++++
> >  7 files changed, 122 insertions(+)
> >
> > --
> > 2.15.0.531.g2ccb3012c9-goog
> >
>=20

--=20
James Morris
<james.l.morris@oracle.com>

--8323328-624254867-1514622714=:24310--
