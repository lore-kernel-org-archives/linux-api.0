From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/2] mm: introduce MAP_FIXED_SAFE
Date: Thu, 30 Nov 2017 07:58:35 +0100
Message-ID: <20171130065835.dbw4ajh5q5whikhf@dhcp22.suse.cz>
References: <20171129144219.22867-1-mhocko@kernel.org>
 <CAGXu5jLa=b2HhjWXXTQunaZuz11qUhm5aNXHpS26jVqb=G-gfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jLa=b2HhjWXXTQunaZuz11qUhm5aNXHpS26jVqb=G-gfw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Khalid Aziz <khalid.aziz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Abdul Haleem <abdhalee-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed 29-11-17 14:25:36, Kees Cook wrote:
> On Wed, Nov 29, 2017 at 6:42 AM, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > The first patch introduced MAP_FIXED_SAFE which enforces the given
> > address but unlike MAP_FIXED it fails with ENOMEM if the given range
> > conflicts with an existing one. The flag is introduced as a completely
> 
> I still think this name should be better. "SAFE" doesn't say what it's
> safe from...

It is safe in a sense it doesn't perform any address space dangerous
operations. mmap is _inherently_ about the address space so the context
should be kind of clear.

> MAP_FIXED_UNIQUE
> MAP_FIXED_ONCE
> MAP_FIXED_FRESH

Well, I can open a poll for the best name, but none of those you are
proposing sound much better to me. Yeah, naming sucks...
-- 
Michal Hocko
SUSE Labs
