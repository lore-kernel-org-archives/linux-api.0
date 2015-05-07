From: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Subject: Re: [PATCH 00/19] converting system calls to 64-bit time_t, part 1
Date: Thu, 07 May 2015 11:24:53 +0200
Message-ID: <1430990693.8171.70.camel@x220>
References: <1430929826-318934-1-git-send-email-arnd@arndb.de>
	 <1430983678.8171.23.camel@x220> <1430984358.8171.28.camel@x220>
	 <2330671.lQAl76KQcx@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2330671.lQAl76KQcx@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, baolin.wang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, albert.aribaud-iEu9NFBzPZE@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 2015-05-07 at 10:52 +0200, Arnd Bergmann wrote:
> On Thursday 07 May 2015 09:39:18 Paul Bolle wrote:
> I realize the downsides of not posting the entire series at once
> here, but it seemed better to avoid spamming everyone too much,
> while I try to find out if we have agreement on the overall
> strategy.

That downside is worse when people only quickly skim your message for
clues while thinking about the problem they _think_ they've spotted
(like I did).

> For reference, see below for the ARM patch.

> > And then it occurred to me to check the y2038-syscalls git branch you
> > referenced. After which the above made much more sense. (Though my
> > remark that ARCH_HAS_COMPAT_TIME simply functions as an alias for COMPAT
> > also seems to hold for that branch.)
> 
> Right, in fact both of these happen at the end of the git tree.

Still, you might consider making ARCH_HAS_COMPAT_TIME a plain bool and
adding "select ARCH_HAS_COMPAT_TIME" to the eight or so COMPAT entries.
But, clearly, I'm now wasting even more of your time by trying to save
face here.

Thanks,


Paul Bolle
