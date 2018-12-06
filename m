From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v4] signal: add taskfd_send_signal() syscall
Date: Fri, 7 Dec 2018 01:27:57 +1100
Message-ID: <20181206142757.4gon5afqd7uphyqk@yavin>
References: <20181206121858.12215-1-christian@brauner.io>
 <87h8fq7s84.fsf@oldenburg2.str.redhat.com>
 <b0e946bcac12358841c9a99017da819b00794d9c.camel@bitron.ch>
 <87pnue6bp2.fsf@oldenburg2.str.redhat.com>
 <87efaun587.fsf@xmission.com>
 <877egm6a7v.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lfqpejtbalk45dmv"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <877egm6a7v.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, =?utf-8?B?SsO8cmc=?= Billeter <j@bitron.ch>, Christian Brauner <christian@brauner.io>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, luto@kernel.org, arnd@arndb.de, serge@hallyn.com, jannh@google.com, akpm@linux-foundation.org, oleg@redhat.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, keescook@chromium.org, tglx@linutronix.de, x86@kernel.org
List-Id: linux-api@vger.kernel.org


--lfqpejtbalk45dmv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2018-12-06, Florian Weimer <fweimer@redhat.com> wrote:
> > Floriam are you seeing a problem with this behavior or the way Christian
> > was describing it?
>=20
> My hope is that you could use taskfd_send_signal one day to send a
> signal to a process which you *known* (based on how you've written your
> application) should be running and not in a zombie state, and get back
> an error if it has exited.

You can detect if a process is a zombie via the procfd by observing "stat"
(the state will be "Z"). Personally I'm with Christian that we should
maintain compatibility with the rest of the signal APIs -- sending a
signal to a zombie is a defined (though no-op) concept.

I don't understand why sending a signal should fail in this case -- a
zombie is not the same as a non-existent process. If we need to have a
way of checking whether something is a zombie (other than through
"stat") we can add another method (or flag if it has to be atomic) in
the future. And given the complexity of doing it, I'm even less of a
fan of doing it in the initial patchset.

> If you get this error, only then you wait on the process, using the file
> descriptor you have, and run some recovery code.
>=20
> Wouldn't that be a reasonable approach once we've got task descriptors?

I think taskfd_wait() is something we'll need eventually, but I don't
think that making taskfd_send_signal() do something that is contrary to
existing kill(2) interfaces (making it so that transitioning to it won't
be seamless),=20

What would the error be? ESRCH would be _very_ wrong, given that it
would confuse the two states (zombie/dead-for-real) and would lead to
weird cases where fstatat(taskfd) succeeds but taskfd_send_signal(2)
fails.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--lfqpejtbalk45dmv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb6Gz4/mhjNy+aiz1Snvnv3Dem58FAlwJMe0ACgkQSnvnv3De
m5+6LQ/9GHVZuwPuP7m7j4zUzFp6qTNTWTbcM9P2/LEc0HwfgEL2UnsBDjOOZTpD
DYJjmeQkO5bfwGoccamM39pKEWmETFOC63dY9wd6faZNtvbNy4p87HRC834/SBfB
0rPgUNO+G9667tdm/0O3wIYoVO9fRmK+52rP+oo4kvKh+0DZr4j8UB3KbTmz7CTN
9g6b5UslN6ukxPs/g5l8Ma2udEuxxfwiWRly0Gg9Cv+Vtm4or0lcQDV0eBTl0Ly5
5/Cgq4sTwNXmiSvECT+1P2mwAu8uNSoqxzzR+IWyN0a1tX4JLGbRuDYRWmflMnGw
no/SYlj3ekza7rJ7SxBrWqbyTFduq2ZGyt8S7AHKPaeSPjIuS3jmBQOqU80ngGrh
5+L+AbCqa5S+HZWpoOAPxhkFPJFCN+ulgK9Da6b253C9MkA93I94NOWod6Ao9MwR
DJmXWwfgcjZ7YykC9To6Oke/wyUQzy06YI8Ne0uAT2iUFjfuE4CMSTars0KbqL7i
991HXFzi7VpgNXA52JnyX1XMwxJVa1Muq2xHNRQW/HyOAGp68ZedJezWJsuKQxyf
R22dqRnfjEYMePVn9eQdjyCy6qrpjDa/hem5T4xF/cCw9Km4pAijYMbzK0g2M/ol
Y1VmNRBXsw8Y1xTqpj79sUbgI2GPHzvFQ37Y4ec7NbAEpZMSfFs=
=KvNk
-----END PGP SIGNATURE-----

--lfqpejtbalk45dmv--
