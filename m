From: "Indan Zupancic" <indan-1J6HnF7K7zE@public.gmane.org>
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Date: Sat, 12 Mar 2011 02:33:37 +0100 (CET)
Message-ID: <1d4d1b7ae64da97f44cad0e2bda4f832.squirrel@webmail.greenhost.nl>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
    <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
    <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
    <201103111255.44979.arnd@arndb.de>
    <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
    <4D7AC0FE.8070806@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D7AC0FE.8070806-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ric Wheeler <ricwheeler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Aneesh Kumar K. V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Jonathan Nieder <jrnieder-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, l@jasper.es
List-Id: linux-api@vger.kernel.org

On Sat, March 12, 2011 01:40, Ric Wheeler wrote:
> On 03/11/2011 06:45 PM, Indan Zupancic wrote:
>> On Fri, March 11, 2011 12:55, Arnd Bergmann wrote:
>>> On Friday 11 March 2011, Indan Zupancic wrote:
>>>>>        http://marc.info/?l=linux-fsdevel&amp;m=127970513829285&amp;w=2
>>>> The patch there seems much more reasonable than introducing a whole
>>>> new systemcall just for 20 lines of kernel code. New system calls are
>>>> added too easily nowadays.
>>> The only problem with adding new system calls is that we are stuck
>>> with the interface until the end of time, so we must be sure not
>>> to get it wrong. The same thing is true for any other interface
>>> such as ioctl or extensions to existing system calls. People usually
>>> get away with adding new ioctls more easily because it is less
>>> obvious when they are added.
>> Agreed.
>>
>> I'm not sure this feature is important enough to add. I can't really
>> think of a regular use case where this would be useful, generally
>> it's transparent on which mount files are. Add symlinks, and you
>> give users a lot of rope. Any user has to make sure that all the
>> files they want to sync are on the same file system.
>>
>> About the arguments against sync(2):
>>
>>>   - On machines with many mounts, it is not at all uncommon for some of
>>>     them to hang (e.g. unresponsive NFS server).  sync(2) will get stuck on
>>>     those and may never get to the one you do care about (e.g., /).
>> It would be better to fix NFS, or mount it with the fsc option (assuming
>> a sync will write to the local cache instead of hanging forever then).
>>
>>>   - Some applications write lots of data to the file system and then
>>>     want to make sure it is flushed to disk.  Calling fsync(2) on each
>>>     file introduces unnecessary ordering constraints that result in a large
>>>     amount of sub-optimal writeback/flush/commit behavior by the file
>>>     system.
>> You can use sync_file_range() on those files to schedule the writes
>> and then do the fsync(2) as usual (both on files and dirs).
>>
>> If there still is a good reason to implement this, please don't add it
>> as a new system call, but add it to sync_file_range(), as that seems
>> the best place for odd file synchronisation operations.
>>
>> Greetings,
>>
>> Indan
>>
>>
>> --
>
> Hi Indan,
>
> I think that you missed the point of the extension.
>
> Ric

The point is clear, it's to synchronize a specific file system instead
of all of them.

But actually doing that from a program is harder than it looks, because
programs work with files, not file systems. To make this feature useful
the program needs meta information it can't easily get. That was my first
point.

The rest was just replying to the motivations given to add the feature.
If those motivations miss the point of the extension, don't blame me.

If you want to add a new one, "I'd like sync /mounpoint to work", then
do so, but please tell what practical use that has, if you're not going
to unmount the thing soon after anyway.

Other than this questionable use case, is there any other one that would
justify adding this extension?

Greetings,

Indan
