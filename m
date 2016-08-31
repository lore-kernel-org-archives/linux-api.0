From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/4] kernel: add a helper to get an owning user namespace
 for a namespace
Date: Wed, 31 Aug 2016 13:38:35 -0700
Message-ID: <CANaxB-zz=tnCSFMsHuGbmhiHa20DGbybWo=xdeeiDwJyoMxmYQ@mail.gmail.com>
References: <1472252891-4963-1-git-send-email-avagin@openvz.org>
 <1472252891-4963-2-git-send-email-avagin@openvz.org> <20160831025605.GA21788@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160831025605.GA21788-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Aug 30, 2016 at 7:56 PM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> On Fri, Aug 26, 2016 at 04:08:08PM -0700, Andrei Vagin wrote:
>> +struct ns_common *ns_get_owner(struct ns_common *ns)
>> +{
>> +     struct user_namespace *my_user_ns = current_user_ns();
>> +     struct user_namespace *owner, *p;
>> +
>> +     /* See if the owner is in the current user namespace */
>> +     owner = p = ns->ops->get_owner(ns);
>> +     for (;;) {
>> +             if (!p)
>> +                     return ERR_PTR(-EPERM);
>> +             if (p == my_user_ns)
>> +                     break;
>> +             p = p->parent;
>> +     }
>> +
>> +     return &get_user_ns(owner)->ns;
>
> get_user_ns() bumps the owner's refcount.  I don't see where
> this is being dropped, especially when ns_ioctl() uses it in
> the next patch.

It is dropped in __ns_get_path if a namespace has a dentry, otherwise
it is dropped from nsfs_evict.

static void *__ns_get_path(struct path *path, struct ns_common *ns)
        |                return -EPERM;
...
        ns->ops->put(ns);                                                      |
got_it:
        |        /* See if the owner is in the current user namespace
*/
        path->mnt = mnt;
        |        owner = p = ns->ops->get_owner(ns);
        path->dentry = dentry;
        |        for (;;) {
        return NULL;
...

static void nsfs_evict(struct inode *inode)                                    |
{
        |        if (!ns_capable(user_ns, CAP_SYS_ADMIN))
        struct ns_common *ns = inode->i_private;
        |                return -EPERM;
        clear_inode(inode);                                                    |
        ns->ops->put(ns);
        |        cred = prepare_creds();
}

> _______________________________________________
> Containers mailing list
> Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
