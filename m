From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH v2 1/5] fs: Add support for an O_MAYEXEC flag on sys_open()
Date: Fri, 06 Sep 2019 20:44:03 +0200
Message-ID: <87r24tcljg.fsf@oldenburg2.str.redhat.com>
References: <20190906152455.22757-1-mic@digikod.net>
        <20190906152455.22757-2-mic@digikod.net>
        <87ef0te7v3.fsf@oldenburg2.str.redhat.com>
        <75442f3b-a3d8-12db-579a-2c5983426b4d@ssi.gouv.fr>
        <f53ec45fd253e96d1c8d0ea6f9cca7f68afa51e3.camel@kernel.org>
        <1fbf54f6-7597-3633-a76c-11c4b2481add@ssi.gouv.fr>
        <5a59b309f9d0603d8481a483e16b5d12ecb77540.camel@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5a59b309f9d0603d8481a483e16b5d12ecb77540.camel@kernel.org> (Jeff
        Layton's message of "Fri, 06 Sep 2019 14:38:11 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Layton <jlayton@kernel.org>
Cc: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>, =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Christian Heimes <christian@python.org>, Daniel Borkmann <daniel@iogearbox.net>, Eric Chiang <ericchiang@google.com>, James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Mimi Zohar <zohar@linux.ibm.com>Philippe =?utf-8?Q?Tr=C3=A9buchet?= <ph>
List-Id: linux-api@vger.kernel.org

* Jeff Layton:

> Even better would be to declare the new flag in some openat2-only flag
> space, so there's no confusion about it being supported by legacy open
> calls.

Isn't that desirable anyway because otherwise fcntl with F_GETFL will
give really confusing results?

> If glibc wants to implement an open -> openat2 wrapper in userland
> later, it can set that flag in the wrapper implicitly to emulate the old
> behavior.

I see us rather doing the opposite, i.e. implement openat2 with
non-exotic flags using openat.  But we've bitten by this in the past, so
maybe that's not such a great idea.  It's tempting to make the same
mistake again for every new system call.

Thanks,
Florian
