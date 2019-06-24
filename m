From: Miklos Szeredi <mszeredi@redhat.com>
Subject: Re: [PATCH 05/13] vfs: don't parse "silent" option
Date: Mon, 24 Jun 2019 12:44:43 +0200
Message-ID: <CAOssrKdGSRVSc38X1J0zCQQN+tUhiwPA4bCL0rHCZ-O8iVzzeQ@mail.gmail.com>
References: <20190619123019.30032-1-mszeredi@redhat.com> <20190619123019.30032-5-mszeredi@redhat.com>
 <1ea8ec52ce19499f021510b5c9e38be8d8ebe38f.camel@themaw.net>
 <CAOssrKcU2JKDYMDbW7V6jpM7_4WFSMA91h9AjpjoYmX=H4ybeg@mail.gmail.com> <30205.1561372589@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <30205.1561372589@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Ian Kent <raven@themaw.net>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 24, 2019 at 12:36 PM David Howells <dhowells@redhat.com> wrote:
>
> Miklos Szeredi <mszeredi@redhat.com> wrote:
>
> > What I'm saying is that with a new interface the rules need not follow
> > the rules of the old interface, because at the start no one is using
> > the new interface, so no chance of breaking anything.
>
> Er. No.  That's not true, since the old interface comes through the new one.

No, old interface sets SB_* directly from arg 4 of mount(2) and not
via parsing arg 5.

Thanks,
Miklos
