From: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC 2/2] perf: Marker software event and ioctl
Date: Fri, 12 Sep 2014 14:58:55 +0100
Message-ID: <1410530335.16936.60.camel@hornet>
References: <1410522513-1045-1-git-send-email-pawel.moll@arm.com>
	 <1410522513-1045-3-git-send-email-pawel.moll@arm.com>
	 <5412EA7A.9020807@codeaurora.org> <1410526672.16936.52.camel@hornet>
	 <20140912134910.GG1801@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140912134910.GG1801-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 2014-09-12 at 14:49 +0100, Arnaldo Carvalho de Melo wrote:
> Perhaps both? I.e. an u64 followed from a string, if the u64 is zero,
> then there is a string right after it?

How would this look like in userspace? Something like this?

8<----
struct perf_event_marker {
	uint64_t value;
	char *string;
} arg;

arg.value =3D 0x1234;

/* or */

arg.value =3D 0;
arg.string =3D "abcd";

ioctl(fd, PERF_EVENT_IOC_MARKER, &arg)
8<----

If so, maybe it would simpler just to go for classic size/data
structure?

8<-----
struct perf_event_marker {
	uint32_t size;
	void *data;
}
8<-----

This would directly map into struct perf_raw_record...

Pawe=C5=82
