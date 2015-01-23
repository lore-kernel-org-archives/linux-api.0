From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [v8 4/5] ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR
 interface support
Date: Fri, 23 Jan 2015 12:39:32 +1100
Message-ID: <20150123013932.GC24722@dastard>
References: <1418102548-5469-1-git-send-email-lixi@ddn.com>
 <1418102548-5469-5-git-send-email-lixi@ddn.com>
 <20141209225758.GB9756@dastard>
 <54C1152F.1080101@yandex-team.ru>
 <20150122155900.GB3062@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150122155900.GB3062-+0h/O2h83AeN3ZZ/Hiejyg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Jan 22, 2015 at 04:59:00PM +0100, Jan Kara wrote:
> On Thu 22-01-15 18:20:15, Konstantin Khlebnikov wrote:
> > Also: is quota for project-id '0' really required for something?
> > It adds overhead but I don't see any use-cases for that.
>   But only if filesystem has project quota feature enabled, no? That
> doesn't concern me too much since the overhead doesn't seem to big and when
> you enable project quotas you likely want to use them ;-). But if you are
> concerned, I'm not strictly opposed to special casing of project id 0. But
> I'd like to see how much speed you gain by that before complicating the
> code...

Except that doing so will result in different behaviour between
filesystems. XFS always *accounts* inodes when quotas are enabled,
but does not allow limits to be placed on quota ID 0.  Hence projid
= 0 accounts all the space not used by other project groups so
admins can easily see how much uncontrolled space is being used.
I've had admins tell me this is one of the features they liked most
about using project quotas because you can't hide from it, even as
root....

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
