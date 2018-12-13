From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH v1 0/5] Add support for O_MAYEXEC
Date: Thu, 13 Dec 2018 04:16:46 -0800
Message-ID: <20181213121645.GN6830@bombadil.infradead.org>
References: <20181212081712.32347-1-mic@digikod.net>
 <20181213030228.GM6830@bombadil.infradead.org>
 <1544699060.6703.11.camel@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1544699060.6703.11.camel@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>, Philippe =?iso-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Shuah Khan <shuah@kernel.org>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Dec 13, 2018 at 06:04:20AM -0500, Mimi Zohar wrote:
> > I don't have a problem with the concept, but we're running low on O_ bits.
> > Does this have to be done before the process gets a file descriptor,
> > or could we have a new syscall?  Since we're going to be changing the
> > interpreters anyway, it doesn't seem like too much of an imposition to
> > ask them to use:
> > 
> > 	int verify_for_exec(int fd)
> > 
> > instead of adding an O_MAYEXEC.
> 
> The indication needs to be set during file open, before the open
> returns to the caller.  This is the point where ima_file_check()
> verifies the file's signature.  On failure, access to the file is
> denied.

I understand that's what happens today, but do we need to do it that way?
There's no harm in the interpreter having an fd to a file if it knows
not to execute it.  This is different from a program opening a file and
having the LSM deny access to it because it violates the security model.
