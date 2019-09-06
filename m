From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH v2 0/5] Add support for O_MAYEXEC
Date: Fri, 06 Sep 2019 20:57:00 +0200
Message-ID: <87mufhckxv.fsf@oldenburg2.str.redhat.com>
References: <20190906152455.22757-1-mic@digikod.net> <2989749.1YmIBkDdQn@x2>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2989749.1YmIBkDdQn@x2> (Steve Grubb's message of "Fri, 06 Sep
        2019 14:50:02 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Grubb <sgrubb@redhat.com>
Cc: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Christian Heimes <christian@python.org>, Daniel Borkmann <daniel@iogearbox.net>, Eric Chiang <ericchiang@google.com>, James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>, Mimi Zohar <zohar@linux.ibm.com>Philippe =?utf-8?Q?Tr=C3=A9buchet?= <ph>
List-Id: linux-api@vger.kernel.org

* Steve Grubb:

> Now with LD_AUDIT
> $ LD_AUDIT=/home/sgrubb/test/openflags/strip-flags.so.0 strace ./test 2>&1 | grep passwd
> openat(3, "passwd", O_RDONLY)           = 4
>
> No O_CLOEXEC flag.

I think you need to explain in detail why you consider this a problem.

With LD_PRELOAD and LD_AUDIT, you can already do anything, including
scanning other loaded objects for a system call instruction and jumping
to that (in case a security module in the kernel performs a PC check to
confer additional privileges).

Thanks,
Florian
