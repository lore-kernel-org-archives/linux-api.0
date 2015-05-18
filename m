From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [CFT][PATCH 09/10] sysfs: Create mountpoints with
 sysfs_create_mount_point
Date: Mon, 18 May 2015 06:14:52 -0700
Message-ID: <20150518131452.GB653@kroah.com>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
 <87siaxuvik.fsf@x220.int.ebiederm.org>
 <87a8x5tgpp.fsf_-_@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87a8x5tgpp.fsf_-_@x220.int.ebiederm.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>, linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Richard Weinberger <richard@nod.at>, Kenton Varda <kenton@sandstorm.io>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>, Eric Windisch <ewindisch@docker.com>, Tejun Heo <tj@kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, May 15, 2015 at 09:10:42PM -0500, Eric W. Biederman wrote:
> 
> This allows for better documentation in the code and
> it allows for a simpler and fully correct version of
> fs_fully_visible to be written.
> 
> The mount points converted and their filesystems are:
> /sys/hypervisor/s390/       s390_hypfs
> /sys/kernel/config/         configfs
> /sys/kernel/debug/          debugfs
> /sys/firmware/efi/efivars/  efivarfs
> /sys/fs/fuse/connections/   fusectl
> /sys/fs/pstore/             pstore
> /sys/kernel/tracing/        tracefs
> /sys/fs/cgroup/             cgroup
> /sys/kernel/security/       securityfs
> /sys/fs/selinux/            selinuxfs
> /sys/fs/smackfs/            smackfs
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
