From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 01/33] vfs: syscall: Add open_tree(2) to reference or clone a mount [ver #11]
Date: Thu, 02 Aug 2018 22:51:58 +0100
Message-ID: <21311.1533246718@warthog.procyon.org.uk>
References: <7a292a44-7e17-572b-2d1e-0085ef400010@gmail.com> <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk> <153313705165.13253.4602180607294286849.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7a292a44-7e17-572b-2d1e-0085ef400010@gmail.com>
Content-ID: <21310.1533246718.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Jenkins <alan.christopher.jenkins@gmail.com>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, linux-api@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Alan Jenkins <alan.christopher.jenkins@gmail.com> wrote:

> Another closely-related limitation of `mount`, is that it can't atomically set
> the propagation type at mount time.

I want to add a mount_setattr() too at some point:

	fd = open_tree(..., OPEN_TREE_CLONE);
	mount_setattr(fd, ...);
	move_mount(fd, ...);

I'm not sure whether you should be able to fchdir into the cloned tree since
it isn't attached to any mount namespace.

David
