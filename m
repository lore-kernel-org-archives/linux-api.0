From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 03/14] VFS: Implement a filesystem superblock creation/configuration context [ver #6]
Date: Fri, 27 Oct 2017 17:03:04 +0100
Message-ID: <3054.1509120184@warthog.procyon.org.uk>
References: <CAOssrKd2MX0ao7f2X32js=72YmZ0exn4KkwdgrXB9tKY7KiSXg@mail.gmail.com> <150730494491.6182.5139368907374172391.stgit@warthog.procyon.org.uk> <150730496982.6182.10042997820796149075.stgit@warthog.procyon.org.uk> <CAOssrKfNtKLskdPWS_p87uFzDsZCoN+4L+_bcWBvX18mRVVf_Q@mail.gmail.com> <28791.1509035055@warthog.procyon.org.uk> <CAOssrKdm-znRnR80rxvzH8WVWf=sEkL1EGMzV4c3dyp_FK2-rA@mail.gmail.com> <29611.1509114932@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOssrKd2MX0ao7f2X32js=72YmZ0exn4KkwdgrXB9tKY7KiSXg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-ID: <3053.1509120184.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Yes I did mean vfs_parse_sb_flag_option().
> 
> Yes, I understand its purpose, but it would be cleaner if all the
> option parsing was done in fc->ops->parse_option().
> 
> It might be worth introducing the vfs_parse_sb_flag_option(), to be
> called from ->parse_option().

I was trying to relieve the filesystem of the requirement to have to deal with
common stuff and also the need to talk directly to the LSM.

> > Btw, how would it affect the LSM?
> 
> LSM would have to reject a "reset" if not enough privileges to
> *create* a new fs instance, since it essentially requires creating a
> new config, which is what is done when creating an fs instance.

That's not what I'm asking.  Would the reset change LSM state?  Reset security
labels and options?

> > Sorry, how does the new, clean one do it without handling these options?
> > There is no MS_* mask passed in, except to fsmount().
> 
> The new one certainly should.

Should what?

> Ignoring unknown flags/options is generally a bad idea.

They're not unknown - just not of interest to the filesystem.

David
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
