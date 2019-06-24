From: Miklos Szeredi <mszeredi@redhat.com>
Subject: Re: [PATCH 05/13] vfs: don't parse "silent" option
Date: Mon, 24 Jun 2019 10:25:49 +0200
Message-ID: <CAOssrKcU2JKDYMDbW7V6jpM7_4WFSMA91h9AjpjoYmX=H4ybeg@mail.gmail.com>
References: <20190619123019.30032-1-mszeredi@redhat.com> <20190619123019.30032-5-mszeredi@redhat.com>
 <1ea8ec52ce19499f021510b5c9e38be8d8ebe38f.camel@themaw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1ea8ec52ce19499f021510b5c9e38be8d8ebe38f.camel@themaw.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Ian Kent <raven@themaw.net>
Cc: David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 20, 2019 at 6:40 AM Ian Kent <raven@themaw.net> wrote:
>
> On Wed, 2019-06-19 at 14:30 +0200, Miklos Szeredi wrote:
> > While this is a standard option as documented in mount(8), it is ignored by
> > most filesystems.  So reject, unless filesystem explicitly wants to handle
> > it.
> >
> > The exception is unconverted filesystems, where it is unknown if the
> > filesystem handles this or not.
> >
> > Any implementation, such as mount(8) that needs to parse this option
> > without failing should simply ignore the return value from fsconfig().
>
> In theory this is fine but every time someone has attempted
> to change the handling of this in the past autofs has had
> problems so I'm a bit wary of the change.
>
> It was originally meant to tell the file system to ignore
> invalid options such as could be found in automount maps that
> are used with multiple OS implementations that have differences
> in their options.
>
> That was, IIRC, primarily NFS although NFS should handle most
> (if not all of those) cases these days.
>
> Nevertheless I'm a bit nervous about it, ;)

What I'm saying is that with a new interface the rules need not follow
the rules of the old interface, because at the start no one is using
the new interface, so no chance of breaking anything.

Yes, there's a chance of making the interface difficult to use, but I
don't think this is one of those things.

For one, "silent" should not be needed on the new interface at all,
because error messages relating to the setup of the filesystem can be
redirected to a log buffer dedicated to the setup instance,
effectively enabling silent operation by default.

Thanks.,
Miklos
