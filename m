From: James Morris <jmorris@namei.org>
Subject: Re: [RFC PATCH v1 0/5] Add support for O_MAYEXEC
Date: Thu, 13 Dec 2018 06:51:53 +1100 (AEDT)
Message-ID: <alpine.LRH.2.21.1812130642250.29507@namei.org>
References: <20181212081712.32347-1-mic@digikod.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="1665246916-1625860249-1544644091=:29507"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181212081712.32347-1-mic@digikod.net>
Content-ID: <alpine.LRH.2.21.1812130649470.29507@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>, Mimi Zohar <zohar@linux.ibm.com>, =?ISO-8859-15?Q?Philippe_Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Shuah Khan <shuah@kernel.org>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-1625860249-1544644091=:29507
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LRH.2.21.1812130649471.29507@namei.org>

On Wed, 12 Dec 2018, Mickaël Salaün wrote:

> Hi,
> 
> The goal of this patch series is to control script interpretation.  A
> new O_MAYEXEC flag used by sys_open() is added to enable userland script
> interpreter to delegate to the kernel (and thus the system security
> policy) the permission to interpret scripts or other files containing
> what can be seen as commands.
> 
> The security policy is the responsibility of an LSM.  A basic
> system-wide policy is implemented with Yama and configurable through a
> sysctl.

If you're depending on the script interpreter to flag that the user may 
execute code, this seems to be equivalent in security terms to depending 
on the user.  e.g. what if the user uses ptrace and clears O_MAYEXEC?

 



-- 
James Morris
<jmorris@namei.org>
--1665246916-1625860249-1544644091=:29507--
