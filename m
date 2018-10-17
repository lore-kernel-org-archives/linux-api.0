From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 31/34] vfs: syscall: Add fspick() to select a superblock for reconfiguration [ver #12]
Date: Wed, 17 Oct 2018 10:38:04 -0500
Message-ID: <87murcinxf.fsf@xmission.com>
References: <87woqgiqta.fsf@xmission.com>
        <19866.1539782101@warthog.procyon.org.uk>
        <68a2107f-bf70-055b-86cf-1ba2ba9422bf@gmail.com>
        <153754740781.17872.7869536526927736855.stgit@warthog.procyon.org.uk>
        <153754766004.17872.9829232103614083565.stgit@warthog.procyon.org.uk>
        <9b8bf436-65de-13b9-0002-0479d11c18ca@gmail.com>
        <20181013061141.GR32577@ZenIV.linux.org.uk>
        <28710.1539782412@warthog.procyon.org.uk>
        <f6f2553e-f64d-9c26-4290-baf43e5f533b@gmail.com>
        <13800.1539789863@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <13800.1539789863@warthog.procyon.org.uk> (David Howells's
        message of "Wed, 17 Oct 2018 16:24:23 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Alan Jenkins <alan.christopher.jenkins@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>, linux-api@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mszeredi@redhat.com
List-Id: linux-api@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> Davids check will work for bind mounts as well.  It just won't work it
>> just won't work for files or subdirectories of some mountpoint.
>
> Bind mounts have to be done with open_tree() and move_mount().  You can't now
> do fsmount() on something fspick()'d.

But a bind mount will have mnt_root set to the the dentry that was
bound.

Therefore fspick as you are proposing modifying will work for the root
of bind mounts, as well as the root of regular mounts.  My apologies for
not being clear.

Eric
