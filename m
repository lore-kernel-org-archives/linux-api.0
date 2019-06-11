From: Arseny Maslennikov <ar@cs.msu.ru>
Subject: Re: [PATCH 1/7] signal.h: Define SIGINFO on all architectures
Date: Wed, 12 Jun 2019 01:38:06 +0300
Message-ID: <20190611223806.GA1112@cello>
References: <20190605081906.28938-1-ar@cs.msu.ru>
 <20190605081906.28938-2-ar@cs.msu.ru>
 <87o933507j.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87o933507j.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, "Vladimir D . Seleznev" <vseleznv@altlinux.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 11, 2019 at 03:36:00PM -0500, Eric W. Biederman wrote:
> Arseny Maslennikov <ar@cs.msu.ru> writes:
>=20
> > This complementary patch defines SIGINFO as a synonym for SIGPWR
> > on every architecture supported by the kernel.
> > The particular signal number chosen does not really matter and is only
> > required for the related tty functionality to work properly,
> > so if it does not suite expectations, any suggestions are warmly
> > welcome.
> >
> > SIGPWR looks like a nice candidate for this role, because it is
> > defined on every supported arch; it is currently only used to inform
> > PID 1 of power failures, and daemons that care about low-level
> > events do not tend to have a controlling terminal.
> >
> > However, on sparcs SIGPWR is a synonym for SIGLOST, a signal unique
> > to that architecture, with a narrow set of intended uses that do not
> > combine well with interactively requesting status.
> > SIGLOST is not used by any kernel code at the moment.
> > I'm not sure there is a more reasonable alternative right now.
>=20
> Is the name SIGINFO already well established.
>=20
> It just is a little bit confusing with struct siginfo.
>=20

I thought about this, but the alternatives are clunkier.
SIGKBINFO? Implies there actually is a keyboard, most ttys are
virtual/software nowadays. Misplaced emphasis.
SIGSTATUS? Too generic.
SIGTINFO? This could work, like conveys the nature and all, but many
applications already do #ifdef SIGINFO; if we reuse the name they will
suddenly just work, and this helps adoption.
SIGTINFO does decipher to "terminal info", this sounds too ambiguous.

Fortunately, from UNIX tradition signal names are defined in caps, and
given there is much more related written discussion than spoken, this
stands out enough to my taste. I'd say, it stands out a lot.

> At least on x86 it looks like we have signals 32 and 33 that are
> reserved and not used for anything.  Is there a reason you have
> not picked one of those?

Quoting signal(7) from man-pages:
       The Linux kernel supports a range of 33 different real-time
       signals, numbered 32  to  64.   However,  the  glibc  POSIX
       threads  implementation  internally  uses two (for NPTL) or
       three   (for   LinuxThreads)   real-time    signals    (see
       pthreads(7)),  and  adjusts  the value of SIGRTMIN suitably
       (to 34 or 35).

This excerpt gives the cue that signals 32 and 33 are not really unused,
and I did not want to cause further adjustments to SIGRTMIN/SIGRTMAX,
since this means we have to recompile the world with the new, changed
SIGRTMIN/MAX...

If we'd change RTMIN, this makes all the rt signal numbers shift to the
right and can cause havoc if we do not recompile the world.

We could probably go with decrementing RTMAX and reusing the value
(effectively reserving a signal number from the end), but aliasing PWR
seems much easier and less harmful, and easier for apps to adopt.
If we find a strong reason not to reuse PWR, this may be considered as a
plan B, but the idea to allocate even more precious signals seems too
wasteful to me for now.

>=20
> Also should this be a realtime signal with signal information
> or a non-realtime signal?

I see no requirement for this to be a realtime signal.

Non-realtime signals like PWR or INT also have at least some signal
information which can be accessed with handlers installed with
sigaction(2). [1] has a small example.
The most obvious piece of info is that signals sent by n_tty
(si_code=3D=3DSI_KERNEL) are easy to distinguish from signals sent by
processes (si_code=3D=3DSI_USER)

>=20
> I don't expect there is much to encode except that the user is asking
> for information.  I half wonder if it could be done as a different
> si_code to SIGWINCH.  But of course that doesn't work because it is
> not a real time signal so does not queue more than one siginfo. (Sigh).
>=20

Signals are just a huge mess (not that this is news...)  :)

> I just would like to see that we have a clear concept of how this new
> signal plays into all of the signal handling bits.
>=20
> Added linux-api because this is fundamentally extending the linux-api,
> and we probably want man-page updates etc.
>=20
> Eric
>=20

[1]https://github.com/porrided/tty-kb-status-userspace/blob/d32028056c85b27=
9cf8d5f43478b5419d090637c/siginfo-test/siginfo.c

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE56JD3UKTLEu/ddrm9dQjyAYL01AFAl0ALUkACgkQ9dQjyAYL
01BW0hAAp16BV3hKnjc+iWwm3CkoMTcMZPMDaDJZmsfyjUIS1qqNiJ3NfKr/2LGv
C9A7sX3VKE0GXijjJvxxnyfVhKsamQ4m0vaJawhYPKcWj9BGVqZoAilEo5Lf4eV8
Mw2unvgdr0YW4aReAb83ocCYD1ZjqFy3VGz9uVZHx9tOCTGXiVT/gijiHuT9PV4G
iaO/SZW+CT1aZ6L0m7XDR78vPFuBLMrJmrBri5yd4LmvGS/A3ldsQA3QEY4v1Shc
usk7AV90llIuKCQCNDj3OLD8odeESSqefCdtAE39Zuaau9N/BqLsXe5h6qp37ZkB
vYsYkR1Bw9Pat5itTzuCNGnPtO4pSiPmnesQkKL2P5bxtUOl11BJCKCFei20O7yE
cQI91lPpcDZrBMWvxtDPUzemqhQxzPoUvI3XbVK8gogFmFsVrTeFc5IlCUf0j3Jr
JkTYbxWbtYf/MK+Pju2jxj5zcmlgVA8CFaF2sYB9BBHNGAnjZPdxJ1NmarHKc4f+
Z1EFGJasACMR1P3TVXV9sjqmBMUzlrgxPGvCqnc+7icXbKMaDc2Lm7cUJfGapGi1
zagyCvwkqJrPydKUgy753Cr8druVfT9jMfnCl/FoPhTpeXjTpbCawh0HAFjMK2JH
aEoNg2C6FwF6IzCMX2D6UGc2RNk9iMJTzvWsOxpvJ6W0L8VAMXk=
=73jc
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
