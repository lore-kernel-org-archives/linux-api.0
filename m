From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH v2 0/5] Add support for O_MAYEXEC
Date: Fri, 06 Sep 2019 15:07:19 -0400
Message-ID: <1802966.yheqmZt8Si@x2>
References: <20190906152455.22757-1-mic@digikod.net> <2989749.1YmIBkDdQn@x2> <87mufhckxv.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87mufhckxv.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>, linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Christian Heimes <christian@python.org>, Daniel Borkmann <daniel@iogearbox.net>, Eric Chiang <ericchiang@google.com>, James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>, Mimi Zohar <zohar@linux.ibm.com>Philippe =?ISO-8859-1?Q?Tr=E9buchet?= <ph>
List-Id: linux-api@vger.kernel.org

On Friday, September 6, 2019 2:57:00 PM EDT Florian Weimer wrote:
> * Steve Grubb:
> > Now with LD_AUDIT
> > $ LD_AUDIT=/home/sgrubb/test/openflags/strip-flags.so.0 strace ./test
> > 2>&1 | grep passwd openat(3, "passwd", O_RDONLY)           = 4
> > 
> > No O_CLOEXEC flag.
> 
> I think you need to explain in detail why you consider this a problem.

Because you can strip the O_MAYEXEC flag from being passed into the kernel. 
Once you do that, you defeat the security mechanism because it never gets 
invoked. The issue is that the only thing that knows _why_ something is being 
opened is user space. With this mechanism, you can attempt to pass this 
reason to the kernel so that it may see if policy permits this. But you can 
just remove the flag.

-Steve

> With LD_PRELOAD and LD_AUDIT, you can already do anything, including
> scanning other loaded objects for a system call instruction and jumping
> to that (in case a security module in the kernel performs a PC check to
> confer additional privileges).
> 
> Thanks,
> Florian
