From: Jann Horn <jannhorn-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [PATCH 3/3] posix timers: Add syscall that works on timer
 sigevent
Date: Sun, 17 Feb 2013 14:42:48 +0100
Message-ID: <20130217134248.GD13378@debjann.fritz.box>
References: <511D0E50.7090505@parallels.com>
 <511D0EA1.9060704@parallels.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pQhZXvAqiZgbeUkD"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <511D0EA1.9060704-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--pQhZXvAqiZgbeUkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 14, 2013 at 08:19:45PM +0400, Pavel Emelyanov wrote:
> +	struct sigevent event;
[...]
> +	event.sigev_notify = timer->it_sigev_notify;
> +	event.sigev_signo = timer->sigq->info.si_signo;
> +	event.sigev_value = timer->sigq->info.si_value;
> +	event.sigev_notify_thread_id = pid_vnr(timer->it_pid);
[...]
> +	if (old_event && copy_to_user(old_event, &event, sizeof(event)))

Won't this leak uninitialized kernel stack data to userspace? As far as I can
see, the _sigev_un union is bigger than the _tid field in it, so the rest of
it will be copied over without initialization, right?

Jann

--pQhZXvAqiZgbeUkD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRIN5XAAoJEGhmizV0f2d1omkP/3aYg8NWXKJAywJymFPipKyq
PyhAhup8mGOnurcQuX84rmQP51P9wzXC1nOotfspkGvvougk1NGHX6Ns/t84qDhE
711xvW28OmJjNyQ+YZyPXwVKMu8cXPmy+yUI42c7zW78MxHdSk50Qf9OeBgTsjcw
RJs6D6jH7+F5uNKa0UxPKPh5Ji1TBTeJzolBIdfzy8OYA6vJ6/GtrpnotDBrDtaR
o2bOpmOADLI9Q48fg9SPy7jAEfS2Z8ULg0vwBixqFC/7+RIUOj1hgro0UgiIdpnT
6/vA9GXotjzDFfl9V7NE0ohLFeDvuirjkhkDmICpS4o5YosigsWYzXbKJ44dw9XP
R/H3lUBfkppS5dik1jmSIIRHWB+wNMLcy+CYqqcQc85BZ0mGchxpGAlzvQb4jMsa
vwXj9KXTcnmGqKkkApdZVtNk1elpd+g408xy1o9ouwuT6XQxHbpshEjBg1WFXh00
lhpCAqkbHfjtCV6gMZhhw34G0TKOfKXOQ5z2XqruOl5XSkjhTTdvZ/PnIzKVve/F
8xNdvCORRQJXmnDrcJePQiyIVv/g68lI2YbwR/pFbR9iGzeBCdg+TkgA+Z5aJrSU
lkpf8lKsssGNuMKiAtV2oUWO572Me4jJeEZzYMOBMtuxXfd0vObXt4BKj1OiE8Ny
mVnRFz9Hy401I5VyIAAm
=6AOp
-----END PGP SIGNATURE-----

--pQhZXvAqiZgbeUkD--
