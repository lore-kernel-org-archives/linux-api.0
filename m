From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v3] signal: add procfd_send_signal() syscall
Date: Wed, 5 Dec 2018 19:27:30 -0800
Message-ID: <CAGXu5j+MRVdo_qjRdiMVSOnm2+d46CsDqdjH21AyzY7e=WNp+Q@mail.gmail.com>
References: <20181205092203.14105-1-christian@brauner.io> <87zhtjn8ck.fsf@xmission.com>
 <20181205205242.hxgba5opiapinj56@brauner.io> <CAGXu5jJgYyhUBgzfkkcHGtu6AcC4MBpfwcEoj3M=Y+8q0FZ_dA@mail.gmail.com>
 <20181206030810.jo5julsc4v5zy34z@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181206030810.jo5julsc4v5zy34z@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Daniel Colascione <dancol@google.com>, Tim Murray <timmurray@google.com>, linux-man <linux-man@vger.kernel.org>, Florian Weimer <fweimer@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Dec 5, 2018 at 7:08 PM Christian Brauner <christian@brauner.io> wrote:
> As a sidenote I'm switching the name from procfd_send_signal() to
> taskfd_send_signal(). It seems to me the best way to handle Eric's
> request to reflect that we can eventually both signal tgids and tids.

Cool; sounds fine to me.

-- 
Kees Cook
