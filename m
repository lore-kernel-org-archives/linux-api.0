From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: Regression in 5.3 for some FS_USERNS_MOUNT (aka user-namespace-mountable) filesystems
Date: Sat, 27 Jul 2019 06:20:18 -0500
Message-ID: <87h877pvv1.fsf@xmission.com>
References: <20190726115956.ifj5j4apn3tmwk64@brauner.io>
        <CAHk-=wgK254RkZg9oAv+Wt4V9zqYJMm3msTofvTUfA9dJw6piQ@mail.gmail.com>
        <20190726232220.GM1131@ZenIV.linux.org.uk>
        <878sskqp7p.fsf@xmission.com>
        <20190727022826.GO1131@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190727022826.GO1131@ZenIV.linux.org.uk> (Al Viro's message of
        "Sat, 27 Jul 2019 03:28:26 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Christian Brauner <christian@brauner.io>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Al Viro <viro@zeniv.linux.org.uk> writes:

> On Fri, Jul 26, 2019 at 07:46:18PM -0500, Eric W. Biederman wrote:
>
>> If someone had bothered to actually look at how I was proposing to clean
>> things up before the new mount api we would already have that.  Sigh.
>> 
>> You should be able to get away with something like this which moves the
>> checks earlier and makes things clearer.  My old patch against the pre
>> new mount api code.
>
> Check your instances of ->permission(); AFAICS in all cases it's (in
> current terms)
> 	return ns_capable(fc->user_ns, CAP_SYS_ADMIN) ? 0 : -EPERM;


Yes.  Because I refactored all of the logic to be in terms of current
before we even get to the filesystem.  The idea is on a per filesystem
basis to know which namespaces for the filesystem will be selected
and to check those.

Since all that version of the patch converts is the old API we know
from only looking at current what needs to be checked.

> In principle I like killing FS_USERNS_MOUNT flag, but when a method
> is always either NULL or exact same function...

Either you are being dramatic or you read the patch much too quickly.

userns_mount_permission covers the common case of FS_USERNS_MOUNT.
Then there are the cases where you need to know how the filesystem is
going to map current into the filesystem that will be mounted.  Those
are: proc_mount_permission, sysfs_mount_permission,
mqueue_mount_permission, cgroup_mount_permission,

So yes I agree the function of interest is always capable in some form,
we just need the filesystem specific logic to check to see if we will
have capable over the filesystem that will be mounted.

I don't doubt that the new mount api has added a few new complexities.

*Shrug*  I have done my best to keep it simple, and to help avoid
breaking changes.   When you never post your patches for public review,
and don't take any feedback it is difficult to give help.

Eric
