From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH 3/4] seccomp: Add SECCOMP_USER_NOTIF_FLAG_PIDFD to get
 pidfd on listener trap
Date: Sun, 26 Jan 2020 15:10:09 +1100
Message-ID: <20200126041009.wubw4t5iaypf6bkk@yavin.dot.cyphar.com>
References: <20200124091743.3357-1-sargun@sargun.me>
 <20200124091743.3357-4-sargun@sargun.me>
 <20200124180332.GA4151@cisco>
 <CAMp4zn_WXwxJ6Md4rgFzdAY_xea4TmVDdQc1iJDObEMm5Yc79g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="b547hxjkssbqtln5"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMp4zn_WXwxJ6Md4rgFzdAY_xea4TmVDdQc1iJDObEMm5Yc79g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: Tycho Andersen <tycho@tycho.ws>, LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>
List-Id: linux-api@vger.kernel.org


--b547hxjkssbqtln5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2020-01-24, Sargun Dhillon <sargun@sargun.me> wrote:
> On Fri, Jan 24, 2020 at 10:03 AM Tycho Andersen <tycho@tycho.ws> wrote:
> >
> > On Fri, Jan 24, 2020 at 01:17:42AM -0800, Sargun Dhillon wrote:
> > > Currently, this just opens the group leader of the thread that trigge=
re
> > > the event, as pidfds (currently) are limited to group leaders.
> >
> > I don't love the semantics of this; when they're not limited to thread
> > group leaders any more, we won't be able to change this. Is that work
> > far off?
> >
> > Tycho
>=20
> We would be able to change this in the future if we introduced a flag like
> SECCOMP_USER_NOTIF_FLAG_PIDFD_THREAD which would send a
> pidfd that's for the thread, and not just the group leader. The flag could
> either be XOR with SECCOMP_USER_NOTIF_FLAG_PIDFD, or
> could require both. Alternatively, we can rename
> SECCOMP_USER_NOTIF_FLAG_PIDFD to
> SECCOMP_USER_NOTIF_FLAG_GROUP_LEADER_PIDFD.

Possibly unpopular proposal -- would it make sense to just store the
pidfd_open(2) flags rather than coming up with our own set for
SECCOMP_USER_NOTIF? If/when pidfds are expanded to include non-leaders
there will be a corresponding flag for pidfd_open(2). Something like:

	struct seccomp_notif {
		__u64 id;
		__u32 pid;
		__u32 flags;
		struct seccomp_data data;
		__u64 pidfd_flags; // or __u32 -- not sure what Christian plans
		__u32 pidfd;
		__u32 __padding;
	};

This does mean there'll be an additional flags field, but I think it's a
slightly more consistent way to indicate "SECCOMP_USER_NOTIF_FLAG_PIDFD
implies a pidfd_open(2) on the traced task".

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--b547hxjkssbqtln5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXi0RHgAKCRCdlLljIbnQ
EhRBAP9kCf5WxYqsddLpbde2EDbbHMYUsQFCJzkEKqYgxO8v6gEAodewLdV9xQjY
t35JSLzrhWvvTNnq1B+Vvdyvj9MvDwA=
=bVpa
-----END PGP SIGNATURE-----

--b547hxjkssbqtln5--
