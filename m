From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: How Not To Use kref (was Re: kdbus: add code for buses, domains
 and endpoints)
Date: Fri, 31 Oct 2014 19:56:07 +0000
Message-ID: <20141031195607.GM7996@ZenIV.linux.org.uk>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <1414620056-6675-9-git-send-email-gregkh@linuxfoundation.org>
 <20141030233801.GF7996@ZenIV.linux.org.uk>
 <CA+55aFxB=jWGvPH3TMhB=ungOg9TBai5Ak-ma5vChBB-H2AgnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFxB=jWGvPH3TMhB=ungOg9TBai5Ak-ma5vChBB-H2AgnQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Simon McVittie <simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Alban Crequy <alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Oct 31, 2014 at 11:00:01AM -0700, Linus Torvalds wrote:
> On Thu, Oct 30, 2014 at 4:38 PM, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrote:
> >
> > If you remove an object from some search structures, taking the lock in
> > destructor is Too Fucking Late(tm).  Somebody might have already found
> > that puppy and decided to pick it (all under that lock) just as we'd
> > got to that point in destructor and blocked there.  Oops...
> 
> Ugh, yes. This is a much too common anti-pattern.

*nod*

kref is badly oversold; it's fine for the case when there's no non-counting
references to the object, but in this kind of situations the things get
subtle.  And the main attraction of kref is the promise that it's easy to
use and avoids all the subtle issues.  It's not specific to kref, of course -
the same breakage can and does occur when refcounting is open-coded; for
example, we used to have that kind of bug in dput().  What makes it really
unpleasant is that easy-to-use-don't-worry-it-takes-care-of-everything
assumption...

FWIW, here's another lovely instance (drivers/infiniband/hw/ipath/ipath_mmap.c):
static void ipath_vma_close(struct vm_area_struct *vma)
{
        struct ipath_mmap_info *ip = vma->vm_private_data;

        kref_put(&ip->ref, ipath_release_mmap_info);
}
void ipath_release_mmap_info(struct kref *ref)
{
        struct ipath_mmap_info *ip =
                container_of(ref, struct ipath_mmap_info, ref);
        struct ipath_ibdev *dev = to_idev(ip->context->device);

        spin_lock_irq(&dev->pending_lock);
        list_del(&ip->pending_mmaps);
        spin_unlock_irq(&dev->pending_lock);

        vfree(ip->obj);
        kfree(ip);
}
static void ipath_vma_open(struct vm_area_struct *vma)
{
        struct ipath_mmap_info *ip = vma->vm_private_data;

        kref_get(&ip->ref);
}
int ipath_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
{
...
        spin_lock_irq(&dev->pending_lock);
        list_for_each_entry_safe(ip, pp, &dev->pending_mmaps,
                /* Only the creator is allowed to mmap the object */
                if (context != ip->context || (__u64) offset != ip->offset)
                        continue;
                /* Don't allow a mmap larger than the object. */
                if (size > ip->size)
                        break;

                list_del_init(&ip->pending_mmaps);
                spin_unlock_irq(&dev->pending_lock);

                ret = remap_vmalloc_range(vma, ip->obj, 0);
                if (ret)
                        goto done;
                vma->vm_ops = &ipath_vm_ops;
                vma->vm_private_data = ip;
                ipath_vma_open(vma);
                goto done;


> > Normally I'd say "just use kref_put_mutex()", but this case is even worse.
> > Look:
> 
> Yeah the whole "release the structure the lock is in" is another one.
> 
> Both of these patterns have happened so many times that I'd love to
> have some kind of automated tool to see them, but I suspect it is
> *much* too complex to be easily checked for.

Especially since here the lock is *not* in the object being fed to
destructor - it's in the object ours holds a reference to, with destructor
dropping that reference and _sometimes_ it ends up being the last one.

As for the first pattern...  Frankly, git grep -n -w kref_put, followed
by quick look through the destructors for something like list_del catches
a _lot_ of that ;-/  Not every match is a bug of that sort, but the
fraction of false positives is not too high...
