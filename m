From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: Should mmap MAP_LOCKED fail if mm_poppulate fails?
Date: Tue, 28 Apr 2015 11:38:35 -0700
Message-ID: <CA+55aFyajquhGhw59qNWKGK4dBV0TPmDD7-1XqPo7DZWvO_hPg@mail.gmail.com>
References: <20150114095019.GC4706@dhcp22.suse.cz>
	<1430223111-14817-1-git-send-email-mhocko@suse.cz>
	<CA+55aFxzLXx=cC309h_tEc-Gkn_zH4ipR7PsefVcE-97Uj066g@mail.gmail.com>
	<20150428164302.GI2659@dhcp22.suse.cz>
	<CA+55aFydkG-BgZzry5DrTzueVh9VvEcVJdLV8iOyUphQk=0vpw@mail.gmail.com>
	<20150428183535.GB30918@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150428183535.GB30918-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 28, 2015 at 11:35 AM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
>
> I am still not sure I see the problem here.

Basically, I absolutely hate the notion of us doing something
unsynchronized, when I can see us undoing a mmap that another thread
is doing. It's wrong.

You also didn't react to all the *other* things that were wrong in
that patch-set. The games you play with !fatal_signal_pending() etc
are just crazy.

End result: I absolutely detest the whole thing. I told you what I
consider an acceptable solution instead, that is much simpler and
doesn't have any of the problems of your patchset.

                      Linus
