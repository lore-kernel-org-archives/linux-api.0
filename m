From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH 2/2] fs: Support compiling out sendfile
Date: Tue, 21 Oct 2014 02:04:22 -0700
Message-ID: <20141021090421.GB17604@thin>
References: <1413841728-1313-1-git-send-email-pieter@boesman.nl>
 <1413841728-1313-2-git-send-email-pieter@boesman.nl>
 <20141020222421.GE8929@cloud>
 <20141021075154.GB10020@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141021075154.GB10020@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Pieter Smith <pieter@boesman.nl>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Eric Paris <eparis@redhat.com>, Matt Turner <mattst88@gmail.com>, Michal Hocko <mhocko@suse.cz>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Fabian Frederick <fabf@skynet.be>, Tejun Heo <tj@kernel.org>, ????????? <zhenglong.cai@cs2c.com.cn>, "Luis R. Rodriguez" <mcgrof@suse.com>, Peter Foley <pefoley2@pefoley.com>, Konstantin Khlebnikov <koct9i@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, David Herrmann <dh.herrmann@gmail.com>, Kees Cook <keescook@chromium.org>, linux-fsdevel@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 21, 2014 at 12:51:54AM -0700, Christoph Hellwig wrote:
> On Mon, Oct 20, 2014 at 03:24:22PM -0700, josh@joshtriplett.org wrote:
> > On Mon, Oct 20, 2014 at 11:48:37PM +0200, Pieter Smith wrote:
> > > Many embedded systems will not need this syscall, and omitting it
> > > saves space.  Add a new EXPERT config option CONFIG_SENDFILE_SYSCALL
> > > (default y) to support compiling it out.
> > 
> > Nice work, thanks!
> > 
> > If there are no objections, and nobody has a tree they'd rather carry
> > this through, I'll take the series through the tiny tree when it's ready
> > to merge.
> 
> I think it's rather pointless - there is very little sendfile code,
> so you'd rather want to disable splice.

That's the plan, but since sendfile depends on some of the splice bits,
sendfile needs to be optional as well; SENDFILE_SYSCALL will then select
SPLICE_SYSCALLS.

- Josh Triplett
