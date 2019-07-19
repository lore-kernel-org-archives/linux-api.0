From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: [PATCH v9 08/10] open: openat2(2) syscall
Date: Fri, 19 Jul 2019 04:59:34 +0300
Message-ID: <20190719015933.GA18022@altlinux.org>
References: <20190706145737.5299-1-cyphar@cyphar.com>
 <20190706145737.5299-9-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190706145737.5299-9-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Christian Brauner <christian@brauner.io>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, containers@lists.linux-f
List-Id: linux-api@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 07, 2019 at 12:57:35AM +1000, Aleksa Sarai wrote:
[...]
> +/**
> + * Arguments for how openat2(2) should open the target path. If @extra i=
s zero,
> + * then openat2(2) is identical to openat(2).
> + *
> + * @flags: O_* flags (unknown flags ignored).

What was the rationale for implementing this semantics?
Ignoring unknown flags makes potential extension of this new interface
problematic.  This has bitten us many times already, so ...

> + * @mode: O_CREAT file mode (ignored otherwise).
> + * @upgrade_mask: restrict how the O_PATH may be re-opened (ignored othe=
rwise).
> + * @resolve: RESOLVE_* flags (-EINVAL on unknown flags).

=2E.. could you consider implementing this (-EINVAL on unknown flags) seman=
tics
for @flags as well, please?


--=20
ldv

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJdMSQFAAoJEAVFT+BVnCUIuaAP/3pgUoQA466F6S8jYN6F/icf
oiQHExdeO3ruxRdNl1gi7af0RxQCiprfNIoD7KQyWSnyUyUm0Cdd7PzpEKXuumQi
pN6ZTEO2bQeSs7AjCNpLrTgKcuOo/pZbNN7InAHKLB7k2xKKeBbdaVypgGiAEDjT
JK+4s+8JcJoSg+d69G428QP2qpoHyIZJ5437gYv5rJbL9BRihwwvWF2OQ4TXrd6I
YnyxPFRRZnfiN3HNbNlJjtMgt5g0AisLuahpJaDMq0NaXnBOosDm9jBAhVOX0CSB
LUNByCygXeBKv9VuyrO4KnLXS3ORGfK38SDGqz3kFYy1quNRAGKgOXPnGXfb2xbZ
bRCqyuxkSUOIfLKA6q9jnqO9RoUeOtLglFUT/5JpixTaoxSFN3Y6GlJFcnw+cVm+
oWH4A/IoST68FCfbOMff976O36pakuWbsVGVsdv384OEHfWaf7c10P9EQc3fhgF3
JoeY5ht9R1k8HWNOlCuCeHfTwSyLG3T/TROuZYtz65RdPemuuPSPERr+GzOtO9Fn
+wQmK99JlE3nhoyv5CmtqCmMQWhYZedqjbjs5wIq7tjalerg6TakNMmhzTGz5l8T
i+3EfyMHhEtwq+2YNhdaPEmjfdBzyI3stxtEkURya0BnCgbYsP2mTIP8UbLGDqsY
EJZiRtPRFfVoePwqT8Ux
=zLLc
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
