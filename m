From: Jann Horn <jann@thejh.net>
Subject: Re: [PACTH v3 1/3] mm, proc: Implement /proc/<pid>/totmaps
Date: Tue, 16 Aug 2016 20:47:33 +0200
Message-ID: <20160816184733.GA19380@pc.thejh.net>
References: <1471368856-11455-1-git-send-email-robert.foss@collabora.com>
 <1471368856-11455-2-git-send-email-robert.foss@collabora.com>
 <20160816181840.GB7298@pc.thejh.net>
 <f8b3bfc6-dbee-dbd1-482b-cfce2c5766d3@collabora.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f8b3bfc6-dbee-dbd1-482b-cfce2c5766d3@collabora.com>
Sender: linux-doc-owner@vger.kernel.org
To: Robert Foss <robert.foss@collabora.com>
Cc: corbet@lwn.net, akpm@linux-foundation.org, vbabka@suse.cz, mhocko@suse.com, koct9i@gmail.com, hughd@google.com, n-horiguchi@ah.jp.nec.com, john.stultz@linaro.org, minchan@kernel.org, ross.zwisler@linux.intel.com, jmarchan@redhat.com, hannes@cmpxchg.org, mingo@kernel.org, keescook@chromium.org, viro@zeniv.linux.org.uk, gorcunov@openvz.org, sonnyrao@chromium.org, plaguedbypenguins@gmail.com, eric.engestrom@imgtec.com, rientjes@google.com, jdanis@google.com, calvinowens@fb.com, adobriyan@gmail.com, kirill.shutemov@linux.intel.com, ldufour@linux.vnet.ibm.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Ben Zhang <benzh@chromium.org>, Bryan Freed <bfreed@chromium.org>, Filipe Brandenburger <filbranden@chromium.org>, Mateusz Guzik <mguzik@redhat.com>, Michal Hocko <mhocko@kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 16, 2016 at 02:34:15PM -0400, Robert Foss wrote:
> On 2016-08-16 02:18 PM, Jann Horn wrote:
> >On Tue, Aug 16, 2016 at 01:34:14PM -0400, robert.foss@collabora.com wrot=
e:
> >>+	}
> >>+
> >>+	return 0;
> >>+
> >>+error:
> >>+	return ret;
> >>+}
> >>+
> >[...]
> >>+const struct file_operations proc_totmaps_operations =3D {
> >>+	.open		=3D totmaps_open,
> >>+	.read		=3D seq_read,
> >>+	.llseek		=3D seq_lseek,
> >>+	.release	=3D proc_map_release,
> >>+};
> >
> >As I said regarding v2 already:
> >This won't release priv->task, causing a memory leak (exploitable
> >through a reference counter overflow of the task_struct usage
> >counter).
>=20
> Sorry about dropping the ball on that one, what's correct way to release
> priv->task?

get_proc_task() does get_pid_task(), which does get_task_struct(), which
increments the ->usage field of the task. You want the inverse
operation - something that decrements ->usage and checks for zero. This is
done via put_task_struct(), which is defined a few lines below
get_task_struct().

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXs1/FAAoJED4KNFJOeCOoSk4P/2WgMqxaEIUhkIeif3lV21/n
DaewSi/tuGskF83YzM4+kQ69dDUXX5isR8xpNnC4xRTonl5jBdUpxalqh375H4HK
WYfc0k6NftW9NT6xwlknfg55q9Wnw1BdAG4uMZN1UX4gH8RUUEGP8vxzltnbmUFy
dhsd4j4ZCaghGITnV7lfRWffgR35btMkxQBqTojNOgZ8foUrGk1Fe7/W6xVgqVdg
KpXm+gqmOj8EMvRxp0A7KMWWMaQcc/P7NS9Cmv+HsfdWG8L9cXQbs06SH36ke4Gb
oUkwiC7u7XeMRIOj7QBuLgFIUYK3VCvVc5jahTa6EcyyQetMILLb+3svuExFQs2m
uVmLn/lgUROz49OGg4Kaaz65kSvpIj02jVkqE/YiOrH/2mUrJQPwUZIx/GiXImJA
h0+wJA2kXNE0DZVbfjPdAFVGvUjbLoM29sGyjKKEVy8duJ9ERsn7zYh+7sS1phh7
GIpXb/o09K3v44h63e44mZevqKBkvuVYvIeEl/jBrBSiCR9u+q4o2FtPMZ197vTt
NZwul06l2YG0t3W5LkJJlXYOMMkfIOV9VQv385z+R24roHH6lUz5wxrwC3OosVzD
lBuyIoldoGPwjUMd1knkTN5d/JadnZbfdJP9uWpgk92+KJdLQjYiHJ/Aw0/dZ363
i2obD0v2fqHbaaa+zKg0
=cOvI
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
