From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Wed, 6 May 2015 19:21:46 -0400
Message-ID: <20150506232146.GB12706@thunk.org>
References: <1430949612-21356-1-git-send-email-zab@redhat.com>
 <CAHQdGtS0=Gjyq2E2QO+zu_HAzdrHJwxtfZ8MB5q0DjWHMEc7hw@mail.gmail.com>
 <alpine.DEB.2.00.1505061515550.28239@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1505061515550.28239-vIokxiIdD2AQNTJnQDzGJqxOck334EZe@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sage Weil <sweil-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, May 06, 2015 at 03:19:13PM -0700, Sage Weil wrote:
> > Just out of curiosity, if you need to modify the application anyway,
> > why wouldn't use of fdatasync() when flushing be able to offer a
> > similar performance boost?
> 
> Although fdatasync(2) doesn't have to update synchronously, it does 
> eventually get written, and that can trigger lots of unwanted IO.

Something that might be worth trying out is using MS_LAZYTIME plus
fdatasync(2).  That should significantly reduce the unwanted IO, while
eventually letting the mtimes get updated, plus allowing updates of
adjacent inodes in the same inode table block update the mtime "for
free".

Regards,

					- Ted
