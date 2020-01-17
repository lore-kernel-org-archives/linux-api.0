From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v8 2/3] pid: Introduce pidfd_getfd syscall
Date: Sat, 18 Jan 2020 10:14:48 +1100
Message-ID: <20200117231448.btck3qzepvtz5lcp@yavin>
References: <20200103162928.5271-1-sargun@sargun.me>
 <20200103162928.5271-3-sargun@sargun.me>
 <20200117230602.GA31944@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qclidy4gbrtvcf5h"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200117230602.GA31944-PfSpb0PWhxZc2C7mugBRk2EX/6BAtgUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Sargun Dhillon <sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tycho-E0fblnxP3wo@public.gmane.org, jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, gpascutto-4eJtQOnFJqFBDgjK7y7TUQ@public.gmane.org, ealvarez-4eJtQOnFJqFBDgjK7y7TUQ@public.gmane.org, fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jld-4eJtQOnFJqFBDgjK7y7TUQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
List-Id: linux-api@vger.kernel.org


--qclidy4gbrtvcf5h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2020-01-17, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Fri, Jan 03, 2020 at 08:29:27AM -0800, Sargun Dhillon wrote:
> > +SYSCALL_DEFINE3(pidfd_getfd, int, pidfd, int, fd,
> > +		unsigned int, flags)
> > +{
> > +	struct pid *pid;
> > +	struct fd f;
> > +	int ret;
> > +
> > +	/* flags is currently unused - make sure it's unset */
> > +	if (flags)
> > +		return -EINVAL;
>=20
> Is EINVAL the right errno here?  Often we use ENOSYS for bad flags to
> syscalls.

I don't think that's right -- every syscall I've seen gives you -EINVAL
for invalid flags (not to mention -ENOSYS would mean userspace would be
confused as to whether the syscall is actually supported by the kernel).

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--qclidy4gbrtvcf5h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXiI/4QAKCRCdlLljIbnQ
EsZ4AP4r48SZU+VGb0kNxiTIYaI9vcaP9MHT16G7vRJU0mdV3gD5AVigsJnWLW0m
gZGhf7y0bY18y31c5t2ijCRxidRHWAQ=
=mswC
-----END PGP SIGNATURE-----

--qclidy4gbrtvcf5h--
