From: Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: Re: [RFC 0/6] Non perf based Gen Graphics OA unit driver
Date: Wed, 30 Sep 2015 11:23:19 +0800
Message-ID: <20150930032319.GA23231@zhen-hp.sh.intel.com>
References: <1443537549-6905-1-git-send-email-robert@sixbynine.org>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1318593094=="
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
In-Reply-To: <1443537549-6905-1-git-send-email-robert@sixbynine.org>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: Robert Bragg <robert@sixbynine.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Matt Fleming <matt.fleming@intel.com>, dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Sourab Gupta <sourab.gupta@intel.com>, linux-api@vger.kernel.org, Zheng Yan <zheng.z.yan@intel.com>, Daniel Vetter <daniel.vetter@intel.com>, Ingo Molnar <mingo@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>
List-Id: linux-api@vger.kernel.org


--===============1318593094==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2015.09.29 15:39:03 +0100, Robert Bragg wrote:
>=20
> - Logistically it might be more practical to contain this to the
>   graphics stack.
>=20
>     It seems fair to consider that if we can't see a very compelling
>     benefit to building on perf, then containing this work to
>     drivers/gpu/drm/i915 may simplify the review process as well as
>     future maintenance and development.
>=20

I think even we all initially like to go with perf but it appears later
that we might need to stick this more close with i915 driver. Also think
about to enable global profiling for all graphics clients, extending or
enabling it within i915 specific interface seems more feasible instead of
trying to create another PMU driver like previous implementation attempt
to suit the need for different gfx perf data definition.

Robert, thanks for send and elaborate on this.

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlYLVacACgkQsQQaM014GCfeegCgiZvWmkYbW+CCTo0DL1jl78uW
jBcAn1R7zkSWAQI55zHGJO7nEmI2AcXL
=1/PW
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--

--===============1318593094==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KSW50ZWwtZ2Z4
IG1haWxpbmcgbGlzdApJbnRlbC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHA6Ly9saXN0
cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9pbnRlbC1nZngK

--===============1318593094==--
