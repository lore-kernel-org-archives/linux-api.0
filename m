From: "Indan Zupancic" <indan-1J6HnF7K7zE@public.gmane.org>
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Date: Mon, 14 Mar 2011 02:56:52 +0100 (CET)
Message-ID: <1e597aedd3d7825dcc0630b1cf2399fa.squirrel@webmail.greenhost.nl>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
    <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
    <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
    <201103111255.44979.arnd@arndb.de>
    <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
    <20110311235607.GB15853@elie>
    <9446ab1a2315c0d2476c30f8315a0503.squirrel@webmail.greenhost.nl>
    <20110312021001.GA16833@elie> <20110312173217.GA24981@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110312173217.GA24981-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: Jonathan Nieder <jrnieder-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Aneesh Kumar K. V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, l@jasper.es
List-Id: linux-api@vger.kernel.org

On Sat, March 12, 2011 18:32, Greg KH wrote:
> On Fri, Mar 11, 2011 at 08:10:01PM -0600, Jonathan Nieder wrote:
>> Indan Zupancic wrote:
>>
>> > I'm not pushing for any official convention, just what seems good taste.
>>
>> In cases like this, conventions (consistency and best practices) are
>> very important.
>>
>> > Less code added, less bloat. Architecture independent, no need to update
>> > all system call tables everywhere (all archs, libc versions and strace).
>> > Two files changed, instead of 7 (which only hooks up x86).
>>
>> Thanks for explaining.  Those do seem like good reasons to use a ioctl
>> instead of a new syscall.
>
> No, make it a syscall, it's more obvious and will be documented much
> better.

There is no such guarantee. Everyone seems to want to add this new syncfs,
but it's not even defined what it does. "Same as sync, but only on one fs"
is IMHO not good enough, because sync's behaviour is pretty badly documented,
and that's a system call. The sync_file_range argument effects are quite
well defined, on the other hand, unlike sync behaviour. You're right for
ioctls though.

If it has to be added, I'm in favour of adding it as a new sync_file_range
flag option, but wouldn't mind if it was added as some obscure ioctl either.

Do you think that widespread sync() usage is something good? Don't you
think sync(2) should be used as little as possible? And if so, why is
it any different than syncfs?

IMHO we're talking about some system call that shouldn't be used often, and
only rarely in very specific cases. They could use sync(2) with exactly the
same effect, but for performance reasons syncfs() is preferred. So instead
of extremely slow it will be very slow in some cases. Hurray, progress!

Next time you want an async version, and have to add a new systemcall with
a flag argument. So instead of going down that path, please add one with
a flag argument immediately. E.g:

syncfs(const char* path, int fd, int flags);

A NULL path, -1 fd and 0 flags is equal to sync (or something), and then
vary the options. But as it's for a file system, wouldn't it make more
sense to have just a path argument instead of an fd one?

Greetings,

Indan
