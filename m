From: James Hogan <james.hogan@imgtec.com>
Subject: Re: [PATCH 03/20] asm-generic: Drop getrlimit and setrlimit syscalls
 from default list
Date: Mon, 19 Jun 2017 23:10:23 +0100
Message-ID: <20170619221023.GT6973@jhogan-linux.le.imgtec.org>
References: <20170619155003.13218-1-ynorov@caviumnetworks.com>
 <20170619155003.13218-4-ynorov@caviumnetworks.com>
 <20170619214223.GS6973@jhogan-linux.le.imgtec.org>
 <CAK8P3a0M2TkoUY4KBgmtnh3NDNj-oSNOpVagHVFuFBEYnAYp8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6848265903696521177=="
Return-path: <linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAK8P3a0M2TkoUY4KBgmtnh3NDNj-oSNOpVagHVFuFBEYnAYp8Q@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-snps-arc/>
List-Post: <mailto:linux-snps-arc@lists.infradead.org>
List-Help: <mailto:linux-snps-arc-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=subscribe>
Sender: "linux-snps-arc" <linux-snps-arc-bounces@lists.infradead.org>
Errors-To: linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-doc@vger.kernel.org, szabolcs.nagy@arm.com, Catalin Marinas <catalin.marinas@arm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, David Howells <dhowells@redhat.com>, Chris Metcalf <cmetcalf@ezchip.com>, Yury Norov <ynorov@caviumnetworks.com>, linux@lists.openrisc.net, linux-hexagon@vger.kernel.org, Philipp Tomsich <philipp.tomsich@theobroma-systems.com>, Joseph Myers <joseph@codesourcery.com>, linux-arch <linux-arch@vger.kernel.org>, Chen Liqin <liqin.linux@gmail.com>, zhouchengming1@huawei.com, Guan Xuetao <gxt@mprc.pku.edu.cn>, Steve Ellcey <sellcey@caviumnetworks.com>, linux-c6x-dev@linux-c6x.org, Yoshinori Sato <ysato@users.sourceforge.jp>, Prasun Kapoor <Prasun.Kapoor@caviumnetworks.com>, Andreas Schwab <schwab@suse.de>, Aurelien Jacquiot <a-jacquiot@ti.com>, Alexander Graf <agraf@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Lennox Wu <lennox.wu@gm>
List-Id: linux-api@vger.kernel.org

--===============6848265903696521177==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="eWt5Jy3V6IQl161k"
Content-Disposition: inline

--eWt5Jy3V6IQl161k
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 19, 2017 at 11:58:41PM +0200, Arnd Bergmann wrote:
> On Mon, Jun 19, 2017 at 11:42 PM, James Hogan <james.hogan@imgtec.com> wr=
ote:
> > On Mon, Jun 19, 2017 at 06:49:46PM +0300, Yury Norov wrote:
> > Subject: [PATCH] Deprecate stat syscalls superseded by statx
> >
> > Various stat system calls can now be implemented as userland wrappers
> > around the new statx system call, so allow them to be removed from the
> > kernel by default for new architectures / ABIs.
> >
> > This involves adding __ARCH_WANT_SYSCALL_UNXSTAT to each existing
> > architecture, which enables the relevant stat system calls in the
> > generic system call list (if used). It also conditionally defines the
> > syscalls in fs/stat.c and struct stat / struct stat64 in
> > asm-generic/stat.h.
> >
> > Signed-off-by: James Hogan <james.hogan@imgtec.com>
> > Cc: David Howells <dhowells@redhat.com>
> > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: linux-fsdevel@vger.kernel.org
> > Cc: linux-arch@vger.kernel.org
> > Cc: linux-api@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
>=20
> Good idea:
>=20
> Acked-by:  Arnd Bergmann <arnd@arndb.de>

Thanks,

>=20
> > +/* statx deprecates the un-extended stat syscalls which use struct sta=
t[64] */
> > +#ifdef __ARCH_WANT_SYSCALL_UNXSTAT
>=20
> I'm glad you explain what 'UNXSTAT' means here, since I would not
> have otherwise guessed it, but I also can't think of anything more
> intuitive.

Yeh, I renamed that several times while playing around with this :-).

The stat syscalls remind me a bit of the Vicar of Dibley episode where
the new road named "New Road" necessitates the renaming of the existing
"New Road" to "Quite Old Road" and "Quite Old Road" to "Really Quite Old
Road" and "Old Road" to "Very Old Road"!

Cheers
James

--eWt5Jy3V6IQl161k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEd80NauSabkiESfLYbAtpk944dnoFAllIS84ACgkQbAtpk944
dnqZlhAAtMuoU23vBZbvRvMNdXP3Oux702bAgsOGng8K4deeTLcQz6yud+2/ctc6
+848RuWv7Oy3g3s7cnXEqYjZ/R3iyBJPHvAhDwaXNzcFwGFjFXI9TDFGDFFLR5P9
DGjOT4Uqz+UJhzuqVkGXZm+6t9Ym4XFUF8lPbo/XqVXZZkXSvXEPpUqMVd+HXqhA
LHUplz22w62cv8+/TPfefypRQNn38lNbd2gYpdq8RSQk27A7EzRc61h8edFdV9lk
c7M3im3w420wub9faRqM34W04GXupOB8oPDdVyLifuug6cyY/g4lD3EmUR098cNh
oobgw3TMXZyrRi4n5CA2p5Q8AI9/1Ntl6R0tNSM728GLrKPIS3PjlF+2ZUL79srT
zwb3mmUVQGMy0Sko7bu/7rOfGRjiLEMEdAMYPgdKVHMVCZr80YGrP2bHRGcgq9NV
9SsMzxBrWZrrp5E0AJbn3747wez4enzYNgygxi0CFUmwNqBojNa6XfB6trvgWcCg
I6YTi8NB67YiC562J/8rBTpADbyPb9jZN0BkfvrcPdbxD+ELIw0b7558IBVAqvQ5
i0Vz4tGmhsFFZ4armvFs1rbPR1DoOJCng/ZiqTDWZ0rlsovYd29KF85rT1+VJ95L
rQ8y9uklKghmcwth8sH5Gmxypt9Buy5W5H0qu12cV0fSOXKC5iQ=
=+7Vk
-----END PGP SIGNATURE-----

--eWt5Jy3V6IQl161k--


--===============6848265903696521177==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-snps-arc mailing list
linux-snps-arc@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-snps-arc
--===============6848265903696521177==--
