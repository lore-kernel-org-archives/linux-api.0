From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [CFT][PATCH 0/10] Making new mounts of proc and sysfs as safe as bind mounts
Date: Fri, 15 May 2015 01:55:38 -0500
Message-ID: <87617u1g9h.fsf@x220.int.ebiederm.org>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
	<20150514202951.GA16416@kroah.com>
	<87oalmg90j.fsf@x220.int.ebiederm.org>
	<CALCETrU1yxcDfv4YV3wVpWMAdiOOsSUFOPUpFAN-mVA4M-OxdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrU1yxcDfv4YV3wVpWMAdiOOsSUFOPUpFAN-mVA4M-OxdQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Andy Lutomirski's message of "Thu, 14 May 2015 23:26:48 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?utf-8?Q?St=C3=A9phane?= Graber <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Eric Windisch <ewindisch-FCduhRhOUaTQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:

> Can we please just get rid of this implicit nodev thing once and for all?  If it
> breaks some really weird /proc use case, then I think the right fix is to
> stop enforcing the nodev lock for the proc fully visible check.  After
> all, /proc doesn't contain useful device nodes anyway.

On second look I don't think that will actually cause issues in this
case.

I actually have a fix for the implicit nodev weirdness in my development
qeueue but it requires figuring out how to add s_user_ns to superblocks.
My last round of testing told me I was doing that wrong.

But if the implicit nodev is actually a problem I will definitely delay
this until I have that change ready to go as well.

> Other than that, the code here looks okay to me on brief inspection.

At a practical level I am concerned that enforcing things like noexec
and nosuid from the original normal global proc might cause problems for
things like sandstorm, lxc, and possibly libvirt-lxc.  So I would really
appreciate if people associated with those projects could test this and
tell me if I break things.

Other than my stupid refactor in my code for /proc/fs/nfsd that causes
the kernel to oops :(  Doh!

Eric
