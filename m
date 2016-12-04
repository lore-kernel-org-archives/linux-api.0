From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/4] statx: Add a system call to make enhanced file info
 available [ver #3]
Date: Sun, 4 Dec 2016 04:38:05 +0000
Message-ID: <20161204043803.GA1022@ZenIV.linux.org.uk>
References: <147986254484.19139.8038609825799670925.stgit@warthog.procyon.org.uk>
 <147986255194.19139.9583434946564699577.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <147986255194.19139.9583434946564699577.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Nov 23, 2016 at 12:55:51AM +0000, David Howells wrote:

> + * vfs_xgetattr - Get the enhanced basic attributes of a file
> + * @path: The file of interest
> + * @stat: Where to return the statistics
> + *
> + * Ask the filesystem for a file's attributes.  The caller must have preset
> + * stat->request_mask and stat->query_flags to indicate what they want.
> + *
> + * If the file is remote, the filesystem can be forced to update the attributes
> + * from the backing store by passing AT_FORCE_ATTR_SYNC in query_flags or can
> + * suppress the update by passing AT_NO_ATTR_SYNC.
> + *
> + * Bits must have been set in stat->request_mask to indicate which attributes
> + * the caller wants retrieving.  Any such attribute not requested may be
> + * returned anyway, but the value may be approximate, and, if remote, may not
> + * have been synchronised with the server.

I understand wanting to avoid extra arguments, but you are asking for trouble
with that sort of calling conventions.  Verifying that all call chains have
these fields initialized is bloody unpleasant and it *is* going to break,
especially since the rules are "you need to initialize it for vfs_xgetattr(),
but not for vfs_getattr()" - the names are similar enough for confusion,
and that's not the only such pair.
