From: James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCHv3 0/2] capability controlled user-namespaces
Date: Mon, 8 Jan 2018 11:35:26 +1100 (AEDT)
Message-ID: <alpine.LFD.2.20.1801081131190.8436@localhost>
References: <20171205223052.12687-1-mahesh@bandewar.net> <CAF2d9jit74_VCdD-pEFy3bJo2W1-0cDo0BOJC5beJiy8yFPCWg@mail.gmail.com> <alpine.LFD.2.20.1712301931360.24310@localhost> <CAF2d9jiPYvMN=_guoZHyTA5FmMgaJb5mtxroi5D9NvcNrHc5gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-1193620534-1515371754=:8436"
Return-path: <kernel-hardening-return-11084-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CAF2d9jiPYvMN=_guoZHyTA5FmMgaJb5mtxroi5D9NvcNrHc5gg@mail.gmail.com>
To: =?UTF-8?Q?Mahesh_Bandewar_=28=E0=A4=AE=E0=A4=B9=E0=A5=87=E0=A4=B6_=E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=B0=29?= <maheshb@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Kernel-hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Serge Hallyn <serge@hallyn.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>, Mahesh Bandewar <mahesh@bandewar.net>
List-Id: linux-api@vger.kernel.org

--8323328-1193620534-1515371754=:8436
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 2 Jan 2018, Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=87=E0=A4=B6 =
=E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=B0) wrote:

> On Sat, Dec 30, 2017 at 12:31 AM, James Morris
> <james.l.morris@oracle.com> wrote:
> > On Wed, 27 Dec 2017, Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=87=E0=A4=
=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=B0) wrote:
> >
> >> Hello James,
> >>
> >> Seems like I missed your name to be added into the review of this
> >> patch series. Would you be willing be pull this into the security
> >> tree? Serge Hallyn has already ACKed it.
> >
> > Sure!
> >
> Thank you James.

I'd like to see what Eric Biederman thinks of this.

Also, why do we need the concept of a controlled user-ns at all, if the=20
default whitelist maintains existing behavior?


--=20
James Morris
<james.l.morris@oracle.com>

--8323328-1193620534-1515371754=:8436--
