From: "John Stoffel" <john-HgN6juyGXH5AfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Tue, 12 May 2015 09:41:30 -0400
Message-ID: <21842.778.486134.281621@quad.stoffel.home>
References: <1430949612-21356-1-git-send-email-zab@redhat.com>
	<20150507002617.GJ4327@dastard>
	<20150507172053.GA659@lenny.home.zabbo.net>
	<alpine.DEB.2.00.1505071752520.28239@cobra.newdream.net>
	<CAHQdGtQjMHA8rVPkggB2zMz=k3O667+APH_1EY_2FtYmHL7-hw@mail.gmail.com>
	<20150508221325.GM4327@dastard>
	<alpine.DEB.2.00.1505081517470.28239@cobra.newdream.net>
	<CAHQdGtTFTN2XuvmarFZ9HPQV=cuhh7FosdHSrJME_U4htr=i8w@mail.gmail.com>
	<20150511073103.GO4327@dastard>
	<alpine.DEB.2.00.1505110925150.28239@cobra.newdream.net>
	<CAHQdGtT3rCf-ycAYw-=7HGaemg1+HfY8sw3+kb54VHONxDyP3w@mail.gmail.com>
	<alpine.DEB.2.00.1505111020120.28239@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1505111020120.28239-vIokxiIdD2AQNTJnQDzGJqxOck334EZe@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>
Cc: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

>>>>> "Sage" == Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org> writes:

Sage> On Mon, 11 May 2015, Trond Myklebust wrote:
>> On Mon, May 11, 2015 at 12:39 PM, Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org> wrote:
>> > On Mon, 11 May 2015, Dave Chinner wrote:
>> >> On Sun, May 10, 2015 at 07:13:24PM -0400, Trond Myklebust wrote:
>> >> > On Fri, May 8, 2015 at 6:24 PM, Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org> wrote:
>> >> > > I'm sure you realize what we're try to achieve is the same "invisible IO"
>> >> > > that the XFS open by handle ioctls do by default.  Would you be more
>> >> > > comfortable if this option where only available to the generic
>> >> > > open_by_handle syscall, and not to open(2)?
>> >> >
>> >> > It should be an ioctl(). It has no business being part of
>> >> > open_by_handle either, since that is another generic interface.
>> >
>> > Our use-case doesn't make sense on network file systems, but it does on
>> > any reasonably featureful local filesystem, and the goal is to be generic
>> > there.  If mtime is critical to a network file system's consistency it
>> > seems pretty reasonable to disallow/ignore it for just that file system
>> > (e.g., by masking off the flag at open time), as others won't have that
>> > same problem (cephfs doesn't, for example).
>> >
>> > Perhaps making each fs opt-in instead of handling it in a generic path
>> > would alleviate this concern?
>> 
>> The issue isn't whether or not you have a network file system, it's
>> whether or not you want users to be able to manage data. mtime isn't
>> useful for the application (which knows whether or not it has changed
>> the file) or for the filesystem (ditto). It exists, rather, in order
>> to enable data management by users and other applications, letting
>> them know whether or not the data contents of the file have changed,
>> and when that change occurred.

Sage> Agreed.
 
>> If you are able to guarantee that your users don't care about that,
>> then fine, but that would be a very special case that doesn't fit the
>> way that most data centres are run. Backups are one case where mtime
>> matters, tiering and archiving is another.

Sage> This is true, although I argue it is becoming increasingly
Sage> common for the data management (including backups and so forth)
Sage> to be layered not on top of the POSIX file system but on
Sage> something higher up in the stack. This is true of pretty much
Sage> any distributed system (ceph, cassandra, mongo, etc., and I
Sage> assume commercial databases like Oracle, too) where backups,
Sage> replication, and any other DR strategies need to be orchestrated
Sage> across nodes to be consistent--simply copying files out from
Sage> underneath them is already insufficient and a recipe for
Sage> disaster.

you're smoking crack here.  Backups are not layered at higher layers
unless absolutely necessary, such as for databases.  Now Mongo, Hadoop
and others might also fit this model, but for day to day backup of
data, it's mtime all the way.  

I don't see why you insist that this is a good idea to implement for a
very special corner case.  

Sage> There is a growing category of applications that can benefit
Sage> from this capability...

There is a perceived growing category of super special niche
applications which might think they want this capability.  

Why are you even using a filesystem in the first place if you're so
worried about writing out inodes being a performance problem?  Just
use raw partitions and do all the work yourself.  Oracle and other DBs
can do this when they want.  

>> Neither of these examples
>> cases are under the control of the application that calls
>> open(O_NOMTIME).

Sage> Wouldn't a mount option (e.g., allow_nomtime) address this
Sage> concern?  Only nodes provisioned explicitly to run these systems
Sage> would be enable this option.

Why do you keep coming back to a mount option?  What's wrong with a
per-file ioctl option?  Making this a mount option means that you
default to a fail hard setup.  If someone screws up and mounts user
home directories with this option thinking that it's like the noatime
option, then suddenly all their backups will silently break unless
they're aware of disk space churn numbers and notice that they are
only backing up tiny bits.

With an ioctl, it's upto the damn application to *request* this
change, and then the VFS/filesystem and *maybe* support this, but the
application shouldn't actually know or care what the result is, it's
just a performance hint/request.  

We should default to sane semantics and not give out such a big
foot-gun if at all possible.  

I'm a sysadm by day (and night, evening, early morning... :-) and I
know my user's don't think about thinks like this. They don't even
think about backups until they want to restore something.  User's only
care about restores, not backups.

John
