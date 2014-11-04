From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 0/3] perf: User/kernel time correlation and event generation
Date: Tue, 04 Nov 2014 17:11:47 +0100
Message-ID: <2022010.zd45j2gEWl@wuerfel>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com> <20141104082728.GB4253@localhost.localdomain> <alpine.DEB.2.11.1411041111010.5308@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.11.1411041111010.5308@nanos>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Cochran <richardcochran@gmail.com>, John Stultz <john.stultz@linaro.org>, Andy Lutomirski <luto@amacapital.net>, Pawel Moll <pawel.moll@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Christopher Covington <cov@codeaurora.org>, Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>, Tomeu Vizoso <tomeu@tomeuvizoso.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Pawel Moll <mail@pawelmoll.com>
List-Id: linux-api@vger.kernel.org

On Tuesday 04 November 2014 11:49:04 Thomas Gleixner wrote:
> On Tue, 4 Nov 2014, Richard Cochran wrote:
> 
> > On Tue, Nov 04, 2014 at 09:01:31AM +0100, Arnd Bergmann wrote:
> > > On Monday 03 November 2014 17:11:53 John Stultz wrote:
> > > > I've got some thoughts on what a possible interface that wouldn't be
> > > > awful could look like, but I'm still hesitant because I don't really
> > > > know if exposing this sort of data is actually a good idea long term.
> > >  
> > > I was also thinking (while working on an unrelated patch) we could use
> > > a system call like
> > > 
> > > int clock_getoffset(clockid_t clkid, struct timespec *offs);
> 
> We might make *offs a timespec64 or u64 

I don't think we are ready yet to introduce timespec64 in the uapi
headers, this needs some more careful planning. Otherwise I agree
it's bad to introduce syscalls that we already know will become
obsolete soon.

	Arnd
