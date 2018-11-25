From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Add /proc/pid_generation
Date: Sun, 25 Nov 2018 23:55:33 +0100
Message-ID: <20181125225533.GB30242@amd>
References: <20181121201452.77173-1-dancol@google.com>
 <20181121203150.GK3065@bombadil.infradead.org>
 <CAKOZueuCYOsaHZzoz5nNPr8Jb-fEiHTR4MektaJx8vuUXcrKCQ@mail.gmail.com>
 <20181122020633.GN3065@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="TRYliJ5NKNqkz5bu"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181122020633.GN3065@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: Daniel Colascione <dancol@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, Primiano Tucci <primiano@google.com>, Joel Fernandes <joelaf@google.com>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Roman Gushchin <guro@fb.com>, Vlastimil Babka <vbabka@suse.cz>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, Prashant Dhamdhere <pdhamdhe@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, rostedt@goodmis.org, tglx@linutronix.de, mingo@kernel.org, linux@dominikbrodowski.net, pasha.tatashin@oracle.com, jpoimboe@redhat.com, ard.biesheuvel@linaro.org, Michal Hocko <mhocko@suse.com>, David Howells <dhowells>
List-Id: linux-api@vger.kernel.org


--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2018-11-21 18:06:33, Matthew Wilcox wrote:
> On Wed, Nov 21, 2018 at 12:38:20PM -0800, Daniel Colascione wrote:
> > On Wed, Nov 21, 2018 at 12:31 PM Matthew Wilcox <willy@infradead.org> w=
rote:
> > >
> > > On Wed, Nov 21, 2018 at 12:14:44PM -0800, Daniel Colascione wrote:
> > > > This change adds a per-pid-namespace 64-bit generation number,
> > > > incremented on PID rollover, and exposes it via a new proc file
> > > > /proc/pid_generation. By examining this file before and after /proc
> > > > enumeration, user code can detect the potential reuse of a PID and
> > > > restart the task enumeration process, repeating until it gets a
> > > > coherent snapshot.
> > > >
> > > > PID rollover ought to be rare, so in practice, scan repetitions will
> > > > be rare.
> > >
> > > Then why does it need to be 64-bit?
> >=20
> > [Resending because of accidental HTML. I really need to switch to a
> > better email client.]
> >=20
> > Because 64 bits is enough for anyone. :-) A u64 is big enough that
> > we'll never observe an overflow on a running system, and PID
> > namespaces are rare enough that we won't miss the four extra bytes we
> > use by upgrading from a u32.  And after reading about some security
> > problems caused by too-clever handling of 32-bit rollover, I'd rather
> > the code be obviously correct than save a trivial amount of space.
>=20
> I don't think you understand how big 4 billion is.  If it happens once a
> second, it will take 136 years for a 2^32 count to roll over.  How often
> does a PID roll over happen?

Well, the cost of 64-bit vs. 32-bit is really small here... I'd go
with 64bits. If you have 1000 CPUs, rollovers may be faster..

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--TRYliJ5NKNqkz5bu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlv7KGUACgkQMOfwapXb+vKUpACguxRTw5+EBG5s9D4iEpat3sen
udYAnRn+k2NI+lNteoHed7ikYIohN7P4
=pK2+
-----END PGP SIGNATURE-----

--TRYliJ5NKNqkz5bu--
