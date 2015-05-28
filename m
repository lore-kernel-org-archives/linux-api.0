From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [CFT][PATCH 00/10] Making new mounts of proc and sysfs as safe as
 bind mounts (take 2)
Date: Thu, 28 May 2015 10:33:29 -0700
Message-ID: <CALCETrXXax28s9kMTQ-zDx0MttQWG4rg2y-oz3bSGiumSL=3sg@mail.gmail.com>
References: <87pp63jcca.fsf@x220.int.ebiederm.org> <87siaxuvik.fsf@x220.int.ebiederm.org>
 <87wq004im1.fsf@x220.int.ebiederm.org> <CALCETrUhXBR5WQ6gXr9KzGc4=7tph7kzopY29Hug4g+FhOzEKg@mail.gmail.com>
 <20150528140839.GD28842@ubuntumail> <87lhg8pwvz.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <87lhg8pwvz.fsf@x220.int.ebiederm.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, Seth Forshee <seth.forshee@canonical.com>, Linux API <linux-api@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kenton Varda <kenton@sandstorm.io>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Richard Weinberger <richard@nod.at>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 28, 2015 at 8:03 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Serge Hallyn <serge.hallyn@ubuntu.com> writes:
>
>> Quoting Andy Lutomirski (luto@amacapital.net):
>>> On Fri, May 22, 2015 at 10:39 AM, Eric W. Biederman
>>> <ebiederm@xmission.com> wrote:
>>> > I had hoped to get some Tested-By's on that patch series.
>>>
>>> Sorry, I've been totally swamped.
>>>
>>> I suspect that Sandstorm is okay, but I haven't had a chance to test
>>> it for real.  Sandstorm makes only limited use of proc and sysfs in
>>> containers, but I'll see if I can test it for real this weekend.
>>
>> Testing this with unprivileged containers, I get
>>
>> lxc-start: conf.c: lxc_mount_auto_mounts: 808 Operation not permitted
>> - error mounting sysfs on
>> /usr/lib/x86_64-linux-gnu/lxc/sys/devices/virtual/net flags 0
>
> Grr..  I was afraid this would break something. :(
>
> Looking at my system I see that sysfs is currently mounted
> "nosuid,nodev,noexec"
>
> Looking at the lxc-start code I don't see it as including any of those
> mount options.  In practice for sysfs I think those options are
> meaningless (as there should be no devices and nothing executable in
> sysfs) but I can understand the past concerns with chmod on virtual
> filesystems that would incline people to use them, so I think the
> failure is reporting a legitimate security issue in the lxc userspace
> code where the the unprivileged code is currently attempting to give
> greater access to sysfs than was given by the original mount of sysfs.
>
> As nosuid,nodev,noexec should not impair the operation of sysfs
> operation it looks like you can always specify those options and just
> make this concern go away.

Linus is pretty strict about not breaking the ABI, and this definitely
counts as breaking the ABI.  There's an exception for security issues,
but is there really a security issue here?  That is, do we lose
anything important if we just drop the offending part of the patch
set?  As you've said, there shouldn't be sensitive device nodes,
executables, or setuid files in proc or sysfs in the first place.

--Andy
