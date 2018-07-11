From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for superblock creation [ver #9]
Date: Wed, 11 Jul 2018 17:18:01 +0100
Message-ID: <14219.1531325881@warthog.procyon.org.uk>
References: <20180711095159.08e5435c@lwn.net> <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk> <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180711095159.08e5435c@lwn.net>
Content-ID: <14218.1531325881.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Jonathan Corbet <corbet@lwn.net> wrote:

> A minor detail but ... the "r" operation mentioned above is not actually
> implemented in this system call.

Yeah, that's something I'd like to add.  NFS4 already does this inside its
->mount() method, so my thought is that we might be able to move this from
there to the core.

David
