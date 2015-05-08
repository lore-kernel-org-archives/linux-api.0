From: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] Allow user to request memory to be locked on page
 fault
Date: Fri, 8 May 2015 16:06:10 -0400
Message-ID: <20150508200610.GB29933@akamai.com>
References: <1431113626-19153-1-git-send-email-emunson@akamai.com>
 <20150508124203.6679b1d35ad9555425003929@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150508124203.6679b1d35ad9555425003929-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-alpha-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, linux-parisc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xtensa-PjhNF2WwrV/0Sa2dR60CXw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 08 May 2015, Andrew Morton wrote:

> On Fri,  8 May 2015 15:33:43 -0400 Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org> wro=
te:
>=20
> > mlock() allows a user to control page out of program memory, but this
> > comes at the cost of faulting in the entire mapping when it is
> > allocated.  For large mappings where the entire area is not necessary
> > this is not ideal.
> >=20
> > This series introduces new flags for mmap() and mlockall() that allow a
> > user to specify that the covered are should not be paged out, but only
> > after the memory has been used the first time.
>=20
> Please tell us much much more about the value of these changes: the use
> cases, the behavioural improvements and performance results which the
> patchset brings to those use cases, etc.
>=20

The primary use case is for mmaping large files read only.  The process
knows that some of the data is necessary, but it is unlikely that the
entire file will be needed.  The developer only wants to pay the cost to
read the data in once.  Unfortunately developer must choose between
allowing the kernel to page in the memory as needed and guaranteeing
that the data will only be read from disk once.  The first option runs
the risk of having the memory reclaimed if the system is under memory
pressure, the second forces the memory usage and startup delay when
faulting in the entire file.

I am working on getting startup times with and without this change for
an application, I will post them as soon as I have them.

Eric

--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVTRcyAAoJELbVsDOpoOa9ve0P/31hrYdpIkjcL8etZV7j1Amz
CbQNUV91heC9gS4zlE+Pkm/1OT+lPBx8qUXxoy1yvGtjh4Hy6dOfkrM/ysC60Xw3
GCLHqDfNm3GoRK4a4MfebDLlesAjLuRpk8n4dxjyZ8EbL6MeTaiAxDqyZ7YUqfNf
/OIxvT6zni/Tw1/JhTEE5G2qnjU7MLXJeALQEOISPmb+Fm59/sIOn5jcppYauPvW
8IieUQkD+BspBKu4L3UG66nhtEc67QX4IMyQCLe4asaZqz2rs4aI9R/YZeuXl+dK
JYcmsI3bX86XGvSKS0wWySw7/agkzOB/df+alVVtMB6iYFn46fwZ0wlMf051q8V1
aK9u/5/Fwp945kC0gnMa2qAirbHhDmhrxAJam+bPUaCz58EZq4ItZ6OmDkWVI/O9
332mvX26Wm5vzKZ9ki5qeh6CdFPBbPWvtxQHo7mx/BVEoJsKR322y73YHY6bsJ4x
eWSQQ+jNq5Oshogd3x73Fon4/8zjN+vBYFva5P9bSUH9Aq+TQtuc9zl3OD2nbe8x
j74wSLsyfrpBjBzSDG1lNiWN+3OZKsvxSFPX07SK4hkCOKf3jv/6g8PlftJaQNgJ
1hFJDRmz0Dr0OLbU8oAaC7A2BiSQLRBpqaW2tcN/igSu1B13adZVPA+WGcjOcqW2
detDdJZun8mNCxkguBtQ
=s0uu
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--
