From: Djalal Harouni <tixxdz@gmail.com>
Subject: Re: [RFC] Add option to mount only a pids subset
Date: Thu, 9 Mar 2017 12:26:49 +0100
Message-ID: <CAEiveUczqzHZG7jcM72oWXAKYZSPJ0ywYEXGDV1sn_FAhr28pA@mail.gmail.com>
References: <20170221145746.GA31914@redhat.com> <20170306230515.GA3453@comp-core-i7-2640m-0182e6>
 <CALCETrVFnSoBP+LvyjN+1qUqrwgZan1nvscq5hV0Ujt_FF2e3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrVFnSoBP+LvyjN+1qUqrwgZan1nvscq5hV0Ujt_FF2e3g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Vasiliy Kulikov <segoon@openwall.com>, Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 7, 2017 at 5:24 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> On Mon, Mar 6, 2017 at 3:05 PM, Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
> >
> > After discussion with Oleg Nesterov I reimplement my patch as an additional
> > option for /proc. This option affects the mountpoint. It means that in one
> > pid namespace it possible to have both the whole traditional /proc and
> > /proc with only pids subset.
> >
>
> I like this.  I think you should split it into two patches, though:
> one that reworks how procfs gets mounted and one that makes adds the
> new functionality.
>
> Djajal had some concerns about the first part breaking applications
> that use stat and expect certain behavior.  This should be manageable,
> though, but making stat work appropriately.

I'm bit lost in the two discussion, however the main concern I was
discussing with Andy was if you have per superblock proc mounts then
each mount will end up with its own device ID st_dev, right now they
share the same ID if they are in the same pid namespace, but if we
change that then we may break the following:
http://man7.org/linux/man-pages/man7/namespaces.7.html

Both new NS_GET_PARENT and NS_GET_USERNS ioctl() that return an fd,
suggests to follow up with fstat() to identify the namespaces..
"By applying fstat(2) to the returned file descriptor, one obtains a
stat structure whose st_dev (resident device) and st_ino (inode
number) fields together identify the owning/parent namespace."

Other /proc/self/ns/* comparison and stat() logic...

Andy suggested that we may have the same st_dev for mounts in the same
pid namespace... I'm not sure which side effect this may bring!

Thanks!

-- 
tixxdz
