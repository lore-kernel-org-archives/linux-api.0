From: "Indan Zupancic" <indan-1J6HnF7K7zE@public.gmane.org>
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Date: Mon, 14 Mar 2011 02:38:01 +0100 (CET)
Message-ID: <3cc2c5c6fa6b3bd384017ae95a4241ab.squirrel@webmail.greenhost.nl>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
    <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
    <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
    <201103111255.44979.arnd@arndb.de>
    <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
    <4D7AC0FE.8070806@gmail.com>
    <1d4d1b7ae64da97f44cad0e2bda4f832.squirrel@webmail.greenhost.nl>
    <1299957736.2332.4.camel@koala>
Mime-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1299957736.2332.4.camel@koala>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Ric Wheeler <ricwheeler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Aneesh Kumar K. V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Jonathan Nieder <jrnieder-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, l@jasper.es
List-Id: linux-api@vger.kernel.org

On Sat, March 12, 2011 20:22, Artem Bityutskiy wrote:
> On Sat, 2011-03-12 at 02:33 +0100, Indan Zupancic wrote:
>> > I think that you missed the point of the extension.
>> >
>> > Ric
>>
>> The point is clear, it's to synchronize a specific file system instead
>> of all of them.
>>
>> But actually doing that from a program is harder than it looks, because
>> programs work with files, not file systems. To make this feature useful
>> the program needs meta information it can't easily get. That was my first
>> point.
>
> I had a program, actually a set of programs, which test a file-system.
> And this set of programs needed such a feature quite a lot, to sync the
> FS which is being tested and nothing else - for both performance reasons
> and to put more stress to the FS under testing. We used -o remount, rw
> for this - but this forced us to run under root.

You could use a tiny setuid root helper binary that does the remount trick.

> IOW, there are programs which take a mount point as an input parameter
> and want do things with the whole FS, not only individual files.

And those probably need to mount or unmount the FS at one point or the
other, or can use the setuid helper binary.

If you want to add syncfs, at least ad it together with BSD so it's slightly
portable.

Greetings,

Indan
