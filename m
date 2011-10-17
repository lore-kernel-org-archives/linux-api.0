From: Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
Date: Mon, 17 Oct 2011 15:46:55 -0400
Message-ID: <17708.1318880815@turing-police.cc.vt.edu>
References: <1318349729-3108-1-git-send-email-kirill@shutemov.name> <1318349729-3108-4-git-send-email-kirill@shutemov.name> <20111014154348.ae6267aa.akpm@linux-foundation.org> <20111015112006.GA10173@tango.0pointer.de> <1318705910.2664.5.camel@laptop> <20111017013921.GA30035@tango.0pointer.de>
            <1318836529.6594.20.camel@twins>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1318880815_2955P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: Your message of "Mon, 17 Oct 2011 09:28:49 +0200."
             <1318836529.6594.20.camel@twins>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, harald-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-o55+BOBDEFg@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

--==_Exmh_1318880815_2955P
Content-Type: text/plain; charset=us-ascii

On Mon, 17 Oct 2011 09:28:49 +0200, Peter Zijlstra said:
> As to the proprietary plugins, let firefox spawn one per tab and simply
> SIGSTOP the thing when the tab becomes invisible or so, dunno.

Which really sucks if you're trying to listen to streaming audio from the tab
while trying to do other work.  Having to keep the tab visible is a pain.

(And yes, I know the *right* answer is to find a URI suitable to feed to amarok
or xine or something - but have you ever *looked* at the maze of indirections
and Javascript and Flash and who knows what other horrors some radio stations
go through to keep you from doing that? ;)


--==_Exmh_1318880815_2955P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOnIYvcC3lWbTT17ARAsb6AKCI70FYy6cHXN3V4v6+j1EcVAreigCfV1rd
2zc+WcYfE9fDEd6Tw1ALhh0=
=6vi1
-----END PGP SIGNATURE-----

--==_Exmh_1318880815_2955P--
