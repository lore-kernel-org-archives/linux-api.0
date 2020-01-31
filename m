From: Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC PATCH v4 1/4] fs: add flags argument to i_op->link()
Date: Fri, 31 Jan 2020 12:24:59 -0800
Message-ID: <20200131202459.GA787405@vader>
References: <5b94d23baef8c2a256384f436650f4c4868915a2.1580251857.git.osandov@fb.com>
 <cover.1580251857.git.osandov@fb.com>
 <134625.1580478522@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <134625.1580478522-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xi Wang <xi-GmWTxIRN22iJaUV4rX00uodd74u8MsAO@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jan 31, 2020 at 01:48:42PM +0000, David Howells wrote:
> Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org> wrote:
> 
> > -	int (*link) (struct dentry *,struct inode *,struct dentry *);
> > +	int (*link) (struct dentry *,struct inode *,struct dentry *, int);
> 
> Can you make it unsigned int?
> 
> David
> 

For some reason, the linkat() syscall takes an int, but you're right,
might as well make it an unsigned int in the VFS.
