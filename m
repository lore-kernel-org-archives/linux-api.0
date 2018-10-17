From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v3 0/3] namei: implement various lookup restriction AT_*
 flags
Date: Thu, 18 Oct 2018 02:23:32 +1100
Message-ID: <20181017152332.madyld45jvhtoog3@ryuk>
References: <20181009070230.12884-1-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yre24zmboslmb52j"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181009070230.12884-1-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Eric Biederman <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, Jann Horn <jannh@google.com>, Christian Brauner <christian@brauner.io>, David Drysdale <drysdale@google.com>, containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, Tycho Andersen <tycho@tycho.ws>, dev@opencontainers.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--yre24zmboslmb52j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2018-10-09, Aleksa Sarai <cyphar@cyphar.com> wrote:
> The need for some sort of control over VFS's path resolution (to avoid
> malicious paths resulting in inadvertent breakouts) has been a very
> long-standing desire of many userspace applications. This patchset is a
> revival of Al Viro's old AT_NO_JUMPS[1,2] patchset (which was a variant
> of David Drysdale's O_BENEATH patchset[3] which was a spin-off of the
> Capsicum project[4]) with a few additions and changes made based on the
> previous discussion within [5] as well as others I felt were useful.

I've been thinking about this problem a little more (from the UX side of
things) and I have a feeling that adding 5 different O_* flags related
to resolution -- rather than properties related to opening the file --
might be less than ideal (even though, as discussed in previous threads,
there is a need for these flags and for them to be separated).

There is *some* precedence for this with O_PATH[**] changing fairly
large semantics of openat(2) but there are some things about O_PATH
which I think could be improved.

What if we had a resolveat(2) which acted like openat(..., O_PATH) *but*
it allowed us to have new flags and to separate the scoping flags from
the (fairly limited) space of O_* flags. Then O_PATH could effectively
just be a legacy way of doing resolveat(2) -- with only O_CLOEXEC,
O_DIRECTORY, and O_NOFOLLOW support.

And the main things we could add would be:

  * These resolution flags, with only support available from
	resolveat(2) for the moment. The idea would be that AT_EMPTY_PATH
	would be the recommended way to make use of this.

  * Support for RESOLVE_{NOPERM,RDONLY,WRONLY,RDWR} (which after some
	discussions with Eric last year might be necessary in order to make
	/proc/$pid/fd/$fd re-opening of O_PATH descriptors safer -- which is
	something that we use in both runc and LXC).

Is this idea palatable, or was this something considered during the
development of O_PATH and someone had an argument why augmenting O_PATH
is better than a new syscall?

[**] And while writing this paragraph I noticed that I didn't update the
     O_PATH "flag whitelist" to allow the scoping flags to affect it. I
	 will include a fix for this in v4 (I must've lost it in an early
	 rebase before I sent v1).

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--yre24zmboslmb52j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEXzbGxhtUYBJKdfWmnhiqJn3bjbQFAlvHU/EACgkQnhiqJn3b
jbQ9yg/7BtjjNaT0TCHf7tBBGch6f70YhcTrfpJBxLByOep4fb/HsSXTMhcy6cCI
ZzmSMXyuNOhlxdg7b1ON5+rLJY0MDmsVzaLhCKCg0erstdTSESUdt7yqnAz5qPw6
+Sag25hC7wXl8U2/Wem/JK9JZXEAcCfUiadac8MF7tWluy/Ivf/mWhsvkmCN00UY
TfSVlb7t83PwGEpTEzdbZ6IkwdEIky44vYJl/Phbau/01A8tM51f74KiDlos/+XH
eMkzU9MYdhG7bsmEh+erBGCuiFevJ+ffAerjerwhqKOCi6KAEbiQJSqxlbRX2rmT
7azLPL6IiJjH47NfnXIo1gTgXKJYp8up7esQpj/lbcP7ZraxEveBQpvTxvGHEdUM
+7CzFxDIVbljZD6kRgvTM/iY5KXHFVcCsg+7NhRbfQoqViJeLL8hRshtqki2+zbX
3fSmkKYIRzkMirrePpT0VVLJw7mkVQfPVAyyn4ZixM+ECzkLSTnwaac33IVvLH6z
86Tf9yBPnpeH7A0MaCUs0EfTSV6hnSV9Wc2RYK+C5bTnBHUUCmO0gN6WIFSHtNAI
BynbcTmD3YACuFxa4hB/h/zqsjrKaSi8g6gVq21+Q10w3iMM93rAZwjaMTGjS1A3
AScZfEJi459Ez/xq7+rwThMW5BD66aX/txL95J+bV8B55V7uvX0=
=06RI
-----END PGP SIGNATURE-----

--yre24zmboslmb52j--
