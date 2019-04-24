From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH RESEND v5 0/5] namei: vfs flags to restrict path
 resolution
Date: Thu, 25 Apr 2019 01:38:06 +1000
Message-ID: <20190424153806.64qkkmkudzodxnz2@yavin>
References: <20190320143717.2523-1-cyphar@cyphar.com>
 <CALCETrV-Q4qZXGeavBPQbF6-VVz7hqvjRkbhFeYmbGiQgu5Omg@mail.gmail.com>
 <20190325130429.dbrgjxnvq3w5cpb3@yavin>
 <CAGXu5jKPrarixQkWWXOBCu6kRRpQd0aaJsPJbvsAyh0Wvc620A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gwuxm2y5lqyvv4zh"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jKPrarixQkWWXOBCu6kRRpQd0aaJsPJbvsAyh0Wvc620A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Jann Horn <jannh@google.com>, Christian Brauner <christian@brauner.io>, David Drysdale <drysdale@google.com>, Tycho Andersen <tycho@tycho.ws>, Linux Containers <containers@lists.linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, Linus Torvalds <torvalds@linux-fo>
List-Id: linux-api@vger.kernel.org


--gwuxm2y5lqyvv4zh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-04-23, Kees Cook <keescook@chromium.org> wrote:
> On Mon, Mar 25, 2019 at 6:05 AM Aleksa Sarai <cyphar@cyphar.com> wrote:
> > On 2019-03-21, Andy Lutomirski <luto@kernel.org> wrote:
> > > On Wed, Mar 20, 2019 at 7:38 AM Aleksa Sarai <cyphar@cyphar.com> wrot=
e:
> > > > Now that the holiday break is over, it's time to re-send this patch
> > > > series (with a few additions, due to new information we got from
> > > > CVE-2019-5736 -- which this patchset mostly protected against but h=
ad
> > > > some holes with regards to #!-style scripts).
> > >
> > > I generally like this, but, as Linus pointed out, it will be
> > > unfortunate if application authors see this as just another
> > > non-portable weird Linux API and don't use it.  Would it be worthwhile
> > > to put some thought into making it an API that other OSes might be
> > > willing to implement?  As it stands, the openat(2) flags are getting
> > > rather crazy in this patch set.
>=20
> I think many of the issues are specific to Linux (and Linux containers
> especially), so I'm not sure this should get blocked because we want
> something more portable.

I agree these issues are quite Linux-specific (*especially* the ability
to re-open fds through /proc and the existence of "magic links").

However, I feel there are a few more good reasons for resolveat(2):

 * openat(2) ignores unknown flags, meaning that old kernels will ignore
   new programs trying to use O_THISROOT and might end up causing
   security issues. Yes, it'd be trivial to check whether the new O_*
   flags are supported at start-up, but I think a security feature
   shouldn't have a foot-gun associated with it. In fact, I didn't know
   openat(2) ignored unknown flags until I wrote this patchset -- I
   doubt many other userspace developers do either.

 * resolveat(2) allows for improvement to the O_PATH interface, which I
   think might be necessary (completely separately to this patchset).
   I've been working on a patchset which would make nd_jump_link()
   transitions in trailing_symlink() depend on the mode of the magic
   link being traversed through (this would allow us to block a
   read-only fd being re-opened as a read-write fd or similar such
   nonsense). One aspect of this could be to allow userspace to enable
   certain re-opening operations by passing a "link mode" to
   resolveat(2).

 * I would argue that O_PATH should've been a separate syscall from the
   beginning, given how different its semantics are to other openat(2)
   flags (not to mention how O_PATH is incompatible with and thus
   ignores so many other openat(2) flags).

 * If we end up needing a resolveat(2) for any of the above reasons,
   then we will have wasted quite a few openat(2) flag slots for naught.
   (Then again, there are plenty of flag slots still left.)

All of that aside, what I'd really like to know is what I should do to
get this patchset reviewed and merged. It's been largely radio-silence
for the last few revisions.

A simple resolveat(2) is fairly trivial (I have a version of it lying
around somewhere), but it doesn't make sense to polish it if there's no
chance Al is interested in it.

> This series provides solutions to so many different race and confusion
> issues, I'd really like to see it land. What's the next step here? Is
> this planned to go directly to Linus for v5.2, or is it going to live
> in -mm for a while? I'd really like to see this moving forward.

Given some of the security requirements of this interface, I think
getting it to live in -mm wouldn't be a bad idea so folks can shake the
bugs out before it's depended on by container runtimes.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--gwuxm2y5lqyvv4zh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb6Gz4/mhjNy+aiz1Snvnv3Dem58FAlzAgtoACgkQSnvnv3De
m5+Qng//UgytI5RxPSbDQDbFvQ7hXxQeK7Hj2F//aO1N7wMcdXddaLGl4k2psrcy
8XV3uLPZGMGIk5O73Ll1vlvikJo6epmauB2Uft0ZmlsseL8lz3cOxnUmrr2DBlAZ
2amB5VzXSLHjwrr351CKUXnOisEIy9aWlhWqb+hjS5MObaVb2GLqrv1sf8pIcd9k
fmUwbDYEAhjLLan+WZnaI1OzE5xf/kvCvb2J4XL0nXK5jbcCravxrvTdt/jGh+Bk
erdQ8n5XdhpQ8bGFKaxQavKkIqmwWf70d7HV4K/pTyWqmE4zdc+F29ZvM4a2XAHa
cRovUeJY26ZD9yuhWLqaswBCM+AkAYQ4E5k6CbRMpYQyJM9i4B5j/s8ZMeyqHknJ
IvFN2hWLesU96bQYM8aUxdx8yM5v71fAKwk1O5pAc1QIiDOja3ua8wfSOiyBvKP1
QXm6wfyqbzj7qBpQ11Gh2cvFKrbq2OLGN59sbM/DHAs8PfhaDvtJstzL7xJ8zaWE
B+GJorQxpHXP8HIKu+XbE5yezapmBKhcRTJcjaQDBjuzMxk7hUS+4J0+mOBL9cAz
b885AoiI2QkdaO2bNEmRHj/jHj9Tdbmin91UPFXOMCUqcbDegpYYKb0to9hRX+g3
IFC9pwuXt7hxEqNbVr8XT73fzA+/eJx7ngaoZU107fUNR0sr8xU=
=23Y4
-----END PGP SIGNATURE-----

--gwuxm2y5lqyvv4zh--
