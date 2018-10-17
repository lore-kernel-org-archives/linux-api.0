From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 31/34] vfs: syscall: Add fspick() to select a superblock for reconfiguration [ver #12]
Date: Wed, 17 Oct 2018 16:24:23 +0100
Message-ID: <13800.1539789863@warthog.procyon.org.uk>
References: <87woqgiqta.fsf@xmission.com> <19866.1539782101@warthog.procyon.org.uk> <68a2107f-bf70-055b-86cf-1ba2ba9422bf@gmail.com> <153754740781.17872.7869536526927736855.stgit@warthog.procyon.org.uk> <153754766004.17872.9829232103614083565.stgit@warthog.procyon.org.uk> <9b8bf436-65de-13b9-0002-0479d11c18ca@gmail.com> <20181013061141.GR32577@ZenIV.linux.org.uk> <28710.1539782412@warthog.procyon.org.uk> <f6f2553e-f64d-9c26-4290-baf43e5f533b@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87woqgiqta.fsf@xmission.com>
Content-ID: <13799.1539789863.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: dhowells@redhat.com, Alan Jenkins <alan.christopher.jenkins@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>, linux-api@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mszeredi@redhat.com
List-Id: linux-api@vger.kernel.org

Eric W. Biederman <ebiederm@xmission.com> wrote:

> Davids check will work for bind mounts as well.  It just won't work it
> just won't work for files or subdirectories of some mountpoint.

Bind mounts have to be done with open_tree() and move_mount().  You can't now
do fsmount() on something fspick()'d.

David
