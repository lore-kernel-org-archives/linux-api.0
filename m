From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [CFT][PATCH 09/10] sysfs: Create mountpoints with sysfs_create_empty_dir
Date: Tue, 11 Aug 2015 13:57:56 -0500
Message-ID: <877fp1hcuj.fsf@x220.int.ebiederm.org>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
	<878ucrhxi9.fsf@x220.int.ebiederm.org>
	<20150811184426.GH23408@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150811184426.GH23408@mtj.duckdns.org> (Tejun Heo's message of
	"Tue, 11 Aug 2015 14:44:26 -0400")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>, linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Richard Weinberger <richard@nod.at>, Kenton Varda <kenton@sandstorm.io>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, =?utf-8?Q?St=C3=A9phane?= Graber <stgraber@ubuntu.com>, Eric Windisch <ewindisch@docker.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> On Thu, May 14, 2015 at 12:36:30PM -0500, Eric W. Biederman wrote:
>> 
>> This allows for better documentation in the code and
>> it allows for a simpler and fully correct version of
>> fs_fully_visible to be written.
>> 
>> The mount points converted and their filesystems are:
>> /sys/hypervisor/s390/       s390_hypfs
>> /sys/kernel/config/         configfs
>> /sys/kernel/debug/          debugfs
>> /sys/firmware/efi/efivars/  efivarfs
>> /sys/fs/fuse/connections/   fusectl
>> /sys/fs/pstore/             pstore
>> /sys/kernel/tracing/        tracefs
>> /sys/fs/cgroup/             cgroup
>> /sys/kernel/security/       securityfs
>> /sys/fs/selinux/            selinuxfs
>> /sys/fs/smackfs/            smackfs
>> 
>> Cc: stable@vger.kernel.org
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
> So, this somehow ends up confusing upstart on centos6 based systems
> making it fail to mount tmpfs on /sys/fs/cgroup.  It also skips sunrpc
> and other mounts are different too.  No idea why at this point.  Can
> we please revert this from -stable until we know what's going on?

*Boggle*

The only time this should prevent anything is when in a container when
you are not global root.  And then only mounting sysfs should be
affected.

The only difference in executed code really should be setting an extra
flag on the kernfs, inode.  The kernfs changes will also refuse to add
entries to these directories (but these directories are empty).

If this is causing problems I don't have a problem with a revert but
reverts take a minute, and this seems to be the first report of this
kind.  Can we take a minute and attempt to get a coherent explanation.

>From what little information you given above it sounds like something
shifted and when you rebuilt the kernel and now a memory stomp is
hitting something else.  It should be a matter of moments to debug this
issue (once a test environment is setup), and see what is wrong and then
we can act intelligently.  Tracing a single system call is not difficult.

If there really is some weird issue I want to know what it is.

Eric

