From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [RFC PATCH v1 1/5] fs: Add support for an O_MAYEXEC flag on
 sys_open()
Date: Wed, 12 Dec 2018 15:42:36 -0500
Message-ID: <1544647356.4028.105.camel@linux.ibm.com>
References: <20181212081712.32347-1-mic@digikod.net>
         <20181212081712.32347-2-mic@digikod.net>
         <20181212144306.GA19945@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181212144306.GA19945@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>, =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>, Philippe =?ISO-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Shuah Khan <shuah@kernel.org>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, sgrubb@redhat.com, Matthew Bobrowski <mbobrowski@mbobrowski.org>
List-Id: linux-api@vger.kernel.org

On Wed, 2018-12-12 at 15:43 +0100, Jan Kara wrote:


> > diff --git a/fs/open.c b/fs/open.c
> > index 0285ce7dbd51..75479b79a58f 100644
> > --- a/fs/open.c
> > +++ b/fs/open.c
> > @@ -974,6 +974,10 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
> >  	if (flags & O_APPEND)
> >  		acc_mode |= MAY_APPEND;
> >  
> > +	/* Check execution permissions on open. */
> > +	if (flags & O_MAYEXEC)
> > +		acc_mode |= MAY_OPENEXEC;
> > +
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
> merge window) - adding some audit people involved in FAN_OPEN_EXEC to
> CC. Just an idea...

Assuming the interpreters are properly modified (and signed),
MAY_OPENEXEC closes a major IMA measurement/appraisal gap.  The kernel
has no insight into the files that the interpreter is opening.  Having
the interpreter annotate the file open, allows IMA to differentiate
scripts opening data files from code.

IMA policy rules could then be written requiring code to be signed.

Example IMA policy rules:
measure func=FILE_CHECK mask=MAY_OPENEXEC
appraise func=FILE_CHECK mask=MAY_OPENEXEC appraise_type=imasig

Mimi
