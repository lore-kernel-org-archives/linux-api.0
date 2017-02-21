From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [RFC 1/3] procfs: fdinfo -- Extend information about epoll
 target files
Date: Tue, 21 Feb 2017 22:16:55 +0300
Message-ID: <20170221191655.GC27653@uranus>
References: <20170221171254.954209904@openvz.org>
 <CALCETrUJcMuLpcLf5iQurGCnA1hqVH5YtHAq+=f81PF1OZy1Fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUJcMuLpcLf5iQurGCnA1hqVH5YtHAq+=f81PF1OZy1Fg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linuxfoundation.org>, Andrew Vagin <avagin@virtuozzo.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Kirill Kolyshkin <kir@openvz.org>, Jason Baron <jbaron@akamai.com>, Andrey Vagin <avagin@openvz.org>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 21, 2017 at 10:41:12AM -0800, Andy Lutomirski wrote:
> > Thus lets add file position, inode and device number where
> > this target lays. This three fields can be used as a primary
> > key for sorting, and together with kcmp help CRIU can find
> > out an exact file target (from the whole set of processes
> > being checkpointed).
> 
> I have no problem with this, but I'm wondering whether kcmp's ordered
> comparisons could also be used for this purpose.

Yes it can, but it would increas number of kcmp calls signisicantly.
Look, here is how we build files tree in criu: we take inode^sdev^pos
as a primary key and remember it inside rbtree while we're dumping files
(note also that we don't keep files opened but rather dump them in
chunks). Then once we find that two files have same primary key
we use kcmp to build subtree. This really helps a lot. And I plan
to do the same with target files from epolls:

 - they gonna be handled after all opened files of all processes
   in container (or children processes if dumping single task),
   thus the complete tree with primary key already will be built

 - on every target file I calculate primary key and then using
   kcmp will find if file is exactly one matching
