From: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC 2/2] perf: Marker software event and ioctl
Date: Tue, 16 Sep 2014 17:33:47 +0100
Message-ID: <1410885227.12376.20.camel@hornet>
References: <1410522513-1045-1-git-send-email-pawel.moll@arm.com>
	 <1410522513-1045-3-git-send-email-pawel.moll@arm.com>
	 <5412EA7A.9020807@codeaurora.org> <1410526672.16936.52.camel@hornet>
	 <20140912134910.GG1801@kernel.org> <1410530335.16936.60.camel@hornet>
	 <20140912161934.GJ1801@kernel.org> <1410802034.3817.21.camel@hornet>
	 <20140915183101.GE11199@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140915183101.GE11199-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, 2014-09-15 at 19:31 +0100, Arnaldo Carvalho de Melo wrote:
> Em Mon, Sep 15, 2014 at 06:27:14PM +0100, Pawel Moll escreveu:
> > On Fri, 2014-09-12 at 17:19 +0100, Arnaldo Carvalho de Melo wrote:
> > > Em Fri, Sep 12, 2014 at 02:58:55PM +0100, Pawel Moll escreveu:
> > > > On Fri, 2014-09-12 at 14:49 +0100, Arnaldo Carvalho de Melo wro=
te:
> > > > > Perhaps both? I.e. an u64 followed from a string, if the u64 =
is zero,
> > > > > then there is a string right after it?
> > > =20
> > > > How would this look like in userspace? Something like this?
> > > =20
> > > > 8<----
> > > > struct perf_event_marker {
> > > > 	uint64_t value;
> > > > 	char *string;
> > > > } arg;
> > > =20
> > > > arg.value =3D 0x1234;
> > > =20
> > > > /* or */
> > > =20
> > > > arg.value =3D 0;
> > > > arg.string =3D "abcd";
> > > =20
> > > > ioctl(fd, PERF_EVENT_IOC_MARKER, &arg)
> > > > 8<----
> > > =20
> > > > If so, maybe it would simpler just to go for classic size/data
> > > > structure?
> > > =20
> > > > 8<-----
> > > > struct perf_event_marker {
> > > > 	uint32_t size;
> > > > 	void *data;
> > > > }
> > > > 8<-----
> > > =20
> > > > This would directly map into struct perf_raw_record...
> > >=20
> > > I can see the usefulness of having it all, i.e. if we do just:
> > >=20
> > > perf trace --pid `pidof some-tool-in-debug-mode-using-this-interf=
ace`
> >=20
> > Hm. I haven't thought about a situation when 3rd party wants to inj=
ect
> > something into "my" data stream... I guess it could be implemented =
(a
>=20
> I was thinking about intercepting calls that pass some logging data, =
as
> strings, and 'tee' them to the 'perf trace' 'data stream'.

Right, ok, like LD_PRELOADing printf (a stupid example of course) and
piping it inside perf... So if I'm getting it right, it's the perf
process that would eventually do the ioctl(PERF_EVENT_IOC_MARKER), not
the traced process, correct? This makes sense. Another use case for
ioctl justification, thanks :-)

> > "myself"?), but will definitely complicate the patch. Should I have=
 a
> > look at it now or maybe leave it till we get a general agreement ab=
out
> > the marker ioctl existence?
> >=20
> > > Then 'perf trace' doesn't know about any binary format a tool may=
 have,
> > > getting strings there (hey, LD_PRELOADing some logging library to=
 hook
> > > into this comes to mind) and having it merged with other events
> > > (syscalls, pagefaults, etc) looks useful.
> >=20
> > But do you still mean a "magic" u64 before the rest? Injecting a st=
ring
> > would just mean:
> >=20
> > 	marker.size =3D strlen(s) + 1;
> > 	marker.data =3D s;
> >=20
> > > As well as some specialized version of 'perf trace' that knows ab=
out
> > > some binary protocol that would get app specific stats or lock st=
atus,
> > > etc, perhaps even plugins for 'perf trace' that would be selected=
 by
> > > that first u64? Also seems useful.
> > > 	 =20
> > > I.e. having a way to provide just strings and another that would =
allow
> > > passing perf_raw_record.
> >=20
> > Sounds interesting. But then maybe this stuff shouldn't go into "ra=
w"
> > then? It could be something like this in the sample:
> >=20
> > 	{ u64 type; /* 0 means zero-terminated string in data */
> > 	  u32 size;
> > 	  char data[size]; } && PERF_SAMPLE_MARKER
>=20
> Yes, this is how I think it should be.

Seems that Ingo had exactly the same thing on mind. I'll get a patch
done.

Pawe=C5=82
