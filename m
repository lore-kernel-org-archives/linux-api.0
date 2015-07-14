From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Tue, 14 Jul 2015 13:44:49 +0200
Message-ID: <20150714114448.GA31973@amd>
References: <1430949612-21356-1-git-send-email-zab@redhat.com>
 <20150507002617.GJ4327@dastard>
 <20150507172053.GA659@lenny.home.zabbo.net>
 <CAFLxGvw8ESrM6vZ4iB70JFQN-qR-Trs3j1O_+y36tSOn0GVH4A@mail.gmail.com>
 <CALCETrWNDMq0nK3ac-uZweV5BKK_yWTQHH5D0YkyEu7bcONo9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWNDMq0nK3ac-uZweV5BKK_yWTQHH5D0YkyEu7bcONo9g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Richard Weinberger <richard.weinberger@gmail.com>, Zach Brown <zab@redhat.com>, Dave Chinner <david@fromorbit.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Sage Weil <sweil@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu 2015-05-07 12:53:46, Andy Lutomirski wrote:
> On Thu, May 7, 2015 at 12:09 PM, Richard Weinberger
> <richard.weinberger@gmail.com> wrote:
> > On Thu, May 7, 2015 at 7:20 PM, Zach Brown <zab@redhat.com> wrote:
> >> On Thu, May 07, 2015 at 10:26:17AM +1000, Dave Chinner wrote:
> >>> On Wed, May 06, 2015 at 03:00:12PM -0700, Zach Brown wrote:
> >>> > Add the O_NOMTIME flag which prevents mtime from being updated which can
> >>> > greatly reduce the IO overhead of writes to allocated and initialized
> >>> > regions of files.
> >>>
> >>> Hmmm. How do backup programs now work out if the file has changed
> >>> and hence needs copying again? ie. applications using this will
> >>> break other critical infrastructure in subtle ways.
> >>
> >> By using backup infrastructure that doesn't use cmtime.  Like btrfs
> >> send/recv.  Or application level backups that know how to do
> >> incrementals from metadata in giant database files, say, without
> >> walking, comparing, and copying the entire thing.
> >
> > But how can Joey random user know that some of his
> > applications are using O_NOMTIME and his KISS backup
> > program does no longer function as expected?
> >
> 
> Joey random user can't have a working KISS backup anyway, though,
> because we screw up mtime updates on mmap writes.  I have patches
> gathering dust that fix that, though.

I'm using unison, and yes, I believe I already seen failures from
mmap(). I'd like to see that fixed, and I can test the patches.

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
