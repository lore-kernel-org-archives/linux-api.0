From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [RFC PATCH v1 1/5] fs: Add support for an O_MAYEXEC flag on sys_open()
Date: Mon, 15 Apr 2019 14:47:49 -0400
Message-ID: <3452959.b6JmBh7Lnt@x2>
References: <20181212081712.32347-1-mic@digikod.net> <20181212081712.32347-2-mic@digikod.net> <20181212144306.GA19945@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181212144306.GA19945@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>, Mimi Zohar <zohar@linux.ibm.com>, Philippe =?ISO-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Shuah Khan <shuah@kernel.org>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdev
List-Id: linux-api@vger.kernel.org

Hello,

On Wednesday, December 12, 2018 9:43:06 AM EDT Jan Kara wrote:
> On Wed 12-12-18 09:17:08, Mickaël Salaün wrote:
> > When the O_MAYEXEC flag is passed, sys_open() may be subject to
> > additional restrictions depending on a security policy implemented by an
> > LSM through the inode_permission hook.
> > 
> > The underlying idea is to be able to restrict scripts interpretation
> > according to a policy defined by the system administrator.  For this to
> > be possible, script interpreters must use the O_MAYEXEC flag
> > appropriately.  To be fully effective, these interpreters also need to
> > handle the other ways to execute code (for which the kernel can't help):
> > command line parameters (e.g., option -e for Perl), module loading
> > (e.g., option -m for Python), stdin, file sourcing, environment
> > variables, configuration files...  According to the threat model, it may
> > be acceptable to allow some script interpreters (e.g. Bash) to interpret
> > commands from stdin, may it be a TTY or a pipe, because it may not be
> > enough to (directly) perform syscalls.
> > 
> > A simple security policy implementation is available in a following
> > patch for Yama.
> > 
> > This is an updated subset of the patch initially written by Vincent
> > Strubel for CLIP OS:
> > https://github.com/clipos-archive/src_platform_clip-patches/blob/f5cb330d
> > 6b684752e403b4e41b39f7004d88e561/1901_open_mayexec.patch This patch has
> > been used for more than 10 years with customized script interpreters. 
> > Some examples can be found here:
> > https://github.com/clipos-archive/clipos4_portage-overlay/search?q=O_MAYE
> > XEC
> > 
> > Signed-off-by: Mickaël Salaün <mic@digikod.net>
> > Signed-off-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
> > Signed-off-by: Vincent Strubel <vincent.strubel@ssi.gouv.fr>
> > Reviewed-by: Philippe Trébuchet <philippe.trebuchet@ssi.gouv.fr>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Mickaël Salaün <mickael.salaun@ssi.gouv.fr>
> 
> ...
> 
> > diff --git a/fs/open.c b/fs/open.c
> > index 0285ce7dbd51..75479b79a58f 100644
> > --- a/fs/open.c
> > +++ b/fs/open.c
> > @@ -974,6 +974,10 @@ static inline int build_open_flags(int flags,
> > umode_t mode, struct open_flags *o> 
> >  	if (flags & O_APPEND)
> >  	
> >  		acc_mode |= MAY_APPEND;
> > 
> > +	/* Check execution permissions on open. */
> > +	if (flags & O_MAYEXEC)
> > +		acc_mode |= MAY_OPENEXEC;
> > +
> > 
> >  	op->acc_mode = acc_mode;
> >  	
> >  	op->intent = flags & O_PATH ? 0 : LOOKUP_OPEN;
> 
> I don't feel experienced enough in security to tell whether we want this
> functionality or not. But if we do this, shouldn't we also set FMODE_EXEC
> on the resulting struct file? That way also security_file_open() can be
> used to arbitrate such executable opens and in particular
> fanotify permission event FAN_OPEN_EXEC will get properly generated which I
> guess is desirable (support for it is sitting in my tree waiting for the
> merge window) - adding some audit people involved in FAN_OPEN_EXEC to CC.
> Just an idea...

Late in replying. But I think it's important to have a deep look into the 
issue.

TL;DR - This is a gentle man's handshake. It won't _really_ solve the 
problem.

This flag that is being proposed means that you would have to patch all 
interpreters to use it. If you are sure that upstreams will accept that, why 
not just change the policy to interpreters shouldn't execute anything unless 
the execute bit is set? That is simpler and doesn't need a kernel change. And 
setting the execute bit is an auditable event.

The bottom line is that any interpreter has to become a security policy 
enforcement point whether by indicating it wants to execute by setting a flag 
or by refusing to use a file without execute bit set. But this just moves the 
problem to one that is harder to fix. Why in the world does any programming 
language allow programs to be loaded via stdin? 

It is possible to wget a program and pipe it into python which subsequently 
pulls down an ELF shared object and runs it all without touching disk via 
memfd_create (e.g. SnakeEater). This is all direct to memory execution. And 
direct to memory bypasses anti-virus, selinux, IMA, application whitelisting, 
and other integrity schemes.

So, to fix this problem, you really need to not allow any programs to load via 
stdin so that everything that executes has to touch disk. This way you can 
get a fanotify event and see the application and vote yes/no on allowing it. 
And this will be particularly harder with the memfd_create fix for the runc 
container breakout. Prior to that, there were very few uses of that system 
call. Now it may be very common which means finding malicious use just got 
harder to spot.

But assuming these problems got fixed, then we have yet another place to look. 
Many interpreters allow you to specify a command to run via arguments. Some 
have a small buffer and some allow lengthy programs to be entered as an 
argument. One strategy might be that an attacker can bootstrap a lengthier 
program across the network. Python for example allows loading modules across 
a network. All you need to put in the commandline is the override for the 
module loader and a couple modules to import. It then loads the modules 
remotely. Getting rid of this hole will likely lead to some unhappy people - 
meaning it can't be fixed.

And even if we get that fixed, we have one last hole to plug. Shells. One can 
simply start a shell and paste their program into the shell and then execute 
it. You can easily do this with bash or python or any language that has a 
REPL (read–eval–print loop). To fix this means divorcing the notion of a 
language from a REPL. Production systems really do not need a Python shell, 
they need the interpreter. I doubt that this would be popular. But fixing each 
of these issues is what it would take to prevent unknown software from 
running. Not going this far leaves holes.

Best Regards,
-Steve
