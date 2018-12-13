From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [RFC PATCH v1 0/5] Add support for O_MAYEXEC
Date: Thu, 13 Dec 2018 07:16:52 -0500
Message-ID: <1544703412.6703.46.camel@linux.ibm.com>
References: <20181212081712.32347-1-mic@digikod.net>
         <20181213030228.GM6830@bombadil.infradead.org>
         <1544699060.6703.11.camel@linux.ibm.com>
         <874lbhoef3.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <874lbhoef3.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>, =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>, Philippe =?ISO-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Shuah Khan <shuah@kernel.org>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, linux-f
List-Id: linux-api@vger.kernel.org

[Cc'ing linux-integrity]

On Thu, 2018-12-13 at 12:26 +0100, Florian Weimer wrote:
> * Mimi Zohar:
> 
> > The indication needs to be set during file open, before the open
> > returns to the caller.  This is the point where ima_file_check()
> > verifies the file's signature.  On failure, access to the file is
> > denied.
> 
> Does this verification happen for open with O_PATH?

Interesting!  According to the manpage, userspace cannot read/write to
the file.  It looks like do_o_path() intentionally skips do_last(),
with the call to ima_file_check().  If the file data isn't being
accessed, does the file's integrity need to be verified?

Mimi
