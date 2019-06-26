From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH 00/25] VFS: Introduce filesystem information query
 syscall [ver #14]
Date: Wed, 26 Jun 2019 16:50:32 +0200
Message-ID: <20190626145031.nvpekusplnt5kqw5@brauner.io>
References: <20190626131902.6xat2ab65arc62td@brauner.io>
 <156138532485.25627.7459410522109581052.stgit@warthog.procyon.org.uk>
 <20190626100525.irdehd24jowz5f75@brauner.io>
 <9360.1561559497@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9360.1561559497@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, raven@themaw.net, mszeredi@redhat.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Jun 26, 2019 at 03:31:37PM +0100, David Howells wrote:
> Christian Brauner <christian@brauner.io> wrote:
> 
> > And I also very much recommend to remove any potential cross-dependency
> > between the fsinfo() and the notification patchset.
> 
> The problem with that is that to make the notification patchset useful for
> mount notifications, you need some information that you would obtain through
> fsinfo().

But would it really be that bad if you'd just land fsinfo() and then
focus on the notification stuff. This very much rather looks like a
timing issue than a conceptual one, i.e. you could very much just push
fsinfo() and leave the notification stuff alone until that is done.

Once fsinfo() has landed you can then go on to put additional bits you
need from or for fsinfo() for the notification patchset in there. Seems
you have at least sketched both APIs sufficiently that you know what you
need to look out for to not cause any regressions later on when you need
to expand them.

Christian
