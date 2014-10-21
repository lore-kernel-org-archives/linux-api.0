From: Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH 2/2] fs: Support compiling out sendfile
Date: Tue, 21 Oct 2014 13:20:30 -0400
Message-ID: <1413912030.2350.2.camel@redhat.com>
References: <1413841728-1313-1-git-send-email-pieter@boesman.nl>
	 <1413841728-1313-2-git-send-email-pieter@boesman.nl>
	 <54467D9C.2030302@zytor.com> <20141021171814.GA14704@cloud>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141021171814.GA14704@cloud>
Sender: linux-kernel-owner@vger.kernel.org
To: josh@joshtriplett.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Pieter Smith <pieter@boesman.nl>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Matt Turner <mattst88@gmail.com>, Michal Hocko <mhocko@suse.cz>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Fabian Frederick <fabf@skynet.be>, Tejun Heo <tj@kernel.org>, =?UTF-8?Q?=E8=94=A1=E6=AD=A3=E9=BE=99?= <zhenglong.cai@cs2c.com.cn>, "Luis R. Rodriguez" <mcgrof@suse.com>, Peter Foley <pefoley2@pefoley.com>, Konstantin Khlebnikov <koct9i@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, David Herrmann <dh.herrmann@gmail.com>, Kees Cook <keescook@chromium.org>, linux-fsdevel@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, ABI/API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, 2014-10-21 at 10:18 -0700, josh@joshtriplett.org wrote:
> On Tue, Oct 21, 2014 at 08:37:00AM -0700, H. Peter Anvin wrote:
> > On 10/20/2014 02:48 PM, Pieter Smith wrote:
> > > Many embedded systems will not need this syscall, and omitting it
> > > saves space.  Add a new EXPERT config option CONFIG_SENDFILE_SYSCALL
> > > (default y) to support compiling it out.
> > 
> > <bikeshed>
> > I believe these options ought to be CONFIG_SYSCALL_*
> > </bikeshed>
> 
> I agree.  I think people started using CONFIG_*_SYSCALL because of
> things like AUDITSYSCALL 

AUDITSYSCALL audits syscalls.  It doesn't actually implement any
syscalls.  You are right about SYSFS_SYSCALL though...
