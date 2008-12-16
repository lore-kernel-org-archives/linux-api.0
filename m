From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 0/3] preadv & pwritev syscalls.
Date: Tue, 16 Dec 2008 22:03:05 +0100
Message-ID: <200812162203.06139.arnd@arndb.de>
References: <1229340977-24345-1-git-send-email-kraxel@redhat.com> <4947DBFA.9050108@redhat.com> <20081216170209.GC410@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20081216170209.GC410@bombadil.infradead.org>
Content-Disposition: inline
Sender: linux-arch-owner@vger.kernel.org
To: Kyle McMartin <kyle@infradead.org>
Cc: Gerd Hoffmann <kraxel@redhat.com>, Ralf Baechle <ralf@linux-mips.org>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tuesday 16 December 2008, Kyle McMartin wrote:
> > I'd prefer to have the ordering coded explicitly instead, like this=
:
> >=20
> > asmlinkage int compat_sys_pwritev(unsigned long fd,
> > =A0 =A0 =A0 =A0const struct compat_iovec __user *vec, unsigned long=
 vlen,
> > =A0 =A0 =A0 =A0unsigned pos_low, unsigned pos_high)
> > {
> > =A0=A0=A0=A0=A0=A0loff_t pos =3D pos_low | (loff_t)pos_high << 32;
> > =A0 =A0 =A0 =A0 [ ... ]
> >=20
>=20
> Sadly this isn't possible without a wrapper unless you can guarantee
> it was passed low high instead of high low. Unless you munge it in
> userspace, you can't.
>=20

Exactly, we have to munge it in userspace anyway because of the
argument ordering requirement we get if we pass it as a single u64.
I vote for the explicit split as well, this will give us a straightforw=
ard
wrapper in user space, unlike the swapped arguments that are just askin=
g
for trouble, and will make it easy to have a common compat_sys_pwritev
function.

	Arnd <><
