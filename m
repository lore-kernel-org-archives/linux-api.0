From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: COW pages and FL_PUNCH_HOLE
Date: Tue, 5 Dec 2017 09:47:28 -0800
Message-ID: <20171205174728.GB26021@bombadil.infradead.org>
References: <20171205153401.GC28760@bombadil.infradead.org>
 <20171205172451.GC6896@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171205172451.GC6896@magnolia>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Dec 05, 2017 at 09:24:51AM -0800, Darrick J. Wong wrote:
> On Tue, Dec 05, 2017 at 07:34:01AM -0800, Matthew Wilcox wrote:
> > 
> > I don't see a discussion of this anywhere ... and I thought linux-api was
> > the right place to ask.
> > 
> > I see holepunch as being "like ftruncate() but for the middle of the file".
> > So it feels weird to me that MAP_PRIVATE behaves differently; truncate
> > will rip out COWed pages, but holepunch won't.  Is there a good reason for
> > this behaviour, and is it too late to change?
> 
> I see truncate as 'change this global size property of a file' which is
> why we'd rip out COWed pages past the new EOF, whereas punch hole is
> more akin to writing zeroes to a certain file range.  This shouldn't
> affect private mappings that a process has already written to and
> therefore gotten its own copy...

Well, gosh darn it, Darrick!  There you go, having a perfectly good
different mental model from mine which makes just as much sense and
corresponds with the current implementation!

> ...but the manpage says "It is unspecified whether changes made to the
> file after the mmap() call are visible in the mapped region." so I guess
> either way is fine?  Though who knows what now depends on the current
> behavior, so changing it would be hard.

Yeah, I withdraw the question.

> Thinking about this more, it seems weird that if you punch a range
> starting before the cow'd page and ending after the cow'd page that a
> reread of that part of the shared mapping now gets you zeroed pages
> except for the cow'd page which is still intact...?

Well, that's true if I do a write of zeroes to a file which has a
MAP_PRIVATE mapping too.  Face it, MAP_PRIVATE just has odd corner
cases ;-)
