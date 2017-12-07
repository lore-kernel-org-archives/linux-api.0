From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 0/2] mm: introduce MAP_FIXED_SAFE
Date: Thu, 7 Dec 2017 11:57:27 -0800
Message-ID: <20171207195727.GA26792@bombadil.infradead.org>
References: <20171129144219.22867-1-mhocko@kernel.org>
 <CAGXu5jLa=b2HhjWXXTQunaZuz11qUhm5aNXHpS26jVqb=G-gfw@mail.gmail.com>
 <20171130065835.dbw4ajh5q5whikhf@dhcp22.suse.cz>
 <20171201152640.GA3765@rei>
 <87wp20e9wf.fsf@concordia.ellerman.id.au>
 <20171206045433.GQ26021@bombadil.infradead.org>
 <20171206070355.GA32044@bombadil.infradead.org>
 <87bmjbks4c.fsf@concordia.ellerman.id.au>
 <CAGXu5jLWRQn6EaXEEvdvXr+4gbiJawwp1EaLMfYisHVfMiqgSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jLWRQn6EaXEEvdvXr+4gbiJawwp1EaLMfYisHVfMiqgSA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Khalid Aziz <khalid.aziz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Abdul Haleem <abdhalee-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Dec 07, 2017 at 11:14:27AM -0800, Kees Cook wrote:
> On Wed, Dec 6, 2017 at 9:46 PM, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org> wrote:
> > Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> writes:
> >> So, just like we currently say "exactly one of MAP_SHARED or MAP_PRIVATE",
> >> we could add a new paragraph saying "at most one of MAP_FIXED or
> >> MAP_REQUIRED" and "any of the following values".
> >
> > MAP_REQUIRED doesn't immediately grab me, but I don't actively dislike
> > it either :)
> >
> > What about MAP_AT_ADDR ?
> >
> > It's short, and says what it does on the tin. The first argument to mmap
> > is actually called "addr" too.
> 
> "FIXED" is supposed to do this too.
> 
> Pavel suggested:
> 
> MAP_ADD_FIXED
> 
> (which is different from "use fixed", and describes why it would fail:
> can't add since it already exists.)
> 
> Perhaps "MAP_FIXED_NEW"?
> 
> There has been a request to drop "FIXED" from the name, so these:
> 
> MAP_FIXED_NOCLOBBER
> MAP_FIXED_NOREPLACE
> MAP_FIXED_ADD
> MAP_FIXED_NEW
> 
> Could be:
> 
> MAP_NOCLOBBER
> MAP_NOREPLACE
> MAP_ADD
> MAP_NEW
> 
> and we still have the unloved, but acceptable:
> 
> MAP_REQUIRED
> 
> My vote is still for "NOREPLACE" or "NOCLOBBER" since it's very
> specific, though "NEW" is pretty clear too.

How about MAP_NOFORCE?
