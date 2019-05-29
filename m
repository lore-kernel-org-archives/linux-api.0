From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATCH 0/7] Mount, FS, Block and Keyrings notifications
Date: Wed, 29 May 2019 18:53:21 +0300
Message-ID: <CAOQ4uxjLzURf8c1UH_xCJKkuD2es8i-=P-ZNM=t3aFcZLMwXEg@mail.gmail.com>
References: <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk>
 <CAOQ4uxjC1M7jwjd9zSaSa6UW2dbEjc+ZbFSo7j9F1YHAQxQ8LQ@mail.gmail.com> <20190529142504.GC32147@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190529142504.GC32147@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-api@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, keyrings@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

> > David,
> >
> > I am interested to know how you envision filesystem notifications would
> > look with this interface.
> >
> > fanotify can certainly benefit from providing a ring buffer interface to read
> > events.
> >
> > From what I have seen, a common practice of users is to monitor mounts
> > (somehow) and place FAN_MARK_MOUNT fanotify watches dynamically.
> > It'd be good if those users can use a single watch mechanism/API for
> > watching the mount namespace and filesystem events within mounts.
> >
> > A similar usability concern is with sb_notify and FAN_MARK_FILESYSTEM.
> > It provides users with two complete different mechanisms to watch error
> > and filesystem events. That is generally not a good thing to have.
> >
> > I am not asking that you implement fs_notify() before merging sb_notify()
> > and I understand that you have a use case for sb_notify().
> > I am asking that you show me the path towards a unified API (how a
> > typical program would look like), so that we know before merging your
> > new API that it could be extended to accommodate fsnotify events
> > where the final result will look wholesome to users.
>
> Are you sure we want to combine notification about file changes etc. with
> administrator-type notifications about the filesystem? To me these two
> sound like rather different (although sometimes related) things.
>

Well I am sure that ring buffer for fanotify events would be useful, so
seeing that David is proposing a generic notification mechanism, I wanted
to know how that mechanism could best share infrastructure with fsnotify.

But apart from that I foresee the questions from users about why the
mount notification API and filesystem events API do not have better
integration.

The way I see it, the notification queue can serve several classes
of notifications and fsnotify could be one of those classes
(at least FAN_CLASS_NOTIF fits nicely to the model).

Thanks,
Amir.
