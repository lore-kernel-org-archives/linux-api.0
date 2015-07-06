From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [GIT PULL] User namespace related fixes for v4.2
Date: Mon, 6 Jul 2015 17:25:15 -0500
Message-ID: <20150706222515.GA131277@ubuntu-hedt>
References: <87381eyz26.fsf@x220.int.ebiederm.org>
 <878uazhapq.fsf@x220.int.ebiederm.org>
 <20150706204748.GB22962@ubuntu-hedt>
 <E81DECCD-9B19-4D42-BE43-5987DE7B05DB@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <E81DECCD-9B19-4D42-BE43-5987DE7B05DB-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?utf-8?B?U3TDqXBoYW5l?= Graber <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Eric Windisch <ewindisch-FCduhRhOUaTQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>, Ivan Delalande <colona-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 06, 2015 at 04:24:00PM -0500, Eric W. Biederman wrote:
> 
> 
> On July 6, 2015 3:47:48 PM CDT, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
> >On Wed, Jul 01, 2015 at 03:41:37PM -0500, Eric W. Biederman wrote:
> >> This set of changes also starts enforcing the mount flags of fresh
> >> mounts of proc and sysfs are consistent with the existing mount of
> >proc
> >> and sysfs.  I expected this to be the boring part of the work but
> >> unfortunately unprivileged userspace winds up mounting fresh copies
> >of
> >> proc and sysfs with noexec and nosuid clear when root set those flags
> >on
> >> the previous mount of proc and sysfs.  So for now only the atime,
> >> read-only and nodev attributes which userspace happens to keep
> >> consistent are enforced.  Dealing with the noexec and nosuid
> >attributes
> >> remains for another time.
> >
> >Sorry to be the bearer of bad news, but I am seeing a regression in lxc
> >with 4.2-rc1 due to this change. lxc is doing a fresh mount of sysfs
> >that never specifies either read-only or nodev regardless of how sysfs
> >has been mounted previously, and this is causing me to see mount
> >failures because of the nodev check.
> >
> >If I comment out only the nodev check then the mount works on my
> >system,
> >but based on the code in lxc I don't think there's any guarantee at all
> >of this mount having flags consistent with previous mounts.
> 
> Seth you are testing your inprogress patchset that
> modifies how nodev works aren't you?
> 
> In rc1 nodev is always forced on a mount in a user namespace.
> 
> There is a fairly easy fix to the nodev cleanup in your
> patchset, but it takes a few lines of code change in
> fs_fully_visible.  Essentially after we get the better
> nodev enforcement, fs_fully_visible does not need
> to bother with nodev.

Drat, you're right. I built an unmodified 4.2-rc1 but I apparently I had
booted to the wrong kernel when I thought I was testing it. Without the
extra patches it's fine; sorry for the noise.

Seth
