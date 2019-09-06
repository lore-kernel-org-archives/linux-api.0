From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH v2 1/5] fs: Add support for an O_MAYEXEC flag on sys_open()
Date: Fri, 06 Sep 2019 17:56:32 +0200
Message-ID: <87ef0te7v3.fsf@oldenburg2.str.redhat.com>
References: <20190906152455.22757-1-mic@digikod.net>
        <20190906152455.22757-2-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190906152455.22757-2-mic@digikod.net> (=?utf-8?Q?=22Micka?=
 =?utf-8?Q?=C3=ABl_Sala=C3=BCn=22's?=
        message of "Fri, 6 Sep 2019 17:24:51 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Christian Heimes <christian@python.org>, Daniel Borkmann <daniel@iogearbox.net>, Eric Chiang <ericchiang@google.com>, James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>, Mimi Zohar <zohar@linux.ibm.com>, Philippe =?utf-8?Q?Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Scott Shell <scottsh@micr>
List-Id: linux-api@vger.kernel.org

Let's assume I want to add support for this to the glibc dynamic loader,
while still being able to run on older kernels.

Is it safe to try the open call first, with O_MAYEXEC, and if that fails
with EINVAL, try again without O_MAYEXEC?

Or do I risk disabling this security feature if I do that?

Do we need a different way for recognizing kernel support.  (Note that
we cannot probe paths in /proc for various reasons.)

Thanks,
Florian
