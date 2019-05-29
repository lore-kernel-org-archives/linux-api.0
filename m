From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [RFC][PATCH 0/7] Mount, FS, Block and Keyrings notifications
Date: Wed, 29 May 2019 08:10:53 -0700
Message-ID: <20190529151053.GA10231@kroah.com>
References: <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk>
 <CAOQ4uxjC1M7jwjd9zSaSa6UW2dbEjc+ZbFSo7j9F1YHAQxQ8LQ@mail.gmail.com>
 <20190529142504.GC32147@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190529142504.GC32147@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Amir Goldstein <amir73il@gmail.com>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-api@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, keyrings@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, May 29, 2019 at 04:25:04PM +0200, Jan Kara wrote:
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

This patchset is looking to create a "generic" kernel notification
system, so I think the question is valid.  It's up to the requestor to
ask for the specific type of notification.

thanks,

greg k-h
