From: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [REVIEW][PATCH 0/4] /proc/thread-self
Date: Mon, 4 Aug 2014 15:12:49 +0200
Message-ID: <20140804131249.GD6923@x2.net.home>
References: <87oaw5caq1.fsf@x220.int.ebiederm.org>
 <1406860795.3036.3.camel@buesod1.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1406860795.3036.3.camel-5JQ4ckphU/8SZAcGdq5asR6epYMZPwEe5NbjCUgZEJk@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Jul 31, 2014 at 07:39:55PM -0700, Davidlohr Bueso wrote:
> On Thu, 2014-07-31 at 17:30 -0700, Eric W. Biederman wrote:
> > This is small chance changing /proc/net and /proc/mounts will cause
> > userspace regressions (although nothing has shown up in my testing) if
> > that happens we can just point the change that moves them from
> > /proc/self/... to /proc/thread-self/...
> 
> Isn't breaking userspace a no no, no matter what? At least some
> util-linux programs makes use of both /proc/mounts and /proc/net.

Frankly, I don't care about /proc/mount, this file is more about backward
compatibility than about any real informations ;-)

The really important file is /proc/self/mountinfo. We use this file on
many places including shared libs and it seems (according to Eric's
suggestion), that the right think will be to update the libs to use
/proc/thread-self/mountinfo.


Note that I like the idea to have the magic symlink to access thread
specific /proc stuff. It's definitely nice thing for userspace.

    Karel

-- 
 Karel Zak  <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 http://karelzak.blogspot.com
