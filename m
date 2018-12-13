From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [RFC PATCH v1 0/5] Add support for O_MAYEXEC
Date: Thu, 13 Dec 2018 12:26:56 +0100
Message-ID: <874lbhoef3.fsf@oldenburg2.str.redhat.com>
References: <20181212081712.32347-1-mic@digikod.net>
        <20181213030228.GM6830@bombadil.infradead.org>
        <1544699060.6703.11.camel@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1544699060.6703.11.camel@linux.ibm.com> (Mimi Zohar's message of
        "Thu, 13 Dec 2018 06:04:20 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: Matthew Wilcox <willy@infradead.org>, =?utf-8?Q?Micka=C3=ABl_Sala?= =?utf-8?Q?=C3=BCn?= <mic@digikod.net>, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>, Philippe =?utf-8?Q?Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Shuah Khan <shuah@kernel.org>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kerne
List-Id: linux-api@vger.kernel.org

* Mimi Zohar:

> The indication needs to be set during file open, before the open
> returns to the caller.  This is the point where ima_file_check()
> verifies the file's signature.  On failure, access to the file is
> denied.

Does this verification happen for open with O_PATH?

Thanks,
Florian
