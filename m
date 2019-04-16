From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [RFC PATCH v1 1/5] fs: Add support for an O_MAYEXEC flag on sys_open()
Date: Tue, 16 Apr 2019 13:49:39 +0200
Message-ID: <87wojuxj8s.fsf@oldenburg2.str.redhat.com>
References: <20181212081712.32347-1-mic@digikod.net>
        <20181212081712.32347-2-mic@digikod.net>
        <20181212144306.GA19945@quack2.suse.cz> <3452959.b6JmBh7Lnt@x2>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3452959.b6JmBh7Lnt@x2> (Steve Grubb's message of "Mon, 15 Apr
        2019 14:47:49 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Grubb <sgrubb@redhat.com>
Cc: Jan Kara <jack@suse.cz>, =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>, Mimi Zohar <zohar@linux.ibm.com>, Philippe =?utf-8?Q?Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Shuah Khan <shuah@kernel.org>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vge
List-Id: linux-api@vger.kernel.org

* Steve Grubb:

> This flag that is being proposed means that you would have to patch all 
> interpreters to use it. If you are sure that upstreams will accept that, why 
> not just change the policy to interpreters shouldn't execute anything unless 
> the execute bit is set? That is simpler and doesn't need a kernel change. And 
> setting the execute bit is an auditable event.

I think we need something like O_MAYEXEC so that security policies can
be enforced and noexec mounts can be detected.  I don't think it's a
good idea to do this in userspace, especially the latter.

Thanks,
Florian
