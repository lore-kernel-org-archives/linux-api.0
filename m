From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [RFC PATCH v1 0/5] Add support for O_MAYEXEC
Date: Wed, 12 Dec 2018 21:13:16 +0100
Message-ID: <87lg4upkpv.fsf@oldenburg2.str.redhat.com>
References: <20181212081712.32347-1-mic@digikod.net>
        <alpine.LRH.2.21.1812130642250.29507@namei.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.21.1812130642250.29507@namei.org> (James Morris's
        message of "Thu, 13 Dec 2018 06:51:53 +1100 (AEDT)")
Sender: linux-kernel-owner@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>, Mimi Zohar <zohar@linux.ibm.com>, Philippe =?utf-8?Q?Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Shuah Khan <shuah@kernel.org>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

* James Morris:

> If you're depending on the script interpreter to flag that the user may 
> execute code, this seems to be equivalent in security terms to depending 
> on the user.  e.g. what if the user uses ptrace and clears O_MAYEXEC?

The argument I've heard is this: Using ptrace (and adding the +x
attribute) are auditable events.

Florian
