From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH v3 1/2] modules:capabilities: automatic module loading
 restriction
Date: Thu, 20 Apr 2017 03:22:22 +0100
Message-ID: <1492654942.31767.21.camel@decadent.org.uk>
References: <1492640420-27345-1-git-send-email-tixxdz@gmail.com>
         <1492640420-27345-2-git-send-email-tixxdz@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-Z4ZLfmn3qns6OKVrRRjb"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1492640420-27345-2-git-send-email-tixxdz@gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Djalal Harouni <tixxdz@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, serge@hallyn.com, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org
Cc: Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, Paul Moore <paul@paul-moore.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Arnaldo Carvalho de Melo <acme@redhat.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Ingo Molnar <mingo@kernel.org>, zendyani@gmail.com, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-api@vger.kernel.org


--=-Z4ZLfmn3qns6OKVrRRjb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-04-20 at 00:20 +0200, Djalal Harouni wrote:
[...]=C2=A0
> +modules_autoload:
> +
> +A sysctl to control if modules auto-load feature is allowed or not.
> +This sysctl complements "modules_disabled" which is for all module
> +operations where this flag applies only to automatic module loading.
> +Automatic module loading happens when programs request a kernel feature
> +that is implemented by an unloaded module, the kernel automatically
> +runs the program pointed by "modprobe" sysctl in order to load the
> +corresponding module.
> +
> +When modules_autoload is set to (0), the default, there are no
> +restrictions.
> +
> +When modules_autoload is set to (1), processes must have CAP_SYS_MODULE
> +to be able to trigger a module auto-load operation, or CAP_NET_ADMIN
> +for modules with a 'netdev-%s' alias.
> +
> +When modules_autoload is set to (2), automatic module loading is
> +disabled for all. Once set, this value can not be changed.

I would expect a parameter 'modules_autoload' to be a boolean, so this
behaviour would be surprising.

What is the point of mode 2?  Why would someone want to set
modules_disabled=3D0 and modules_autoload=3D2?

[...]
> --- a/kernel/module.c
> +++ b/kernel/module.c
[...]
> +static int modules_autoload_privileged_access(const char *name)
> +{
> +	if (capable(CAP_SYS_MODULE))
> +		return 0;
> +	else if (name && strstr(name, "netdev-") && capable(CAP_NET_ADMIN))
[...]

We want a prefix match, so use strncmp() not strstr().

Ben.

--=20
Ben Hutchings
It is easier to change the specification to fit the program than vice
versa.


--=-Z4ZLfmn3qns6OKVrRRjb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAlj4G14ACgkQ57/I7JWG
EQn8VRAAxO2ST8I9U4+RyxT3NnFNaX12gsM8SPRupt3wRmB/wur3t3Xza9QS/QdS
ZGsVJP+Dh7CEg6LzB8oM8LekTcCHHv45S7Gr4AcAUB8urbAQjTzB3mxx7d2+LkBm
XG7KySVhgyOw7rjARnGfFXDTqFVVAW23HBsejmTt2craKH+yd1sS6WV1EQttjO8u
m6vsg/C7aGnVLmQyjTlK+rUbWoMjJBNKaR6VfPgs92Q2oIjfpBQFCrYpx+Df8j/I
uxi8tCGxa5ZDdjUFpn/v/y0qod20M71qWjXLcJAmsQwyTVqp4HKyGA5TCI1BaS5I
D0snnxNLu4/VdQrDw66cMMNPLHeO1aNWrWgHMX7Lx+H/wWWJJGF/hygvnY5NP2PP
PDZucHRGklMxq3MjByk455/NIlmmHqA0MhI5GSOBOf03cq1iAtAHzJHz24Tczu8Z
P/CAJTNz2vODE6xWI2XGbAuBG6k2Pofb4K+p6JA5kGO1d7ikM4JDsTUQv1/QiQJU
fleobtslISJ5V/B+5Gsl4bOv+DLfP5a22eS4RlOXZY56h7n8AfUG3ACvTuJHvMcF
A+FwNrWuvv/znps1QiJHMChTq/Txk8KeXHnUQBbKqfWS47uGYDOHuR/UKpgIjr0a
RzCTyInltnAsz6gQre759HgP1oCTtGYtjIjWGESB8dECb0giFY4=
=8NFu
-----END PGP SIGNATURE-----

--=-Z4ZLfmn3qns6OKVrRRjb--
