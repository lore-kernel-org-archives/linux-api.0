From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATCH 0/7] Mount, FS, Block and Keyrings notifications
Date: Wed, 29 May 2019 10:40:11 +0300
Message-ID: <CAOQ4uxiBMmDg2Rn2+jsexTdK7g25J7WD79chDdRvofrvC_PLXQ@mail.gmail.com>
References: <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk>
 <CAOQ4uxjC1M7jwjd9zSaSa6UW2dbEjc+ZbFSo7j9F1YHAQxQ8LQ@mail.gmail.com> <22971.1559112346@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <22971.1559112346@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-api@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, keyrings@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
List-Id: linux-api@vger.kernel.org

On Wed, May 29, 2019 at 9:45 AM David Howells <dhowells@redhat.com> wrote:
>
> Amir Goldstein <amir73il@gmail.com> wrote:
>
> > I am interested to know how you envision filesystem notifications would
> > look with this interface.
>
> What sort of events are you thinking of by "filesystem notifications"?  You
> mean things like file changes?

I mean all the events provided by
http://man7.org/linux/man-pages/man7/fanotify.7.html

Which was recently (v4.20) extended to support watching a super block
and more recently (v5.1) extended to support watching directory entry
modifications.

Thanks,
Amir.
