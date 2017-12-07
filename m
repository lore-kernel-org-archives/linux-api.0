From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH 0/2] mm: introduce MAP_FIXED_SAFE
Date: Thu, 07 Dec 2017 16:46:11 +1100
Message-ID: <87bmjbks4c.fsf@concordia.ellerman.id.au>
References: <20171129144219.22867-1-mhocko@kernel.org> <CAGXu5jLa=b2HhjWXXTQunaZuz11qUhm5aNXHpS26jVqb=G-gfw@mail.gmail.com> <20171130065835.dbw4ajh5q5whikhf@dhcp22.suse.cz> <20171201152640.GA3765@rei> <87wp20e9wf.fsf@concordia.ellerman.id.au> <20171206045433.GQ26021@bombadil.infradead.org> <20171206070355.GA32044@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171206070355.GA32044-PfSpb0PWhxZc2C7mugBRk2EX/6BAtgUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Khalid Aziz <khalid.aziz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Abdul Haleem <abdhalee-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> writes:

> On Tue, Dec 05, 2017 at 08:54:35PM -0800, Matthew Wilcox wrote:
>> On Wed, Dec 06, 2017 at 03:51:44PM +1100, Michael Ellerman wrote:
>> > Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org> writes:
>> > 
>> > > Hi!
>> > >> > MAP_FIXED_UNIQUE
>> > >> > MAP_FIXED_ONCE
>> > >> > MAP_FIXED_FRESH
>> > >> 
>> > >> Well, I can open a poll for the best name, but none of those you are
>> > >> proposing sound much better to me. Yeah, naming sucks...
>> > >
>> > > Given that MAP_FIXED replaces the previous mapping MAP_FIXED_NOREPLACE
>> > > would probably be a best fit.
>> > 
>> > Yeah that could work.
>> > 
>> > I prefer "no clobber" as I just suggested, because the existing
>> > MAP_FIXED doesn't politely "replace" a mapping, it destroys the current
>> > one - which you or another thread may be using - and clobbers it with
>> > the new one.
>> 
>> It's longer than MAP_FIXED_WEAK :-P
>> 
>> You'd have to be pretty darn strong to clobber an existing mapping.
>
> I think we're thinking about this all wrong.  We shouldn't document it as
> "This is a variant of MAP_FIXED".  We should document it as "Here's an
> alternative to MAP_FIXED".
>
> So, just like we currently say "exactly one of MAP_SHARED or MAP_PRIVATE",
> we could add a new paragraph saying "at most one of MAP_FIXED or
> MAP_REQUIRED" and "any of the following values".
>
> Now, we should implement MAP_REQUIRED as having each architecture
> define _MAP_NOT_A_HINT, and then #define MAP_REQUIRED (MAP_FIXED |
> _MAP_NOT_A_HINT), but that's not information to confuse users with.
>
> Also, that lets us add a third option at some point that is Yet Another
> Way to interpret the 'addr' argument, by having MAP_FIXED clear and
> _MAP_NOT_A_HINT set.
>
> I'm not set on MAP_REQUIRED.  I came up with some awful names
> (MAP_TODDLER, MAP_TANTRUM, MAP_ULTIMATUM, MAP_BOSS, MAP_PROGRAM_MANAGER,
> etc).  But I think we should drop FIXED from the middle of the name.

MAP_REQUIRED doesn't immediately grab me, but I don't actively dislike
it either :)

What about MAP_AT_ADDR ?

It's short, and says what it does on the tin. The first argument to mmap
is actually called "addr" too.

cheers
