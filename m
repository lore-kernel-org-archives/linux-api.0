From: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Subject: Re: [PATCH 1/3] proc: Stop reporting eip and esp in /proc/PID/stat
Date: Sat, 1 Oct 2016 12:37:28 +0200
Message-ID: <20161001103728.GM14666@pc.thejh.net>
References: <cover.1475257877.git.luto@kernel.org>
 <a5fed4c3f4e33ed25d4bb03567e329bc5a712bcc.1475257877.git.luto@kernel.org>
 <20160930185642.GH14666@pc.thejh.net>
 <CALCETrUBmsoUK5Shkjwo6n=BGaHFtZhhUZ=2uOcAzWUend-BXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="NqSa+Xr3J/G6Hhls"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUBmsoUK5Shkjwo6n=BGaHFtZhhUZ=2uOcAzWUend-BXg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--NqSa+Xr3J/G6Hhls
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 30, 2016 at 07:01:13PM -0700, Andy Lutomirski wrote:
> On an unrelated note, can we please lock down all the silly historical
> *userspace* info leaks in /proc?  Nasty ones include: net, cmdline (at
> the very least, only argv[0] should be visible if the reader lacks
> ptrace access).
>=20
> Less nasty ones include: limits, sched, autogroup, comm, wchan,
> schedstat, cpuset, cgroup, oom_*, sessionid, coredump_filter

If that doesn't break stuff, I'm very much in favor of it.


> uid_map, gid_map, etc are just screwed up.  They should be per
> *namespace* somewhere, and they should require creds on the namespace.

What do you have in mind? Something like
/proc/namespaces/user:123456/{uid_map,gid_map,setgroups,parent_ns},
with jumped fake symlinks to the directory and its entries in /proc/$pid/?


> timerslack is totally fscked up -- it allows ugo to write and it
> checks the wrong creds.  Jann, does your series fix that?

Nope. Never noticed that thing so far, probably because it was only
added a few months ago. :/ Will add it to my series.

--NqSa+Xr3J/G6Hhls
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX75HoAAoJED4KNFJOeCOo9w4QALI01llvm7z4+10o7W4F4cwV
Go/YhaG6b8Jaw8eFzy46ywCpTC64mgr6Our69zF6pBc2eK60osaaQWSVgObO9tem
unFWIbQUlraRjyAGbyawfC/VEsHmwPl7CyG3eZNjy63vRndat7LJwrG42D1Au8Md
dMAX2MzklZ2gP4s1h7WoS6nai1ARS1U9eBC6AHDza4VGWe2JoNuU5iPKkJOfnmc7
fkpWX6AaWEFMsexJ779EyA1/9hv5ibr37PQTs0jKsdrUgm84HyPkfSQlU6i9XLZe
+TTrw3vutfCqR7ID3A3/L+6s5rg6FputSKOkclo11S6HL3f31GkghldhgJmzVu4U
Fhl+x2905f/Fz/C4Zr1ERRHLRYlrOuPhhEQEcCqfG7JPzX5w6NnDvCj5y6wgAwBH
kiuoa8ETNgOZrWf0xyFFamuuwnP16Qv1m2u51ZpKl/JCIc+uiJd4N+RguC6iuAv0
4cd2OVkCHfMGmDoiyWZo8ORIEZ+6yupPafviAcyjZrtyj/NiKIq+/FuluuOd4Mbh
SDnRRzAL56vqptcYx/9++M6j1cqSwWVNZ3ce/B1qJrZQm+Ug7iiQTNWzNJhKeaMR
wDyz7ZinsWdXRk9xWlJweNr0ouXCNDFQRTzZJvb5JnG4GfADVkzpClvEH1fmjnfZ
ecbMMCk/zXhcFTr0VevN
=4vyQ
-----END PGP SIGNATURE-----

--NqSa+Xr3J/G6Hhls--
