From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v12 10/12] namei: aggressively check for nd->root escape
 on ".." resolution
Date: Thu, 5 Sep 2019 07:48:56 +1000
Message-ID: <20190904214856.vnvom7h5xontvngq@yavin.dot.cyphar.com>
References: <20190904201933.10736-1-cyphar@cyphar.com>
 <20190904201933.10736-11-cyphar@cyphar.com>
 <CAHk-=wiod1rQMU+6Zew=cLE8uX4tUdf42bM5eKngMnNVS2My7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="i46h7izteerqaavi"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wiod1rQMU+6Zew=cLE8uX4tUdf42bM5eKngMnNVS2My7g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Rasmus
List-Id: linux-api@vger.kernel.org


--i46h7izteerqaavi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-09-04, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Wed, Sep 4, 2019 at 1:23 PM Aleksa Sarai <cyphar@cyphar.com> wrote:
> > This patch allows for LOOKUP_BENEATH and LOOKUP_IN_ROOT to safely permit
> > ".." resolution (in the case of LOOKUP_BENEATH the resolution will still
> > fail if ".." resolution would resolve a path outside of the root --
> > while LOOKUP_IN_ROOT will chroot(2)-style scope it). Magic-link jumps
> > are still disallowed entirely because now they could result in
> > inconsistent behaviour if resolution encounters a subsequent ".."[*].
>=20
> This is the only patch in the series that makes me go "umm".
>=20
> Why is it ok to re-initialize m_seq, which is used by other things
> too? I think it's because we're out of RCU lookup, but there's no
> comment about it, and it looks iffy to me. I'd rather have a separate
> sequence count that doesn't have two users with different lifetime
> rules.

Yeah, the reasoning was that it's because we're out of RCU lookup and if
we didn't re-grab ->m_seq we'd hit path_is_under() on every subsequent
".." (even though we've checked that it's safe). But yes, I should've
used a different field to avoid confusion (and stop it looking
unnecessarily dodgy). I will fix that.

> But even apart from that, I think from a "patch continuity" standpoint
> it would be better to introduce the sequence counts as just an error
> condition first - iow, not have the "path_is_under()" check, but just
> return -EXDEV if the sequence number doesn't match.

Ack, will do.

> So you'd have three stages:
>=20
>  1) ".." always returns -EXDEV
>=20
>  2) ".." returns -EXDEV if there was a concurrent rename/mount
>=20
>  3) ".." returns -EXDEV if there was a concurrent rename/mount and we
> reset the sequence numbers and check if you escaped.
>=20
> becasue the sequence number reset really does make me go "hmm", plus I
> get this nagging little feeling in the back of my head that you can
> cause nasty O(n^2) lookup cost behavior with deep paths, lots of "..",
> and repeated path_is_under() calls.

The reason for doing the concurrent-{rename,mount} checks was to try to
avoid the O(n^2) in most cases, but you're right that if you have an
attacker that is spamming renames (or you're on a box with a lot of
renames and/or mounts going on *anywhere*) you will hit an O(n^2) here
(more pedantically, O(m*n) but who's counting?).

Unfortunately, I'm not sure what the best solution would be for this
one. If -EAGAIN retries are on the table, we could limit how many times
we're willing to do path_is_under() and then just return -EAGAIN.

> So (1) sounds safe. (2) sounds simple. And (3) is where I think subtle
> things start happening.
>=20
> Also, I'm not 100% convinced that (3) is needed at all. I think the
> retry could be done in user space instead, which needs to have a
> fallback anyway. Yes? No?

Hinting to userspace to do a retry (with -EAGAIN as you mention in your
other mail) wouldn't be a bad thing at all, though you'd almost
certainly get quite a few spurious -EAGAINs -- &{mount,rename}_lock are
global for the entire machine, after all.

But if the only significant roadblock is that (3) seems a bit too hairy,
I would be quite happy with landing (2) as a first step (with -EAGAIN).

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--i46h7izteerqaavi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXXAxQwAKCRCdlLljIbnQ
Er4vAQDiHBfZXElf8shcA4ixj+Uqqylcy09QYhCXLxI7/JHdiQD9GI/Ehs0C3HPA
8HQsyqVEjkx8dq5gApLNG5Rp8gVgywQ=
=Il7T
-----END PGP SIGNATURE-----

--i46h7izteerqaavi--
