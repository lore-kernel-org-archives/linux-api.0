From: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Subject: Re: [RFD] A mount api that notices previous mounts
Date: Tue, 29 Jan 2019 15:01:30 -0800
Message-ID: <03e0993b-21db-1cc4-7a33-0236de7be20d@schaufler-ca.com>
References: <87va2716mh.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87va2716mh.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 1/29/2019 1:44 PM, Eric W. Biederman wrote:
> All,
>
> With the existing mount API it is possible to mount a filesystem
> like:
>
> mount -t ext4 /dev/sda1 -o user_xattr /some/path
> mount -t ext4 /dev/sda1 -o nouser_xattr /some/other/path
>
> And have both mount commands succeed and have two mounts of the same
> filesystem.  If the mounter is not attentive or the first mount is added
> earlier it may not be immediately noticed that a mount option that is
> needed for the correct operation or the security of the system is lost.
>
> We have seen this failure mode with both devpts and proc.  So it is not
> theoretical, and it has resulted in CVEs.
>
> In some cases the existing mount API (such as a conflict between ro and
> rw) handles this by returning -EBUSY.  So we may be able to correct this
> in the existing mount API.  But it is always very tricky to to get
> adequate testing for a change like that to avoid regressions, so I am
> proposing we change this in the new mount api.
>
> This has been brought up before and I have been told it is technically
> infeasible to make this work.  To counter that I have sat down and
> implemented it.
>
> The basic idea is:
>  - get a handle to a filesystem
>    (passing enough options to uniquely identify the super block).
>    Also capture enough state in the file handle to let you know if
>    the file system has it's mount options changed between system calls.
>    (essentially this is just the fs code that calls sget)
>
>  - If the super block has not been configured allow setting the file
>    systems options.
>
>  - If the super block has already been configured require reading the
>    file systems mount options before setting/updating the file systems
>    mount options.
>
> To complement that I have functionality that:
>  - Allows reading a file systems current mount options.
>  - Allows reading the mount options that are needed to get a handle to
>    the filesystem.  For most filesystems it is just the block device
>    name.  For nfs is is essentially all mount options.  For btrfs
>    it is the block device name, and the "devices=" mount option for
>    secondary block device names.

Are you taking the LSM specific mount options into account?

>
> Please find below a tree where all of this is implemented and working.
> Not all file systems have been converted but the most of the unconverted
> ones are just a couple minutes work as I have converted all of the file
> system mount helper routines.
>
> Also please find below an example mount program that takes the same set
> of mount options as mount(8) today and mounts filesystems with the
> proposed new mount api.
>  - Without having any filesystem mount knowledge it sucessfully figures
>
> out which system calls different mount options needs to be applied
>    to.
>
> - Without having any filesystem specific knowledge in most cases it
>    can detect if a mount option you specify is already specified to an
>    existing mount or not.  For duplicates it can detect it ignores them.
>    For the other cases it fails the mount as it thinks the mount options
>    are different.
>
>  - Which demonstrates it safe to put the detection and remediation of
>    multiple mount commands resolving to the same filesystem in user
>    space.
>
> I really don't care whose code gets used as long as it works.  I do very
> much care that we don't add a new mount api that has the confusion flaws
> of the existing mount api.
>
> Along the way I have also detected a lot of room for improvement on the
> mount path for filesystems.  Those cleanup patches are in my tree below
> and will be extracting them and sending them along shortly.
>
> Comments?
>
> git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git no-losing-mount-options-proof-of-concept
>
>
>
> Eric
>
