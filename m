From: Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 03/14] VFS: Implement a filesystem superblock
 creation/configuration context [ver #6]
Date: Mon, 30 Oct 2017 09:44:50 +0100
Message-ID: <CAOssrKc8YzWybuuXvMOXgXT6Fqawj3J_sewW+88bxf+O9kTgvw@mail.gmail.com>
References: <150730494491.6182.5139368907374172391.stgit@warthog.procyon.org.uk>
 <150730496982.6182.10042997820796149075.stgit@warthog.procyon.org.uk>
 <CAOssrKfNtKLskdPWS_p87uFzDsZCoN+4L+_bcWBvX18mRVVf_Q@mail.gmail.com>
 <28791.1509035055@warthog.procyon.org.uk> <CAOssrKdm-znRnR80rxvzH8WVWf=sEkL1EGMzV4c3dyp_FK2-rA@mail.gmail.com>
 <29611.1509114932@warthog.procyon.org.uk> <CAOssrKd2MX0ao7f2X32js=72YmZ0exn4KkwdgrXB9tKY7KiSXg@mail.gmail.com>
 <3054.1509120184@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3054.1509120184-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 27, 2017 at 6:03 PM, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> Yes I did mean vfs_parse_sb_flag_option().
>>
>> Yes, I understand its purpose, but it would be cleaner if all the
>> option parsing was done in fc->ops->parse_option().
>>
>> It might be worth introducing the vfs_parse_sb_flag_option(), to be
>> called from ->parse_option().
>
> I was trying to relieve the filesystem of the requirement to have to deal with
> common stuff and also the need to talk directly to the LSM.

No need to talk directly to the LSM:
security_fs_context_parse_option() will do that in VFS code.

How common is common stuff?

dirsync/sync/rw: not handled by all filesystems, those that don't
handle it should reject the option on the new interface

lazytime: handled by generic code, AFAICS, but makes no sense on
read-only fs so those should probably reject it

mand: handled by generic code, but does not make sense for some
filesystems (e.g. those that don't have all the unixy permission
bits).

posixacl: there's no such mount option now.  The options is "acl" and
does not get translated to MS_POSIXACL in mount(8).   Makes zero sense
to add a previously nonexistent option to the new interface.

silent: makes no sense on the new interface, since we should no longer
be putting error messages into the kernel log.

So that leaves async/ro/nolazytime/nomand options to be handled by all
filesystems.

Not sure how to best handle these differences, but the current code
definitely seems lacking, and I cannot imagine a better way than to
pass all options to filesystem's ->parse_option() and add helper(s) to
handle the generic options.

>> > Btw, how would it affect the LSM?
>>
>> LSM would have to reject a "reset" if not enough privileges to
>> *create* a new fs instance, since it essentially requires creating a
>> new config, which is what is done when creating an fs instance.
>
> That's not what I'm asking.  Would the reset change LSM state?  Reset security
> labels and options?

No.   And it wouldn't reset any other option that is immutable (e.g.
server IP address).

Thanks,
Miklos
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
