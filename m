From: James Morris <jmorris@namei.org>
Subject: Re: [RFC PATCH v1 0/5] Add support for O_MAYEXEC
Date: Thu, 13 Dec 2018 10:40:32 +1100 (AEDT)
Message-ID: <alpine.LRH.2.21.1812131039400.7600@namei.org>
References: <20181212081712.32347-1-mic@digikod.net> <alpine.LRH.2.21.1812130642250.29507@namei.org> <87lg4upkpv.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87lg4upkpv.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>, Mimi Zohar <zohar@linux.ibm.com>, =?ISO-8859-15?Q?Philippe_Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Shuah Khan <shuah@kernel.org>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 12 Dec 2018, Florian Weimer wrote:

> * James Morris:
> 
> > If you're depending on the script interpreter to flag that the user may 
> > execute code, this seems to be equivalent in security terms to depending 
> > on the user.  e.g. what if the user uses ptrace and clears O_MAYEXEC?
> 
> The argument I've heard is this: Using ptrace (and adding the +x
> attribute) are auditable events.

I guess you could also preload a modified libc which strips the flag.


-- 
James Morris
<jmorris@namei.org>
