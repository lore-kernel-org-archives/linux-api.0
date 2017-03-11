From: Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] Add option to mount only a pids subset
Date: Sat, 11 Mar 2017 22:51:02 +0100
Message-ID: <20170311215102.GF4554@comp-core-i7-2640m-0182e6>
References: <20170221145746.GA31914@redhat.com>
 <20170306230515.GA3453@comp-core-i7-2640m-0182e6>
 <CALCETrVFnSoBP+LvyjN+1qUqrwgZan1nvscq5hV0Ujt_FF2e3g@mail.gmail.com>
 <CAEiveUczqzHZG7jcM72oWXAKYZSPJ0ywYEXGDV1sn_FAhr28pA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAEiveUczqzHZG7jcM72oWXAKYZSPJ0ywYEXGDV1sn_FAhr28pA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Vasiliy Kulikov <segoon-cxoSlKxDwOJWk0Htik3J/w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 09, 2017 at 12:26:49PM +0100, Djalal Harouni wrote:
> I'm bit lost in the two discussion, however the main concern I was
> discussing with Andy was if you have per superblock proc mounts then
> each mount will end up with its own device ID st_dev, right now they
> share the same ID if they are in the same pid namespace, but if we
> change that then we may break the following:
> http://man7.org/linux/man-pages/man7/namespaces.7.html

In fact, nothing has changed. I added a parameter that affects
the mountpoint, not the entire pid namespace.

The procfs will still be global. The device ID will be the same as before.

> Both new NS_GET_PARENT and NS_GET_USERNS ioctl() that return an fd,
> suggests to follow up with fstat() to identify the namespaces..
> "By applying fstat(2) to the returned file descriptor, one obtains a
> stat structure whose st_dev (resident device) and st_ino (inode
> number) fields together identify the owning/parent namespace."
> 
> Other /proc/self/ns/* comparison and stat() logic...
> 
> Andy suggested that we may have the same st_dev for mounts in the same
> pid namespace... I'm not sure which side effect this may bring!

Basically we have here a issue because other proc options (hidepid for
example) affect the entire pid namespace, but, I guess, have to affect
the mountpoint.

# grep ^proc /proc/mounts 
proc /proc proc rw,relatime 0 0

# mount -t proc proc /tmp/proc
# mount -o remount,hidepid=2 -t proc proc /tmp/proc

# grep ^proc /proc/mounts 
proc /proc proc rw,relatime,hidepid=2 0 0
proc /tmp/proc proc rw,relatime,hidepid=2 0 0

-- 
Rgrds, legion
