From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [RFC PATCH v1 1/5] fs: Add support for an O_MAYEXEC flag on sys_open()
Date: Tue, 16 Apr 2019 11:34:07 -0400
Message-ID: <2361288.r9sZr2NHLB@x2>
References: <20181212081712.32347-1-mic@digikod.net> <3452959.b6JmBh7Lnt@x2> <87wojuxj8s.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87wojuxj8s.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Jan Kara <jack@suse.cz>, =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>, Mimi Zohar <zohar@linux.ibm.com>, Philippe =?ISO-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Shuah Khan <shuah@kernel.org>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vge
List-Id: linux-api@vger.kernel.org

On Tuesday, April 16, 2019 7:49:39 AM EDT Florian Weimer wrote:
> * Steve Grubb:
> > This flag that is being proposed means that you would have to patch all
> > interpreters to use it. If you are sure that upstreams will accept that,
> > why not just change the policy to interpreters shouldn't execute
> > anything unless the execute bit is set? That is simpler and doesn't need
> > a kernel change. And setting the execute bit is an auditable event.
> 
> I think we need something like O_MAYEXEC so that security policies can
> be enforced and noexec mounts can be detected.

Application whitelisting can already today stop unknown software without 
needing O_MAYEXEC.

> I don't think it's a good idea to do this in userspace, especially the
> latter.

The problem is that passing O_MAYEXEC is opt-in. You can use ptrace/seccomp/
bpf/LD_PRELOAD/LD_AUDIT to remove that bit from an otherwise normal program. 
This does not require privs to do so.

But let's consider that this comes to pass and every interpreter is updated 
and IMA can see the O_MAYEXEC flag. Attackers now simply pivot to running 
programs via stdin. It never touches disk and therefore nothing enforces 
security policy. This already is among the most common ways that malware runs 
today to evade detection.

-Steve
