From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v5 5/6] clone3: allow spawning processes into cgroups
Date: Mon, 3 Feb 2020 15:32:28 +0100
Message-ID: <20200203143228.GC13360@blackbody.suse.cz>
References: <20200121154844.411-1-christian.brauner@ubuntu.com>
 <20200121154844.411-6-christian.brauner@ubuntu.com>
 <20200129132719.GD11384@blackbody.suse.cz>
 <20200202093702.cdlyytywty7hk3rn@wittgenstein>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="iFRdW5/EC4oqxDHL"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200202093702.cdlyytywty7hk3rn@wittgenstein>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--iFRdW5/EC4oqxDHL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 02, 2020 at 10:37:02AM +0100, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> wrote:
> cgroup_post_fork() is called past the point of no return for fork and
> cgroup_css_set_put_fork() is explicitly documented as only being
> callable before forks point of no return:
I missed this and somehow incorrectly assumed it's called at the end of
fork too. I find the css_set refcounting correct now.

BTW any reason why not to utilize cgroup_css_set_put_fork() for the
regular cleanup in cgroup_post_fork() too?

Thanks,
Michal

--iFRdW5/EC4oqxDHL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAl44LvcACgkQia1+riC5
qSih0g//dEMA5UJIbc+0y7DXE9E+SiqXkYhkYbIoloeRHoNZZnwezyhercYrcOya
1yJzJ0H9zz9i3gQ3A5VE/Aqp9/gqjRakmtpLg3HNFO7gEFv3l9Mn5YwP0HEWIa3v
BOCCmdKlCFjMl41ZqsHjqnFYpNosVV/NP946BsTdN3zmDpRHLZLMTPz06CGrfvoB
vxE1Rbwn155YhwSmTQc2jBEhswXCs1LR7Y992a4aTOcvtTDGJafX3B4hbEPjQsRs
aIjE1nbF/WB0giyfyw6UjBt+VI/1DYh9+wHNrbctlCufSi+r+ideubGqH027vgnb
UNynOqSoBOcTdbI7O7ON69Ir7eB9itrsEGp6H+SqBMqPrxt8ZaVTjA6EFKrX99ST
ypg27IRkSSufIk9JMnIBCMOAXmU2SxlCJk5imkyS8ghOoZcI9VlnS4jDh5IHlSm+
25L9thnO+QjtfGXYQhtddSPBYTa5tdN23/SigWvuvumWBOMEIpBqxndH4gv658Lz
vo4OnmpAWuT400Tt/YZF1HX0gCDWLPlYz+nA9VXn7aMyzMPZdIVqjFAuY35OXZyF
8mwQdWPdyKeOXjfbQoiSqbTsR/mEDGUCbbf5v+bxI2vvJsBz+otzUGT8MKqPEC6c
lFvB9fnlI7rZ1x4lCoy+fqtIJfoLvuZq9pSx38U/O20H3siWH08=
=Y692
-----END PGP SIGNATURE-----

--iFRdW5/EC4oqxDHL--
