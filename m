From: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC 2/2] perf: Marker software event and ioctl
Date: Mon, 15 Sep 2014 18:27:14 +0100
Message-ID: <1410802034.3817.21.camel@hornet>
References: <1410522513-1045-1-git-send-email-pawel.moll@arm.com>
	 <1410522513-1045-3-git-send-email-pawel.moll@arm.com>
	 <5412EA7A.9020807@codeaurora.org> <1410526672.16936.52.camel@hornet>
	 <20140912134910.GG1801@kernel.org> <1410530335.16936.60.camel@hornet>
	 <20140912161934.GJ1801@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140912161934.GJ1801-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 2014-09-12 at 17:19 +0100, Arnaldo Carvalho de Melo wrote:
> Em Fri, Sep 12, 2014 at 02:58:55PM +0100, Pawel Moll escreveu:
> > On Fri, 2014-09-12 at 14:49 +0100, Arnaldo Carvalho de Melo wrote:
> > > Perhaps both? I.e. an u64 followed from a string, if the u64 is zero,
> > > then there is a string right after it?
>  
> > How would this look like in userspace? Something like this?
>  
> > 8<----
> > struct perf_event_marker {
> > 	uint64_t value;
> > 	char *string;
> > } arg;
>  
> > arg.value = 0x1234;
>  
> > /* or */
>  
> > arg.value = 0;
> > arg.string = "abcd";
>  
> > ioctl(fd, PERF_EVENT_IOC_MARKER, &arg)
> > 8<----
>  
> > If so, maybe it would simpler just to go for classic size/data
> > structure?
>  
> > 8<-----
> > struct perf_event_marker {
> > 	uint32_t size;
> > 	void *data;
> > }
> > 8<-----
>  
> > This would directly map into struct perf_raw_record...
> 
> I can see the usefulness of having it all, i.e. if we do just:
> 
> perf trace --pid `pidof some-tool-in-debug-mode-using-this-interface`

Hm. I haven't thought about a situation when 3rd party wants to inject
something into "my" data stream... I guess it could be implemented (a
"pid" member of the struct perf_event_marker with default 0 meaning
"myself"?), but will definitely complicate the patch. Should I have a
look at it now or maybe leave it till we get a general agreement about
the marker ioctl existence?

> Then 'perf trace' doesn't know about any binary format a tool may have,
> getting strings there (hey, LD_PRELOADing some logging library to hook
> into this comes to mind) and having it merged with other events
> (syscalls, pagefaults, etc) looks useful.

But do you still mean a "magic" u64 before the rest? Injecting a string
would just mean:

	marker.size = strlen(s) + 1;
	marker.data = s;

> As well as some specialized version of 'perf trace' that knows about
> some binary protocol that would get app specific stats or lock status,
> etc, perhaps even plugins for 'perf trace' that would be selected by
> that first u64? Also seems useful.
> 	  
> I.e. having a way to provide just strings and another that would allow
> passing perf_raw_record.

Sounds interesting. But then maybe this stuff shouldn't go into "raw"
then? It could be something like this in the sample:

	{ u64 type; /* 0 means zero-terminated string in data */
	  u32 size;
	  char data[size]; } && PERF_SAMPLE_MARKER

Pawel
