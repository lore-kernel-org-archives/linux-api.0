From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [RFC PATCH v1 0/5] Add support for O_MAYEXEC
Date: Thu, 13 Dec 2018 06:22:00 +0100
Message-ID: <87bm5qovbb.fsf@oldenburg2.str.redhat.com>
References: <20181212081712.32347-1-mic@digikod.net>
        <20181213030228.GM6830@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181213030228.GM6830@bombadil.infradead.org> (Matthew Wilcox's
        message of "Wed, 12 Dec 2018 19:02:28 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>, Mimi Zohar <zohar@linux.ibm.com>, Philippe =?utf-8?Q?Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Shuah Khan <shuah@kernel.org>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdev
List-Id: linux-api@vger.kernel.org

* Matthew Wilcox:

> On Wed, Dec 12, 2018 at 09:17:07AM +0100, Mickaël Salaün wrote:
>> The goal of this patch series is to control script interpretation.  A
>> new O_MAYEXEC flag used by sys_open() is added to enable userland script
>> interpreter to delegate to the kernel (and thus the system security
>> policy) the permission to interpret scripts or other files containing
>> what can be seen as commands.
>
> I don't have a problem with the concept, but we're running low on O_ bits.
> Does this have to be done before the process gets a file descriptor,
> or could we have a new syscall?  Since we're going to be changing the
> interpreters anyway, it doesn't seem like too much of an imposition to
> ask them to use:
>
> 	int verify_for_exec(int fd)
>
> instead of adding an O_MAYEXEC.

Will this work for auditing?

Maybe add an interface which explicitly upgrades O_PATH descriptors, and
give that a separate flag argument?  I suppose that would be more
friendly to auditing.

Thanks,
Florian
