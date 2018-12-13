From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH v1 0/5] Add support for O_MAYEXEC
Date: Thu, 13 Dec 2018 09:44:08 -0800
Message-ID: <20181213174408.GS6830@bombadil.infradead.org>
References: <20181212081712.32347-1-mic@digikod.net>
 <20181213030228.GM6830@bombadil.infradead.org>
 <374ea88c-edc5-f1a6-3637-748635e1e7df@ssi.gouv.fr>
 <20181213171310.GR6830@bombadil.infradead.org>
 <ba523381-1b98-a8bf-ee5b-94a71caee48c@ssi.gouv.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ba523381-1b98-a8bf-ee5b-94a71caee48c@ssi.gouv.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>
Cc: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Mimi Zohar <zohar@linux.ibm.com>, Philippe =?iso-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Shuah Khan <shuah@kernel.org>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Dec 13, 2018 at 06:36:15PM +0100, Mickaël Salaün wrote:
> On 13/12/2018 18:13, Matthew Wilcox wrote:
> > On Thu, Dec 13, 2018 at 04:17:29PM +0100, Mickaël Salaün wrote:
> >> Adding a new syscall for this simple use case seems excessive. I think
> > 
> > We have somewhat less than 400 syscalls today.  We have 20 O_ bits defined.
> > Obviously there's a lower practical limit on syscalls, but in principle
> > we could have up to 2^32 syscalls, and there are only 12 O_ bits remaining.
> > 
> >> that the open/openat syscall familly are the right place to do an atomic
> >> open and permission check, the same way the kernel does for other file
> >> access. Moreover, it will be easier to patch upstream interpreters
> >> without the burden of handling a (new) syscall that may not exist on the
> >> running system, whereas unknown open flags are ignored.
> > 
> > Ah, but that's the problem.  The interpreter can see an -ENOSYS response
> > and handle it appropriately.  If the flag is silently ignored, the
> > interpreter has no idea whether it can do a racy check or whether to
> > skip even trying to do the check.
> 
> Right, but the interpreter should interpret the script if the open with
> O_MAYEXEC succeed (but not otherwise): it may be because the flag is
> known by the kernel and the system policy allow this call, or because
> the (old) kernel doesn't known about this flag (which is fine and needed
> for backward compatibility). The script interpretation must not failed
> if the kernel doesn't support O_MAYEXEC, it is then useless for the
> interpreter to do any additional check.

If that's the way interpreters want to work, then that's fine.  They
can just call the verify() syscall and ignore the -ENOSYS.  Done.

Or somebody who cares very, very deeply can change the interpreter to
decline to run any scripts if the kernel returns -ENOSYS.
