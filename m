From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 28/33] vfs: syscall: Add fsconfig() for configuring and managing a context [ver #11]
Date: Mon, 06 Aug 2018 12:28:47 -0500
Message-ID: <87in4n9zg0.fsf@xmission.com>
References: <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
        <153313723557.13253.9055982745313603422.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153313723557.13253.9055982745313603422.stgit@warthog.procyon.org.uk>
        (David Howells's message of "Wed, 01 Aug 2018 16:27:15 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, linux-api@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

David Howells <dhowells@redhat.com> writes:
>
>  (*) FSCONFIG_CMD_CREATE: Trigger superblock creation.
>
>  (*) FSCONFIG_CMD_RECONFIGURE: Trigger superblock reconfiguration.
>

First let me thank you for adding both FSCONFIG_CMD_CREATE and
FSCONFIG_CMD_RECONFIGURE.  Unfortunately the implementation is currently
broken.  So this patch gets my:

This is broken in two specific ways.
1) FSCONFIG_CMD_RECONFIGURE always returns -EOPNOTSUPPORTED.
   So it is useless.

2) FSCONFIG_CMD_CREATE will succeed even if the superblock already
   exists and it can not use all of the superblock parameters.

   This happens because vfs_get_super will only call fill_super
   if the super block is created.  Which is reasonable on the face
   of it.  But it in practice this introduces security problems.

   a) Either through reconfiguring a shared super block you did not
      realize was shared (as we saw with devpts).

   b) Mounting a super block and not honoring it's mount options
      because something has already mounted it.  As we see today
      with proc.  Leaving userspace to think the filesystem will behave
      one way when in fact it behaves another.

I have already explained this several times, and apparently I have been
ignored.  This fundamental usability issue that leads to security
problems.

The only feedback I have had from previous time is that it is ``racy''
to fix the code.  But it is only racy in the way that O_EXCL is racy.
You might have to retry in userspace if the mount you want isn't in the
state you expect.

Until this security issue is fixed this entire patchset has my:
Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

> +/*
> + * Perform an action on a context.
> + */
> +static int vfs_fsconfig_action(struct fs_context *fc, enum fsconfig_command cmd)
> +{
> +	int ret = -EINVAL;
> +
> +	switch (cmd) {
> +	case FSCONFIG_CMD_CREATE:
> +		if (fc->phase != FS_CONTEXT_CREATE_PARAMS)
> +			return -EBUSY;
> +		fc->phase = FS_CONTEXT_CREATING;
> +		ret = vfs_get_tree(fc);
> +		if (ret == 0)
> +			fc->phase = FS_CONTEXT_AWAITING_MOUNT;
> +		else
> +			fc->phase = FS_CONTEXT_FAILED;
> +		return ret;
> +
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}

See no support for FSCONFIG_CMD_RECONFIGURE, and no checks to see if
the superblock has already been mounted.

> +	ret = mutex_lock_interruptible(&fc->uapi_mutex);
> +	if (ret == 0) {
> +		switch (cmd) {
> +		case FSCONFIG_CMD_CREATE:
> +		case FSCONFIG_CMD_RECONFIGURE:
> +			ret = vfs_fsconfig_action(fc, cmd);
> +			break;
> +		default:
> +			ret = vfs_fsconfig(fc, &param);
> +			break;
> +		}
> +		mutex_unlock(&fc->uapi_mutex);
> +	}
> +

Eric
