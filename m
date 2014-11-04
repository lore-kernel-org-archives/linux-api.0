From: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v3 2/3] perf: Userspace event
Date: Tue, 04 Nov 2014 16:42:11 +0000
Message-ID: <1415119331.24819.19.camel@arm.com>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
	 <1415060918-19954-3-git-send-email-pawel.moll@arm.com>
	 <87ppd35vbk.fsf@sejong.aot.lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87ppd35vbk.fsf-vfBCOVm4yAnB69T4xOojN9BPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 2014-11-04 at 06:33 +0000, Namhyung Kim wrote:
> Hi Pawel,
> 
> On Tue,  4 Nov 2014 00:28:37 +0000, Pawel Moll wrote:
> > +	/*
> > +	 * Data in userspace event record is transparent for the kernel
> > +	 *
> > +	 * Userspace perf tool code maintains a list of known types with
> > +	 * reference implementations of parsers for the data field.
> > +	 *
> > +	 * Overall size of the record (including type and size fields)
> > +	 * is always aligned to 8 bytes by adding padding after the data.
> > +	 *
> > +	 * struct {
> > +	 *	struct perf_event_header	header;
> > +	 *	u32				type;
> > +	 *	u32				size;
> 
> The struct perf_event_header also has 'size' field and it has the entire
> length of the record so it's redundant. 

Well, is it? Correct me if I'm wrong, but as far as I remember the
record size must be always aligned to 8 bytes. Thus you can't reliably
derive the data size from it - if I my data is 3 bytes long, I have to
add 5 bytes of padding thus making the header.size = 24 (I'm ignoring
sample_id here), right? So now, decoding the record, all I can do is:
header.size - sizeof(header) - sizeof(type) - sizeof(size) = 24 - 8 - 8
= 8. So, basing on the header.size the data is 8 bytes long. But only 3
first bytes are valid...

To summarize, there are three options:

1. I'm wrong and the record doesn't have to be padded to make it 8 bytes
aligned. Then I can drop the additional size field.

2. I could impose a limitation on the prctl API that the data size must
be 8 bytes aligned. Bad idea in my opinion, I'd rather not.

3. The additional size (for the data part) field stays. Notice that
PERF_SAMPLE_RAW has it as well :-)

>  Also there's 'misc' field in the
> perf_event_header and I guess it can be used as 'type' info as it's
> mostly for cpumode and we are in user mode by definition.

Hm. First of all, I don't really like the idea of "overloading" the misc
meaning. It's a set of flags and I'd rather see it staying like this.

Secondly, I'm not sure that it can be reused - we are in user mode,
true, but it can be either PERF_RECORD_MISC_USER or
PERF_RECORD_MISC_GUEST_USER.

Thirdly, misc is "only" 16 bits wide, and someone even asked for the
type to be 64 bit long! (I suspect he wanted to use it in some special,
hacky way though :-) 32 bit length seems like a reasonable choice,
though.

Do you feel that the "unnecessary" type field is a big problem?

Thanks for your time!

Pawel
