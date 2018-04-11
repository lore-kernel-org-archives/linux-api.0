From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 24/24] debugfs: Restrict debugfs when the kernel is locked down
Date: Wed, 11 Apr 2018 13:50:12 -0500
Message-ID: <87zi29k26z.fsf@xmission.com>
References: <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk>
        <152346403637.4030.15247096217928429102.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <152346403637.4030.15247096217928429102.stgit@warthog.procyon.org.uk>
        (David Howells's message of "Wed, 11 Apr 2018 17:27:16 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org, jmorris@namei.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> Disallow opening of debugfs files that might be used to muck around when
> the kernel is locked down as various drivers give raw access to hardware
> through debugfs.  Given the effort of auditing all 2000 or so files and
> manually fixing each one as necessary, I've chosen to apply a heuristic
> instead.  The following changes are made:
>
>  (1) chmod and chown are disallowed on debugfs objects (though the root dir
>      can be modified by mount and remount, but I'm not worried about that).
>
>  (2) When the kernel is locked down, only files with the following criteria
>      are permitted to be opened:
>
> 	- The file must have mode 00444
> 	- The file must not have ioctl methods
> 	- The file must not have mmap
>
>  (3) When the kernel is locked down, files may only be opened for reading.
>
> Normal device interaction should be done through configfs, sysfs or a
> miscdev, not debugfs.

> Note that this makes it unnecessary to specifically lock down show_dsts(),
> show_devs() and show_call() in the asus-wmi driver.
>
> I would actually prefer to lock down all files by default and have the
> the files unlocked by the creator.  This is tricky to manage correctly,
> though, as there are 19 creation functions and ~1600 call sites (some of
> them in loops scanning tables).

Why is mounting debugfs allowed at all?  Last I checked (it has been a while)
the code quality of debugfs was fine for debugging but debugfs was not
safe to mount on a production system.

Maybe the code quality is better now but for a filesystem that is
not supposed to be needed for developers letting us mount debugfs
seems odd.

Eric
