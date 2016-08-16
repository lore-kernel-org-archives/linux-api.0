From: Jann Horn <jann@thejh.net>
Subject: Re: [PACTH v3 1/3] mm, proc: Implement /proc/<pid>/totmaps
Date: Tue, 16 Aug 2016 20:18:40 +0200
Message-ID: <20160816181840.GB7298@pc.thejh.net>
References: <1471368856-11455-1-git-send-email-robert.foss@collabora.com>
 <1471368856-11455-2-git-send-email-robert.foss@collabora.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rJwd6BRFiFCcLxzm"
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1471368856-11455-2-git-send-email-robert.foss@collabora.com>
Sender: linux-doc-owner@vger.kernel.org
To: robert.foss@collabora.com
Cc: corbet@lwn.net, akpm@linux-foundation.org, vbabka@suse.cz, mhocko@suse.com, koct9i@gmail.com, hughd@google.com, n-horiguchi@ah.jp.nec.com, john.stultz@linaro.org, minchan@kernel.org, ross.zwisler@linux.intel.com, jmarchan@redhat.com, hannes@cmpxchg.org, mingo@kernel.org, keescook@chromium.org, viro@zeniv.linux.org.uk, gorcunov@openvz.org, sonnyrao@chromium.org, plaguedbypenguins@gmail.com, eric.engestrom@imgtec.com, rientjes@google.com, jdanis@google.com, calvinowens@fb.com, adobriyan@gmail.com, kirill.shutemov@linux.intel.com, ldufour@linux.vnet.ibm.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Ben Zhang <benzh@chromium.org>, Bryan Freed <bfreed@chromium.org>, Filipe Brandenburger <filbranden@chromium.org>, Mateusz Guzik <mguzik@redhat.com>, Michal Hocko <mhocko@kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--rJwd6BRFiFCcLxzm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 16, 2016 at 01:34:14PM -0400, robert.foss@collabora.com wrote:
> From: Robert Foss <robert.foss@collabora.com>
>=20
> This is based on earlier work by Thiago Goncales. It implements a new
> per process proc file which summarizes the contents of the smaps file
> but doesn't display any addresses.  It gives more detailed information
> than statm like the PSS (proprotional set size).  It differs from the
> original implementation in that it doesn't use the full blown set of
> seq operations, uses a different termination condition, and doesn't
> displayed "Locked" as that was broken on the original implemenation.
>=20
> This new proc file provides information faster than parsing the potential=
ly
> huge smaps file.
>=20
> Tested-by: Robert Foss <robert.foss@collabora.com>
> Signed-off-by: Robert Foss <robert.foss@collabora.com>
>=20
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> ---
[...]
> +static int totmaps_open(struct inode *inode, struct file *file)
> +{
> +	struct proc_maps_private *priv =3D NULL;
> +	struct seq_file *seq;
> +	int ret;
> +
> +	ret =3D do_maps_open(inode, file, &proc_totmaps_op);
> +	if (ret)
> +		goto error;
> +
> +	/*
> +	 * We need to grab references to the task_struct
> +	 * at open time, because there's a potential information
> +	 * leak where the totmaps file is opened and held open
> +	 * while the underlying pid to task mapping changes
> +	 * underneath it
> +	 */
> +	seq =3D file->private_data;
> +	priv =3D seq->private;
> +	priv->task =3D get_proc_task(inode);
> +	if (!priv->task) {
> +		ret =3D -ESRCH;
> +		goto error;

I see that you removed the proc_map_release() call for the upper
error case as I recommended. However, for the second error case,
you do have to call it because do_maps_open() succeeded.

You could fix this by turning the first "goto error;" into
"return;" and adding the proc_map_release() call back in after
the "error:" label. This would be fine - if an error branch just
needs to return an error code, it's okay to do so directly
without jumping to an error label.

Alternatively, you could add a second label
in front of the existing "error:" label, jump to the new label
for the second error case, and call proc_map_release() between
the new label and the old one.


> +	}
> +
> +	return 0;
> +
> +error:
> +	return ret;
> +}
> +
[...]
> +const struct file_operations proc_totmaps_operations =3D {
> +	.open		=3D totmaps_open,
> +	.read		=3D seq_read,
> +	.llseek		=3D seq_lseek,
> +	.release	=3D proc_map_release,
> +};

As I said regarding v2 already:
This won't release priv->task, causing a memory leak (exploitable
through a reference counter overflow of the task_struct usage
counter).

--rJwd6BRFiFCcLxzm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXs1kAAAoJED4KNFJOeCOoMh8P/iv1Lq0JD6LhVrZnHR3b+mce
B8hDCqgiGycyUokzD0lyj0uMyu3OGytgTaZgMyBTlIY4YJOMmy/adQd5mh8tJnMO
6sTbfxOq2DvYmzr3C6MYfakQJytr5u4q+jFX+LMvPN491tHsudNFcomWcLBZFaOx
wKg5ksSIeRaZj0Xba5N+nbs4h5OTHXE3NYf9gDCj0hYN4hIwGIbBtIwkmZpy5W4O
9YeqAoJtci3Vi/xqjNCeSIq9dUNhBgzFFEGrMEqOUaLTgeTnNXmO1b9n/z3Odho+
qkJX13hSTVpxa4QkC1EIBn4KO54q+AmgotwEUZeIKkaEaHJ4MV41xckIBTNyO5fT
xqGJ02J7g60A13MJjXeDz07IaD996VzPqtoZixZXHh8CcanSWGj9PtLvfmSg+qHa
YzbvOAHHiQr5mVjuWhlIWr7TeMUS1PqZVjdnXiK0sufiCs3FafCKJej46Jx1/FZE
HAoO/DDbHBwpFd6eNLeMcrJ5Kb5LnqBBaExz2H4UoxkukuwgzyQ3dOL80uK5FcAY
fW/eReD48qF7IrFn4baX1C1ZtBILWAkbId6HGKK6itumWSYdpyLT7nJ0S6Bky7Bv
efGqQMR2lfBHcDLMKkzzvkSIObxmhFHW0HQihItHwgB/S0xYqMyVD7HjSkk6f4eO
jrtYMJ1N9zV9IngnVwwL
=K/wH
-----END PGP SIGNATURE-----

--rJwd6BRFiFCcLxzm--
