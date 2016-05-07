From: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Subject: Re: [PATCH 1/1] simplified security.nscapability xattr
Date: Sun, 8 May 2016 01:10:12 +0200
Message-ID: <20160507231012.GA11076@pc.thejh.net>
References: <1461345993-17526-1-git-send-email-serge.hallyn@ubuntu.com>
	<1461345993-17526-2-git-send-email-serge.hallyn@ubuntu.com>
	<CAGXu5jKFNQs8oxq+yD6_Q8HcNyf+GouSHFzkxT9u9BkK=ZLQ7Q@mail.gmail.com>
	<20160426222627.GA19307@mail.hallyn.com>
	<CAGXu5jJbmSKst_RiM84-7OaX=2XettzpTh34uFFoevvoPRO76Q@mail.gmail.com>
	<20160502035452.GA31837@mail.hallyn.com>
	<87h9egp2oq.fsf@x220.int.ebiederm.org>
	<CALQRfL7mfpyudWs4Z8W5Zi8CTG-9O0OvrCnRU7pk0MXtsLBd0A@mail.gmail.com>
	<20160503051921.GA31551@mail.hallyn.com>
	<87bn4nhejj.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7338456091538793204=="
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87bn4nhejj.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--===============7338456091538793204==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 03, 2016 at 12:54:40AM -0500, Eric W. Biederman wrote:
> "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:
>=20
> > Quoting Andrew G. Morgan (morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
> >>=20
> >> I guess I'm confused how we have strayed so far that this isn't an obv=
ious
> >> requirement. Uid=3D0 as being the root of privilege was the basic prob=
lem
> >> that capabilities were designed to change.
> >
> > The task executing the file can be any uid mapped into the namespace.  =
The
> > file only has to be owned by the root of the user_ns.  Which I agree is
> > unfortunate.  We can work around it by putting the root uid into the xa=
ttr
> > itself (which still isn't orthogonal but allows the file to at least by
> > owned by non-root), but the problem then is that a task needs to know i=
ts
> > global root k_uid just to write the xattr.
>=20
> The root kuid is just make_kuids(user_ns, 0) so it is easy to find.
>=20
> It might be a hair better to use the userns->owner instead of the root
> uid.  That would allow user namespaces without a mapped root to still
> use file capabilities.

Please don't do that. A user might want to create multiple containers with
isolated security properties, and in that case, it would be bad if binaries
that are capable in one container are also automatically valid in the user's
other containers.
Also, this would mean that in an owner!=3Droot scenario, container root can=
't
setcap executables and needs to ask the administrator of the surrounding sy=
stem
to do it.
(Of course, this could be worked around using a dummy userns layer between =
the
init ns and the container, but I don't like seeing new reasons for such a h=
ack.)

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXLnXUAAoJED4KNFJOeCOo68MP/ipr/RvktHG1aRne99x1Urqc
0fkutryX8S7ZBBF/rYlhjc9Mw/cSQNQ4h04SXXyKcenH1Iqx/gFZ7pwPyGLZABU/
gmGGY6325LjTcWFuu/QwoQcMGxvtA7qmhFr/okSzNlP8zygxWNbMqX31GToxQJA3
1LFSLehtzXtrEzH6eOX7Lb62kK9HodYbwywP2NYrQfgDFhsrR13h91TwsCmMPG1W
dBqjq+R81tey66KN42fTOpgRlC6l8m0BEsTW5fgFnM/Qi6q1szprUpZYjiAg7BnM
VaoTqCOPw84BaGHbG5LAi3X4vYjZzxDx1jqHjTnzMf0hWlJFhg6NuR6pcQk4tBfA
BIjGZPYGD1IFsu6mt/OY++YxCbZCewiFdtrUSsW4EgpLEJ/d2FpYbYrI0CoVB+/w
zHY8f5l2pgFwGm7Fy/d5gDop7KGjWotxrbPsDAhpRMgssrJU5Jl7Ysvacxwrx7TI
Votx/g3chYKxSlLXucFMQd34sS6sSiH5qVB3MuDERnLMOJpNSIMBAB+5zGhvHc1O
Wn77P8ToP3N4EiwXio1OOzg3XR7HkNLIdoixc8b+XfiFO9EAW59CTVA8rmnnKcl7
337MiZ2m4b3d9brDDSY2w4tw7LjJMrER9q7px/t4xyLQzx60EOeflm2WwSeyYKw5
7Jwu/qjCc+NnsKUAMCiP
=p1ko
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--

--===============7338456091538793204==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Containers mailing list
Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
https://lists.linuxfoundation.org/mailman/listinfo/containers
--===============7338456091538793204==--
