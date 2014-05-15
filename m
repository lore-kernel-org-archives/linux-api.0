From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: futex(2) man page update help request
Date: Thu, 15 May 2014 17:11:09 +0200
Message-ID: <20140515151109.GQ30445@twins.programming.kicks-ass.net>
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
 <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>
 <5373D0CA.2050204@redhat.com>
 <20140515081444.GD11096@twins.programming.kicks-ass.net>
 <5374BE9E.8080408@redhat.com>
 <20140515132235.GM30445@twins.programming.kicks-ass.net>
 <CAKgNAkjrS8WWMoQzsiOkMVn1_Bf06uFCL6ECU7z=mv0fszg+gQ@mail.gmail.com>
 <5374D18D.6020608@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bmpniq+Thlljzm46"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5374D18D.6020608@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Carlos O'Donell <carlos@redhat.com>
Cc: mtk.manpages@gmail.com, Darren Hart <dvhart@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>, "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Davidlohr Bueso <davidlohr.bueso@hp.com>, Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


--Bmpniq+Thlljzm46
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 15, 2014 at 10:39:09AM -0400, Carlos O'Donell wrote:
> For example does gettid *really* return a pid_t as considered by
> userspace? It's not a full out process...

Yeah, PIDs and TIDs are the same namespace in the kernel. All we have
are tasks and each task has an id. gettid() actually returns the id of
the current task.

getpid() returns the id of the thread group leader, so for that task
gettid() and getpid() return the same id.

--Bmpniq+Thlljzm46
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdNkNAAoJEHZH4aRLwOS6ENQP/RsOAo22nckgUnC7R0YLUkB2
KUEz2sf8LL/kFob5ad7RY5ELhWk7HjmTj4RQFo/gc3GR8gb/3oc8m3xTB5Sa7TZw
Nu/50en1ZOmEMCJmPZ14l6WMudGZRRuIhyfTidDlKefNe9IlbRDC1iyn2KEmzBiq
Q8uplsw7myoWIduyYjN8xyCNVaDiUT1xOLuQYiqFU5SUJ9orYt/fU8e3u0L8qhAK
cggS4xMxVZDJSsIvZ/7AeQmWSCFU2WkSEWQNJ5Nlaza2+1SDinJoIbATQrGSTMuq
MgK5mF0+FF7tevN4PEmN0LBSS07UrKwpzlclSZwAKHLNuH6ZVclvtWeE0QC4vWRD
UaRFdXjgU4SFsA/DFeY2TaM5WDqdYo+YkX5wFkyPLcSUGGU0BGIK5i+iAhabCZb9
46jW+ZHkqmMkKMkmgypuIgdHyquukGZlvxLzd9sXjl7StV2uuxh4oMBI9GbXVozM
UBahHvXpWAxVNuTKo3ykemKBOPxiri2dBQOT9lomg+i+auTzhdxYuUEYnQwCZayu
MDKFaCNc7nw14+A6UnFUgyDMoFhoh4iDacv4+DXzD8NlJ7ZcReEpJ96N67jJfrYC
X8WOian0MSdtikRvoVNvI2zIalOj7/rNw/o7Rj6AtHAYYlUAXwxVKx6VuMbvg+NB
WTXlkC/b43xDkG1m+2Xh
=HyM8
-----END PGP SIGNATURE-----

--Bmpniq+Thlljzm46--
