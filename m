From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 31/34] vfs: syscall: Add fspick() to select a superblock
 for reconfiguration [ver #12]
Date: Sat, 13 Oct 2018 07:11:41 +0100
Message-ID: <20181013061141.GR32577@ZenIV.linux.org.uk>
References: <153754740781.17872.7869536526927736855.stgit@warthog.procyon.org.uk>
 <153754766004.17872.9829232103614083565.stgit@warthog.procyon.org.uk>
 <9b8bf436-65de-13b9-0002-0479d11c18ca@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9b8bf436-65de-13b9-0002-0479d11c18ca@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Jenkins <alan.christopher.jenkins@gmail.com>
Cc: David Howells <dhowells@redhat.com>, linux-api@vger.kernel.org, torvalds@linux-foundation.org, ebiederm@xmission.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mszeredi@redhat.com
List-Id: linux-api@vger.kernel.org

On Fri, Oct 12, 2018 at 03:49:50PM +0100, Alan Jenkins wrote:
> > +SYSCALL_DEFINE3(fspick, int, dfd, const char __user *, path, unsigned int, flags)
> > +{
> > +	struct fs_context *fc;
> > +	struct path target;
> > +	unsigned int lookup_flags;
> > +	int ret;
> > +
> > +	if (!ns_capable(current->nsproxy->mnt_ns->user_ns, CAP_SYS_ADMIN))
> > +		return -EPERM;
> 
> 
> This seems to accept basically any mount.  Specifically: are you sure it's
> OK to return a handle to a SB_NO_USER superblock?

Umm...  As long as we don't try to do pathname resolution from its ->s_root,
shouldn't be a problem and I don't see anything that would do that.  I might've
missed something, but...
