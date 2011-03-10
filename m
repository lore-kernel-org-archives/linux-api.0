From: Jamie Lokier <jamie-yetKDKU6eevNLxjTenLetw@public.gmane.org>
Subject: Re: [RFCv4] timerfd: add TFD_NOTIFY_CLOCK_SET to watch for clock changes
Date: Thu, 10 Mar 2011 11:16:22 +0000
Message-ID: <20110310111622.GH29234@shareable.org>
References: <1299681411-9227-1-git-send-email-virtuoso@slind.org> <20110309162513.5058c824.akpm@linux-foundation.org> <AANLkTinZioShsr3O0Z=xaEQ-S=JBCgs_SS_LdsBnNhZ2@mail.gmail.com> <alpine.LFD.2.00.1103101004540.2787@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103101004540.2787-bi+AKbBUZKagILUCTcTcHdKyNwTtLsGr@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alexander Shishkin <virtuoso-0lOfPCoBze7YtjvyW6yDsg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ken MacLeod <ken-VbOJbV3qneKf+c8Povm/Gg@public.gmane.org>, Shaun Reich <predator106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Greg Kroah-Hartman <gregkh-l3A5Bk7waGM@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michael Tokarev <mjt-XAri/EZa3C4vJsYlp49lxw@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Stultz <johnstul-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Chris Friesen <chris.friesen-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Artem Bityutskiy <dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Thomas Gleixner wrote:
> Note, that we have CLOCK_BOOTTIME pending for .39 which aims at the
> same problem. It's basically CLOCK_MONOTONIC adjusted by the time we
> were in suspend. So while CLOCK_MONOTONIC timers are not aware of the
> time spent in suspend CLOCK_BOOTTIME timers are. The reason for
> implementing CLOCK_BOOTTIME was basically the same problem.

I'm afraid for coherent distributed system problems,
I don't trust CLOCK_BOOTTIME.

What happens when the clock battery is flat?  (Some systems have
separate battery for the clock, and it's never changed or recharged).

What about systems that just don't have a hardware clock while
suspended, or the clock doesn't remember the current year reliably, or
it's handled by userspace not the kernel?

(I have a system here where the clock battery will eventually run
down, and which has a userspace-only hwclock driver)

What happens if user does suspend to disk and resumes the disk image
after they used a different OS for a while, which has meanwhile also
altered the clock?

Or suspend to disk on a VM followed by moving to a different VM host.

In general I trust CLOCK_BOOTTIME to be a reasonable measure of
elapsed time most of the time - but not reliable enough for
distributed systems (such as coherent caches) that need stricter
guarantees whatever the client hardware, or need to know when those
guarantees aren't met.

Whereas I'd trust an "something happened so recalibate" event that is
always triggered - provided it's not sent too early or too late
relative to clock measurements and timer queue reads.  I've yet to
check if these proposed timerfd events meet that criterion.

-- Jamie
