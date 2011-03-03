From: Jonathan Nieder <jrnieder-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] introduce sys_syncat to sync a single file system
Date: Thu, 3 Mar 2011 01:22:24 -0600
Message-ID: <20110303072223.GA28133@elie>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1102171035220.13904-vIokxiIdD2AQNTJnQDzGJqxOck334EZe@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

Sage Weil wrote:

>  - On machines with many of mounts, it is not at all uncommon for some of
>    them to hang (e.g. unresponsive NFS server).  sync(2) will get stuck on
>    those and may never get to the one you do care about (e.g., /).

Fun to see this again.

>  - Some applications (Ceph, dpkg) write lots of data to the file system and
>    then want to make sure it is flushed to disk.  Calling fsync(2) on each
>    file introduces unnecessary ordering constraints that result in a large
>    amount of sub-optimal writeback/flush/commit behavior by the file
>    system.

FWIW dpkg uses sync_file_range(2) and only syncs the files it needs to
nowadays.  Other apps in the same position should probably do the
same.[1][2]

> This patch introduces a new system call syncat(2) that mimics the existing 
> *at() interfaces by taking an fd and/or path.  The fd can be either an 
> open file descriptor or AT_FDCWD, and the pathname can be either a path or 
> (unlike the usual *at() style interface) NULL.  Only the file system for 
> the referenced file is synced.

Sounds like overengineering.  The openat(2) family of calls are meant
to add flexibility to familiar calls that perform an operation with a
path relative to the cwd.  To maintain familiarity, they include some
complication (AT_FDCWD, taking a relative path, and so on).

Since sync_one_filesystem(2) is new, why not just take a file or
directory fd (and perhaps flags for future expansion)?  I can use
open(".", O_NONBLOCK) to get a file descriptor for the cwd.

> Is this a reasonable approach?  (Patch below is compile tested only.  :)

Sounds reasonably sane.

As for the patch: without the pathname arg it becomes much simpler.
To my inexpert eyes, aside from that it looks good.

Thanks,
Jonathan

[1] http://thread.gmane.org/gmane.comp.file-systems.ext4/22190
[2] http://lists.debian.org/debian-dpkg/2010/11/threads.html#00075
