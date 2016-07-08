From: Andrei Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [CRIU] Introspecting userns relationships to other namespaces?
Date: Thu, 7 Jul 2016 22:47:56 -0700
Message-ID: <CANaxB-xZNKhyNVM=64XeGz+90htvC6cseP8VG933y7AG1uPGAA@mail.gmail.com>
References: <c2a26220-69f2-f2f5-491a-e43abd9a6f92@gmail.com>
	<87r3b7pxja.fsf@x220.int.ebiederm.org>
	<CAKgNAkgQbxLH-B3N3Xti3LLis+1Y-SJD2h1DEaXao7zTDA7pug@mail.gmail.com>
	<20160706141348.GB20728@mail.hallyn.com>
	<CAKgNAkhtQNg0mVv6ei_JigNz3njo_G3opE+rzd4OtKpa2hQe9g@mail.gmail.com>
	<20160707133631.GA2994@mail.hallyn.com>
	<1467903712.2347.16.camel@HansenPartnership.com>
	<CAKgNAkg+OiBngdFsdVR0gsSnVhMppuH2DxMBLCNAx8in5C0-zQ@mail.gmail.com>
	<1467919055.2322.36.camel@HansenPartnership.com>
	<20160708021617.GB10512@outlook.office365.com>
	<20160708030055.GC10512@outlook.office365.com>
	<1467948407.2322.88.camel@HansenPartnership.com>
	<CANaxB-wBkHrsQXcruEDXWwU-X8y4szW3dgVd+9JvgCGrrNeW4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CANaxB-wBkHrsQXcruEDXWwU-X8y4szW3dgVd+9JvgCGrrNeW4g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org" <criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 7, 2016 at 10:41 PM, Andrei Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Thu, Jul 7, 2016 at 8:26 PM, James Bottomley
> <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
>> On Thu, 2016-07-07 at 20:00 -0700, Andrew Vagin wrote:
>>> On Thu, Jul 07, 2016 at 07:16:18PM -0700, Andrew Vagin wrote:
>>> > On Thu, Jul 07, 2016 at 12:17:35PM -0700, James Bottomley wrote:
>>> > > On Thu, 2016-07-07 at 20:21 +0200, Michael Kerrisk (man-pages)
>>> > > wrote:
>>> > > > On 7 July 2016 at 17:01, James Bottomley
>>> > > > <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
>>> > > [Serge already answered the parenting issue]
>>> > > > > On Thu, 2016-07-07 at 08:36 -0500, Serge E. Hallyn wrote:
>>> > > > > > Hm.  Probably best-effort based on the process hierarchy.
>>> > > > > >  So
>>> > > > > > yeah you could probably get a tree into a state that would
>>> > > > > > be
>>> > > > > > wrongly recreated. Create a new netns, bind mount it, exit;
>>> > > > > >   Have
>>> > > > > > another task create a new user_ns, bind mount it, exit;
>>> > > > > >  Third
>>> > > > > > task setns()s first to the new netns then to the new
>>> > > > > > user_ns.  I
>>> > > > > > suspect criu will recreate that wrongly.
>>> > > > >
>>> > > > > This is a bit pathological, and you have to be root to do it:
>>> > > > > so
>>> > > > > root can set up a nesting hierarchy, bind it and destroy the
>>> > > > > pids
>>> > > > > but I know of no current orchestration system which does
>>> > > > > this.
>>> > > > >
>>> > > > > Actually, I have to back pedal a bit: the way I currently set
>>> > > > > up
>>> > > > > architecture emulation containers does precisely this: I set
>>> > > > > up the
>>> > > > > namespaces unprivileged with child mount namespaces, but then
>>> > > > > I ask
>>> > > > > root to bind the userns and kill the process that created it
>>> > > > > so I
>>> > > > > have a permanent handle to enter the namespace by, so I
>>> > > > > suspect
>>> > > > > that when our current orchestration systems get more
>>> > > > > sophisticated,
>>> > > > > they might eventually want to do something like this as well.
>>> > > > >
>>> > > > > In theory, we could get nsfs to show this information as an
>>> > > > > option
>>> > > > > (just add a show_options entry to the superblock ops), but
>>> > > > > the
>>> > > > > problem is that although each namespace has a parent user_ns,
>>> > > > > there's no way to get it without digging in the namespace
>>> > > > > specific
>>> > > > > structure.  Probably we should restructure to move it into
>>> > > > > ns_common, then we could display it (and enforce all
>>> > > > > namespaces
>>> > > > > having owning user_ns) but it would be a
>>> > > >
>>> > > > I'm missing something here. Is it not already the case that all
>>> > > > namespaces have an owning user_ns?
>>> > >
>>> > > Um, yes, I don't believe I said they don't.  The problem I
>>> > > thought you
>>> > > were having is that there's no way of seeing what it is.
>>> > >
>>> > > nsfs is the Namespace fileystem where bound namespaces appear to
>>> > > a cat
>>> > > of /proc/self/mounts.  It can display any information that's in
>>> > > ns_common (the common core of namespaces) but the owning user_ns
>>> > > pointer currently isn't in this structure.  Every user namespace
>>> > > has a
>>> > > pointer to it, but they're all privately embedded in the
>>> > > individual
>>> > > namespace specific structures.  What I was proposing was that
>>> > > since
>>> > > every current namespace has a pointer somewhere to the owning
>>> > > user
>>> > > namespace, we could abstract this out into ns_common so it's now
>>> > > accessible to be displayed by nsfs, probably as a mount option.
>>> >
>>> > James, I am not sure that I understood you correctly. We have one
>>> > file system for all namespace files, how we can show per-file
>>> > properties
>>> > in mount options. I think we can show all required information in
>>> > fdinfo. We open a namespaces file (/proc/pid/ns/N) and then read
>>> > /proc/pid/fdinfo/X for it.
>>>
>>> Here is a proof-of-concept patch.
>>>
>>> How it works:
>>>
>>> In [1]: import os
>>>
>>> In [2]: fd = os.open("/proc/self/ns/pid", os.O_RDONLY)
>>>
>>> In [3]: print open("/proc/self/fdinfo/%d" % fd).read()
>>> pos:  0
>>> flags:        0100000
>>> mnt_id:       2
>>> userns: 4026531837
>>>
>>> In [4]: print "/proc/self/ns/user -> %s" %
>>> os.readlink("/proc/self/ns/user")
>>> /proc/self/ns/user -> user:[4026531837]
>>
>> can't you just do
>>
>> readlink /proc/self/ns/user | sed 's/.*\[\(.*\)\]/\1/'
>
> We can get fdinfo for any ns file. I used /proc/self/ns/pid as an example.
>
> Look at another example:
>
> [root@fc22-vm ~]# cat /proc/self/mountinfo | grep pid_ns_file
> 115 38 0:3 pid:[4026532306] /tmp/pid_ns_file rw shared:67 - nsfs nsfs rw
>

Sorry, I forgot to say that fd is a file descriptor for /tmp/pid_ns_file

In [2]  : fd = os.open("/tmp/pid_ns_file", os.O_RDONLY)
In [3]  : fd
Out[4]: 5

> In [4]: print open("/proc/self/fdinfo/5").read()
> pos: 0
> flags: 0100000
> mnt_id: 115
> userns: 4026532305
>
>
> In [5]: os.readlink("/proc/self/ns/user")
> Out[5]: 'user:[4026531837]'
>
>
>>
>> ?
>>
>> But what Michael was asking about was the parent user_ns of all the
>> other namespaces ... I don't think there's any way we can get that out
>> of any information in /proc/self/
>>
>> James
>>
>>
>> _______________________________________________
>> Containers mailing list
>> Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
>> https://lists.linuxfoundation.org/mailman/listinfo/containers
