From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC] Add option to mount only a pids subset
Date: Sun, 12 Mar 2017 20:19:33 -0700
Message-ID: <CALCETrVT5sfGhNomLKAephrSGj8fc81ZjGTN-Y6UwgAHngVRCA@mail.gmail.com>
References: <20170221145746.GA31914@redhat.com> <20170306230515.GA3453@comp-core-i7-2640m-0182e6>
 <20170312015430.GO29622@ZenIV.linux.org.uk> <20170312021257.GP29622@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170312021257.GP29622-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Vasiliy Kulikov <segoon-cxoSlKxDwOJWk0Htik3J/w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Mar 11, 2017 at 6:13 PM, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrote:
> PS: AFAICS, simple mount --bind of your pid-only mount will suddenly
> expose the full thing.  And as for the lifetimes making no sense...
> note that you are simply not freeing these structures of yours.
> Try to handle that and you'll get a serious PITA all over the
> place.
>
> What are you trying to achieve, anyway?  Why not add a second vfsmount
> pointer per pid_namespace and make it initialized on demand, at the
> first attempt of no-pid mount?  Just have a separate no-pid instance
> created for those namespaces where it had been asked for, with
> separate superblock and dentry tree not containing anything other
> that pid-only parts + self + thread-self...

Can't we just make procfs work like most other filesystems and have
each mount have its own superblock?  If we need to do something funky
to stat() output to keep existing userspace working, I think that's
okay.

As far as I can tell, proc_mnt is very nearly useless -- it seems to
be used for proc_flush_task (which claims to be purely an optimization
and could be preserved in the common case where there's only one
relevant mount) and for sysctl_binary.  For the latter, we could
create proc_mnt but make actual user-initiated mounts be new
superblocks anyway.
