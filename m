From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH v2 0/5] Add support for O_MAYEXEC
Date: Sun, 8 Sep 2019 17:16:23 -0700 (PDT)
Message-ID: <alpine.LRH.2.21.1909081622240.20426@namei.org>
References: <20190906152455.22757-1-mic@digikod.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="1665246916-1947903910-1567986261=:20426"
Return-path: <kernel-hardening-return-16878-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20190906152455.22757-1-mic@digikod.net>
Content-ID: <alpine.LRH.2.21.1909081645470.20426@namei.org>
To: =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Christian Heimes <christian@python.org>, Daniel Borkmann <daniel@iogearbox.net>, Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>, Mimi Zohar <zohar@linux.ibm.com>, =?ISO-8859-15?Q?Philippe_Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Scott Shell <scottsh@microsoft.com>
List-Id: linux-api@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-1947903910-1567986261=:20426
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LRH.2.21.1909081645471.20426@namei.org>

On Fri, 6 Sep 2019, Mickaël Salaün wrote:

> Furthermore, the security policy can also be delegated to an LSM, either
> a MAC system or an integrity system.  For instance, the new kernel
> MAY_OPENEXEC flag closes a major IMA measurement/appraisal interpreter
> integrity gap by bringing the ability to check the use of scripts [2].

To clarify, scripts are already covered by IMA if they're executed 
directly, and the gap is when invoking a script as a parameter to the 
interpreter (and for any sourced files). In that case only the interpreter 
is measured/appraised, unless there's a rule also covering the script 
file(s).

See:
https://en.opensuse.org/SDB:Ima_evm#script-behaviour

In theory you could probably also close the gap by modifying the 
interpreters to check for the execute bit on any file opened for 
interpretation (as earlier suggested by Steve Grubb), and then you could 
have IMA measure/appraise all files with +x.  I suspect this could get 
messy in terms of unwanted files being included, and the MAY_OPENEXEC flag 
has cleaner semantics.



-- 
James Morris
<jmorris@namei.org>
--1665246916-1947903910-1567986261=:20426--
