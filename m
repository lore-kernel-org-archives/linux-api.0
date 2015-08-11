From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [CFT][PATCH 09/10] sysfs: Create mountpoints with
 sysfs_create_empty_dir
Date: Tue, 11 Aug 2015 14:44:26 -0400
Message-ID: <20150811184426.GH23408@mtj.duckdns.org>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
 <878ucrhxi9.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <878ucrhxi9.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Graber <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Eric Windisch <ewindisch-FCduhRhOUaTQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 14, 2015 at 12:36:30PM -0500, Eric W. Biederman wrote:
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
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>

So, this somehow ends up confusing upstart on centos6 based systems
making it fail to mount tmpfs on /sys/fs/cgroup.  It also skips sunrpc
and other mounts are different too.  No idea why at this point.  Can
we please revert this from -stable until we know what's going on?

Thanks.

-- 
tejun
