From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: [PATCH v9 08/10] open: openat2(2) syscall
Date: Fri, 19 Jul 2019 05:12:18 +0300
Message-ID: <20190719021218.GB18022@altlinux.org>
References: <20190706145737.5299-1-cyphar@cyphar.com>
 <20190706145737.5299-9-cyphar@cyphar.com>
 <CAK8P3a33rGhPDFfRBAQyLTMG_WoEgX_toDgWR2O7rSwxKsZG+w@mail.gmail.com>
 <20190718161231.xcno272nvqpln3wj@yavin>
 <CAK8P3a3MiYK4bJiA3G_m5H-TpfN5__--b+=szsJBhG7_it+NQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6406167198628696286=="
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAK8P3a3MiYK4bJiA3G_m5H-TpfN5__--b+=szsJBhG7_it+NQg@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-ia64@vger.kernel.org, Linux-sh list <linux-sh@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, sparclinux <sparclinux@vger.kernel.org>, Shuah Khan <shuah@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>, Tycho Andersen <tycho@tycho.ws>, Aleksa Sarai <asarai@suse.de>, Linux ARM <linux-arm-kernel@lists.infradead.org>, linux-mips@vger.kernel.org, linux-xtensa@linux-xtensa.org, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, David Drysdale <drysdale@>
List-Id: linux-api@vger.kernel.org


--===============6406167198628696286==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="XOIedfhf+7KOe/yw"
Content-Disposition: inline


--XOIedfhf+7KOe/yw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 18, 2019 at 11:29:50PM +0200, Arnd Bergmann wrote:
[...]
> 5. you get the same problem with seccomp and strace that
>    clone3() has -- these and others only track the register
>    arguments by default.

Just for the record, this is definitely not the case for strace:
it decodes arrays, structures, netlink messages, and so on by default.


--=20
ldv

--XOIedfhf+7KOe/yw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJdMScCAAoJEAVFT+BVnCUIYvwQANcM+eTRdr/OJd9417suNuao
fK6ZbVTB/aaBGBsln3InsvqjxtiOe72mbflNqDDxwP0oUq2xEEAAdYmkEIRJ5pEn
N2R2uSpSqZFIDhR+lm6eAfA28Suec+rb0A9HwKKGHPpd5YrqWaxWEVfRxnCngswi
BH6aC+g9yXIRMR7ge0KVES+Gd5dU1jU8qfQETkko32Ezsnec88dLUftqKIhKWIDd
VnH8ew6RK6aje6oxhHbvqdJnSFXrMeV6Ws//cp2OLF4A4EKOm7q/Rhf0+yFF5ePQ
awYV/U0TdWkjIU9bQDCNDphS5p25MAv3g6AIXaUAotT3gaWe6WpFMSEKMgmBLph1
PsaazyUgw8nOh9RwDFT9yek4gmPF5x0HWrZsI85fKIsOt1t1wX3CHRQ3JVjYkpTC
d4GxWgiiAgTg8b1wjTUAjiMYqVrtSwx9srn6GA6ej9fopN2j4iWkARDLk//+xHWC
UfqMUw42wEY6PNKhY3YCa1M9joeXUlWSbz65v9ZAZRPCoXvo7eNw8EePrwMBX3QM
3pzUI2Ljakux7pASi/YYLl5Vpl1yHqEEi7ToQchsUfTJD/Geqj6528ht9GqBgaYf
s5a/eS/MD0AnBD7ytiDIfimWqrLJrLCpWLEufV60EOzRBFDxoS5QNOhQYbHVsZbh
ZLQTIMZM09jpTHhYqh4r
=2x2F
-----END PGP SIGNATURE-----

--XOIedfhf+7KOe/yw--


--===============6406167198628696286==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-arm-kernel mailing list
linux-arm-kernel@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

--===============6406167198628696286==--
