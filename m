From: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Subject: Re: [PATCH 2/4] Convert epoll to a bitlock
Date: Tue, 3 Feb 2009 15:37:40 -0700
Message-ID: <20090203153740.363d0a04@bike.lwn.net>
References: <1233598811-6871-1-git-send-email-corbet@lwn.net>
	<1233598811-6871-3-git-send-email-corbet@lwn.net>
	<20090203133942.2ecec281.akpm@linux-foundation.org>
	<4988BD4E.8080206@cosmosbay.com>
	<20090203140543.6e915f97.akpm@linux-foundation.org>
	<1233699722.3243.127.camel@calx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1233699722.3243.127.camel@calx>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Dumazet <dada1-fPLkHRcR87vqlBn2x/YWAg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 03 Feb 2009 16:22:02 -0600
Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org> wrote:

> But that re-opens the question of what to do about poor Jon's quest.
>
> I got confused halfway through as he went from using a global fasync
> spinlock to a non-locked but atomic flag bit. Not sure why using a
> per-file or per-inode lock doesn't work for the fasync code.

No per-file lock because (1) there is resistance to growing struct
file, and (2) lockless algorithms are all the rage now.  Additionally,
solving the fasync-atomicity problem with locks requires the use of a
mutex (or the BKL) rather than a spinlock.  I suppose we could combine
a global f_flags lock with the set-FASYNC-in-fasync_helper() bits.

At this point Poor Jon sees a fork in the road as he contemplates the
future of his quest:

- Go with this patch set, perhaps with a bit of cleanup as suggested by
  Andrew.

- Go back to the global lock.

- Go away, leave the BKL in place, and wait for somebody smarter to
  attack the problem.

Any wise guidance would be most welcome...

jon
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
