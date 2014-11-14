From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 1/1] truncate: generate fanotify and inotify events
Date: Fri, 14 Nov 2014 10:01:44 +0100
Message-ID: <20141114090144.GA17262@quack.suse.cz>
References: <1412619208-8087-1-git-send-email-xypron.glpk@gmx.de>
 <54650D23.9040701@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54650D23.9040701-Mmb7MZpHnFY@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

  Hello Heinrich,

On Thu 13-11-14 20:57:23, Heinrich Schuchardt wrote:
> could you, please, give me some feedback for
> https://lkml.org/lkml/2014/10/6/380
  Oh, I completely forgot about that one...

> Currently truncate() only generates an IN_MODIFY event.
> 
> Do you agree that it also should additionally create
> FAN_OPEN_PERM, FAN_OPEN, IN_OPEN, FAN_MODIFY, FAN_CLOSE_WRITE,
> IN_CLOSE_WRITE as well?
>
> IN_CLOSE_WRITE is used by editors to warn the user about updated files.
> 
> FAN_OPEN_PERM, FAN_MODIFY, and FAN_CLOSE_WRITE would be relevant for
> a malware scanner.
> 
> FAN_OPEN_PERM would be needed if the fanotify interface were used to
> build a hierarchical storage managers.
  I agree about FAN_MODIFY, that is a clear bug. OPEN / CLOSE events are
generated on open / close. Noone really guarantees you that to modify a
file you have to open it. So I agree they would make life simpler for
userspace but at this point I don't think we can change the user interface
in such way :(.
 
I can imagine that especially for content checkers the fact that file can
be truncated without FAN_OPEN_PERM is rather unpleasant (OTOH file can be
unlinked & replaced in a directory also without FAN_OPEN_PERM so it doesn't
seem like a completely new problem area either).

The cleanest way I see how we could deal with the situation is to add a new
type of event. Maybe something like IN_TRUNCATE, FAN_TRUNCATE,
FAN_TRUNCATE_PERM - and userspace application aware of the problem could
use these events instead of watching for IN_MODIFY / FAN_MODIFY which is
generated rather frequently. But this definitely needs more thought -
we have to carefully define when the events get generated so that they are
useful - is e.g. punching holes and similar fallocate tricks elligible as
well? What about ftruncate() where you have open file descriptor?

								Honza

-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
