From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 4/7] xfs: Implement fallocate query support mode
Date: Tue, 19 Sep 2017 07:13:58 -0700
Message-ID: <20170919141358.GA4202@infradead.org>
References: <1505749947-26360-1-git-send-email-lczerner@redhat.com>
 <1505749947-26360-5-git-send-email-lczerner@redhat.com>
 <20170918175651.GA7937@infradead.org>
 <20170919081538.mk23eue6dysv67b2@rh_laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170919081538.mk23eue6dysv67b2@rh_laptop>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Czerner <lczerner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Sep 19, 2017 at 10:15:38AM +0200, Lukas Czerner wrote:
> On Mon, Sep 18, 2017 at 10:56:51AM -0700, Christoph Hellwig wrote:
> > This seems to miss any explanation and 6 out of 7 patches.
> 
> See linux-fsdevel for entire patch set.
> https://www.spinics.net/lists/linux-fsdevel/msg115740.html

But only one made it to linux-xfs, so please fix your patch sending.

> (f)pathconf on it's own is useless because I need to get this
> information directly from the file system. Supported fallocate modes can
> differ with inode flags (encrypted files, extent/indirect based files on
> ext4). I also need in-kernel interface.

And that is exactly what I want you to do:  finally bite the bullet
and add pathconf inode operation.
