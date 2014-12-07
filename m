From: Pieter Smith <pieter@boesman.nl>
Subject: Re: [PATCH v6 4/7] fs/fuse: support compiling out splice
Date: Sun, 7 Dec 2014 14:00:40 +0100
Message-ID: <20141207130040.GA8267@smipidev>
References: <1417715473-24110-1-git-send-email-pieter@boesman.nl>
 <1417715473-24110-5-git-send-email-pieter@boesman.nl>
 <CAJfpegu+NQQ_+af=6UXi2=fyTJK1CsQBZ2++Nysu4mume4UEOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJfpegu+NQQ_+af=6UXi2=fyTJK1CsQBZ2++Nysu4mume4UEOQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:FUSE: FILESYSTEM..." <fuse-devel@lists.sourceforge.net>, "open list:ABI/API" <linux-api@vger.kernel.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Dec 05, 2014 at 11:44:36AM +0100, Miklos Szeredi wrote:
> On Thu, Dec 4, 2014 at 6:50 PM, Pieter Smith <pieter@boesman.nl> wrote:
> > To implement splice support, fs/fuse makes use of nosteal_pipe_buf_ops. This
> > struct is exported by fs/splice. The goal of the larger patch set is to
> > completely compile out fs/splice, so uses of the exported struct need to be
> > compiled out along with fs/splice.
> >
> > This patch therefore compiles out splice support in fs/fuse when
> > CONFIG_SYSCALL_SPLICE is undefined.
> >
> > Signed-off-by: Pieter Smith <pieter@boesman.nl>
> 
> 
> In the future could you PLEASE PLEASE cut the fuse-devel Cc from the
> non-fuse specific patches (and I guess that goes for any other
> subsystem specific lists and persons as well)?
> 
> Otherwise:
> 
> Acked-by: Miklos Szeredi <mszeredi@suse.cz>
> 
> Thanks,
> Miklos

I added your Acked-by and removed you and fuse-dev from postings on future
versions of this patch-set.

Thanks,
Pieter
