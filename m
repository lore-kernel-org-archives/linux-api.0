From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [CFT][PATCH 0/10] Making new mounts of proc and sysfs as safe as bind mounts
Date: Thu, 14 May 2015 16:10:52 -0500
Message-ID: <87oalmg90j.fsf@x220.int.ebiederm.org>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
	<20150514202951.GA16416@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150514202951.GA16416@kroah.com> (Greg Kroah-Hartman's message
	of "Thu, 14 May 2015 13:29:51 -0700")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>, linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Richard Weinberger <richard@nod.at>, Kenton Varda <kenton@sandstorm.io>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, =?utf-8?Q?St=C3=A9phane?= Graber <stgraber@ubuntu.com>, Eric Windisch <ewindisch@docker.com>, Tejun Heo <tj@kernel.org>
List-Id: linux-api@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Thu, May 14, 2015 at 12:30:45PM -0500, Eric W. Biederman wrote:
>> 
>> The code is currently available at:
>> 
>>    git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-testing
>> 
>>    HEAD: a524faf520600968e58bbc732063fccf2fdf9199 mnt: Update fs_fully_visible to test for permanently empty directories
>> 
>> The problem:  Mounting a new instance of proc of sysfs can allow things
>> that a bind mount of those filesystems would not.
>> 
>> That is the cases I am dealing with are:
>>      unshare --user --net --mount ; mount -t sysfs ...
>>      unshare --user --pid --mount ; mount -t proc ...
>> 
>> The big change is that this set of changes enforces the preservation of
>> locked mount flags, from the existing mount to the current mount.  Which
>> means that if proc was mounted read-only the current current will allow
>> a new instance of proc to be mounted read-write, and this set of changes
>> enforces that proc remain read-only.
>> 
>> The other gotcha is that the current code does not properly detect empty
>> directories so to prevent things slipping through the cracks this set of
>> changes annotates all mount points where nothing will be revealed if
>> the filesystem mounted on top is removed.
>> 
>> Enforcing the administrators policy can actually matter in the real
>> world as has been shown by the recent docker issue.
>> 
>> With this patchset I have two concerns:
>> - The enforcement of mount flag preservation on proc and sysfs may break
>>   things.  (I am especially worried about the implicit adding of nodev).
>
> What do you mean by this?  What got added?

In a user namespace mounting a filesystem implicitly adds nodev.

When I started enforcing not clearing bits that root had set on a
filesystem in mount -o remount the implicit nodev wound up being
an issue that broke userspace for no good reason.  The fix was
to implicitly add nodev in remount as well.

Taking a second look at this nodev is implicitly added before the
fs_fully_visible check so even for applications that are know how the
original proc was mounted (and don't see an implicit nodev) and that
don't add nodev (because they ''know'' the mount flags) this change
should not be a problem.  Hooray!  One less scary thing.

>> - I missed a filesystem mountpoint on proc or sysfs which would make a
>>   fresh copy unmountable for no good reason.
>> 
>> I don't want to break userspace if I can help it, and the code has been
>> this way for a while so I figure there is time to find any pitfalls and
>> address them before this code gets merged.
>> 
>> So if this works for you please give me your Tested-By
>> 
>> The well known mountpoints for pseudo filesystems that I could find are:
>> /dev/ffs*/                 functionfs
>> /dev/gadget/               gadgetfs
>> /dev/mqueue                mqueue
>> /dev/oprofile/             oprofilefs
>> /dev/pts/                  devpts
>
> /dev/shm gets a tmpfs, right?  Or do those not matter here?

It does, but it doesn't matter in this context.   I was looking for
things that mounted themselves on proc or sysfs and I catalogued the
rest just to know they were not mounted there.

>> /dlm/                      ocfs2_dlmfs
>> /ipath/                    ipathfs
>> /proc/fs/nfsd/             nfsd
>> /proc/openprom/            openpromfs
>> /proc/sys/fs/binfmt_misc/  binfmt_misc
>> /spu/                      spufs
>
>> /sys/firmware/efi/efivars/ efivarfs
>> /sys/fs/cgroup/            cgroup
>> /sys/fs/fuse/connections/  fusectl
>
> I thought fuse mounted a few more things in here, but I don't know for
> sure.

There are definitely some fuse attributes under /sys/fs/fuse/ but
I don't see anything else in the code that could be creating a mount
point.

>> /sys/fs/pstore/            pstore
>> /sys/fs/selinux/           selinuxfs
>> /sys/fs/smackfs/           smackfs
>> /sys/hypervisor/s390/      s390_hypfs
>> /sys/kernel/config/        configfs
>> /sys/kernel/debug/         debugfs
>> /sys/kernel/security/      securityfs
>> /sys/kernel/tracing/       tracefs
>
> I think these are all correct for sysfs, I have a minor comment on the
> sysfs patch I'll make in it.

Good to hear and I will answer there as well.

Eric

