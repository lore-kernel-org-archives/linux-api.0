From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [RFC] Add option to mount only a pids subset
Date: Thu, 09 Mar 2017 14:52:46 -0600
Message-ID: <877f3ydvfl.fsf@xmission.com>
References: <20170221145746.GA31914@redhat.com>
        <20170306230515.GA3453@comp-core-i7-2640m-0182e6>
        <CALCETrVFnSoBP+LvyjN+1qUqrwgZan1nvscq5hV0Ujt_FF2e3g@mail.gmail.com>
        <CAEiveUczqzHZG7jcM72oWXAKYZSPJ0ywYEXGDV1sn_FAhr28pA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAEiveUczqzHZG7jcM72oWXAKYZSPJ0ywYEXGDV1sn_FAhr28pA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
        (Djalal Harouni's message of "Thu, 9 Mar 2017 12:26:49 +0100")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Vasiliy Kulikov <segoon-cxoSlKxDwOJWk0Htik3J/w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:

> On Tue, Mar 7, 2017 at 5:24 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>>
>> On Mon, Mar 6, 2017 at 3:05 PM, Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> > After discussion with Oleg Nesterov I reimplement my patch as an additional
>> > option for /proc. This option affects the mountpoint. It means that in one
>> > pid namespace it possible to have both the whole traditional /proc and
>> > /proc with only pids subset.
>> >
>>
>> I like this.  I think you should split it into two patches, though:
>> one that reworks how procfs gets mounted and one that makes adds the
>> new functionality.
>>
>> Djajal had some concerns about the first part breaking applications
>> that use stat and expect certain behavior.  This should be manageable,
>> though, but making stat work appropriately.
>
> I'm bit lost in the two discussion, however the main concern I was
> discussing with Andy was if you have per superblock proc mounts then
> each mount will end up with its own device ID st_dev, right now they
> share the same ID if they are in the same pid namespace, but if we
> change that then we may break the following:
> http://man7.org/linux/man-pages/man7/namespaces.7.html
>
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

Well right now it is less of an issue than you image.  I suggest you
stat /proc and /proc/self/ns/* and look at st_dev.

That said anything that changes today's proc needs to be tested with a
range of distro's especially those using selinux and apparmor as they
tend to have policies that are very sensitive to the implementation
details.  Such that seemingly innocent changes can cause systems to stop
booting.

Eric
