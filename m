From: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] Add option to mount only a pids subset
Date: Mon, 13 Mar 2017 08:24:23 -0700
Message-ID: <CALCETrXqv8VUeO6MpKWDR6DFYBgmmT0nZVezBJsimtmmQgDksw@mail.gmail.com>
References: <20170221145746.GA31914@redhat.com> <20170306230515.GA3453@comp-core-i7-2640m-0182e6>
 <20170312015430.GO29622@ZenIV.linux.org.uk> <20170312021257.GP29622@ZenIV.linux.org.uk>
 <CALCETrVT5sfGhNomLKAephrSGj8fc81ZjGTN-Y6UwgAHngVRCA@mail.gmail.com> <20170313132732.GR29622@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170313132732.GR29622-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Vasiliy Kulikov <segoon-cxoSlKxDwOJWk0Htik3J/w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 13, 2017 at 6:27 AM, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrote:
> On Sun, Mar 12, 2017 at 08:19:33PM -0700, Andy Lutomirski wrote:
>> On Sat, Mar 11, 2017 at 6:13 PM, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrote:
>> > PS: AFAICS, simple mount --bind of your pid-only mount will suddenly
>> > expose the full thing.  And as for the lifetimes making no sense...
>> > note that you are simply not freeing these structures of yours.
>> > Try to handle that and you'll get a serious PITA all over the
>> > place.
>> >
>> > What are you trying to achieve, anyway?  Why not add a second vfsmount
>> > pointer per pid_namespace and make it initialized on demand, at the
>> > first attempt of no-pid mount?  Just have a separate no-pid instance
>> > created for those namespaces where it had been asked for, with
>> > separate superblock and dentry tree not containing anything other
>> > that pid-only parts + self + thread-self...
>>
>> Can't we just make procfs work like most other filesystems and have
>> each mount have its own superblock?  If we need to do something funky
>> to stat() output to keep existing userspace working, I think that's
>> okay.
>
> First of all, most of the filesystems do *NOT* guarantee anything of
> that sort.  And what's the point of having more instances than
> necessary, anyway?

I mean that, if I do:

mount -t proc -o foobar none a
mount -t proc -o baz none b

Then I think that the second mount should create a whole new proc
instance rather than just a new vfsmount.  Then the options could
differ, which would solve a bunch of problems.

>
> Again, what for?  It won't salvage that kludge...  It's not as if it
> had been hard to have separate pid-only instance created when asked
> for (and reused every time when we are asked for pid-only).  What's
> the point of ever having more than two instances per pidns?  IDGI...

I can easily procfs growing more than one interesting option.
Pid-only and hidepid come to mind, and that's already six possible
combinations.  The current hidepid implementation is really awful.

>
> Folks, there is no one-to-one correspondence between mountpoints and
> superblocks.  Not since 2000 or so.  Just don't try to shove your
> per-superblock stuff into vfsmount; it simply won't work.  If you
> want a separate instance for that thing, then just go ahead and
> have ->mount() decide which one to use (and whether to create a new
> one).  All there is to it...

That's what I mean.  I just don't see the point of going all-out in
trying to reuse superblocks.
