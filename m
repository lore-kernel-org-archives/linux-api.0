From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH v4 1/4] fs: add flags argument to i_op->link()
Date: Fri, 31 Jan 2020 13:48:42 +0000
Message-ID: <134625.1580478522@warthog.procyon.org.uk>
References: <5b94d23baef8c2a256384f436650f4c4868915a2.1580251857.git.osandov@fb.com> <cover.1580251857.git.osandov@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <5b94d23baef8c2a256384f436650f4c4868915a2.1580251857.git.osandov@fb.com>
Content-ID: <134624.1580478522.1@warthog.procyon.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, kernel-team@fb.com, linux-api@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, Xi Wang <xi@cs.washington.edu>
List-Id: linux-api@vger.kernel.org

Omar Sandoval <osandov@osandov.com> wrote:

> -	int (*link) (struct dentry *,struct inode *,struct dentry *);
> +	int (*link) (struct dentry *,struct inode *,struct dentry *, int);

Can you make it unsigned int?

David
