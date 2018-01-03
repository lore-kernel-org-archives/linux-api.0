From: =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?=
        <maheshb@google.com>
Subject: Re: [PATCHv3 0/2] capability controlled user-namespaces
Date: Tue, 2 Jan 2018 17:30:34 -0800
Message-ID: <CAF2d9jiPYvMN=_guoZHyTA5FmMgaJb5mtxroi5D9NvcNrHc5gg@mail.gmail.com>
References: <20171205223052.12687-1-mahesh@bandewar.net> <CAF2d9jit74_VCdD-pEFy3bJo2W1-0cDo0BOJC5beJiy8yFPCWg@mail.gmail.com>
 <alpine.LFD.2.20.1712301931360.24310@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.20.1712301931360.24310@localhost>
Sender: netdev-owner@vger.kernel.org
To: James Morris <james.l.morris@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Kernel-hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Serge Hallyn <serge@hallyn.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>, Mahesh Bandewar <mahesh@bandewar.net>
List-Id: linux-api@vger.kernel.org

On Sat, Dec 30, 2017 at 12:31 AM, James Morris
<james.l.morris@oracle.com> wrote:
> On Wed, 27 Dec 2017, Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=87=E0=A4=
=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=B0) wrote:
>
>> Hello James,
>>
>> Seems like I missed your name to be added into the review of this
>> patch series. Would you be willing be pull this into the security
>> tree? Serge Hallyn has already ACKed it.
>
> Sure!
>
Thank you James.
>
>>
>> Thanks,
>> --mahesh..
>>
>> On Tue, Dec 5, 2017 at 2:30 PM, Mahesh Bandewar <mahesh@bandewar.net> wr=
ote:
>> > From: Mahesh Bandewar <maheshb@google.com>
>> >
>> > TL;DR version
>> > -------------
>> > Creating a sandbox environment with namespaces is challenging
>> > considering what these sandboxed processes can engage into. e.g.
>> > CVE-2017-6074, CVE-2017-7184, CVE-2017-7308 etc. just to name few.
>> > Current form of user-namespaces, however, if changed a bit can allow
>> > us to create a sandbox environment without locking down user-
>> > namespaces.
>> >
>> > Detailed version
>> > ----------------
>> >
>> > Problem
>> > -------
>> > User-namespaces in the current form have increased the attack surface =
as
>> > any process can acquire capabilities which are not available to them (=
by
>> > default) by performing combination of clone()/unshare()/setns() syscal=
ls.
>> >
>> >     #define _GNU_SOURCE
>> >     #include <stdio.h>
>> >     #include <sched.h>
>> >     #include <netinet/in.h>
>> >
>> >     int main(int ac, char **av)
>> >     {
>> >         int sock =3D -1;
>> >
>> >         printf("Attempting to open RAW socket before unshare()...\n");
>> >         sock =3D socket(AF_INET6, SOCK_RAW, IPPROTO_RAW);
>> >         if (sock < 0) {
>> >             perror("socket() SOCK_RAW failed: ");
>> >         } else {
>> >             printf("Successfully opened RAW-Sock before unshare().\n")=
;
>> >             close(sock);
>> >             sock =3D -1;
>> >         }
>> >
>> >         if (unshare(CLONE_NEWUSER | CLONE_NEWNET) < 0) {
>> >             perror("unshare() failed: ");
>> >             return 1;
>> >         }
>> >
>> >         printf("Attempting to open RAW socket after unshare()...\n");
>> >         sock =3D socket(AF_INET6, SOCK_RAW, IPPROTO_RAW);
>> >         if (sock < 0) {
>> >             perror("socket() SOCK_RAW failed: ");
>> >         } else {
>> >             printf("Successfully opened RAW-Sock after unshare().\n");
>> >             close(sock);
>> >             sock =3D -1;
>> >         }
>> >
>> >         return 0;
>> >     }
>> >
>> > The above example shows how easy it is to acquire NET_RAW capabilities
>> > and once acquired, these processes could take benefit of above mention=
ed
>> > or similar issues discovered/undiscovered with malicious intent. Note
>> > that this is just an example and the problem/solution is not limited
>> > to NET_RAW capability *only*.
>> >
>> > The easiest fix one can apply here is to lock-down user-namespaces whi=
ch
>> > many of the distros do (i.e. don't allow users to create user namespac=
es),
>> > but unfortunately that prevents everyone from using them.
>> >
>> > Approach
>> > --------
>> > Introduce a notion of 'controlled' user-namespaces. Every process on
>> > the host is allowed to create user-namespaces (governed by the limit
>> > imposed by per-ns sysctl) however, mark user-namespaces created by
>> > sandboxed processes as 'controlled'. Use this 'mark' at the time of
>> > capability check in conjunction with a global capability whitelist.
>> > If the capability is not whitelisted, processes that belong to
>> > controlled user-namespaces will not be allowed.
>> >
>> > Once a user-ns is marked as 'controlled'; all its child user-
>> > namespaces are marked as 'controlled' too.
>> >
>> > A global whitelist is list of capabilities governed by the
>> > sysctl which is available to (privileged) user in init-ns to modify
>> > while it's applicable to all controlled user-namespaces on the host.
>> >
>> > Marking user-namespaces controlled without modifying the whitelist is
>> > equivalent of the current behavior. The default value of whitelist inc=
ludes
>> > all capabilities so that the compatibility is maintained. However it g=
ives
>> > admins fine-grained ability to control various capabilities system wid=
e
>> > without locking down user-namespaces.
>> >
>> > Please see individual patches in this series.
>> >
>> > Mahesh Bandewar (2):
>> >   capability: introduce sysctl for controlled user-ns capability white=
list
>> >   userns: control capabilities of some user namespaces
>> >
>> >  Documentation/sysctl/kernel.txt | 21 +++++++++++++++++
>> >  include/linux/capability.h      |  7 ++++++
>> >  include/linux/user_namespace.h  | 25 ++++++++++++++++++++
>> >  kernel/capability.c             | 52 ++++++++++++++++++++++++++++++++=
+++++++++
>> >  kernel/sysctl.c                 |  5 ++++
>> >  kernel/user_namespace.c         |  4 ++++
>> >  security/commoncap.c            |  8 +++++++
>> >  7 files changed, 122 insertions(+)
>> >
>> > --
>> > 2.15.0.531.g2ccb3012c9-goog
>> >
>>
>
> --
> James Morris
> <james.l.morris@oracle.com>
