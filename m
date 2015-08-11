From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [CFT][PATCH 09/10] sysfs: Create mountpoints with sysfs_create_empty_dir
Date: Tue, 11 Aug 2015 12:21:54 -0700
Message-ID: <CALCETrXE=fKa3XkEEo6y2=ZNtsuBfX=kaoyDwiP0C2BwqKJWjw@mail.gmail.com>
References: <87pp63jcca.fsf@x220.int.ebiederm.org> <878ucrhxi9.fsf@x220.int.ebiederm.org>
 <20150811184426.GH23408@mtj.duckdns.org> <877fp1hcuj.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <877fp1hcuj.fsf@x220.int.ebiederm.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Richard Weinberger <richard@nod.at>, Kenton Varda <kenton@sandstorm.io>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>, Eric Windisch <ewindisch@docker.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org

On Tue, Aug 11, 2015 at 11:57 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Tejun Heo <tj@kernel.org> writes:
>
>> On Thu, May 14, 2015 at 12:36:30PM -0500, Eric W. Biederman wrote:
>>>
>>> This allows for better documentation in the code and
>>> it allows for a simpler and fully correct version of
>>> fs_fully_visible to be written.
>>>
>>> The mount points converted and their filesystems are:
>>> /sys/hypervisor/s390/       s390_hypfs
>>> /sys/kernel/config/         configfs
>>> /sys/kernel/debug/          debugfs
>>> /sys/firmware/efi/efivars/  efivarfs
>>> /sys/fs/fuse/connections/   fusectl
>>> /sys/fs/pstore/             pstore
>>> /sys/kernel/tracing/        tracefs
>>> /sys/fs/cgroup/             cgroup
>>> /sys/kernel/security/       securityfs
>>> /sys/fs/selinux/            selinuxfs
>>> /sys/fs/smackfs/            smackfs
>>>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>>
>> So, this somehow ends up confusing upstart on centos6 based systems
>> making it fail to mount tmpfs on /sys/fs/cgroup.  It also skips sunrpc
>> and other mounts are different too.  No idea why at this point.  Can
>> we please revert this from -stable until we know what's going on?
>
> *Boggle*
>
> The only time this should prevent anything is when in a container when
> you are not global root.  And then only mounting sysfs should be
> affected.

Before:

open("/sys/kernel/debug/asdf", O_WRONLY|O_CREAT|O_NOCTTY|O_NONBLOCK,
0666) = -1 EACCES (Permission denied)


After:

open("/sys/kernel/debug/asdf", O_WRONLY|O_CREAT|O_NOCTTY|O_NONBLOCK,
0666) = -1 ENOENT (No such file or directory)

Something broke.  I don't know whether CentOS cares about that change,
but there could be other odd side effects.

--Andy
