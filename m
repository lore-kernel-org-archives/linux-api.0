From: Pawel Moll <pawel.moll@arm.com>
Subject: Re: [PATCH v2 2/2] perf: Userspace event
Date: Fri, 26 Sep 2014 11:59:50 +0100
Message-ID: <1411729190.3852.21.camel@hornet>
References: <1411491787-25938-1-git-send-email-pawel.moll@arm.com>
	 <1411491787-25938-3-git-send-email-pawel.moll@arm.com>
	 <87oau5k0u9.fsf@sejong.aot.lge.com> <20140924072017.GC990@gmail.com>
	 <87y4t6j40p.fsf@sejong.aot.lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87y4t6j40p.fsf@sejong.aot.lge.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Namhyung Kim <namhyung@kernel.org>
Cc: Richard Cochran <richardcochran@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, John Stultz <john.stultz@linaro.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, 2014-09-26 at 07:21 +0100, Namhyung Kim wrote:
> It looks like what trace-marker in ftrace does..  We might connect
> output of the trace marker into a perf event somehow.

I can probably trace_marker's write handler do the same as the new
prctl() would do. But this means that we really want the pre-defined
"zero terminated string" type (0). Otherwise, what type would be
assigned to a record originating from it?

Pawel
