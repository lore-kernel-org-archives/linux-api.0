From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/7] locking/rwsem: don't resched at the end of
 optimistic spinning
Date: Mon, 4 Aug 2014 09:55:28 +0200
Message-ID: <20140804075528.GI9918@twins.programming.kicks-ass.net>
References: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com>
 <1407119782-41119-2-git-send-email-Waiman.Long@hp.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vzhXYRv6YJrvJIA1"
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1407119782-41119-2-git-send-email-Waiman.Long@hp.com>
Sender: linux-doc-owner@vger.kernel.org
To: Waiman Long <Waiman.Long@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, Davidlohr Bueso <davidlohr@hp.com>, Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>
List-Id: linux-api@vger.kernel.org


--vzhXYRv6YJrvJIA1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 03, 2014 at 10:36:16PM -0400, Waiman Long wrote:
> For a fully preemptive kernel, a call to preempt_enable() could
> potentially trigger a task rescheduling event. In the case of rwsem
> optimistic spinning, the task has either gotten the lock or is going
> to sleep soon. So there is no point to do rescheduling here.

Uh what? Why shouldn't we preempt if we've gotten the lock? What if a
FIFO task just woke up?=20

--vzhXYRv6YJrvJIA1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT3zxwAAoJEHZH4aRLwOS6RYMP/RKT7ZtZg1Gg4KJhJJHMgXcg
SbnhqX5QJdJxu4KZ9w9KqmODKp6zUdBUI1Y70Qg/Xhafrkqcpt2qnfShfITQGaVk
smm1gje+0ZAZzQeW01Hj1bZcj6WIRVoFVcXMsNvO+bamtyI4oOrGlSOggo8XI6+h
NZW8YZClw4Ui5qy+OiOCBToU41XI/eUka7Y5QTU3FR5cNL4W0e0TMCmgSlfleIWt
J20HdykK7arBfOGew1DQ3/Uau/lAb1X+YZIWtYes1g76wLXAoteGVOHCsGoeNk6o
5SsPVq9diI33wd4jseZ/3co87R2gPxabmmQLFQOnhMgI/wdisKux4GTv1FWyENsW
+IfeF2ZvssuYvcT6fyGWncuosNeQTMlf9r4b/xDzr47f3xugQaLv3KPy2QowVTEG
jVTuNyh2sKs8V9EWgdzpTzrk5XaIudoqnAwYHYNkh22zYv/5pTogScSMWPEFd9ZT
KH808BZ4A0B/wsbeqhf23MRyPv7f049bg4V7sq/lWdxDB9OvSUa+hPnKKBd1FYde
e+jllWEE33X4iDuxBY41bUOGOIuuMTPdFe7qlCe25PWUF8hLe8us9w/UF1ra6xHD
ByzdJDvCa6PxknJmRNayQOR8iSNkQ/7QFpnS7dyMRpU49DWwjgAG9QIpwYVTpWQu
vuIEWMl/YIvIiqJi5Kuy
=upai
-----END PGP SIGNATURE-----

--vzhXYRv6YJrvJIA1--
