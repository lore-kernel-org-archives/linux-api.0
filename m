From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH v1 2/4] pid: add pidctl()
Date: Tue, 26 Mar 2019 14:47:47 -0400
Message-ID: <20190326184747.GB114492@google.com>
References: <20190326155513.26964-1-christian@brauner.io>
 <20190326155513.26964-3-christian@brauner.io>
 <20190326170601.GA101741@google.com>
 <20190326172231.daa5a53lxf6nz6jn@brauner.io>
 <20190326181012.GA138478@google.com>
 <20190326181929.eypk2hzprdltcrqd@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190326181929.eypk2hzprdltcrqd@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: jannh@google.com, khlebnikov@yandex-team.ru, luto@kernel.org, dhowells@redhat.com, serge@hallyn.com, ebiederm@xmission.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, keescook@chromium.org, adobriyan@gmail.com, tglx@linutronix.de, mtk.manpages@gmail.com, bl0pbl33p@gmail.com, ldv@altlinux.org, akpm@linux-foundation.org, oleg@redhat.com, nagarathnam.muthusamy@oracle.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, dancol@google.com
List-Id: linux-api@vger.kernel.org

On Tue, Mar 26, 2019 at 07:19:30PM +0100, Christian Brauner wrote:
[snip]
> > > > I am actually supportive of Daniel's view that by combining too many
> > > > arguments into a single syscall, becomes confusing and sometimes some
> > > > arguments have to be forced to 0 in the single shoe-horned syscall. Like you
> > > 
> > > There's a difference between an ioctl() and say seccomp() which this is
> > > close to:
> > > int seccomp(unsigned int operation, unsigned int flags, void *args);
> > > The point is that the functionality is closely related not just randomly
> > > unrelated stuff. But as I said I'm more than willing to compromise.
> > 
> > Sounds great, yeah whatever makes sense.
> 
> In case I haven't said this enough: I really appreciate the discussion
> and in general the help on this. That probably sometimes gets lost in
> mails sometimes. :)

I appreciate you saying that and thanks for the work on this :)

 - Joel
