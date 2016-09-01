From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] kernel: add a helper to get an owning user namespace
	for a namespace
Date: Thu, 1 Sep 2016 00:12:54 -0500
Message-ID: <20160901051254.GA5893@mail.hallyn.com>
References: <1472252891-4963-1-git-send-email-avagin@openvz.org>
	<1472252891-4963-2-git-send-email-avagin@openvz.org>
	<20160831025605.GA21788@mail.hallyn.com>
	<CANaxB-zz=tnCSFMsHuGbmhiHa20DGbybWo=xdeeiDwJyoMxmYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANaxB-zz=tnCSFMsHuGbmhiHa20DGbybWo=xdeeiDwJyoMxmYQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Aug 31, 2016 at 01:38:35PM -0700, Andrey Vagin wrote:
> On Tue, Aug 30, 2016 at 7:56 PM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> > On Fri, Aug 26, 2016 at 04:08:08PM -0700, Andrei Vagin wrote:
> >> +struct ns_common *ns_get_owner(struct ns_common *ns)
> >> +{
> >> +     struct user_namespace *my_user_ns = current_user_ns();
> >> +     struct user_namespace *owner, *p;
> >> +
> >> +     /* See if the owner is in the current user namespace */
> >> +     owner = p = ns->ops->get_owner(ns);
> >> +     for (;;) {
> >> +             if (!p)
> >> +                     return ERR_PTR(-EPERM);
> >> +             if (p == my_user_ns)
> >> +                     break;
> >> +             p = p->parent;
> >> +     }
> >> +
> >> +     return &get_user_ns(owner)->ns;
> >
> > get_user_ns() bumps the owner's refcount.  I don't see where
> > this is being dropped, especially when ns_ioctl() uses it in
> > the next patch.
> 
> It is dropped in __ns_get_path if a namespace has a dentry, otherwise
> it is dropped from nsfs_evict.
> 
> static void *__ns_get_path(struct path *path, struct ns_common *ns)
>         |                return -EPERM;
> ...
>         ns->ops->put(ns);                                                      |
> got_it:
>         |        /* See if the owner is in the current user namespace
> */
>         path->mnt = mnt;
>         |        owner = p = ns->ops->get_owner(ns);
>         path->dentry = dentry;
>         |        for (;;) {
>         return NULL;
> ...
> 
> static void nsfs_evict(struct inode *inode)                                    |
> {
>         |        if (!ns_capable(user_ns, CAP_SYS_ADMIN))
>         struct ns_common *ns = inode->i_private;
>         |                return -EPERM;
>         clear_inode(inode);                                                    |
>         ns->ops->put(ns);
>         |        cred = prepare_creds();
> }

Gotcha, thanks.
