From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/4] statx: Add a system call to make enhanced file info
 available [ver #3]
Date: Sun, 4 Dec 2016 16:05:04 +0000
Message-ID: <20161204160504.GG1555@ZenIV.linux.org.uk>
References: <147986254484.19139.8038609825799670925.stgit@warthog.procyon.org.uk>
 <147986255194.19139.9583434946564699577.stgit@warthog.procyon.org.uk>
 <20161204043803.GA1022@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161204043803.GA1022@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sun, Dec 04, 2016 at 04:38:05AM +0000, Al Viro wrote:

> I understand wanting to avoid extra arguments, but you are asking for trouble
> with that sort of calling conventions.  Verifying that all call chains have
> these fields initialized is bloody unpleasant and it *is* going to break,
> especially since the rules are "you need to initialize it for vfs_xgetattr(),
> but not for vfs_getattr()" - the names are similar enough for confusion,
> and that's not the only such pair.

BTW, after some grepping: you seem to leave ecryptfs_getattr() as-is, which
means that flags it had been passed by caller in *stat are not seen by
underlying fs.  Looks fishy...
