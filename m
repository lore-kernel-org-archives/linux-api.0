From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH 2/4] pid: add pidfd_open()
Date: Thu, 28 Mar 2019 12:59:46 -0400
Message-ID: <533075A9-A6CF-4549-AFC8-B90505B198FD@joelfernandes.org>
References: <20190327162147.23198-1-christian@brauner.io> <20190327162147.23198-3-christian@brauner.io> <CAGLj2rG8xMMt8-+r-pauA_qi4aun2y_kBZMCZGkXWQsKJrb-Ww@mail.gmail.com> <20190327213404.pv4wqtkjbufkx36u@brauner.io> <CAGLj2rHpYAOGz0h0k2pS4JwFSQkMmRSUWxa4BtO+7BUMD21vdQ@mail.gmail.com> <20190327222543.huugotqcew6jyytv@brauner.io> <CAGLj2rG0Sbho6MnPSmcS73Xj=oG92E4W_QLRu4dD8NfweoUm5Q@mail.gmail.com> <20190328103813.eogszrqbitw3e7k7@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190328103813.eogszrqbitw3e7k7@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>, Jonathan Kowalski <bl0pbl33p@gmail.com>
Cc: Jann Horn <jannh@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org



On March 28, 2019 6:38:15 AM EDT, Christian Brauner <christian@brauner=2Ei=
o> wrote:
>> All that said, thanks for the work on this once again=2E My intention
>is
>> just that we don't end up with an API that could have been done
>better
>> and be cleaner to use for potential users in the coming years=2E
>
>Thanks for your input on all of this=2E I still don't find multiplexers
>in
>the style of seccomp()/fsconfig()/keyctl() to be a problem since they
>deal with a specific task=2E They are very much different from ioctl()s
>in
>that regard=2E But since Joel, you, and Daniel found the pidctl()
>approach
>not very nice I dropped it=2E The interface needs to be satisfactory for
>all of us especially since Android and other system managers will be
>the
>main consumers=2E
>So let's split this into pidfd_open(pid_t pid, unsigned int flags)
>which
>allows to cleanly get pidfds independent procfs and do the translation
>to procpidfds in an ioctl() as we've discussed in prior threads=2E This
>should also accommodate comments and ideas from Andy and Jann=2E
>I'm coding this up now=2E

This sounds quite sensible to me=2E Thanks!


Joel Fernandes, Android kernel team
Sent from k9-mail on Android
